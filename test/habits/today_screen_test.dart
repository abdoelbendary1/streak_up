import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/habits/domain/entities/habit_occurrence.dart';
import 'package:streak_up/features/habits/domain/entities/habit_check_in.dart';
import 'package:streak_up/features/habits/domain/failures/habit_failure.dart';
import 'package:streak_up/features/habits/domain/repositories/habit_repository.dart';
import 'package:streak_up/features/habits/domain/use_cases/habit_use_cases.dart';
import 'package:streak_up/features/habits/presentation/cubit/today_cubit.dart';
import 'package:streak_up/features/habits/presentation/screens/today_screen.dart';
import 'package:streak_up/features/habits/domain/habit_occurrence_rules.dart';
import 'today_projection_test.dart' show fixture;

class _TodayRepository implements HabitRepository {
  final events = StreamController<TodayProjection>();
  var refreshes = 0;
  var submission = Completer<Either<HabitFailure, CompleteOccurrenceResult>>();
  var completeCalls = 0;
  @override
  Future<Either<HabitFailure, CompleteOccurrenceResult>> completeOccurrence({
    required String habitId,
    required String scheduledLocalDate,
  }) {
    completeCalls++;
    return submission.future;
  }

  @override
  Stream<TodayProjection> watchToday() => events.stream;
  @override
  void refreshToday() => refreshes++;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'closed TodayCubit safely ignores a late action result and further taps',
    () async {
      final repository = _TodayRepository();
      final cubit = TodayCubit(
        WatchTodayUseCase(repository),
        RefreshTodayUseCase(repository),
        CompleteOccurrenceUseCase(repository),
      );
      final row = projectToday([
        fixture(),
      ], DateTime.utc(2026, 10, 6, 12)).due.single;
      final action = cubit.complete(row);
      await cubit.close();
      repository.submission.complete(
        const Right(CompleteOccurrenceResult.completed),
      );
      await action;
      await cubit.complete(row);
      expect(cubit.isClosed, isTrue);
      expect(repository.completeCalls, 1);
      await repository.events.close();
    },
  );
  for (final locale in ['en', 'ar']) {
    testWidgets(
      'Today $locale compact large text: local completion, Pending, storage retry, Missed and refresh',
      (tester) async {
        tester.view.physicalSize = const Size(320, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final repository = _TodayRepository();
        final cubit = TodayCubit(
          WatchTodayUseCase(repository),
          RefreshTodayUseCase(repository),
          CompleteOccurrenceUseCase(repository),
        );
        var creates = 0;
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.5)),
              child: child!,
            ),
            home: Scaffold(
              body: BlocProvider.value(
                value: cubit,
                child: TodayScreen(
                  onCreate: () => creates++,
                  onOpenHabits: () {},
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        final now = DateTime.utc(2026, 10, 6, 12);
        repository.events.add(projectToday([], now));
        await tester.pump();
        final context = tester.element(find.byType(TodayScreen));
        final l10n = AppLocalizations.of(context);
        expect(
          Directionality.of(context),
          locale == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        );
        expect(find.text(l10n.todayNoHabits), findsOneWidget);
        await tester.ensureVisible(find.text(l10n.habitCreateTitle));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.habitCreateTitle));
        expect(creates, 1);
        repository.events.add(
          projectToday([
            fixture(days: [3]),
          ], now),
        );
        await tester.pump();
        expect(find.text(l10n.todayNothingDue), findsOneWidget);
        repository.events.add(projectToday([fixture()], now));
        await tester.pump();
        expect(find.text(l10n.todayUnchecked), findsOneWidget);
        await tester.scrollUntilVisible(find.text(l10n.todayMissed), 150);
        expect(find.text(l10n.todayMissed), findsOneWidget);
        expect(find.byType(Checkbox), findsNothing);
        expect(find.text(l10n.habitSynced), findsNothing);
        expect(find.text(l10n.habitPending), findsNothing);
        expect(tester.takeException(), isNull);
        final action = find.byKey(const ValueKey('complete/abc/2026-10-06'));
        await tester.ensureVisible(action);
        await tester.pumpAndSettle();
        await tester.tap(action);
        await tester.pump();
        expect(repository.completeCalls, 1);
        expect(cubit.state.completing, contains('abc/2026-10-06'));
        expect(find.text(l10n.todayCompleted), findsNothing);
        await cubit.complete(projectToday([fixture()], now).due.single);
        expect(repository.completeCalls, 1);
        repository.submission.complete(const Left(HabitFailure.storage));
        await tester.pump();
        expect(find.text(l10n.todayCheckInStorageError), findsOneWidget);
        expect(find.text(l10n.todayUnchecked), findsOneWidget);
        expect(find.text(l10n.habitPending), findsNothing);
        repository.submission = Completer();
        await tester.ensureVisible(action);
        await tester.pumpAndSettle();
        await tester.tap(action);
        await tester.pump();
        repository.submission.complete(
          const Right(CompleteOccurrenceResult.completed),
        );
        await tester.pump();
        // The command result alone must never paint a completion.
        expect(find.text(l10n.todayCompleted), findsNothing);
        final habit = fixture();
        final fact = HabitCheckIn(
          accountId: 'A',
          habitId: habit.id,
          scheduledLocalDate: '2026-10-06',
          commandId: 'check-in',
          admittedAtUtc: now,
          observedLocalDate: '2026-10-06',
          schedule: habit.schedule,
          coverageStartLocalDate: habit.coverageStartLocalDate!,
          coverageStartObservedAtUtc: habit.coverageStartObservedAtUtc!,
          coverageStartSource: habit.coverageStartSource!,
        );
        repository.events.add(projectToday([habit], now, checkIns: [fact]));
        await tester.pump();
        expect(find.text(l10n.todayCompleted), findsOneWidget);
        expect(find.text(l10n.habitPending), findsOneWidget);
        expect(find.text(l10n.todayAllComplete), findsOneWidget);
        expect(find.text(l10n.habitSynced), findsNothing);
        expect(action, findsNothing);
        expect(cubit.state.actionFailures, isEmpty);
        expect(tester.takeException(), isNull);
        await tester.pump(const Duration(seconds: 60));
        expect(repository.refreshes, greaterThan(0));
        final beforeResume = repository.refreshes;
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        expect(repository.refreshes, beforeResume + 1);
        repository.events.addError(StateError('Local storage unavailable'));
        await tester.pump();
        expect(find.text(l10n.habitStorageError), findsOneWidget);
        expect(find.text(l10n.todayNoHabits), findsNothing);
        await tester.pumpWidget(const SizedBox());
        final beforeDisposal = repository.refreshes;
        await tester.pump(const Duration(seconds: 65));
        expect(repository.refreshes, beforeDisposal);
        await tester.runAsync(() async {
          await cubit.close();
          await repository.events.close();
        });
      },
    );
  }
}
