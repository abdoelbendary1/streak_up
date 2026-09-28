# StreakUp — Product Requirements Document

## 1. Document Control

| Field          | Value                  |
| -------------- | ---------------------- |
| Product        | StreakUp               |
| PRD Version    | v1.0                   |
| Status         | Approved — v1 Baseline |
| Owner          | Abdelrahman Elbendary  |
| Created        | 2026-09-28             |
| Last Updated   | 2026-09-28             |
| Canonical Path | `docs/PRD.md`          |

**Document authority:** This PRD is the canonical source of truth for StreakUp product behavior and release scope. Technical specifications, architecture documents, implementation plans, and code may refine implementation details but must not silently contradict this PRD.

---

## 2. Executive Summary

StreakUp is a mobile habit-building product for people who want to build and maintain positive habits with stronger motivation, accountability, and social engagement than traditional habit trackers provide.

The first release targets students and young professionals who want to improve behaviors such as exercise, study, reading, sleep, hydration, productivity, and similar recurring habits. Users can create and manage habits, complete daily or scheduled check-ins, build streaks, recover selected broken streaks using a limited Streak Restore allowance, add friends, participate in private challenges, compare progress through leaderboards, and send reminder nudges to each other.

StreakUp v1 is designed as a fully offline-first Android and iOS application. Core personal habit actions must remain usable without connectivity, with automatic synchronization when connectivity returns. English and Arabic, including right-to-left layout support, are both required in v1.

The core product value is to make consistency more engaging by combining personal progress with friendly competition, shared challenges, accountability, and social motivation.

---

## 3. Product Vision & Context

### 3.1 Vision

StreakUp aims to turn habit consistency from an isolated tracking activity into a motivating social experience where users can improve themselves while receiving encouragement, accountability, and friendly competition from people they know.

### 3.2 Current State

Target users commonly use notes, reminders, calendars, or simple habit-tracking applications. These tools can record progress but often become repetitive and easy to abandon because they provide limited accountability and social motivation.

### 3.3 Desired Future State

A StreakUp user should be able to:

- build a personal habit routine;
- see what must be completed today;
- check in quickly;
- maintain meaningful streaks;
- recover a limited number of broken streaks without eliminating accountability;
- share selected progress while keeping private habits private;
- challenge friends;
- compare progress fairly;
- remind friends to keep going;
- continue using core habit functionality without an internet connection.

### 3.4 Business Context

The first release is focused on validating whether combining habit tracking with social accountability and competition improves engagement and retention compared with isolated habit tracking.

Monetization, AI coaching, public social networking, organizations, external health integrations, and web access are intentionally excluded from v1.

---

## 4. Problem & Opportunity

### 4.1 Problem Statement

People want to build good habits but frequently lose motivation because habit tracking feels lonely, repetitive, and easy to abandon. Existing habit tools often record progress without providing enough accountability, friendly competition, or interaction with people the user already knows.

### 4.2 Affected Users

Primary users are students and young professionals who want to establish or maintain recurring positive behaviors such as:

- exercising;
- studying;
- reading;
- improving sleep routines;
- drinking enough water;
- improving productivity;
- reducing undesirable habits.

### 4.3 Current Pain

Users may start with enthusiasm but stop because:

- progress feels isolated;
- there is limited accountability;
- friends cannot easily encourage each other;
- traditional tracking becomes repetitive;
- a single missed day can reduce motivation;
- competitive and cooperative habit experiences are separated from personal habit tracking.

### 4.4 Opportunity

StreakUp can combine personal progress, limited streak recovery, friend relationships, private challenges, leaderboards, and reminder nudges into one experience.

### 4.5 Why Now

The product is being created to validate whether social accountability and friendly competition can make recurring habit-building more engaging and sustainable for the target audience.

---

## 5. Goals & Non-Goals

### 5.1 Primary Goal

Enable a user to create habits, maintain daily or scheduled streaks, add friends, and compete with them through private shared challenges and leaderboards.

### 5.2 Supporting Objectives

1. Make daily habit completion fast and understandable.
2. Preserve motivation through visible streaks and a limited Streak Restore mechanic.
3. Provide social accountability without exposing private habits.
4. Support fair private challenges between friends.
5. Allow friends to encourage each other through reminder nudges and Streak Restore gifts.
6. Keep core habit functionality available under unreliable or absent connectivity.
7. Deliver the complete v1 experience in both English and Arabic.

### 5.3 Non-Goals for v1

StreakUp v1 will not include:

- AI habit coaching;
- AI-generated habit plans;
- public social feeds;
- public challenges;
- public global leaderboards;
- communities or clubs;
- organization/company accounts;
- paid subscriptions;
- in-app purchases;
- advertising;
- paid Streak Restores;
- smartwatch applications;
- Apple Health integration;
- Google Health Connect integration;
- Fitbit integration;
- advanced predictive analytics;
- a web application;
- a marketplace or rewards store.

---

## 6. Stakeholders

| Stakeholder / Role      | Responsibility                                            | Decision Authority                                     | Notes                                                            |
| ----------------------- | --------------------------------------------------------- | ------------------------------------------------------ | ---------------------------------------------------------------- |
| Abdelrahman Elbendary   | Product Owner                                             | Final authority for product scope and product behavior | Owner of this PRD                                                |
| Regular Users           | Primary product users                                     | Feedback / validation                                  | Students and young professionals are the initial target audience |
| Admin                   | Basic moderation and management of reported users/content | Operational authority within moderation permissions    | Detailed moderation workflow remains open                        |
| Engineering             | Technical implementation                                  | Technical decisions within approved product scope      | Team composition is `[TBD]`                                      |
| QA / Product Validation | Validate requirements and release readiness               | Release-quality input                                  | Ownership is `[TBD]`                                             |

---

## 7. Users & Personas

### 7.1 Primary Role — Regular User

**Context:** A person who wants to build recurring positive habits and stay motivated through personal tracking and social accountability.

**Goals:**

- create and manage habits;
- know what is due today;
- complete scheduled check-ins;
- maintain streaks;
- recover selected broken streaks;
- add friends;
- share selected progress;
- join private challenges;
- compare progress;
- encourage friends.

**Pain Points:**

- losing motivation;
- repetitive tracking;
- lack of accountability;
- isolated progress;
- all-or-nothing streak experiences.

**Usage Frequency:** Expected to be daily or near-daily.

**Success Definition:** The user can consistently understand what is due, record progress with low friction, trust streak calculations, and stay motivated through personal and social mechanisms.

### 7.2 Secondary Role — Admin

**Context:** An operational role responsible for managing reported content/users and basic moderation.

**Goals:**

- respond to reports;
- protect users from abuse;
- take permitted moderation actions;
- maintain platform integrity.

