# SL-05 — Today and occurrence check-in

**Stage:** Understand + Specify only
**Date:** 2026-10-06
**Status:** Product clarification finalized; PO-01 Option A and Missed rule approved by the Product Owner on 2026-10-06. Minimum design references and effective-start integration gap remain; implementation not authorized.

## User outcome

Open Today → see locally known habits due on their current Habit-local date → one-tap completion → immediate feedback after durable local commit → offline/restart survival → later canonical acceptance/rejection and reconciliation, without duplicate completions or silent loss.

## Authority and current baseline

Read/inspected: [PRD](../../docs/PRD.md), [registry](../../docs/FEATURE_REGISTRY.md), [roadmap](../../docs/ROADMAP.md), [project state](../../docs/PROJECT_STATE.md), [architecture](../../docs/ARCHITECTURE.md), [database](../../docs/DATABASE.md), [UI/UX foundation](../../docs/UI_UX_FOUNDATION.md), [design manifest](../../docs/design/DESIGN_MANIFEST.md), [Habits implementation guide](../../docs/features/habits/IMPLEMENTATION_GUIDE.md), [SL-03 specification](../003-local-first-write-sync-recovery/spec.md), and [joint SL-03/SL-04 Create Habit plan](../003-local-first-write-sync-recovery/plan.md). No separate SL-04 spec/plan artifact exists in the current repository. The joint plan records the approved creation subset.

Trace: FR-004, FR-005, FR-020, BR-003, PERM-002, FLOW-001/FLOW-003, NFR-002–NFR-006, UX-001/UX-002 and bilingual/accessibility requirements.

Inspected current Habit/HabitSchedule, domain repository/use cases, local Habit/CreateHabit intent/store, repository implementation, creation/list presentation, HabitAccountScope and routes. Current reality is account-private Isar, stable UUID entities/immutable Create Habit commands, local commit before independent Dio delivery, watcher-driven views, canonical atomic reconciliation, and fixed IANA timezone with Daily/selected ISO weekdays (Monday 1–Sunday 7). Today is a placeholder; occurrence/check-in implementation is absent.

The latest state/guide supersede historical generic statements that no product persistence exists or proposed files represent current ownership. The first personal Create Habit slice is closed and verified on development Supabase and Android. Full SL-03/SL-04 remain incomplete. Preserve their architecture and account guards; no feed, generic sync engine, full recovery destination or multi-device discovery is assumed. This is a product specification, not a storage/wire schema or technical implementation plan.

## Occurrence definition

An occurrence is one personal opportunity for one owned Habit on one scheduled Gregorian civil date in its retained IANA creation timezone. It exists by schedule semantics, whether the app ran or materialized a record. Daily selects every date; selected weekdays selects matching ISO weekdays. Dates before the effective local start date have no occurrence. A newly created Habit on a matching day becomes eligible immediately after successful local creation.

**Exact stable product identity:** the ordered pair `(canonical Habit UUID, scheduledLocalDate)`. Canonical UUID representation is lowercase; date representation is zero-padded `YYYY-MM-DD`, not a timestamp. If expressed as one string its meaning is `habitUuid/YYYY-MM-DD`. Account identity scopes storage and authorization but does not replace ownership validation. Names, row positions, acceptance timestamps and command IDs never identify an occurrence.

Timezone and applicable schedule evidence determine eligibility, but are not extra uniqueness dimensions: travel, offset/DST changes, new commands or future schedule revisions cannot create a second completion for the same Habit/date. Future SL-07 edits must preserve dated facts and this invariant; their effective-date rules are not specified here. No large future occurrence pre-generation is needed.

