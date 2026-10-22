# SL-03 — Local-first write, sync, and recovery path

**Stage:** Understand + Specify only  
**Date:** 2026-10-05  
**Status:** Draft specification; open decisions recorded; implementation not authorized  
**Validation:** SL-04's first real owned-habit Create Habit command

## Purpose and user-visible outcome

An eligible signed-in user can save a personal action immediately on the device, including offline, distinguish local success from remote acceptance, and later receive reconciled Supabase-confirmed state without duplicate effects or silent loss. Interrupted delivery, restart, account changes and rejection leave durable, understandable retry/recovery.

SL-03 defines the guarantees required by the first real owned-habit command. It must not become an unused generic infrastructure project. FR-020's later edits, pause/archive, check-ins, reminders and profile operations stay with their owning slices. FR-021/BR-023 constrain later social/challenge commands; they do not authorize building those features here.

## Sources and current baseline

Authority: [PRD](../../docs/PRD.md) FR-020–FR-022, BR-022–BR-023, §18 offline/failure cases, OQ-009, NFR-002–NFR-012 and UX-003/UX-010/UX-014; [registry](../../docs/FEATURE_REGISTRY.md) SL-03/SL-04; [roadmap](../../docs/ROADMAP.md) planning rules, Stage A/B and first personal vertical checkpoint; [architecture](../../docs/ARCHITECTURE.md) local-first boundaries; [database](../../docs/DATABASE.md) DB-01–DB-07 and sync metadata/receipts/feed; [UI/UX foundation](../../docs/UI_UX_FOUNDATION.md) recovery/design gates; [design manifest](../../docs/design/DESIGN_MANIFEST.md); latest dated relevant [project-state decisions](../../docs/PROJECT_STATE.md).

SL-02 is completed for this stage, as directed by the Product Owner. [Auth implementation guide](../../docs/features/auth/IMPLEMENTATION_GUIDE.md) controls current Auth ownership: Cubit -> UseCase -> AuthRepository -> SupabaseAuthRepository -> SDK, with secure Auth/PKCE storage. AuthSession retains userId/expiry evidence and dynamic accessTokenValid. Historical coordinator/DataSource text is not current authority. This specification changes no Auth behavior and grants no offline login or broader protected-access exception.

There is no production product Isar store, outbox, sync engine or product migration. Removed speculative connectivity/status code is not an existing capability. Latest Auth production analysis is clean; historical full-suite results are not SL-03 evidence, and Auth test migration remains separately pending.

## User flows

1. **Local save:** Eligible A submits SL-04's valid Create Habit. Habit evidence, local projection and durable intent commit together before success or network work. The local habit list immediately shows the saved habit and Pending sync, online or offline.
2. **Resume delivery:** Launch/resume, reachability changes and eligible active use provide sync opportunities. Valid same-account authorization and actual backend reachability are required. Remote refresh keeps local content usable. Accepted canonical results are reconciled locally before Synced.
3. **Unknown outcome:** A response is lost after server commit, or the app dies before recording acknowledgement. The original intent survives; resend uses the same command ID and retrieves the recorded outcome without creating another habit.
4. **Recovery:** Transient errors retain Pending intent. Persistent failure or definitive rejection is visible with a reason and applicable Retry or Review/recovery. Conflict preserves local intent and relevant authorized server evidence; exact choices remain OQ-009.
5. **Account exit/return:** A signs out through the existing pending/unknown-work warning; A's work survives but B cannot see or upload it. Confirmed invalidation hides protected work and blocks upload. Valid same-account reauthentication can resume retained work; no dedicated account-switch feature is added.
6. **Offline restart:** After local loading, committed personal data, intent and durable statuses return without network. An unresolved previous upload stays unconfirmed rather than being discarded or guessed Synced.

## Business rules

### Local-first and durable intent