**Pain Points:** Detailed moderation workflow and tooling are not yet defined.

**Usage Frequency:** As needed.

**Success Definition:** Reports and abusive behavior can be handled without exposing unrelated user data or altering legitimate product history incorrectly.

---

## 8. Roles & Permissions

| ID       | Role                      | Resource / Action           | Allowed Behavior                                                                                          | Restrictions                                                                                     | Status                 |
| -------- | ------------------------- | --------------------------- | --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ | ---------------------- |
| PERM-001 | Regular User              | Own habits                  | Create, view, edit, pause, resume, archive, and request permanent deletion of owned habits                | Cannot rewrite historical check-ins through ordinary habit editing                               | Confirmed              |
| PERM-002 | Regular User              | Own check-ins               | Complete eligible scheduled habit occurrences                                                             | Cannot create duplicate completion for the same scheduled occurrence                             | Confirmed              |
| PERM-003 | Friend                    | Another user's habits       | View only habit/progress information explicitly shared with them                                          | Private habits must remain undiscoverable                                                        | Confirmed              |
| PERM-004 | Friend                    | Another user's progress     | Send permitted reminder nudges and Streak Restore requests/gifts                                          | Cannot edit habits, modify progress, or submit check-ins for another user                        | Confirmed              |
| PERM-005 | Challenge Participant     | Active challenge            | View challenge data, submit own eligible progress through normal habit check-ins, and leave the challenge | Cannot alter another participant's score or check-ins                                            | Confirmed              |
| PERM-006 | Challenge Creator         | Challenge                   | Configure before start, invite friends, cancel before start, remove participant with confirmation         | Scoring rules, dates, and other locked rules cannot be changed after start                       | Confirmed              |
| PERM-007 | Restore Request Recipient | Restore gift request        | Accept or decline a restore gift request                                                                  | Acceptance must deduct one restore from recipient's own available monthly balance                | Confirmed              |
| PERM-008 | Admin                     | Reported users/content      | Perform basic moderation actions                                                                          | Exact actions and escalation workflow are `[TBD]`                                                | Confirmed / TBD detail |
| PERM-009 | Any User                  | Another user's private data | No access                                                                                                 | Friendship, challenge participation, or nudges must not grant private-habit access automatically | Confirmed              |

---

## 9. Scope

### 9.1 In Scope — v1

- account registration and authentication;
- password reset;
- habit creation, viewing, editing, pausing, resuming, archiving, and deletion controls;
- habit schedule/frequency;
- reminder configuration;
- private/shared visibility;
- today's habit list;
- daily/scheduled check-ins;
- pending/completed/missed occurrence states;
- current streak;
- longest streak;
- completion history;
- monthly Streak Restore allowance;
- requesting a Streak Restore from a friend;
- gifting a Streak Restore from the giver's own allowance;
- friend requests and friendships;
- viewing permitted friend progress;
- private challenges;
- challenge invitations;
- challenge participant progress;
- challenge leaderboards;
- participants leaving active challenges;
- challenge creator removing a participant;
- challenge completion/final ranking;
- peer reminder nudges;
- user profile;
- basic notifications;
- full offline-first behavior for core product workflows;
- synchronization and recovery states;
- English;
- Arabic and RTL layout support.

### 9.2 Should-Have Scope — v1 if schedule allows

- richer habit categories/icons;
- basic habit statistics;
- dedicated challenge history browsing;
- friend activity summary;
- richer friend search;
- detailed notification preferences;
- dedicated archived-habit browsing;
- onboarding.

### 9.3 Out of Scope / Deferred

See Section 5.3. Deferred capabilities are not to be implemented implicitly by downstream agents.

### 9.4 Dependencies

- mobile operating-system notification capability;
- backend/synchronization service;
- network availability for cross-user synchronization;
- final legal/privacy review for launch markets;
- app distribution approval for Android and iOS.

---

## 10. User Journeys & Workflows

### FLOW-001 — Create and Maintain a Habit

**Actors:** Regular User  
**Entry Condition:** User is signed in.

**Main Steps:**

1. User opens StreakUp.
2. Home displays today's habits, current streaks, completion status, upcoming reminders, and relevant friend/challenge activity.
3. User selects **Create Habit**.
4. User provides habit name, optional description, category/icon, frequency, days/schedule, preferred reminder time, visibility, and optional target.
5. User saves the habit.
6. The habit appears on appropriate scheduled days.
7. StreakUp sends the configured reminder when applicable.
8. User performs the habit and selects **Check In**.
9. StreakUp records the completion against the eligible scheduled occurrence.
10. Current streak and completion history update.
11. UI provides immediate success feedback.
12. Shared progress is visible only to permitted friends.
13. Private habits remain undiscoverable to friends.
14. User may later edit future settings, pause/resume, change visibility, archive, or delete subject to business rules.

**Decision Points:** scheduled today; already completed; private/shared; online/offline; sync conflict.

**Completion State:** Eligible occurrence is completed, local streak state updates, and the action is synchronized or marked pending synchronization.

**Failure / Recovery:** Failed synchronization must not silently discard the local action. Pending/failed state and retry/recovery must be available.

### FLOW-002 — Private Challenge

**Actors:** Challenge Creator, Invited Friends, Participants  
**Entry Condition:** Creator is signed in and has eligible friends.

**Main Steps:**

1. User opens Challenges and selects **Create Challenge**.
2. Creator defines name, duration, start/end dates, goal, and habit association model.
3. Creator selects friends and submits.
4. Invitees accept or decline.
5. Accepted users become participants.
6. Participants view challenge details, remaining days, participant progress, and leaderboard.
7. Participants complete normal habit check-ins.
8. Each valid occurrence scores: completed = 1 point; missed = 0 points.
9. Leaderboard updates from valid synchronized progress.
10. Participants may send reminder nudges.
11. At the end date, challenge closes automatically.
12. StreakUp calculates final ranking and preserves the result historically.

**Alternate Paths:** creator cancels before start; participant leaves; creator removes participant; ties remain valid.

**Failure / Recovery:** Unsynchronized check-ins and social actions must remain pending/failed until synchronized or explicitly resolved.

### FLOW-003 — Missed Habit and Streak Restore

1. Scheduled occurrence reaches its completion deadline without a valid check-in.
2. Occurrence becomes **Missed**.
3. Current personal streak breaks.
4. Historical completions and longest streak remain.
5. If user has an available restore, user may choose **Restore Streak**.
6. One restore is deducted from monthly allowance.
7. Personal streak is reinstated to its pre-miss value.
8. Any missed challenge occurrence remains missed for challenge scoring.
9. Restore usage is recorded.

**Failure / Recovery:** If no restore remains, user may request one from a friend.