An uncompleted occurrence becomes eligible at the start of its scheduled Habit-local date, or at successful creation during that date. Eligibility ends when that timezone enters the next civil date. Recheck eligibility at local action admission; a stale Monday row cannot accept a new Monday tap on Tuesday. Technical review clarification: sample admittedAtUtc inside the admitted repository write path after queue delay and verify its Habit-local date equals scheduledLocalDate. Persist that admission evidence and immutable typed intent atomically in one transaction. admittedAtUtc identifies valid admission, not exact filesystem/fsync commit time. Local success exists only after the transaction completes successfully; network starts afterward. A crash before transaction completion produces no committed action. A validly admitted action whose transaction succeeds across the date boundary retains its original occurrence date; a new next-day admission cannot backdate. No second confirmation transaction or exact commit timestamp is required. A failed transaction is not completion. No time-of-day deadline, 24-hour interval, grace period, rollover, advanced recurrence or future completion.

| Occurrence state | Meaning |
| --- | --- |
| Pending | Current scheduled date, with neither accepted completion nor unresolved locally committed completion. User wording communicates “not completed”; unrelated to Pending sync. |
| Completed | One unresolved locally committed completion (provisional), or one canonical accepted completion. Sync status distinguishes these. |
| Missed | Scheduled date ended with neither accepted completion nor unresolved valid local completion. Connectivity does not determine this. |

Future dates are not due/actionable Pending. A definitively rejected attempt is retained evidence, not valid completion: state becomes Pending if its day remains open, otherwise Missed, unless canonical evidence establishes an existing accepted completion. Explain this correction visibly. No undo/completion deletion/manual historical check-in is introduced.

## Today rules

1. After local account data opens, select locally known owned habits scheduled on the current date **in each Habit's fixed timezone**, on/after its effective start. Do not apply device weekday or UTC date to every Habit.
2. Daily appears on each eligible date; selected weekdays appears only on matching dates. Unscheduled habits stay in Habits, outside Today's due list.
3. Completed rows stay visible alongside uncompleted rows. Count each due occurrence once. Unresolved local completions count provisionally with their sync label. All complete requires a nonempty due set; it does not claim all uploads are accepted.
4. A matching newly created local Habit appears immediately, even while creation is Pending sync. It can be completed offline. Its check-in's remote acceptance waits for canonical parent creation; temporary remote parent absence is not definitive invalidity. Rejected Habit creation blocks further check-ins and exposes retained dependent work as unaccepted recovery evidence.
5. Offline launch/restart render local data without a server request. Local loading/storage failure are distinct from empty; do not reset storage or fabricate example habits.
6. Reevaluate on launch/resume and date boundaries while visible, plus observed clock changes. Each Habit advances at its own zone's calendar boundary, including shorter/longer DST days. Travel does not migrate timezone.
7. Ended-date rows leave the current Today due list; no rollover. Prior-day pending/rejected work remains discoverable through feature-owned sync/recovery feedback even when its row leaves Today. This does not authorize history or a full recovery screen.
8. Distinguish no locally known habits, habits but none due, and all due complete. Do not claim the device has downloaded every account Habit; feed/multi-device discovery is deferred.
9. Mixed fixed Habit zones may have different current dates. Each row targets its own date; a screen heading is orientation, not universal eligibility. Any necessary per-row date/zone clarification requires explicit design approval.

## Check-in rules and local-first/offline behavior

One tap requests completion of that exact eligible occurrence. Local acceptance atomically retains completion evidence, immutable durable intent, and Completed / Pending sync **before network work**. Feedback/progress update follows successful commit immediately, without awaiting remote response. Local write failure yields no partial completion, success or send; expose actionable local failure.

Required durable evidence: original account, Habit UUID, exact occurrence key/date, retained timezone, applicable schedule/start evidence, admittedAtUtc as the locally observed completion-admission instant and its corresponding Habit-local date, separate stable command UUID/version and immutable action contents. Remote acceptance instant is a separate canonical fact. These are evidence requirements, not collection/SQL/request definitions.

Offline commit → close → same-account reopen → same dated completion/intent and Pending sync → later authorized delivery → canonical local reconciliation. Temporary network failures or credential expiry do not undo completion or delete intent. Existing Auth admission/reauthentication rules apply; no new offline login promise.

Foreground activation/resume, post-commit delivery opportunity and explicit Retry must permit eventual delivery with valid same-account credentials. A pending parent creation must be accepted before the dependent check-in can be canonically accepted. Preserve the original targeted date across this dependency. No background engine, timer loop or guaranteed OS background execution is specified.

