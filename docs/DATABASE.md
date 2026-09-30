# StreakUp Database Foundation Proposal

| Field | Value |
| --- | --- |
| Status | **Approved Foundation — DB-01 through DB-07 approved by Product Owner** |
| Date | 2026-09-28 |
| Phase | Database Foundation |
| Product authority | [PRD v1.0](PRD.md) |
| Architecture | [ARCHITECTURE.md](ARCHITECTURE.md): Bloc/Cubit, Isar, Supabase, `go_router` approved |
| Governance | [StreakUp Constitution](../.specify/memory/constitution.md) v1.0.0 |

This is an approved database foundation, **not a production schema**. It creates no Supabase project, migration, table, function, Isar collection, or application feature. Feature schemas follow the constitution's PRD alignment → specification → clarification → plan → tasks → consistency analysis → implementation → verification sequence. Product rules marked open in the PRD remain open here.

## 1. Boundary and database principles

- Isar is the device source of truth for offline-capable product data. A core personal action commits locally with a durable outbox operation before the UI reports local success. Bloc/Cubit observes Isar through repositories (`FR-020`, `BR-022`, `NFR-004`).
- Supabase Auth identifies the account. Supabase PostgreSQL is authoritative for shared/cross-user state, current permissions, accepted check-ins, restore transfers, and challenge scoring. Realtime may trigger refresh but is never a correctness dependency (`BR-003`, `BR-007`, `BR-023`, `NFR-005`, `PERM-009`).
- No client-provided ID, timestamp, owner field, score, or revision grants authority. Trusted database rules validate every command; RLS and grants protect every exposed read/write path. Private habits remain private by default (`BR-001`, `NFR-007`, `NFR-008`).
- A locally accepted action remains available until synchronized or explicitly resolved. Pending, Synced, and Failed must be derivable from durable local state (`FR-022`, `NFR-003`, `NFR-012`).

## 2. Supabase migration strategy