### FLOW-004 — Request and Gift a Streak Restore

1. User with no available restores chooses to ask a friend.
2. Restore request is created.
3. Friend receives it when synchronized.
4. Friend accepts or declines.
5. Decline changes no balances.
6. Acceptance deducts one restore from the friend's balance and grants one to requester.
7. Requester may use it on an eligible broken personal streak.
8. Gifted restore still does not retroactively create a challenge point.

**Failure / Recovery:** One active request to the same friend at a time. Anti-spam and receiving limits apply, exact thresholds TBD.

### FLOW-005 — Leave or Remove an Active Challenge

**Participant leave path:**

1. Participant chooses Leave Challenge.
2. StreakUp explains consequences.
3. Participant confirms.
4. Participant stops earning points, leaves active leaderboard eligibility, and becomes ineligible to win.
5. Personal habit/streak remains unaffected.
6. Challenge-specific reminders stop.
7. Historical participation remains with a Left state.

**Creator removal path:**

1. Creator selects participant and Remove Participant.
2. Confirmation is required.
3. Participant is removed from active participation and final eligibility.
4. Personal habit remains unchanged.
5. Historical participation remains with a Removed state.

**Open Detail:** Rejoining the same active challenge is unresolved.

---

## 11. Feature Prioritization

### Must Have — P0

| ID      | Feature                  | Description                                                           | Release | Status  |
| ------- | ------------------------ | --------------------------------------------------------------------- | ------- | ------- |
| P0-F001 | Authentication           | Sign up, login, logout, password reset, basic session behavior        | v1      | DEFINED |
| P0-F002 | Habit Management         | CRUD, schedule, visibility, pause/resume, archive/delete controls     | v1      | DEFINED |
| P0-F003 | Daily Check-In           | Today's habits and pending/completed/missed states                    | v1      | DEFINED |
| P0-F004 | Streak System            | Current/longest streak, history, missed-day behavior, Streak Restores | v1      | DEFINED |
| P0-F005 | Habit Reminders          | User-configured reminders for scheduled habits                        | v1      | DEFINED |
| P0-F006 | Friends                  | Friend requests, relationships, permitted shared progress             | v1      | DEFINED |
| P0-F007 | Private Challenges       | Create/invite/accept/decline/participate/leave/remove/close           | v1      | DEFINED |
| P0-F008 | Challenge Leaderboard    | Challenge scoring, ranking, ties, final results                       | v1      | DEFINED |
| P0-F009 | Peer Reminder Nudges     | Friends may send reminder nudges subject to preferences               | v1      | DEFINED |
| P0-F010 | Profile                  | Basic user information and progress summary                           | v1      | DEFINED |
| P0-F011 | Notifications            | Habit, friendship, challenge, restore, and nudge notifications        | v1      | DEFINED |
| P0-F012 | Offline-First Experience | Core workflows remain usable offline with safe synchronization        | v1      | DEFINED |
| P0-F013 | English + Arabic         | Full v1 product experience in English and Arabic with RTL support     | v1      | DEFINED |

### Should Have — P1

| ID      | Feature                    | Description                                                               | Release               | Status  |
| ------- | -------------------------- | ------------------------------------------------------------------------- | --------------------- | ------- |
| P1-F001 | Habit Categories & Icons   | Richer predefined/custom presentation for habits                          | v1 if schedule allows | DEFINED |
| P1-F002 | Basic Habit Statistics     | Completion percentage, weekly/monthly totals, history/calendar views      | v1 if schedule allows | DEFINED |
| P1-F003 | Challenge History Browsing | Dedicated browsing of completed challenges and detailed results           | v1 if schedule allows | DEFINED |
| P1-F004 | Friend Activity Summary    | Visible activity for permitted shared events only                         | v1 if schedule allows | DEFINED |
| P1-F005 | Friend Search              | Richer user lookup by approved identifiers                                | v1 if schedule allows | DEFINED |
| P1-F006 | Notification Preferences   | Fine-grained control by notification type                                 | v1 if schedule allows | DEFINED |
| P1-F007 | Archived Habit Browsing    | Dedicated view of archived habits and preserved history                   | v1 if schedule allows | DEFINED |
| P1-F008 | Onboarding                 | Guided introduction to habits, streaks, friends, challenges, and restores | v1 if schedule allows | DEFINED |

### Could Have — P2

No P2 features are currently approved. New P2 items require PRD revision.

### Won't Have / Deferred — P3

| ID      | Feature               | Description                                                 | Planned Revisit | Status   |
| ------- | --------------------- | ----------------------------------------------------------- | --------------- | -------- |
| P3-F001 | AI Coaching           | AI coach, plans, recommendations, motivational assistant    | Post-v1         | DEFERRED |
| P3-F002 | Public Social Network | Public feed, posts, comments, likes, influencers            | Post-v1         | DEFERRED |
| P3-F003 | Public Challenges     | Discoverable/global challenges and public leaderboards      | Post-v1         | DEFERRED |
| P3-F004 | Groups / Communities  | Clubs, communities, group administration                    | Post-v1         | DEFERRED |
| P3-F005 | Organizations         | Company/employer accounts and dashboards                    | Post-v1         | DEFERRED |
| P3-F006 | Monetization          | Subscriptions, IAP, advertising, paid restores              | Post-v1         | DEFERRED |
| P3-F007 | Wearables             | Apple Watch, Wear OS, fitness trackers                      | Post-v1         | DEFERRED |
| P3-F008 | Health Integrations   | Apple Health, Health Connect, Fitbit                        | Post-v1         | DEFERRED |
| P3-F009 | Advanced Analytics    | Predictive and deep behavioral analytics                    | Post-v1         | DEFERRED |
| P3-F010 | Web App               | Full browser-based client                                   | Post-v1         | DEFERRED |
| P3-F011 | Marketplace / Rewards | Rewards store, redemption, partner rewards, physical prizes | Post-v1         | DEFERRED |

---

## 12. Functional Requirements

### FR-001 — Account Access

**Feature:** P0-F001  
**Primary Actor:** Regular User  
**Requirement:** User can register, sign in, sign out, and initiate password recovery. User-specific product data requires authenticated access.

**Acceptance Criteria**

- [ ] New user can register.
- [ ] Existing user can sign in and sign out.
- [ ] Password recovery can be initiated.
- [ ] Failed authentication does not expose another user's private information.

### FR-002 — Create and Edit Habits

**Feature:** P0-F002  
**Primary Actor:** Regular User  
**Requirement:** User can create a habit with name, optional description, category/icon, schedule/frequency, reminder, visibility, and optional target. Future-facing settings can be edited without rewriting historical check-ins.

**Acceptance Criteria**