### Separate completion from synchronization

| Check-in sync state | Meaning |
| --- | --- |
| Pending sync | Locally committed intent awaits delivery, acknowledgement or successful local reconciliation; includes offline, timeout, uncertain outcome, authorization interruption and invalid response. |
| Synced | Server accepted, and canonical completion plus acknowledgement committed locally together. |
| Failed | Definitive rejection requiring attention; intent/reason retained. |

An occurrence without a check-in has no check-in sync status. Habit creation status is separate: an unchecked row must not imply “Synced completion.” Temporary transport trouble remains Pending sync with safe explanation/applicable Retry. No arbitrary persistent-failure threshold or generic state framework is introduced.

After definitive rejection, an eligible current-day corrected action may be admitted only if no accepted or unresolved completion exists; preserve previous failed evidence. Blind retry cannot override rejection. Uncertain transport retries always reuse the original intent.

## Duplicate and idempotency rules

| Case | Required behavior |
| --- | --- |
| Double/concurrent tap | Durable admission permits at most one unresolved or accepted completion per occurrence; subsequent tap communicates already completed. Button disabling alone is insufficient. |
| Same command retry | Same stable UUID and immutable contents return the original canonical outcome. Changed-content reuse cannot overwrite it. |
| Different command, same occurrence | At most one canonical completion; return authorized existing completion evidence and reconcile already completed, without a second contribution. |
| Response lost after server commit | Local remains unresolved; replay original command retrieves recorded outcome. |
| Restart before acknowledgement | Same command/key and provisional completion restore; retry unchanged. |
| Local apply fails after acceptance | No partial acknowledgement/Synced; same-command replay recovers recorded outcome. |

A duplicate rejection cannot erase an existing canonical completion. Deduplication must remain safe across long-offline replay; no receipt purge duration is invented.

## Late offline upload decision — PO-01 Option A approved

**Approved personal V1 rule (2026-10-06):** a completion validly admitted for Monday in the Habit zone and successfully committed by its atomic local transaction remains valid if first delivered Tuesday or later. Admission is evidenced by admittedAtUtc; durable success is evidenced by successful transaction completion, not an exact fsync timestamp. No arbitrary maximum offline age. Arrival date does not move it to Tuesday. Someone who never completed Monday cannot open Tuesday and create a Monday check-in; this is a new historical action, not delivery of retained intent.

Server validation must authenticate the original owner, validate canonical Habit identity/schedule/zone and applicable start, verify the targeted date exists, ensure recorded admittedAtUtc maps to that date in that zone and is not in the future relative to authoritative receipt time, validate immutable command/evidence consistency, and deduplicate command plus occurrence. It returns canonical dated acceptance/rejection. Offline-created Habits may be accepted later than their first completion; metadata creation time cannot be substituted for recurrence start.

Durable evidence proves what the app recorded and which occurrence it targeted. It does **not** cryptographically prove real wall-clock time or defeat device-clock manipulation/modified clients. The Product Owner approves Option A and accepts the documented limitation: internally consistent client-observed timing is personal V1 evidence after independent ownership/schedule validation, not cryptographic proof against a modified client/device clock. No anti-fraud or challenge scoring guarantee is claimed. Inconsistent evidence is rejected visibly with retained intent, never silently reassigned.

## Missed-state rule

**Approved Missed rule (2026-10-06):** after a scheduled Habit-local date ends, an occurrence is Missed only when there is no canonical accepted completion and no unresolved valid locally committed completion. Evaluate this whether online, offline or returning after restart. No midnight job or server request is needed. Non-scheduled dates and dates before effective start are never Missed.

A Monday locally committed completion stays Completed / Pending sync after Monday ends; delay alone cannot make it Missed. Late acceptance confirms Monday. Definitive rejection after day end makes it Missed with visible correction and retained attempted-action evidence, unless an existing accepted completion is returned. No streak change is calculated here.

