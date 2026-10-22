import 'habit_schedule.dart';

enum HabitSyncStatus { pending, synced, failed }

enum HabitRejection { invalidPayload, commandReused, entityExists }

enum HabitCategory { exercise, water, reading, mindfulness, sleep }

enum HabitStartSource { localCreation, legacyObservation }

class Habit {
  const Habit({
    required this.id,
    required this.accountId,
    required this.name,
    required this.schedule,
    this.description = '',
    this.category,
    this.targetMinutes,
    this.syncStatus = HabitSyncStatus.pending,
    this.serverRevision,
    this.createdAt,
    this.updatedAt,
    this.rejection,
    this.coverageStartLocalDate,
    this.coverageStartObservedAtUtc,
    this.coverageStartSource,
  });
  final String id;
  final String accountId;
  final String name;
  final String description;
  final HabitSchedule schedule;
  final HabitCategory? category;
  final int? targetMinutes;
  final HabitSyncStatus syncStatus;
  final int? serverRevision;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final HabitRejection? rejection;
  // Legacy coverage is prospective, never a reconstructed creation date.
  final String? coverageStartLocalDate;
  final DateTime? coverageStartObservedAtUtc;
  final HabitStartSource? coverageStartSource;
}
