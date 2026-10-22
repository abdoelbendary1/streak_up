import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/habit.dart';
import '../../domain/use_cases/habit_use_cases.dart';
import '../../domain/failures/habit_failure.dart';

class HabitListState {
  const HabitListState({
    this.isLoading = true,
    this.hasError = false,
    this.habits = const [],
    this.deliveryFailure,
    this.isDelivering = false,
  });
  final bool isLoading;
  final bool hasError;
  final List<Habit> habits;
  final HabitFailure? deliveryFailure;
  final bool isDelivering;
}

class HabitListCubit extends Cubit<HabitListState> {
  HabitListCubit(
    WatchHabitsUseCase watch, {
    DeliverPendingHabitCreatesUseCase? deliver,
  }) : _deliver = deliver,
       super(const HabitListState()) {
    _subscription = watch().listen(
      (habits) {
        emit(
          HabitListState(
            isLoading: false,
            habits: habits,
            deliveryFailure:
                habits.any(
                  (habit) => habit.syncStatus == HabitSyncStatus.pending,
                )
                ? state.deliveryFailure
                : null,
            isDelivering: state.isDelivering,
          ),
        );
      },
      onError: (Object _) {
        emit(
          HabitListState(
            isLoading: false,
            hasError: true,
            habits: state.habits,
          ),
        );
      },
    );
  }
  late final StreamSubscription<List<Habit>> _subscription;
  final DeliverPendingHabitCreatesUseCase? _deliver;

  Future<void> deliver() async {
    if (isClosed || state.isDelivering || _deliver == null) return;
    emit(
      HabitListState(
        isLoading: state.isLoading,
        hasError: state.hasError,
        habits: state.habits,
        isDelivering: true,
      ),
    );
    final result = await _deliver();
    if (isClosed) return;
    emit(
      HabitListState(
        isLoading: state.isLoading,
        hasError: state.hasError,
        habits: state.habits,
        deliveryFailure: result.fold((f) => f, (_) => null),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    await super.close();
  }
}