- **R01 — Atomic acceptance:** Every eligible personal write commits its action/projection, durable outbox intent and Pending state in one Isar transaction before reporting local success or sending a request (FR-020, BR-022). Transaction failure yields no successful/partial accepted action or upload; recoverable input remains available.
- **R02 — Durability:** Committed actions survive restart, process death and connectivity changes until synchronized or explicitly resolved. UI/Cubit observes account-scoped local state through repositories, not a separately synchronized network copy.
- **R03 — Intent evidence:** Required conceptual information is account ID; separate stable entity and command UUIDs; aggregate/command identity and version; payload or durable reference; expected revision when applicable; causal order; retry state/attempts and last outcome. Sync evidence includes cursor, acknowledgement/status, last successful sync and recovery evidence. This is not a collection or schema definition.
- **R04 — Stable retry:** Retries reuse command IDs. Preserve per-aggregate causal order; independent work may progress. Rejected intent is retained, not silently deleted, expired or overwritten. Later local upgrades must preserve outstanding intent/recovery and fail safely with a recoverable copy.

### Account isolation and privacy

- **R05 — Ownership:** Supabase Auth userId scopes each isolated local store/path, projection, outbox, cursor and recovery record. Leaving A closes/locks its access before binding B. In-flight A results cannot mutate B's state or send A's work under B's credentials. Resume requires confirmed original-account identity.
- **R06 — Admission:** Local eligibility follows accepted SL-02 access rules; offline connectivity alone is not invalidation. Fresh login/registration/recovery require network. Upload requires valid original-account authorization. Expiry never erases intent. No expiry timer or new Auth exception is specified.
- **R07 — Authority:** Server derives actor identity and checks current ownership/permissions/domain rules. Client IDs, timestamps, owner fields and revisions confer no authority. Private default and owner-only base habit access remain SL-04/DB-06 requirements. Deny-by-default RLS/grants protect exposed paths.
- **R08 — Privacy:** Do not durably cache other users' shared habit details. Later social queueing uses only minimum permitted metadata. Feeds/revocation markers must not disclose private content; unavailable states must not confirm private existence. Logs and indicators omit credentials, command payloads, habit contents and private account details. Auth secure storage does not prove product-data at-rest protection.
- **R09 — Remote effects:** Social actions and offline privacy reductions/removal are effective for other users only after authoritative acceptance (FR-021, BR-023, UXF-08). Copy explains delayed effect. No social implementation or account-deletion retention policy is added here.

### Status and Supabase acknowledgement

| Status | Meaning | User-facing obligation |
| --- | --- | --- |
| Pending | Action/intent is locally committed; canonical acceptance is not yet reconciled, including offline, in-flight, transient failure or uncertain outcome. | Local success plus Pending sync beside the affected action. |
| Synced | Supabase accepted the domain command and its canonical result/acknowledgement committed to Isar. | Accessible restrained confirmation for that command/version; not a promise about subsequent edits. |
| Failed | Definitive rejection/conflict or persistent delivery problem needs attention; original intent survives. | Reason and applicable Retry or Review/recovery, discoverable beyond a transient toast. |

- **R10 — Separate meanings:** Offline is a condition, not a failed personal action. Reachability, local loading/save and sync status are separate. Online/interface availability, HTTP delivery alone, a toast or Realtime event never proves canonical acceptance. Transient errors remain Pending; persistent errors expose Failed. Numerical thresholds/backoff timings remain unspecified at this stage.
- **R11 — Acknowledgement:** A trusted authenticated command transaction validates permissions/domain/expected revision and commits canonical outcome, actor-scoped command receipt and required change evidence. Duplicate requests return the first committed outcome. A rejected outcome is not successful Synced acceptance.
- **R12 — Ambiguity/deduplication:** Timeout or connection loss may follow remote commit. Recover/resend the same intent; never infer rejection or generate a new command ID. Receipt retention must support long-offline retries. Without an approved maximum offline age, preserve minimal durable deduplication evidence or equivalent proof against repeated side effects (DB-07).

### Reconciliation and recovery