Offline evaluation uses observed device time. Clock changes cause reevaluation; never rewrite saved completion dates or create new identities. Clock rollback cannot duplicate an existing completion. Missed is derived, not an irreversible midnight mutation, so a corrected observed date may correct projection. True physical time cannot be guaranteed offline; the server independently validates submitted evidence. This limitation belongs to PO-01's trust choice, not a new anti-fraud feature.

No historical manual completion decision is reopened: the approved same-day eligibility rule excludes new backdated actions. Adding such a control requires separate scope approval. The next-date Missed rule follows from approved full-day eligibility; it is not an additional arbitrary deadline choice.

## Account isolation

A's occurrences, intents and outcomes are observable/uploadable only by A. B cannot see or upload A's pending work. Captured actor credentials cannot be substituted with B credentials. Late A results cannot mutate B's store/presentation or reopen a closed scope. Confirmed A can resume retained work when A returns. Preserve current cleanup-before-rebind, stale-event/account guards, sign-out warning and reauthentication behavior. No HabitAccountScope/Auth redesign.

## Server authority boundary

Server authority covers canonical accepted completions. Required guarantees: stable command identity, stable occurrence equality, authenticated ownership, concurrency-safe duplicate protection, immutable canonical accepted/rejected/already-completed outcome, and atomic local reconciliation. IDs/timestamps are evidence, not authorization. No exposed mutation may bypass these guarantees.

Acceptance must correlate account, command/version, Habit and occurrence date. Synced requires valid canonical facts and acknowledgement committed locally together. Malformed/mismatched outcomes leave intent unresolved. Rejection preserves intent/reason and visibly corrects provisional state. Authorized existing accepted completion evidence must not be erased by duplicate rejection. No SQL, Edge implementation, generic protocol, streak counter or score is designed.

Leave stable dated schedule/start/zone facts, occurrence identity, observed completion timing, canonical acceptance timing/outcome and duplicate/rejection evidence for SL-06. Do not calculate history or streaks.

## Concrete required integration gap

Current Habit `createdAt` is nullable until server acknowledgement; current immutable Create Habit intent has no local creation instant/start date. The current implementation therefore cannot recover an original offline recurrence start from canonical creation metadata. SL-05 requires a durable effective start date established by successful local creation in the fixed zone and preserved across later acceptance. Missing historical evidence must not be fabricated, inferred from UUID/Isar order or replaced with server acceptance time.

This is the concrete integration issue permitted by this task, recorded only. The later technical plan must propose the minimum compatible change to establish durable effective schedule-start evidence during local Create Habit and handle existing stored Habits before pre-start validation is implemented. Do not implement that change now. Current locally known existence supports today's opportunity but does not prove prior start dates. No Create Habit code, schema, migration or architecture is changed here; no retroactive history reconstruction is specified. This is an engineering evidence gap, not a reopened schedule/product decision.

## Approved design coverage

Approval applies only to the exact image/scope in the manifest. Visually inspected REF-001 and supporting failure/offline/Arabic references.

| Repository-root PNG | Approved coverage / limits |
| --- | --- |
| `docs/design/references/REF-001-today.png` | Primary English Today shell/hierarchy, unchecked circles, green Completed controls, Completed / Pending sync row, Synced treatment and partial progress. No Missed/empty/all-complete state. |
| `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-001-sync-failed-review-en.png` | Completed control plus failed-sync label and Review entry; not actual Retry/rejection details/destination. |
| `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-002-offline-en.png` | Offline/local-save treatment and completed controls; example copy/icons do not establish canonical acceptance. |
| `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-003-large-text-en.png` | Supporting approved layout-growth reference, not approval of unshown feature states. |
| `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-004-sync-issue-compact-en.png` | Supporting compact issue/Review pattern; example wording cannot override state meaning. |
| `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-005-today-rtl-ar.png` | Arabic RTL shell/cards, unchecked/Completed controls and Pending sync. Not every failure/empty variant. |

