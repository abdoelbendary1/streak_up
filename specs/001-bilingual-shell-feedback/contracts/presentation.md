# SL-01 Presentation Contracts

This contract defines what later slices provide to the shared shell. It is not a network, database, or product-event API.

## Navigation host

- Provide one typed route/host for each of Today, Habits, Challenges, and Friends; exactly one is selected in the bottom bar.
- Provide global Inbox and Profile actions, and a Sync & Recovery entry when there is pending work or a failure needing attention. Returning from a global route restores the prior selected branch.
- Destination content enters through owning feature route builders or hosts. SL-01 may use labeled test/development surfaces; they are not production feature implementations.

## State input

- A future state source supplies a typed connection projection: Online, Offline, Reconnecting, Syncing, or SyncFailed. Interface connectivity alone cannot supply Online. An auth/session action-required cause is distinct from Offline.
- An owning feature supplies a typed Pending, Synced, or Failed action status and the affected action context. Pending means local save without remote acknowledgment; Synced requires acknowledgment/reconciliation; Failed stays discoverable with a valid recovery intent.
- SL-01 maps supplied state to localized text, icon/shape, semantic color, accessibility announcement, and optional recovery entry. It does not retry, synchronize, persist, or decide domain outcomes.

## Feedback input and lifecycle

- Input: localized message identifier and safe arguments, semantic kind, optional valid action intent, and transient/persistent presentation intent.
- Transient feedback can close without clearing a persistent action-level failure. Repetitive background updates are grouped or suppressed. Product Inbox events are a separate later feature.
- Global feedback and logs exclude private habit text, sensitive friend details, credentials, raw Bloc states, and payloads.

## Localization and accessibility

- All user-facing strings resolve through English/Arabic ARB. Device `en`/`ar` select the matching language; unsupported locales select English. A later Profile-supplied explicit locale updates presentation without SL-01 storing it.
- Directionality drives start/end alignment and reading order. Mirror directional navigation cues, preserve non-directional marks, announce selected destinations and important status changes, and keep labels/actions usable at large text sizes. Status meaning is never color-only.
