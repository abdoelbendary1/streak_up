import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_schedule.dart';
import '../../domain/failures/habit_failure.dart';
import '../../domain/use_cases/habit_use_cases.dart';

class CreateHabitState {
  const CreateHabitState({this.isSubmitting = false, this.failure, this.habit});
  final bool isSubmitting;
  final HabitFailure? failure;
  final Habit? habit;
}

class CreateHabitCubit extends Cubit<CreateHabitState> {
  CreateHabitCubit(
    this._create, {
    required Future<String> Function() readTimezone,
  }) : _readTimezone = readTimezone,
       super(const CreateHabitState());
  final CreateHabitUseCase _create;
  final Future<String> Function() _readTimezone;

  Future<bool> create({
    required String name,
    required HabitFrequency frequency,
    Iterable<int> weekdays = const [],
    String description = '',
    HabitCategory? category,
    String targetMinutes = '',
  }) async {
    if (state.isSubmitting) return false;
    final days = List<int>.of(weekdays);
    final target = targetMinutes.trim().isEmpty
        ? null
        : int.tryParse(targetMinutes.trim());
    HabitFailure? invalid;
    if (name.trim().isEmpty) {
      invalid = HabitFailure.invalidName;
    } else if (frequency == HabitFrequency.selectedWeekdays &&
        (days.isEmpty ||
            days.toSet().length != days.length ||
            days.any((day) => day < 1 || day > 7))) {
      invalid = HabitFailure.invalidSchedule;
    } else if (frequency == HabitFrequency.daily && days.isNotEmpty) {
      invalid = HabitFailure.invalidSchedule;
    } else if (targetMinutes.trim().isNotEmpty &&
        (target == null || target <= 0)) {
      invalid = HabitFailure.invalidTarget;
    }
    if (invalid != null) {
      emit(CreateHabitState(failure: invalid));
      return false;
    }
    emit(const CreateHabitState(isSubmitting: true));
    String timezone;
    try {
      timezone = await _readTimezone();
    } catch (_) {
      if (!isClosed) {
        emit(const CreateHabitState(failure: HabitFailure.timezoneUnavailable));
      }
      return false;
    }
    if (isClosed) return false;
    final schedule = HabitSchedule(
      frequency: frequency,
      timezone: timezone,
      weekdays: days..sort(),
    );
    if (!schedule.isValid) {
      emit(const CreateHabitState(failure: HabitFailure.timezoneUnavailable));
      return false;
    }
    final result = await _create(
      name: name.trim(),
      schedule: schedule,
      description: description.trim(),
      category: category,
      targetMinutes: target,
    );
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(CreateHabitState(failure: failure));
        return false;
      },
      (habit) {
        emit(CreateHabitState(habit: habit));
        return true;
      },
    );
  }
}
