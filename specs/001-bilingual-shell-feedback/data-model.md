# SL-01 Data Model and Presentation Types

SL-01 defines **no persisted product entity**. It creates no domain habit/account/challenge model, Isar collection, Supabase table, migration, DTO, mapper, outbox, or sync cursor. The future feature-by-feature Data Contract requirement in [PROJECT_STATE.md](../../docs/PROJECT_STATE.md) applies when a slice persists product data.

## Focused presentation values

| Value | Members / constraints | Owner |
| --- | --- | --- |
| `ShellDestination` | Today, Habits, Challenges, Friends only | SL-01 navigation |
| `NetworkState` presentation projection | Online, Offline, Reconnecting, Syncing, SyncFailed; auth/session action-required remains a distinct cause | SL-01 consumes; SL-02/SL-03 later supply real signals |
| `ActionSyncStatus` | Pending, Synced, Failed; stays associated with the affected action by a safe opaque presentation key | SL-01 renders; owning feature supplies truth |
| `FeedbackDescriptor` | Localized message key and safe arguments, semantic kind, optional localized action intent, transient/persistent mode | SL-01 feedback coordinator |
| `FeedbackKind` | Success, information, warning, recoverable error, offline, sync, action required | SL-01 feedback presentation |
| `ActiveLocale` | `en` or `ar`; unsupported device locale resolves to `en`; later Profile input can override | SL-01 presentation; no persistence |

These are finite presentation contracts, not remote row or durable domain schemas. Do not add product fields or generic sync metadata to them. A failed action's dismissal from a transient overlay does not erase its source-level failure. “Synced” requires a future source's remote acknowledgment; SL-01 fixtures only simulate the visual state in tests or explicit development mode.