- [ ] Valid habit can be created.
- [ ] Future settings can be edited.
- [ ] Visibility can be changed Private/Shared.
- [ ] Offline creation/editing remains available.

### FR-003 — Habit Lifecycle

**Feature:** P0-F002  
**Requirement:** User can pause/resume, archive, and request permanent deletion of owned habits. Archiving preserves history. Destructive deletion requires explicit confirmation.

**Acceptance Criteria**

- [ ] Personal habit can be paused/resumed.
- [ ] Paused personal habit does not create personal missed occurrences.
- [ ] Archive preserves history.
- [ ] Active challenge obligations cannot be bypassed by pausing.

### FR-004 — Today's Habit List

**Feature:** P0-F003  
**Requirement:** Home shows eligible scheduled habits with Pending, Completed, or Missed state and remains useful with locally available data offline.

### FR-005 — Habit Check-In

**Feature:** P0-F003  
**Requirement:** User can complete an eligible occurrence. The same occurrence cannot produce duplicate completion. Offline check-ins update local state immediately and queue synchronization.

### FR-006 — Personal Streak Calculation

**Feature:** P0-F004  
**Requirement:** Consecutive valid scheduled completions extend current streak. A missed required occurrence breaks it. Longest streak and history remain preserved.

### FR-007 — Monthly Streak Restore

**Feature:** P0-F004  
**Requirement:** Each user receives 3 personal Streak Restores per calendar month. They do not roll over. Restore use is explicit and reinstates an eligible personal streak to its pre-miss value. It does not restore a missed challenge point.

### FR-008 — Request and Gift a Streak Restore

**Feature:** P0-F004, P0-F006  
**Requirement:** A user with zero restores can request one from a friend. Acceptance transfers one restore from the friend's available balance to the requester. Decline changes no balances.

### FR-009 — Habit Reminders

**Feature:** P0-F005  
**Requirement:** User can configure habit reminders. Reminder delivery does not itself change completion/streak state and can be disabled where applicable.

### FR-010 — Friend Relationships

**Feature:** P0-F006  
**Requirement:** Users can send/receive/accept/reject friend requests and remove friends. Friendship enables only authorized social capabilities.

### FR-011 — Shared Friend Progress

**Feature:** P0-F006  
**Requirement:** Friends may view only explicitly shared habit/progress information. Private habits remain undiscoverable. Friends cannot edit or check in for another user.

### FR-012 — Create Private Challenge

**Feature:** P0-F007  
**Requirement:** Creator can define a private challenge, associate eligible habit behavior, invite friends, and cancel before start. Invitees accept or decline.

### FR-013 — Challenge Participation

**Feature:** P0-F007  
**Requirement:** Accepted participants participate through valid normal habit check-ins. One scheduled challenge occurrence contributes at most one point. Equivalent-habit compatibility remains TBD.

### FR-014 — Challenge Leaderboard

**Feature:** P0-F008  
**Requirement:** Completed occurrence = 1 point; missed occurrence = 0 points. Ties are allowed. Personal restores do not change missed challenge points.

### FR-015 — Leave or Remove Participant

**Feature:** P0-F007  
**Requirement:** Participant may leave an active challenge. Creator may remove a participant after confirmation. In both cases, new points stop, final-win eligibility ends, history remains, and personal habit/streak remains unchanged.

### FR-016 — Challenge Completion and History

**Feature:** P0-F007, P0-F008  
**Requirement:** Challenge closes automatically at end date, final ranking is preserved, and historical records remain available. Deleted users may be represented anonymously.

### FR-017 — Peer Reminder Nudges

**Feature:** P0-F009  
**Requirement:** Eligible users can send reminder nudges. Nudges respect recipient controls and never modify the recipient's habit state.

### FR-018 — User Profile

**Feature:** P0-F010  
**Requirement:** Profile contains basic user information, current/longest streaks, basic completion summary, and relevant challenge results.

### FR-019 — Product Notifications

**Feature:** P0-F011  
**Requirement:** StreakUp communicates approved habit/social events such as reminders, friend requests, challenge invitations/updates, nudges, and restore requests/gifts.

### FR-020 — Offline Personal Operations

**Feature:** P0-F012  
**Requirement:** Habit create/edit/pause/archive, check-ins, reminder preferences, and appropriate profile edits work offline, save locally first, and queue synchronization.

### FR-021 — Offline Social and Challenge Queueing

**Feature:** P0-F012  
**Requirement:** Supported social actions may be initiated offline and queued, but are not globally effective for other users until synchronization succeeds.

### FR-022 — Sync Status and Conflict Recovery

**Feature:** P0-F012  
**Requirement:** Users can distinguish Synced, Pending, and Failed states. Persistent failures/conflicts provide retry or recovery. Important user progress must not be silently overwritten.

### FR-023 — English and Arabic

**Feature:** P0-F013  
**Requirement:** All P0 user-facing flows are available in English and Arabic. Arabic supports RTL and must not lose functionality or critical content through layout issues.

### FR-024 — Habit Categories & Icons

**Feature:** P1-F001  
**Requirement:** User may classify habits with supported categories/icons without affecting streak logic.

### FR-025 — Basic Habit Statistics

**Feature:** P1-F002  
**Requirement:** Provide completion percentage, weekly/monthly totals, and simple history/calendar presentation consistent with check-in history.

### FR-026 — Dedicated Challenge History Browsing

**Feature:** P1-F003  
**Requirement:** Provide a dedicated experience for browsing completed challenge records and detailed results beyond minimal P0 historical preservation.

### FR-027 — Friend Activity Summary

**Feature:** P1-F004  
**Requirement:** Summarize only friend activity the viewing user is authorized to see.

### FR-028 — Rich Friend Search

**Feature:** P1-F005  
**Requirement:** Provide richer friend discovery using approved identifiers without exposing private account data.

### FR-029 — Fine-Grained Notification Preferences

**Feature:** P1-F006  
**Requirement:** Allow independent control over supported notification categories.

### FR-030 — Archived Habit Browsing

**Feature:** P1-F007  
**Requirement:** User can browse archived habits and preserved history.

### FR-031 — Onboarding

**Feature:** P1-F008  
**Requirement:** Introduce habits, streaks, friends, challenges, and Streak Restores to new users.

---

## 13. Business Rules

