import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:streak_up/app/theme/app_colors.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_occurrence.dart';
import '../../domain/failures/habit_failure.dart';
import '../cubit/today_cubit.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({
    super.key,
    required this.onCreate,
    required this.onOpenHabits,
  });
  final VoidCallback onCreate;
  final VoidCallback onOpenHabits;
  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> with WidgetsBindingObserver {
  Timer? _timer;
  bool _active = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void _schedule(TodayState state) {
    _timer?.cancel();
    if (!_active) return;
    var delay = const Duration(seconds: 60);
    final next = state.projection?.nextBoundaryUtc;
    if (next != null) {
      final untilBoundary = next.difference(DateTime.now().toUtc());
      if (untilBoundary < delay) delay = untilBoundary;
    }
    // A short minimum avoids spinning on a stale boundary; resume rechecks now.
    if (delay <= Duration.zero) delay = const Duration(milliseconds: 100);
    _timer = Timer(delay, () {
      if (mounted && _active) context.read<TodayCubit>().refresh();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _active = state == AppLifecycleState.resumed;
    _timer?.cancel();
    if (_active) {
      context.read<TodayCubit>().refresh();
      _schedule(context.read<TodayCubit>().state);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocConsumer<TodayCubit, TodayState>(
      listener: (_, state) => _schedule(state),
      builder: (context, state) {
        final projection = state.projection;
        return ListView(
          key: const ValueKey('shell_host_today'),
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            Text(
              l10n.todayHeading,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.brandTagline,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 28),
            Text(
              l10n.todayHabits,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (state.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (state.hasError) ...[
              Text(l10n.habitStorageError),
              TextButton(
                onPressed: context.read<TodayCubit>().refresh,
                child: Text(l10n.actionRetry),
              ),
            ] else if (projection != null) ...[
              if (projection.due.isNotEmpty) ...[
                Text(
                  l10n.todayProgress(
                    projection.completedCount,
                    projection.due.length,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: projection.completedCount / projection.due.length,
                  semanticsLabel: l10n.todayProgress(
                    projection.completedCount,
                    projection.due.length,
                  ),
                ),
                if (projection.completedCount == projection.due.length)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(l10n.todayAllComplete),
                  ),
                const SizedBox(height: 16),
              ],
              if (projection.due.isEmpty)
                _EmptyToday(
                  noHabits: projection.habitCount == 0,
                  onCreate: widget.onCreate,
                  onOpenHabits: widget.onOpenHabits,
                ),
              for (final occurrence in projection.due)
                _OccurrenceRow(
                  occurrence: occurrence,
                  busy: state.completing.contains(occurrence.key),
                  failure: state.actionFailures[occurrence.key],
                  onComplete: () =>
                      context.read<TodayCubit>().complete(occurrence),
                ),
              if (projection.yesterday.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  l10n.todayYesterday,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                for (final occurrence in projection.yesterday)
                  _OccurrenceRow(occurrence: occurrence),
              ],
              if (projection.pendingEarlier.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  l10n.todayEarlierCheckIns,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                for (final occurrence in projection.pendingEarlier)
                  _OccurrenceRow(occurrence: occurrence),
              ],
            ],
          ],
        );
      },
    );
  }
}

class _EmptyToday extends StatelessWidget {
  const _EmptyToday({
    required this.noHabits,
    required this.onCreate,
    required this.onOpenHabits,
  });
  final bool noHabits;
  final VoidCallback onCreate;
  final VoidCallback onOpenHabits;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const ExcludeSemantics(
              child: Icon(
                Icons.inventory_2_outlined,
                size: 88,
                color: AppColors.greenDark,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              noHabits ? l10n.todayNoHabits : l10n.todayNothingDue,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              noHabits ? l10n.todayNoHabitsHint : l10n.todayNothingDueHint,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: noHabits ? onCreate : onOpenHabits,
              icon: Icon(noHabits ? Icons.add : Icons.list_alt),
              label: Text(noHabits ? l10n.habitCreateTitle : l10n.navHabits),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _OccurrenceRow extends StatelessWidget {
  const _OccurrenceRow({
    required this.occurrence,
    this.onComplete,
    this.busy = false,
    this.failure,
  });
  final HabitOccurrence occurrence;
  final VoidCallback? onComplete;
  final bool busy;
  final HabitFailure? failure;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final habit = occurrence.habit;
    final missed = occurrence.state == HabitOccurrenceState.missed;
    final completed = occurrence.state == HabitOccurrenceState.completed;
    final icon = switch (habit.category) {
      HabitCategory.exercise => Icons.directions_run,
      HabitCategory.water => Icons.water_drop_outlined,
      HabitCategory.reading => Icons.menu_book,
      HabitCategory.mindfulness => Icons.spa_outlined,
      HabitCategory.sleep => Icons.bedtime_outlined,
      null => Icons.eco_outlined,
    };
    final date = DateFormat.yMMMd(
      Localizations.localeOf(context).toString(),
    ).format(DateTime.parse(occurrence.scheduledLocalDate));
    return Card(
      key: ValueKey(occurrence.key),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: CircleAvatar(
                backgroundColor: AppColors.selectedGreenPill,
                foregroundColor: AppColors.greenDark,
                child: Icon(icon),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (habit.targetMinutes != null)
                    Text(l10n.todayMinutes(habit.targetMinutes!)),
                  const SizedBox(height: 8),
                  Text(
                    '$date • ${habit.schedule.timezone}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    missed
                        ? l10n.todayMissed
                        : completed
                        ? l10n.todayCompleted
                        : l10n.todayUnchecked,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (completed) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const ExcludeSemantics(
                          child: Icon(
                            Icons.sync,
                            size: 16,
                            color: AppColors.pending,
                          ),
                        ),
                        Text(
                          l10n.habitPending,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                  if (failure != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      failure == HabitFailure.occurrenceUnavailable
                          ? l10n.todayOccurrenceUnavailable
                          : failure == HabitFailure.accountUnavailable
                          ? l10n.todayCheckInAccountUnavailable
                          : l10n.todayCheckInStorageError,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (busy)
              SizedBox(
                width: 48,
                height: 48,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    semanticsLabel: l10n.todaySaving,
                  ),
                ),
              )
            else if (!missed && !completed && onComplete != null)
              IconButton(
                key: ValueKey('complete/${occurrence.key}'),
                tooltip: l10n.todayCompleteHabit(habit.name),
                onPressed: onComplete,
                icon: const Icon(Icons.radio_button_unchecked, size: 28),
              )
            else
              ExcludeSemantics(
                child: Icon(
                  completed
                      ? Icons.check_circle
                      : missed
                      ? Icons.schedule
                      : Icons.radio_button_unchecked,
                  color: completed
                      ? AppColors.greenDark
                      : AppColors.secondaryText,
                  size: 28,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