REF-001's streak numbers, past-day checkmarks, “Before 11:00 PM” deadline, reminders, glass targets, overflow menus and detail/promotional arrows are visual examples, not permission to implement these features. No fabricated streak/history data, deadlines or new target types. Weekly historical progress requires facts outside SL-05. Reuse REF-001 for the approved core Today presentation without fabricating unavailable facts; the first design gate is limited to the three additional treatments below, not a full-screen redesign or exhaustive variant matrix.

## Minimum design-gap brief — first implementation gate

Only three additional treatments need explicit visual approval. Component/section PNG references may reuse the approved shell; no new full-screen PNG or exhaustive English/Arabic/size matrix is required. Bilingual, RTL and accessibility requirements still apply to implementation.

| Treatment | Minimum additional reference | Reuse of approved SL-01 patterns |
| --- | --- | --- |
| Today — Missed occurrence | One dated Missed row/notice reference showing neutral wording, no completion action, and distinction from current-day Pending. It must show where the ended-date notice sits without adding the past occurrence to today's due count or enabling history/backdating. | Reuse Today cards/shell, RTL and large-text patterns. No existing approved PNG depicts Missed, so its small state/placement reference needs approval; a new full screen is unnecessary. |
| Today — no habits / nothing due | One empty-panel reference with two copy/action variants: no habits offers the existing Create Habit entry; nothing due explains that habits exist but none are scheduled now. | Reuse approved shell, typography, spacing and buttons. SL-01 references do not establish this empty treatment; approve one reusable panel rather than two full screens. |
| Today — definitive check-in failure / Retry or Review | One compact failure/correction row or panel reference with a safe reason, retained action evidence and applicable Review. A rejected completion must not remain visually accepted; after day end it is Missed unless canonical accepted evidence exists. | Reuse `SL01-UI-001` failed label/Review entry and `SL01-UI-004` compact issue pattern. Only the check-in-specific correction/reason/action needs additional approval; no new full screen or full recovery destination is required. |

Retry applies to unresolved delivery/reconciliation trouble using the same command. A definitive rejection is not repaired by blindly retrying the unchanged rejected command; use Review or an applicable eligible current-day correction. Approval of a Review visual does not imply a full Sync & Recovery screen already exists. The failure reference must make the actual scoped action understandable.

Normal Today, unchecked, Completed, Pending sync and Synced treatment remain covered by REF-001. Reuse the existing progress/status patterns for all-complete without requesting another full-screen reference. Conventional loading, storage feedback and already-completed interactions do not expand this first gate into a separate PNG matrix. No images are designed or produced in this clarification.

## Acceptance criteria

Future acceptance obligations, not executed tests or an implementation plan. Late-upload and Missed criteria use the Product Owner-approved rules.