| ID     | Rule                                                                                                                           | Applies To            | Exceptions                                             | Source Status          |
| ------ | ------------------------------------------------------------------------------------------------------------------------------ | --------------------- | ------------------------------------------------------ | ---------------------- |
| BR-001 | Habits are private by default; sharing requires explicit choice                                                                | Habits / Friends      | None                                                   | Confirmed              |
| BR-002 | Friends cannot edit, complete, or alter another user's habit/progress                                                          | Social                | None                                                   | Confirmed              |
| BR-003 | Each scheduled occurrence may contribute at most one valid completion                                                          | Check-In / Challenges | None                                                   | Confirmed              |
| BR-004 | Missing a required occurrence breaks the active personal streak while preserving history and longest streak                    | Streaks               | Restore may reinstate personal streak                  | Confirmed              |
| BR-005 | Each user receives 3 personal Streak Restores per calendar month                                                               | Streaks               | Gifted restores may add availability subject to limits | Confirmed              |
| BR-006 | Unused monthly personal restores do not roll over; use is always explicit                                                      | Streaks               | None                                                   | Confirmed              |
| BR-007 | Restoring a personal streak does not retroactively grant a missed challenge point                                              | Streaks / Challenges  | None                                                   | Confirmed              |
| BR-008 | Friend gifting transfers one available restore from giver; it does not create a new restore                                    | Social / Restores     | None                                                   | Confirmed              |
| BR-009 | Only one active restore request to the same friend is allowed at a time                                                        | Restore Requests      | None                                                   | Confirmed              |
| BR-010 | Restore-request spam and gifted-restore receiving must be limited                                                              | Restore Requests      | Exact thresholds TBD                                   | Confirmed / TBD detail |
| BR-011 | Habit changes affect future behavior and must not rewrite historical check-ins                                                 | Habits                | Explicit deletion rules                                | Confirmed              |
| BR-012 | Pausing a personal habit suspends personal requirements without breaking streak; it cannot bypass active challenge obligations | Habits / Challenges   | None                                                   | Confirmed              |
| BR-013 | Challenge scoring rules, dates, and locked rules cannot change after challenge start                                           | Challenges            | Defined moderation actions                             | Confirmed              |
| BR-014 | Creator may cancel challenge before start                                                                                      | Challenges            | None                                                   | Confirmed              |
| BR-015 | Participant may leave an active challenge; new points stop, win eligibility ends, history remains                              | Challenges            | Re-entry TBD                                           | Confirmed              |
| BR-016 | Creator may remove participant after confirmation; history remains; personal habit is unchanged                                | Challenges            | None                                                   | Confirmed              |
| BR-017 | Ties are valid outcomes unless a future rule adds tie-breaking                                                                 | Challenges            | None                                                   | Confirmed              |
| BR-018 | Removing/blocking a friend revokes future friend-only access; historical challenge records may remain                          | Social / Privacy      | Historical challenge data                              | Confirmed              |
| BR-019 | Reminder/nudge delivery does not determine habit completion and can be muted/disabled where applicable                         | Notifications         | Required transactional notices TBD                     | Confirmed              |
| BR-020 | User-specific product data requires authenticated access                                                                       | Account               | None defined                                           | Confirmed              |
| BR-021 | Account deletion removes identifying visibility; historical challenge results may retain anonymous participant reference       | Privacy / Challenges  | Legal retention requirements TBD                       | Confirmed              |
| BR-022 | Offline personal actions must be preserved locally until synchronized or explicitly resolved                                   | Offline               | Invalid authoritative action requires visible recovery | Confirmed              |
| BR-023 | Offline social actions are not effective for other users until synchronization succeeds                                        | Offline / Social      | None                                                   | Confirmed              |

---

## 14. Non-Functional Requirements

| ID      | Category          | Requirement                                                                                         | Target                                                       | Verification                 | Source Status |
| ------- | ----------------- | --------------------------------------------------------------------------------------------------- | ------------------------------------------------------------ | ---------------------------- | ------------- |
| NFR-001 | Platform          | v1 supports Android and iOS                                                                         | Both platforms at release                                    | Release test matrix          | Confirmed     |
| NFR-002 | Offline           | Core habit workflows remain usable without internet                                                 | Full offline-first behavior for defined core actions         | Offline functional tests     | Confirmed     |
| NFR-003 | Sync Transparency | Synced/Pending/Failed state is distinguishable where needed                                         | All relevant P0 sync actions                                 | UX + integration tests       | Confirmed     |
| NFR-004 | Data Integrity    | Confirmed/local accepted check-in is not silently lost                                              | Zero known silent-loss defects at release                    | Fault-injection + sync tests | Confirmed     |
| NFR-005 | Consistency       | Streak/challenge calculations remain consistent after synchronization                               | No known release-blocking inconsistency                      | Domain + multi-device tests  | Confirmed     |
| NFR-006 | Responsiveness    | Core local actions provide immediate feedback without waiting on network                            | Numeric target deferred to architecture/performance planning | UX/performance validation    | Confirmed     |
| NFR-007 | Security          | User-specific data and protected actions require authenticated/authorized access                    | No known authorization bypass in release scope               | Security tests               | Confirmed     |
| NFR-008 | Privacy           | Private habits never become visible through social/challenge/sync mistakes                          | Zero known private-habit disclosure defects                  | Privacy/permission tests     | Confirmed     |
| NFR-009 | Accessibility     | Important states do not rely on color alone; larger text and reasonable touch targets remain usable | P0 flows pass accessibility review                           | Accessibility QA             | Confirmed     |
| NFR-010 | Localization      | English and Arabic required in v1                                                                   | All P0 user-facing flows localized                           | Localization QA              | Confirmed     |
| NFR-011 | RTL               | Arabic layouts support RTL without functional breakage                                              | All P0 flows usable in RTL                                   | RTL QA                       | Confirmed     |
| NFR-012 | Recoverability    | Persistent sync failures/conflicts provide understandable recovery                                  | No hidden unrecoverable P0 failure                           | Integration/UX tests         | Confirmed     |

---

## 15. Data Requirements

| ID       | Business Data                                    | Purpose                        | Sensitivity           | Ownership            | Retention / Rules                            | Status     |
| -------- | ------------------------------------------------ | ------------------------------ | --------------------- | -------------------- | -------------------------------------------- | ---------- |
| DATA-001 | Account identity                                 | Identity and account access    | Sensitive / personal  | User / service       | Account deletion applies                     | Confirmed  |
| DATA-002 | Habit definition                                 | Habit behavior                 | Potentially personal  | User                 | Private by default                           | Confirmed  |
| DATA-003 | Habit progress/check-ins/streak history          | Core progress/statistics       | Personal              | User                 | Preserved until deletion policy applies      | Confirmed  |
| DATA-004 | Streak Restore allowance, usage, gifts, requests | Restore correctness/anti-abuse | Personal/social       | User/service         | Exact retention TBD                          | Confirmed  |
| DATA-005 | Friend relationships/requests                    | Social graph                   | Personal/social       | Participating users  | Revocation removes future friend-only access | Confirmed  |
| DATA-006 | Sharing permissions                              | Control friend visibility      | Privacy-sensitive     | Habit owner          | Explicit owner control                       | Confirmed  |
| DATA-007 | Challenge definitions/participation              | Competition                    | Social                | Creator/participants | Historical result retained                   | Confirmed  |
| DATA-008 | Scores/rankings/leave/remove history             | Fairness/history               | Social                | Service/participants | Historical record retained                   | Confirmed  |
| DATA-009 | Notification preferences/events                  | Product communication          | Personal              | User                 | Exact retention TBD                          | Confirmed  |
| DATA-010 | Moderation/report data                           | Safety operations              | Potentially sensitive | Service/Admin        | Workflow/retention TBD                       | TBD detail |