**Recommendation:** Use reviewed, immutable-after-application SQL migrations under version control, generated and applied with the Supabase CLI. Keep database objects, RLS, grants, functions, indexes, and constraints in the same migration history; version and verify non-SQL Supabase API exposure settings separately. Each migration has a descriptive name and a linked feature specification/PRD IDs. Supabase documents this workflow in [Database Migrations](https://supabase.com/docs/guides/deployment/database-migrations).

1. Develop against a local Supabase stack and a disposable database. A candidate migration must rebuild from a clean state and upgrade a representative prior state.
2. Review schema diff and privilege diff. CI runs database tests, including RLS allow/deny cases, constraints, function privileges, idempotency, and a migration replay. Do not use dashboard-only changes as the source of truth; capture any exceptional change in a new migration.
3. Apply the **same committed migration files** to isolated development, then staging, then production projects. Record applied migration versions and compare them across projects before promotion. Staging must pass the relevant mobile sync contract and privacy checks.
4. Never edit a migration already applied to a shared environment. Fix it with a new forward migration. For breaking changes, use expand → backfill → dual-client compatibility → contract, allowing older installed mobile versions to sync during the transition. Plan restore/forward-fix procedures before destructive migrations; a down script alone is not a recovery plan.
5. Pair each remote contract change with the Isar application data migration and sync-command version it affects. A local migration must preserve pending outbox commands, tombstones, and conflict records across app upgrades.

Alternative: a declarative schema source can generate migration files, but adds diff-tool conventions. The proposal uses explicit SQL migration files as the canonical deployment artifact. No migration file is created in this phase.

## 3. PostgreSQL naming and schema boundaries

**Recommendation:** Use lowercase `snake_case` identifiers without quoting, plural table names, singular descriptive columns, and explicit names for all nontrivial constraints and indexes. Reserve Supabase-managed `auth` objects; never rename or edit them as application tables. Proposed namespaces are `api` for the deliberately exposed Data API surface and `app_private` for trusted internal ledgers/functions. Keep application objects out of the automatically exposed `public` schema unless a feature plan gives a specific reason and an exposure review. Configure the project to expose only intended schemas, verify that configuration in each environment, and revoke unused default grants on `public`. Supabase supports [custom exposed schemas](https://supabase.com/docs/guides/api/using-custom-schemas) and recommends a clearly audited API surface in [Securing your API](https://supabase.com/docs/guides/api/securing-your-api).

| Object | Convention | Purpose |
| --- | --- | --- |
| Tables | Plural noun, e.g. `habits` in a later feature | Stable names that describe stored facts, not UI screens. |
| Columns | `id`, `<entity>_id`, `owner_user_id`, `created_at`, `updated_at`, `revision`, optional `deleted_at` | Consistent identity, ownership, lifecycle, and concurrency fields where applicable. |
| Constraints | `pk_<table>`, `fk_<table>__<column>`, `uq_<table>__<rule>`, `ck_<table>__<rule>` | Diagnostics name the invariant that failed. |
| Indexes | `ix_<table>__<lookup>`; use `uq_` only for a uniqueness rule | Avoid duplicate indexes and make query purpose visible. |
| Functions | Verb phrase with domain name and contract version when exposed, e.g. `submit_<domain>_v1` | Callers know the operation and version; do not expose generic unrestricted CRUD functions. |
| RLS policies | `<table>_<operation>_<audience>` | Review each operation/audience separately. |

Keep identifiers short enough for PostgreSQL's identifier limit. The examples are naming illustrations, **not proposed production objects**. Enum values and lifecycle states are defined in feature specifications; this foundation does not invent them. Any view or function in an exposed schema must be reviewed separately because it can bypass assumptions made about table RLS.

## 4. UUID and Isar identity mapping

**Recommendation:** Use PostgreSQL `uuid` for externally synchronized entity IDs and command IDs. Generate UUIDv4 on the device for offline-created, syncable entities and outbox commands so the same stable ID exists before and after upload; validate syntax and ownership server-side. Supabase Auth's user UUID is the canonical account identity. UUIDv4 is simple across Dart and PostgreSQL and does not depend on a synchronized clock; UUIDv7 and server-only sequences are alternatives if later measured write/index needs justify them. PostgreSQL supports native [UUID values](https://www.postgresql.org/docs/current/datatype-uuid.html).

- Store the canonical UUID as a normal indexed property in Isar. Isar's internal object key is local implementation detail and is **never** sent as a Supabase ID. Repository mapping uses canonical UUIDs, not names, timestamps, or row position.
- A client-created object's UUID remains its canonical ID if Supabase accepts the command. A server-only record may receive a server UUID; the command result returns that ID and the mapping is reconciled into Isar atomically with its acknowledgment.
- Outbox command IDs are separate from entity IDs. Retries reuse the same command ID. The server scopes an idempotency receipt to authenticated user plus command ID and returns the first committed outcome for duplicates.
- UUIDs are identifiers, **not secrets or authorization**. RLS/trusted functions derive the actor from Supabase Auth and check current permissions. No client may choose another user's `owner_user_id` or credit its own score by supplying an ID.
- One authenticated account has one isolated Isar store/path and outbox, per the architecture. Account switching must never sync another account's queue. The user-visible fate of unsynced data on sign-out/deletion remains a product decision.

## 5. Time, revisions, and optimistic concurrency

**Recommendation:** Mutable synchronized records use server-assigned `created_at` and `updated_at` (`timestamptz`) and a server-incremented integer `revision`. `created_at` is immutable; `updated_at` is observation metadata, not a conflict resolver or sync cursor. A command that edits an existing record supplies its expected revision. The server compares it inside the same transaction as validation and the write, then returns either the new canonical revision or a conflict with the current allowed snapshot. Client timestamps can be retained as evidence only; they do not decide acceptance or overwrite order.

Domain time is separate from metadata time. A scheduled occurrence's civil date/time-zone, completion deadline, and whether a late offline upload counts require `OQ-004`. A challenge's finalization window is also unresolved. Do not substitute `created_at`, device clock, or upload arrival time for those rules. Append-only check-in, restore, and score facts should preserve their own domain event meaning and not rewrite history (`BR-003`, `BR-007`, `BR-011`).

Alternative: `updated_at`-based last-write-wins is easy to implement but can silently erase offline edits. A row `revision` provides a clear compare-and-reconcile contract. Revision assignment and idempotency outcome must be atomic; the precise sync API is still architecture item `T-02`.

## 6. Soft deletion, tombstones, and retention

**Recommendation:** Distinguish **archive/pause** from **deletion**. For mutable syncable entities, represent an accepted delete with a server-controlled deletion marker and revision, and emit a minimal tombstone into the authorized change feed. The device keeps its local deletion intent in Isar until acknowledged; reconciliation then removes or marks the local projection while retaining the outbox receipt. A resnapshot must not resurrect deleted data. Historical check-ins, challenge results, and restore ledgers follow their PRD retention rules rather than a blanket cascading delete (`FR-003`, `FR-016`, `BR-011`, `BR-021`).

Tombstones expose only the minimum identifier and revision needed for a recipient to remove cached state. Permission revocation uses a recipient-scoped invalidation that can be delivered even after the recipient loses read access, without disclosing the owner's private content. Do not use a filtered feed that simply stops returning a row; that would leave stale local data. If a cursor is too old, a full authorized resnapshot plus local diff is required.

Physical purge timing, account-deletion retention, historical anonymization details, backup retention, and tombstone lifetime require Product/Legal input (`OQ-008`, `OQ-010`). The migration design must allow purge without breaking idempotency or exposing personal identifiers. This proposal does not define retention periods.

## 7. Row Level Security conventions

**Recommendation:** Deny by default. On each exposed table, enable RLS, reduce grants to the required operations, and add separate policies for `SELECT`, `INSERT`, `UPDATE`, and `DELETE` only where those operations are approved. Policies use the Supabase Auth identity and current stored ownership/friendship/sharing/challenge membership. Test both allowed and denied cases for signed-out, owner, friend, participant, creator, removed/blocked, and admin roles as applicable (`PERM-001`–`PERM-009`). Supabase explains the distinction between [grants and RLS](https://supabase.com/docs/guides/database/postgres/row-level-security).

- Private habit base records remain owner-only. Friend-visible data uses a narrow, permission-checked projection/endpoint that includes only explicitly shared fields. Row access does not imply permission to expose every column.
- Challenge membership never implies access to a participant's private habits. A friend removal or visibility change is checked against current server state on every remote read, including sync feeds.
- Exposed views must use a safe caller-security model or be replaced by narrow functions; never assume a view inherits base-table RLS. Review function execution grants and default privileges. Keep privileged `SECURITY DEFINER` functions outside exposed schemas, with fixed `search_path` and focused tests.
- A client publishable key may be embedded in the app; Supabase secret/service credentials must remain server-side. Privileged Edge Functions verify the caller and apply explicit authorization even when using a credential that bypasses RLS.
- RLS is defense in depth alongside constraints and trusted command validation. It cannot by itself enforce every cross-row balance, scoring, or idempotency invariant.

## 8. Index and constraint rules

**Recommendation:** Put invariants in PostgreSQL constraints and transactions; use indexes for measured access patterns. Every table added later needs a primary key, required foreign keys, appropriate `NOT NULL`/`CHECK` rules, and uniqueness for any rule where duplication would corrupt state. Candidate invariants include one accepted completion per scheduled occurrence, one contribution per eligible challenge occurrence, and one active restore request per friend pair; their exact keys/statuses wait for feature specifications and open product decisions (`BR-003`, `BR-009`). PostgreSQL documents [constraints](https://www.postgresql.org/docs/current/ddl-constraints.html), and Supabase documents [index trade-offs](https://supabase.com/docs/guides/database/postgres/indexes).

- Index ownership and permission joins, expected-revision lookups, and authorized sync-feed scans when those queries are designed. Add partial/composite indexes only for a demonstrated predicate and order. Check that foreign-key columns used in deletion/join paths are indexed where needed.
- Avoid a duplicate index where a primary-key or unique constraint already supplies one. Indexes cost writes and storage; inspect query plans under realistic data before adding speculative indexes.
- Isar's indexes speed local queries and can catch duplicate local intent, but Supabase constraints decide canonical validity. A constraint failure becomes a stable command outcome; it must never silently delete the Isar outbox entry.
- RLS and index design are reviewed together so permission checks remain both correct and practical at expected scale.

## 9. RPC, Edge Functions, and sync metadata

**RPC/database function guideline:** Use an authenticated, versioned database function for an atomic command when it can run safely with caller privileges and RLS (`SECURITY INVOKER` preferred). The command transaction validates expected revision, permissions, domain rules, idempotency, canonical write, and change-feed record together. For command-only private tables, deny direct client mutation; a verified Edge Function may invoke a narrowly scoped private transactional function. `SECURITY DEFINER` use requires explicit security review, fixed search path, and narrow execution grants. [Supabase database functions](https://supabase.com/docs/guides/database/functions)

**Edge Function guideline:** Use Edge Functions when a trusted credential, external push provider, server-to-server call, or request orchestration is needed. Verify Auth identity or server secret before work. Edge Functions do not replace PostgreSQL transactions for a multi-row gift or score update. Do not put service credentials in Flutter, Isar, or migration fixtures. Realtime may wake the sync engine but does not acknowledge commands. [Supabase Edge Function authentication](https://supabase.com/docs/guides/functions/auth)

**Minimum sync contract metadata (conceptual, no schema defined):**

| Location | Required information | Why |
| --- | --- | --- |
| Isar outbox | Account ID, command UUID, aggregate UUID/type, command type/contract version, payload or stable reference, expected revision, causal order, retry state/attempts, last outcome | Durable resend without losing local intent or crossing accounts. |
| Isar sync state | Last applied opaque server cursor, last successful sync, per-command acknowledgment/status, conflicts and recovery choices | Atomic reconciliation and Pending/Synced/Failed UI. |
| Supabase command receipt | Authenticated actor plus command UUID, canonical outcome, resulting IDs/revisions, and retention sufficient for long-offline retries | A timeout after server commit cannot duplicate a check-in/gift. Retention policy needs Product/Legal input. |
| Supabase change feed | Commit-safe order, authorized change reference, revision, deletion/revocation marker, contract version, and server-issued opaque cursor | Incremental pull without missing earlier commits or leaking private data. |

The cursor must represent **commit-safe ordering**. Do not use `updated_at`, device time, or an unvalidated allocation sequence as the sole cursor: a transaction that commits later could otherwise be skipped. The exact feed ordering mechanism and cursor-expiry/resnapshot protocol require technical approval (`T-02`). Apply canonical data, tombstones, command acknowledgment, and the new cursor in **one Isar transaction**. If Supabase committed but Isar did not record the result, retry the same command UUID and reconcile its recorded outcome. A receipt must not expire while its command might still be retried after a long offline period; without an approved maximum offline age, retain a minimal durable deduplication record or another proof that prevents repeated side effects. Social commands remain pending for other users until Supabase accepts them (`BR-023`).

## 10. Environment separation and staged schema evolution

Use separate Supabase **development**, **staging**, and **production** projects, each with its own Auth users, PostgreSQL data, keys, Edge Function secrets, and migration history. Developers may also use a local Supabase stack. No production user data is copied to nonproduction without an approved sanitization/legal process. Mobile environment selection is explicit; the app contains only the selected environment's publishable configuration. CI credentials are scoped per project. Region choice waits for `OQ-008`. Supabase describes [environment management](https://supabase.com/docs/guides/deployment/managing-environments).

Evolve one approved feature slice at a time. A slice contains only the objects and policies it needs, its Isar mapping/migration, command and feed versions, grant/RLS tests, constraints, indexes, and recovery tests. Candidate slices are account/profile, habits and schedules, occurrence/check-ins, restores, friends, challenges/leaderboards, and notifications; this is a planning list, **not permission to create their schemas now**. P1/P3 features retain PRD priority gates. Cross-feature constraints are introduced when the relevant specifications are ready, with compatibility for older mobile clients and existing pending outbox payloads. No feature table or function is created merely because it appears in this document.

## 11. Approved foundation decisions and unresolved product input

### Approved database foundation decisions

| ID | Approved decision | Alternative / risk |
| --- | --- | --- |
| DB-01 | Immutable reviewed Supabase CLI SQL migrations; local → dev → staging → prod promotion of the same artifact. | Declarative generation is possible; dashboard-only changes create drift. |
| DB-02 | Dedicated exposed `api` schema and non-exposed `app_private` schema, with explicit grants/RLS and no app tables in `public` by default. | `public` is simpler but has a larger default exposure surface. |
| DB-03 | Client-generated UUIDv4 for offline-created entities and commands; Supabase Auth UUID for users; Isar internal keys stay local. | Server-only IDs require mapping after sync and complicate offline references. |
| DB-04 | Server `timestamptz` metadata and per-record integer revision; expected-revision compare, no timestamp-based last-write-wins. | Timestamp conflict resolution can silently discard offline edits. |
| DB-05 | Deletion marker plus authorized tombstone/revocation feed, followed by policy-driven purge; archive stays distinct. | Immediate hard deletion can strand offline clients; exact retention is product/legal input. |
| DB-06 | Deny-by-default RLS/grants, owner-only base habit data, narrow shared projections, and transactional RPC/Edge command boundaries. | Broad table access or client-side permission checks can leak private data. |
| DB-07 | Idempotent command receipts and a commit-safe, opaque per-user change cursor, reconciled atomically into Isar. | `updated_at` or naive sequence cursors risk missing changes. Exact protocol remains architecture `T-02`. |

### Product rules that must remain open

| PRD question / dependency | Blocks |
| --- | --- |
| `OQ-004` and late-finalization decision | Occurrence identity/deadline, month boundary, acceptance of late offline check-ins, challenge final ranking. |
| `OQ-009` | User-visible conflict resolution for concurrent offline habit edits and deletion/edit races. |
| `OQ-003`, `OQ-005` | Equivalent challenge habits and rejoining; score/membership constraints. |
| `OQ-001`, `OQ-002` | Gift cap and anti-spam/rate-limit constraints. |
| `OQ-006`, `OQ-007` | Friend identifiers/discovery and moderation/report data access. |
| `OQ-008`, `OQ-010` | Region, legal/privacy controls, account deletion, backups, idempotency/tombstone retention and purge timing. |
| Local account-data decision from architecture | Handling unsynced Isar data when signing out, switching accounts, or deleting an account. |

Approval of DB-01 through DB-07 does not resolve these product questions. The affected feature specification must resolve them before its schema and implementation are authorized.