| ID | Scenario | Required result |
| --- | --- | --- |
| AC01 | Daily and selected-weekday Habits in Today | Matching current Habit-local dates appear once; unscheduled Habits are absent. |
| AC02 | Monday/Wednesday schedule on Tuesday then Wednesday | No Tuesday occurrence/Missed; Wednesday is eligible. |
| AC03 | Create matching Habit during today, including offline | Immediate due row/check-in eligibility after local create, without remote acknowledgement; nonmatching Habit stays absent. |
| AC04 | Offline launch/restart | Cached due rows/check-ins render without server request; loading/storage error is not empty. |
| AC05 | Tap while remote delivery is delayed | Local commit precedes send; Completed / Pending sync and progress update immediately after commit. |
| AC06 | Local write fails | No completion/progress increment/upload; actionable local error. |
| AC07 | Offline check-in, close, reopen same account | Same dated key/command/completion survive; later delivery reconciles to Synced. |
| AC08 | Double/concurrent tap, tap after restart | One contribution and no second unresolved completion; already completed is understandable. |
| AC09 | Same remote command retried/concurrent | Same canonical outcome, one completion; changed contents cannot overwrite it. |
| AC10 | Different commands target same occurrence | One canonical completion; existing completion reconciles without duplicate contribution or false loss. |
| AC11 | Server commits, response lost | Pending sync persists; same-command replay produces eventual Synced with one completion. |
| AC12 | Invalid response/local reconciliation failure | No Synced/partial acknowledgement; retained intent permits recovery. |
| AC13 | Monday committed offline, delivered Tuesday/much later | Under approved PO-01 Option A, valid original Monday completion accepted, never moved to Tuesday; admittedAtUtc maps to Monday and the single atomic transaction succeeded; no exact fsync date proof is required. |
| AC14 | No Monday action, Tuesday opens/stale Monday tap | Monday Missed; no new Monday backdated completion admitted. |
| AC15 | Scheduled day ends or restart offline after end | Uncompleted occurrence derives Missed without network/job; unresolved committed completion stays Completed / Pending sync. |
| AC16 | Temporary transport/credential failure | Local action survives; appropriate Retry/reauthentication, no silent rollback. |
| AC17 | Canonical rejection during/after its day | Retained intent/reason and visible correction to Pending/Missed unless existing accepted completion exists. |
| AC18 | Habit and check-in created Monday offline, parent accepted Tuesday | Original start/date preserved; acceptance metadata cannot shift or falsely invalidate Monday. |
| AC19 | A pending → sign out → B → A | B sees/uploads none of A's work; late A result cannot affect B; confirmed A resumes original intent. |
| AC20 | Travel/DST/clock rollback | Fixed Habit zone/calendar governs; no 24-hour rollover/duplicate completion; inconsistent evidence reconciles visibly. |
| AC21 | No habits / none due / all due complete | Distinct states; all-complete does not imply pending uploads are Synced. |
| AC22 | English/Arabic RTL, large text, screen reader | Completion and sync states separately understandable, accessible controls and correct reading order; color is not sole signal. |

## Final Product Owner clarification — 2026-10-06

- **PO-01 Option A: APPROVED for personal V1.** A check-in validly admitted for its scheduled Habit-local date and successfully committed by the atomic local transaction remains valid when first uploaded after that date ends. The technical review distinguishes admittedAtUtc from durable transaction success and requires no exact fsync timestamp or second confirmation phase; PO-01 remains approved. Server arrival time cannot move it to another date.
- Server still validates authenticated ownership, canonical Habit, schedule, retained Habit timezone, effective start date, occurrence identity, internally consistent recorded completion evidence and deduplication.
- The Product Owner accepts that offline client-observed time is not cryptographic proof against a modified client/device clock. No challenge finalization or anti-fraud policy follows from personal V1 acceptance.
- **Missed rule: APPROVED.** After scheduled date end, Missed requires both no canonical accepted completion and no unresolved valid locally committed completion. A valid offline completion remains Completed + Pending sync until canonical reconciliation.
- **Historical/manual backdated completion: OUT OF SCOPE.** Tuesday cannot create a new Monday completion.
- **Effective-start evidence gap: PRESERVED, unimplemented.** The later technical plan must propose the minimum compatible change. No inferred server acknowledgement time, UUID/Isar ordering or fabricated evidence is permitted.

No unresolved Product Owner decision remains for this SL-05 clarification. Minimum visual approvals and the later engineering integration treatment remain separate gates; this artifact authorizes no implementation or technical plan.

## Out of scope

Streak calculation/current or longest streak; history screen/projection; Streak Restore; reminders; Habit edit/pause/archive/delete; friends; challenges; leaderboards; generic sync feed/framework; background sync engine; automatic timezone migration; advanced recurrence. Future dependencies receive stable facts only.

## Technical timing clarification — current review

Only admission-versus-durable-success wording is clarified by this review. PO-01, Missed, historical completion exclusion and the effective-start gap remain unchanged in authority. The separate plan records technical review decisions; no implementation is authorized.

## Files changed and stage boundary

Only `specs/005-today-occurrence-check-in/spec.md` updated for final clarification. No production code, implementation plan, migration/schema/Isar collection, Edge Function, package change, PNG, commit or push. Existing working-tree edits preserved. Product clarification is finalized. The minimum visual references above and explicit authorization for later stages remain; no technical plan or implementation is created now.