- **R13 — Atomic reconciliation:** Apply canonical changes, applicable tombstones, command acknowledgement/status and new cursor in one Isar transaction. Failed local reconciliation after remote commit must not show Synced or partially advance evidence; retry obtains the recorded outcome. Server corrections remain visible and cannot silently erase local intent.
- **R14 — Authorized pull:** Use a permission-filtered feed with server-issued opaque commit-safe cursor. Device time, updated_at and naive allocation sequence are not adequate cursors. Expired cursors require an authorized bounded resnapshot/local diff preserving unacknowledged intent and preventing deletion/revocation resurrection. Exact protocol remains T-02.
- **R15 — Retry:** Transient failure uses bounded backoff/jitter; resume/reachability/active use can trigger opportunities subject to OS limits. Correctness cannot depend on background execution or Realtime. Retry rechecks authorization and idempotency; definitive rejection is not overcome by blind automatic retries.
- **R16 — Conflict:** Detect applicable expected-revision mismatch and retain original local intent plus relevant allowed canonical evidence. Do not choose automatic merge, last-write-wins, winner, discard default or user resolution choices before OQ-009.
- **R17 — Local failure:** Store-opening/storage/migration failure fails safely with understandable recovery; do not pretend data is absent or accept undurable writes. Pending work is not silently reset to empty on recovery.
- **R18 — Presentation:** English/Arabic, RTL, large text, readable labels/icons and accessible controls apply from the first path. Status cannot rely on color. Opening local data is distinct from empty; refresh leaves local content usable. Consolidated Sync & Recovery complements action-level status; global indicators must not obstruct the main action.

## SL-03 and SL-04 boundary

Stage A establishes foundation guarantees; Stage B owns the first personal aggregate. SL-03 supplies observable local-save/delivery/recovery semantics. SL-04 owns Create Habit validation, habit/schedule meaning, Private default, optional details/category/icon/target where specified, local list and the concrete feature command/data contract. Richer taxonomy and later commands remain outside scope.

SL-03's eventual validation MUST use SL-04's first real Create Habit command: submit -> account-isolated durable local habit plus intent -> local list/Pending -> offline restart survival -> duplicate-safe authorized Supabase acceptance -> canonical Isar reconciliation/Synced, with failure/recovery and account-isolation evidence. A placeholder command, simulated queue or generic engine demonstration cannot close this slice.

This is a joint validation checkpoint, not circular prerequisites: specified SL-03 guarantees inform SL-04, and SL-04 supplies the approved concrete aggregate for the first implementation proof. Do not build unused infrastructure beforehand. The first personal vertical checkpoint also needs the approved occurrence/deadline rule, bilingual UI and local success distinct from remote sync. OQ-004 gates final SL-04 schedule semantics; an approved form PNG cannot resolve them. No SL-04 specification/plan or data contract is created here.

## Acceptance criteria

| ID | Scenario | Required result |
| --- | --- | --- |
| AC01 | Eligible A creates a valid SL-04 habit online/offline | One atomic local habit/intent commit before success/network; one locally visible habit with Pending sync. |
| AC02 | Local write fails, including full/unavailable storage | No success, partial accepted write or upload; actionable feedback and recoverable form input. |
| AC03 | Process dies after local commit; restart offline | Same account restores habit, same command ID and outstanding status after loading; no premature empty state. |
| AC04 | Supabase accepts Create Habit | Canonical result and acknowledgement reconcile atomically before Synced; entity identity remains stable. |
| AC05 | Lost response or crash between remote commit/local acknowledgement | Same-ID retry returns recorded outcome; one canonical habit/side effect; no guessed Synced. |
| AC06 | Local reconciliation fails after remote acceptance | Original intent survives; no partial acknowledgement/cursor advancement; recovery avoids duplication. |
| AC07 | Backend unreachable despite connectivity; repeated transient errors | Local content remains usable; Pending/bounded retries; persistent failure is visible Failed with recovery and preserved intent. |
| AC08 | Server rejects permission/domain validity or detects conflict | Preserve reason/intent; no unauthorized write, silent correction/merge or invented conflict choice. |
| AC09 | A exits; B enters while A has queued/in-flight work | Existing warning applies; B cannot access/upload/reconcile A's work; only confirmed A resumes it. |
| AC10 | Authorization expires/is confirmed invalid | Stop unauthorized delivery, preserve intent and obey current Auth guards; valid original-account authorization required to resume. |
| AC11 | Cursor expires, deletion/revocation arrives, or local apply is interrupted | Authorized reconciliation/resnapshot is atomic, preserves unacknowledged intent and does not resurrect removed data; protocol awaits T-02. |
| AC12 | Recovery/status is shown in English/Arabic RTL/large text | Local success, reachability and Pending/Synced/Failed stay distinct and accessible; persistent problems have actionable Review/recovery. |
| AC13 | Later social/privacy feature uses these guarantees | No remote effect claim before acceptance and no private leakage through queue/feed/logs. Boundary criterion only, not social implementation here. |

