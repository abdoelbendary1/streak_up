<!--
Sync Impact Report
- Version change: unratified template -> 1.0.0 (initial ratification)
- Modified principles: template placeholders -> PRD authority and traceability; specification-driven delivery; deterministic correctness and data integrity; privacy and least privilege; verifiable quality
- Added sections: Scope and Architecture Boundaries; Delivery and Verification
- Removed sections: none
- Follow-up TODOs: none
-->

# StreakUp Constitution

## Core Principles

### I. PRD Authority and Requirement Traceability

`docs/PRD.md` is the canonical authority for product behavior, priorities, and release scope. Technical
artifacts may make implementation decisions within that scope, but must not silently change product
requirements. Every feature specification MUST cite applicable PRD identifiers, including `FR-###`,
`BR-###`, `NFR-###`, `PERM-###`, and `FLOW-###` where relevant. Acceptance criteria, implementation
tasks, and verification evidence MUST remain traceable to those requirements. Missing, ambiguous, or
conflicting product requirements MUST be recorded and resolved with the Product Owner; they MUST NOT
be replaced by engineering assumptions.

### II. Specification-Driven, Ordered Delivery

Every feature MUST follow this sequence: PRD alignment, feature specification, clarification, technical
plan, tasks, consistency analysis, implementation, and verification/convergence. Implementation MUST
NOT begin until the preceding artifacts exist, applicable ambiguities are resolved or explicitly
accepted as risks, and consistency analysis has been completed. Tasks MUST identify their requirement
and acceptance-criteria links. Verification/convergence MUST report unmet work and residual gaps; an
incomplete feature MUST NOT be represented as complete.

### III. Deterministic Correctness and Recoverable Data

Streak, check-in, restore, and challenge outcomes MUST be deterministic for the same valid inputs and
recorded state. Their rules, boundary conditions, and failure behavior MUST be specified and covered by
automated tests before release. A personal Streak Restore MUST NOT retroactively award or alter a
challenge point. Offline actions accepted locally MUST remain available until synchronized or
explicitly resolved. Retries, duplicate or reordered delivery, synchronization failures, and conflicts
MUST have defined outcomes; important user data MUST NOT be silently discarded or overwritten. Any
product rule needed to determine these outcomes that remains TBD in the PRD MUST be clarified before
implementation relies on it.

### IV. Privacy, Authorization, and Least Privilege

Habits MUST be private by default. Sharing requires an explicit user choice, and each access path MUST
enforce the owner's current permissions. Friendship, challenge participation, reminders, and
synchronization MUST NOT grant access to private habit data or authority to change another user's
progress. Features MUST collect and expose only the data necessary for their approved behavior.
Authorization and privacy boundaries MUST be included in relevant tests and reviews.

### V. Verifiable Outcomes and Release Readiness

Each acceptance criterion MUST have proportionate verification evidence. Changes to calculations,
permissions, persistence, synchronization, or other high-risk behavior MUST include focused automated
tests for relevant invariants and failure cases. Release verification MUST cover Android and iOS, and
the affected user-facing P0 flows in both English and Arabic, including RTL behavior. A feature MUST
NOT pass its release gate with unresolved release-blocking defects, unverified acceptance criteria, or
known silent-loss or privacy-disclosure defects. Any unavailable verification MUST be reported with
its impact and an explicit disposition; it MUST NOT be implied to have passed.

## Scope and Architecture Boundaries

This constitution governs engineering and delivery; it does not add, remove, or reinterpret product
requirements in `docs/PRD.md`. StreakUp v1 MUST support Android and iOS, core habit workflows MUST be
offline-first, and English and Arabic with RTL MUST be supported for P0 user-facing flows. Deferred
P3 capabilities MUST NOT enter implementation without an approved PRD revision. Other scope changes
MUST also be reflected in the PRD before downstream specifications authorize implementation.

The constitution deliberately selects no application architecture, backend, persistence technology,
or synchronization protocol. Technical plans MUST select and justify such decisions against the PRD,
the feature specification, and the repository's established constraints.

## Delivery and Verification

Feature artifacts and reviews MUST preserve the ordered workflow in Principle II. Consistency analysis
MUST check that specifications, plans, tasks, and tests agree with one another and retain PRD
traceability. Verification plans MUST address applicable offline operation, synchronization and
recovery, privacy, deterministic calculations, Android/iOS behavior, and English/Arabic RTL behavior.
The plan MUST state which checks were run, their results, and any checks that could not be run.

P1 scope remains conditional on the PRD's schedule qualification. P2 or P3 work, and any other
unapproved product scope, MUST NOT be introduced through implementation tasks, opportunistic refactors,
or technical plans. A proposed scope change requires Product Owner review and an approved PRD revision
before implementation.

## Governance

This constitution governs engineering and delivery practice. It does not supersede `docs/PRD.md` on
product behavior or scope. If a conflict is discovered, work affected by the conflict MUST pause until
the Product Owner resolves it and the controlling artifact is updated.

Every feature review MUST verify compliance with this constitution, requirement traceability, and the
feature's verification evidence. Amendments MUST be reviewed and approved by the Product Owner,
document their rationale, and follow semantic versioning: MAJOR for incompatible governance changes,
MINOR for new or materially expanded principles, and PATCH for clarifications that do not change
obligations. The ratification and amendment dates MUST reflect the actual approval history. Any
exception MUST be explicit, scoped, approved by the Product Owner, and recorded with its rationale and
expiration or reevaluation condition; exceptions MUST NOT waive PRD requirements or authorize scope
change.

**Version**: 1.0.0 | **Ratified**: 2026-09-28 | **Last Amended**: 2026-09-28