---

## 16. Integrations & External Dependencies

| ID      | System / Dependency                     | Purpose                                          | Direction               | Criticality     | Known Contract         | Status                      |
| ------- | --------------------------------------- | ------------------------------------------------ | ----------------------- | --------------- | ---------------------- | --------------------------- |
| INT-001 | Mobile notification delivery capability | Reminders, invitations, nudges, restore requests | StreakUp → device/user  | High            | Provider/mechanism TBD | Confirmed requirement       |
| INT-002 | Synchronization/backend service         | Cross-device and cross-user state                | Bidirectional           | Critical        | Technical contract TBD | Confirmed requirement       |
| INT-003 | Android distribution platform           | Public Android release                           | Deployment              | High for launch | TBD                    | Confirmed                   |
| INT-004 | iOS distribution platform               | Public iOS release                               | Deployment              | High for launch | TBD                    | Confirmed                   |
| INT-005 | Product analytics capability            | Measure KPIs                                     | App/service → analytics | Medium          | Tool TBD               | Required by KPI measurement |

---

## 17. UX & Interaction Requirements

| ID     | Requirement                                                                                        |
| ------ | -------------------------------------------------------------------------------------------------- |
| UX-001 | Home makes today's habits and Pending/Completed/Missed states immediately understandable.          |
| UX-002 | Successful check-in provides immediate local feedback.                                             |
| UX-003 | Sync-dependent actions expose Pending/Synced/Failed state where ambiguity would mislead the user.  |
| UX-004 | Invalid input shows clear actionable feedback.                                                     |
| UX-005 | Destructive actions require explicit confirmation.                                                 |
| UX-006 | Streak Restore use clearly shows a limited restore will be consumed.                               |
| UX-007 | Restore requests and nudges must not use coercive or shaming language.                             |
| UX-008 | Private/shared visibility is clear during habit creation/editing.                                  |
| UX-009 | Leaving a challenge explains loss of ranking eligibility and preservation of personal habit state. |
| UX-010 | Offline actions are not presented as remotely confirmed before synchronization.                    |
| UX-011 | Important states do not rely on color alone.                                                       |
| UX-012 | English and Arabic remain functionally equivalent; Arabic supports RTL.                            |
| UX-013 | Empty states explain the next valid action.                                                        |
| UX-014 | Failed synchronization provides retry/recovery rather than silent dismissal.                       |

---

## 18. Edge Cases & Failure Behavior

| Related Requirement / Flow | Condition                                       | Required Behavior                           | User Feedback / Recovery                  |
| -------------------------- | ----------------------------------------------- | ------------------------------------------- | ----------------------------------------- |
| FR-005 / FLOW-001          | Duplicate check-in attempt                      | Reject duplicate contribution               | Show already completed                    |
| FR-005                     | Offline check-in                                | Save locally, queue sync                    | Show pending sync                         |
| FR-022                     | Sync persistently fails                         | Preserve local data where possible          | Show failed + retry/recovery              |
| FR-006 / FLOW-003          | Required occurrence missed                      | Break streak, preserve history              | Show missed + restore option if eligible  |
| FR-007                     | No restore available                            | Do not restore                              | Offer friend request where eligible       |
| FR-008                     | Friend declines restore request                 | No balance change                           | Mark declined/expired neutrally           |
| FR-008                     | Giver has no restore at acceptance time         | Do not transfer                             | Explain gift cannot complete              |
| FR-008                     | Duplicate active restore request to same friend | Prevent duplicate                           | Show existing request                     |
| FR-011                     | Friend attempts private-habit access            | Deny access                                 | Habit remains undiscoverable              |
| FR-012                     | Invite declined                                 | Do not add participant                      | Mark invitation declined                  |
| FR-013                     | Offline challenge check-in syncs later          | Reconcile according to valid rules          | Update score or explain rejected conflict |
| FR-014                     | Tie                                             | Keep tie                                    | Show tied result                          |
| FR-015                     | Participant leaves                              | Stop new points, preserve history           | Confirm consequences                      |
| FR-015                     | Creator removes participant                     | Remove active eligibility, preserve history | Confirmation required                     |
| FR-016                     | Account deleted after challenge                 | Remove identifying data                     | Show Deleted User where needed            |
| FR-020                     | App reopens offline                             | Restore local state/queue                   | Keep offline/pending visible              |
| FR-023                     | Arabic content expands                          | Adapt layout                                | Critical text remains readable            |
| FR-019                     | Push fails                                      | Underlying state unchanged                  | User can still see state in-app           |

---

## 19. Success Metrics & KPIs

| ID      | Metric                 | Target / Baseline                                                                                                          | Measurement Method | Review Timing           | Owner              |
| ------- | ---------------------- | -------------------------------------------------------------------------------------------------------------------------- | ------------------ | ----------------------- | ------------------ |
| KPI-001 | Activation             | ≥60% create first habit within 24h of signup                                                                               | Product analytics  | Weekly                  | Product Owner      |
| KPI-002 | Early Habit Engagement | ≥50% of activated users complete 3+ check-ins in first 7 days                                                              | Product analytics  | Weekly                  | Product Owner      |
| KPI-003 | Day-7 Retention        | ≥30%                                                                                                                       | Cohort analysis    | Weekly/monthly          | Product Owner      |
| KPI-004 | Day-30 Retention       | Baseline to be established during controlled rollout                                                                       | Cohort analysis    | Monthly                 | Product Owner      |
| KPI-005 | Friend Adoption        | ≥25% of active users add at least one friend                                                                               | Product analytics  | Weekly/monthly          | Product Owner      |
| KPI-006 | Challenge Adoption     | ≥15% of active users participate in at least one private challenge                                                         | Product analytics  | Weekly/monthly          | Product Owner      |
| KPI-007 | Check-In Integrity     | No accepted check-in silently lost because of sync                                                                         | Telemetry + QA     | Continuous/release gate | Engineering + QA   |
| KPI-008 | Critical Flow Quality  | 0 known release-blocking defects in auth, habit creation, check-in, restore, friend request, challenge participation at RC | QA report          | Each RC                 | Product Owner + QA |