Criteria describe future verification obligations, not executed tests or an implementation/test plan.

## Resolved decisions and genuine blockers

Resolved: local-first Isar; durable transactional intent before success; UUIDv4 entity/command identities; server revisions/authority; deny-by-default grants/RLS; authorized tombstones/revocations; idempotent receipts and commit-safe opaque cursor/atomic reconciliation; status meanings; one active account/no dedicated switch; original-account retention across sign-out and same-account resumption; delayed social/privacy effects; separate reachability; bilingual/accessibility and design gates. DB-01–DB-07 are approved principles, not existing schemas or approval of all protocol details.

| Open item | Unresolved decision and gate |
| --- | --- |
| **OQ-009** | User-visible conflict choices/allowed resolution for competing habit edits, schedule/visibility/deletion races. Blocks final conflict behavior/UX and affected implementation. No resolution is invented. |
| **T-02** | Versioned command/outcome/feed contracts; commit-safe ordering; cursor expiry/resnapshot; exact RPC vs Edge boundary and grants/privileged-function review. Blocks concrete remote sync implementation. |
| **T-01** | Maintained Isar distribution/platform validation plus at-rest protection, backup and key recovery. Blocks safe product/outbox persistence approval; Auth storage is not sufficient evidence. |
| **OQ-004** | Schedule period/deadline/time-zone/travel/DST/late-offline rules. Blocks SL-04's final schedule specification and complete first personal vertical checkpoint. |
| **OQ-008 / OQ-010** | Legal/region, receipt/tombstone/backup/purge/account-deletion retention. Gates affected production policies; no duration is invented, and deduplication must remain safe. |
| **Transport authority inconsistency** | ARCHITECTURE §2 permits Supabase SDK database/RPC/Realtime; PROJECT_STATE's 2026-10-04 infrastructure decision restricts SDK to Auth and uses configured Dio for feature REST. Reconcile with T-02 before choosing feature-data transport. This spec selects none. |
| **SL-03 design approval** | Full Sync & Recovery and detailed retry/preserved-intent/conflict states have no approved SL-03 screens. Blocks their UI implementation; conflict designs also wait for OQ-009. |

These do not prevent recording this specification. Sign-out retention is resolved and is not reopened. Other slices' challenge/gift/deletion semantics do not expand the first Create Habit path. Historical Auth architecture and test results do not establish current persistence/sync behavior.

## Design references and outstanding designs

Approved supporting references from the manifest; repository-root paths:

- REF-001: `docs/design/references/REF-001-today.png` — shell/one Pending item.
- REF-002: `docs/design/references/REF-002-habits.png` — habit list/Pending.
- SL01-UI-001: `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-001-sync-failed-review-en.png` — persistent issue, failed item, Review entry.
- SL01-UI-002: `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-002-offline-en.png` — offline/local-save distinction.
- SL01-UI-003: `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-003-large-text-en.png` — layout growth.
- SL01-UI-004: `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-004-sync-issue-compact-en.png` — compact issue entry; example copy does not override status semantics.
- SL01-UI-005: `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-005-today-rtl-ar.png` — Arabic RTL/Pending.
- SL04-UI-001: `docs/design/screens/004-habit-create/SL04-UI-001-create-habit.png` — Create Habit visual only, not schedule semantics.

SL-01 approves shell/status references, not the full recovery destination or conflict workflow. Reconnecting/Syncing need no separate PNG merely for technical planning, per the manifest. Future required design coverage includes consolidated recovery pending/failed/empty/loading; action reasons/retry details; preserved-intent/server-correction presentation; after OQ-009, actual conflict-resolution and any consequential confirmation. Relevant English/Arabic RTL, large-text/accessibility states require approval; unshown states are not approved by implication. SL-04 owns additional local-save/list/failure variants for its command. No new design is created here.

## Stage boundary

Only this specification is created. No plan/tasks, production code, schema/contract/migration, Isar collection or generic sync framework is created. Later design/planning/implementation must respect applicable unresolved gates. No commit or push.
