import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/habit_occurrence.dart';
import '../../domain/use_cases/habit_use_cases.dart';
import '../../domain/failures/habit_failure.dart';

class TodayState {
  const TodayState({
    this.isLoading = true,
    this.hasError = false,
    this.projection,
    this.completing = const {},
    this.actionFailures = const {},
  });
  final bool isLoading;
  final bool hasError;
  final TodayProjection? projection;
  final Set<String> completing;
  final Map<String, HabitFailure> actionFailures;
}

class TodayCubit extends Cubit<TodayState> {
  TodayCubit(WatchTodayUseCase watch, this._refresh, this._complete)
    : super(const TodayState()) {
    _subscription = watch().listen(
      (projection) => emit(
        TodayState(
          isLoading: false,
          projection: projection,
          completing: state.completing,
          actionFailures: state.actionFailures,
        ),
      ),
      onError: (Object _) => emit(
        TodayState(
          isLoading: false,
          hasError: true,
          completing: state.completing,
          actionFailures: state.actionFailures,
        ),
      ),
    );
  }
  final RefreshTodayUseCase _refresh;
  final CompleteOccurrenceUseCase _complete;
  late final StreamSubscription<TodayProjection> _subscription;
  void refresh() {
    if (!isClosed) _refresh();
  }

  Future<void> complete(HabitOccurrence occurrence) async {
    if (isClosed ||
        occurrence.state != HabitOccurrenceState.pending ||
        state.completing.contains(occurrence.key)) {
      return;
    }
    void publish(Set<String> completing, Map<String, HabitFailure> failures) {
      emit(
        TodayState(
          isLoading: state.isLoading,
          hasError: state.hasError,
          projection: state.projection,
          completing: Set.unmodifiable(completing),
          actionFailures: Map.unmodifiable(failures),
        ),
      );
    }

    publish({
      ...state.completing,
      occurrence.key,
    }, {...state.actionFailures}..remove(occurrence.key));
    HabitFailure? failure;
    try {
      final result = await _complete(
        habitId: occurrence.habit.id,
        scheduledLocalDate: occurrence.scheduledLocalDate,
      );
      failure = result.fold((value) => value, (_) => null);
    } catch (_) {
      failure = HabitFailure.storage;
    }
    if (isClosed) return;
    final failures = {...state.actionFailures}..remove(occurrence.key);
    if (failure != null) failures[occurrence.key] = failure;
    publish({...state.completing}..remove(occurrence.key), failures);
    if (failure == HabitFailure.occurrenceUnavailable) refresh();
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    await super.close();
  }
}