---

## 20. Assumptions & Constraints

### Assumptions

| ID      | Assumption                                                      | Validation Needed       | Owner         | Status |
| ------- | --------------------------------------------------------------- | ----------------------- | ------------- | ------ |
| ASM-001 | Friend-based accountability improves engagement                 | Beta metrics/interviews | Product Owner | OPEN   |
| ASM-002 | 3 monthly personal restores balance recovery and accountability | Beta behavior/feedback  | Product Owner | OPEN   |
| ASM-003 | Private challenges are sufficient for v1                        | Beta feedback           | Product Owner | OPEN   |
| ASM-004 | English + Arabic cover initial target release languages         | Launch-market decision  | Product Owner | OPEN   |

### Constraints

| ID      | Constraint                                                    | Source        | Impact                                                               |
| ------- | ------------------------------------------------------------- | ------------- | -------------------------------------------------------------------- |
| CON-001 | v1 is Android + iOS mobile                                    | Product Owner | No web client                                                        |
| CON-002 | Core workflows are fully offline-first                        | Product Owner | All affected specs must cover local state, sync, recovery, conflicts |
| CON-003 | English + Arabic + RTL are v1 requirements                    | Product Owner | Localization/RTL tested throughout                                   |
| CON-004 | Habits are private by default                                 | Product Owner | Social features require explicit sharing                             |
| CON-005 | Personal restore never retroactively creates challenge point  | Product Owner | Personal motivation separated from challenge fairness                |
| CON-006 | Deferred P3 scope requires PRD revision before implementation | Product Owner | Prevents scope creep                                                 |

---

## 21. Risk Register

High=3, Medium=2, Low=1. Score = Likelihood × Impact.

| ID       | Risk                                                                             | Likelihood |     Impact | Score | Mitigation                                                                               | Owner               | Status |
| -------- | -------------------------------------------------------------------------------- | ---------: | ---------: | ----: | ---------------------------------------------------------------------------------------- | ------------------- | ------ |
| RISK-001 | Offline sync conflicts may duplicate/reorder/conflict actions                    |   High (3) |   High (3) |     9 | Define sync/conflict behavior before implementation; test offline/multi-device scenarios | Engineering/Product | OPEN   |
| RISK-002 | Time zones, schedule changes, offline events, restores may produce wrong streaks | Medium (2) |   High (3) |     6 | Explicit domain rules + strong automated tests                                           | Engineering/QA      | OPEN   |
| RISK-003 | Late sync/restores/leaving/removal/device time may affect challenge fairness     | Medium (2) |   High (3) |     6 | Separate personal restore from challenge score; validate events consistently             | Engineering/Product | OPEN   |
| RISK-004 | Nudges/restore requests may become spammy or abusive                             | Medium (2) | Medium (2) |     4 | Rate limits, mute controls, preferences, abuse rules                                     | Product/Engineering | OPEN   |
| RISK-005 | Private habit data may leak through social/challenge/sync paths                  |    Low (1) |   High (3) |     3 | Private-by-default permissions + privacy tests                                           | Engineering/QA      | OPEN   |
| RISK-006 | Arabic/RTL may break if handled late                                             | Medium (2) | Medium (2) |     4 | Build/test Arabic and RTL throughout v1                                                  | Engineering/QA      | OPEN   |
| RISK-007 | Social/gamification scope may expand v1 indefinitely                             |   High (3) | Medium (2) |     6 | Enforce P0/P1/P3 and PRD change control                                                  | Product Owner       | OPEN   |

---

## 22. Open Questions

| ID     | Question                                                                         | Why It Matters                       | Decision Owner         | Needed Before        | Status |
| ------ | -------------------------------------------------------------------------------- | ------------------------------------ | ---------------------- | -------------------- | ------ |
| OQ-001 | Maximum gifted restores a user may receive per month?                            | Prevents restore inflation/abuse     | Product Owner          | Restore spec         | OPEN   |
| OQ-002 | Anti-spam limits for restore requests across friends?                            | Protects social experience           | Product Owner          | Restore spec         | OPEN   |
| OQ-003 | What makes participant habits equivalent in a challenge?                         | Challenge fairness                   | Product Owner          | Challenge spec       | OPEN   |
| OQ-004 | Exact completion deadline/time-zone rule for scheduled occurrences?              | Streak correctness                   | Product Owner          | Streak/check-in spec | OPEN   |
| OQ-005 | Can a participant rejoin after leaving an active challenge?                      | Scoring/history/fairness             | Product Owner          | Challenge spec       | OPEN   |
| OQ-006 | Which identifiers are used to find/add friends in P0/P1?                         | Privacy/discovery                    | Product Owner          | Friends spec         | OPEN   |
| OQ-007 | What user-facing reporting workflow supports Admin moderation in v1?             | Admin role currently assumes reports | Product Owner          | Moderation scope     | OPEN   |
| OQ-008 | Which launch countries/jurisdictions and privacy/legal requirements apply?       | Production compliance                | Product Owner/Legal    | Release Candidate    | OPEN   |
| OQ-009 | What user-visible behavior resolves conflicting offline edits to the same habit? | Prevents silent data loss/confusion  | Product + Architecture | Offline/sync spec    | OPEN   |
| OQ-010 | What retention periods apply after account deletion?                             | Privacy/compliance                   | Product Owner/Legal    | Production launch    | OPEN   |

---

## 23. Release Definition & Product Milestones

### Release 1 is ready when:

- all approved P0 features are implemented and validated;
- Android and iOS are supported;
- English and Arabic/RTL are complete for P0 flows;
- offline-first behavior works across defined core workflows;
- no known release-blocking data-loss, privacy, streak, challenge-scoring, or authorization defects remain;
- critical flows are testable end-to-end;
- applicable launch privacy/legal requirements are resolved.

### Internal Alpha

Core functionality end-to-end with development team/small trusted group. Validate offline-first, streak, restore, challenge, and sync fundamentals.

### Closed Beta

Target approximately 20–50 invited users. Validate habit workflows, offline synchronization, streak logic, restores/gifts, friendships, private challenges, leaderboards, Arabic/English usability, and KPI baselines.

### Release Candidate

No known release-blocking defects. English/Arabic/RTL tested. Offline sync tested under unreliable connectivity. Privacy/permissions verified. Compliance decisions resolved.

### Public v1 Launch

Platforms: Android and iOS.  
Target date: `[TBD]` — establish after architecture and implementation planning.

---

## 24. Requirement Traceability Index

| Feature                            | Functional Requirements        | Business Rules                 | Flows                        | Permissions                  | NFRs                      | Open Questions         |
| ---------------------------------- | ------------------------------ | ------------------------------ | ---------------------------- | ---------------------------- | ------------------------- | ---------------------- |
| P0-F001 Authentication             | FR-001                         | BR-020                         | FLOW-001                     | PERM-001                     | NFR-007                   | OQ-008                 |
| P0-F002 Habit Management           | FR-002, FR-003                 | BR-001, BR-011, BR-012         | FLOW-001                     | PERM-001                     | NFR-002, NFR-004          | OQ-009                 |
| P0-F003 Daily Check-In             | FR-004, FR-005                 | BR-003, BR-004                 | FLOW-001, FLOW-003           | PERM-002                     | NFR-002, NFR-004, NFR-005 | OQ-004, OQ-009         |
| P0-F004 Streak System              | FR-006, FR-007, FR-008         | BR-004–BR-010                  | FLOW-003, FLOW-004           | PERM-007                     | NFR-004, NFR-005          | OQ-001, OQ-002, OQ-004 |
| P0-F005 Habit Reminders            | FR-009                         | BR-019                         | FLOW-001                     | PERM-001                     | NFR-002                   | None                   |
| P0-F006 Friends                    | FR-008, FR-010, FR-011         | BR-001, BR-002, BR-008, BR-018 | FLOW-004                     | PERM-003, PERM-004, PERM-007 | NFR-007, NFR-008          | OQ-006                 |
| P0-F007 Private Challenges         | FR-012, FR-013, FR-015, FR-016 | BR-012–BR-017                  | FLOW-002, FLOW-005           | PERM-005, PERM-006           | NFR-004, NFR-005          | OQ-003, OQ-005         |
| P0-F008 Challenge Leaderboard      | FR-014, FR-016                 | BR-007, BR-013, BR-017         | FLOW-002, FLOW-005           | PERM-005                     | NFR-005                   | OQ-003, OQ-004         |
| P0-F009 Peer Reminder Nudges       | FR-017                         | BR-019                         | FLOW-002                     | PERM-004                     | NFR-007                   | OQ-002                 |
| P0-F010 Profile                    | FR-018                         | BR-001, BR-021                 | FLOW-001                     | PERM-001, PERM-009           | NFR-008                   | OQ-010                 |
| P0-F011 Notifications              | FR-019                         | BR-019                         | FLOW-001, FLOW-002, FLOW-004 | PERM-004, PERM-007           | NFR-010, NFR-011          | None                   |
| P0-F012 Offline-First Experience   | FR-020, FR-021, FR-022         | BR-022, BR-023                 | FLOW-001–FLOW-004            | All applicable               | NFR-002–NFR-006, NFR-012  | OQ-009                 |
| P0-F013 English + Arabic           | FR-023                         | None                           | All applicable               | All applicable               | NFR-009–NFR-011           | None                   |
| P1-F001 Habit Categories & Icons   | FR-024                         | None                           | FLOW-001                     | PERM-001                     | NFR-009–NFR-011           | None                   |
| P1-F002 Basic Habit Statistics     | FR-025                         | BR-004                         | FLOW-001                     | PERM-001                     | NFR-005                   | None                   |
| P1-F003 Challenge History Browsing | FR-026                         | BR-015–BR-017, BR-021          | FLOW-002, FLOW-005           | PERM-005                     | NFR-005, NFR-008          | None                   |
| P1-F004 Friend Activity Summary    | FR-027                         | BR-001, BR-018                 | FLOW-001                     | PERM-003                     | NFR-008                   | None                   |
| P1-F005 Friend Search              | FR-028                         | BR-018                         | N/A                          | PERM-003                     | NFR-007, NFR-008          | OQ-006                 |
| P1-F006 Notification Preferences   | FR-029                         | BR-019                         | FLOW-001, FLOW-002, FLOW-004 | PERM-001                     | NFR-009–NFR-011           | None                   |
| P1-F007 Archived Habit Browsing    | FR-030                         | BR-011                         | FLOW-001                     | PERM-001                     | NFR-002                   | None                   |
| P1-F008 Onboarding                 | FR-031                         | None                           | N/A                          | PERM-001                     | NFR-009–NFR-011           | None                   |

---

## 25. Downstream Handoff Contract

### Canonical Product Source

- PRD Path: `docs/PRD.md`
- PRD Version: v1.0
- PRD Status: Draft — Ready for Product Review
- Last Updated: 2026-09-28
- Product Owner: Abdelrahman Elbendary

### Approved Scope

- P0: P0-F001 through P0-F013
- P1: P1-F001 through P1-F008
- Deferred: P3-F001 through P3-F011

### Requirement Range

- Functional Requirements: FR-001..FR-031
- Business Rules: BR-001..BR-023
- Non-Functional Requirements: NFR-001..NFR-012
- User Flows: FLOW-001..FLOW-005
- Permission Rules: PERM-001..PERM-009
- Data Requirements: DATA-001..DATA-010
- Integration Requirements: INT-001..INT-005
- UX Requirements: UX-001..UX-014
- KPIs: KPI-001..KPI-008
- Risks: RISK-001..RISK-007
- Open Questions: OQ-001..OQ-010
- Constraints: CON-001..CON-006

### Explicit Technical Constraints

1. StreakUp v1 is a mobile application for Android and iOS.
2. Core defined workflows must be fully offline-first.
3. English and Arabic, including RTL behavior, are required in v1.
4. Private-habit behavior remains private by default across implementations.

No framework, state-management library, API style, database technology, hosting provider, synchronization protocol, or code architecture has been selected by this PRD.

### Open Product Decisions

Downstream specifications must resolve or explicitly carry forward OQ-001 through OQ-010.

### Rules for Downstream Agents

1. Read this PRD before creating feature specifications.
2. Reference requirement IDs rather than silently rewriting product behavior.
3. Feature specs may add detail but must not contradict approved PRD requirements.
4. Technical plans must not modify product requirements implicitly.
5. Product ambiguity must be resolved at the product/specification layer.
6. Architecture decisions must be recorded separately.
7. If implementation reveals a product contradiction, revise the PRD rather than silently adapting code.
8. Preserve requirement IDs across revisions.
9. Mark superseded requirements instead of recycling identifiers.
10. Tests should reference relevant requirement/spec IDs when practical.
11. Deferred P3 functionality requires an approved PRD revision.
12. Offline-first, Arabic/RTL, privacy, and streak/challenge correctness are cross-cutting v1 requirements.

### Next Artifact

**Project Constitution and Project Context bootstrap.**

---

## 26. Revision History

| Version | Date       | Author                | Change                       | Requirement Impact           |
| ------- | ---------- | --------------------- | ---------------------------- | ---------------------------- |
| v1.0    | 2026-09-28 | Abdelrahman Elbendary | Initial PRD baseline created | Initial requirement baseline |
