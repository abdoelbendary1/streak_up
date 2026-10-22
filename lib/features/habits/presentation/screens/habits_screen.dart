import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:streak_up/app/theme/app_colors.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_schedule.dart';
import '../cubit/habit_list_cubit.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key, required this.onCreate});
  final VoidCallback onCreate;
  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<HabitListCubit>().deliver();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<HabitListCubit>().deliver();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<HabitListCubit, HabitListState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 16,
              runSpacing: 12,
              children: [
                Text(
                  l10n.navHabits,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                FilledButton.icon(
                  onPressed: widget.onCreate,
                  icon: const Icon(Icons.add),
                  label: Text(l10n.habitNew),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(l10n.habitListSubtitle),
            if (state.habits.any(
              (habit) => habit.syncStatus == HabitSyncStatus.pending,
            ))
              TextButton.icon(
                onPressed: state.isDelivering
                    ? null
                    : context.read<HabitListCubit>().deliver,
                icon: const Icon(Icons.sync),
                label: Text(l10n.actionRetry),
              ),
            if (state.deliveryFailure != null) Text(l10n.habitDeliveryPending),
            const SizedBox(height: 28),
            Text(
              l10n.habitActive,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (state.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (state.hasError)
              Text(l10n.habitStorageError)
            else if (state.habits.isEmpty)
              Text(l10n.habitEmpty),
            for (final habit in state.habits) _HabitRow(habit: habit),
          ],
        );
      },
    );
  }
}

class _HabitRow extends StatelessWidget {
  const _HabitRow({required this.habit});
  final Habit habit;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final statusLabel = switch (habit.syncStatus) {
      HabitSyncStatus.pending => l10n.habitPending,
      HabitSyncStatus.synced => l10n.habitSynced,
      HabitSyncStatus.failed => l10n.habitFailed,
    };
    final statusColor = switch (habit.syncStatus) {
      HabitSyncStatus.pending => AppColors.pending,
      HabitSyncStatus.synced => Theme.of(context).colorScheme.primary,
      HabitSyncStatus.failed => Theme.of(context).colorScheme.error,
    };
    final schedule = habit.schedule.frequency == HabitFrequency.daily
        ? l10n.habitDaily
        : habit.schedule.weekdays
              .map(
                (day) => DateFormat.E(
                  Localizations.localeOf(context).toString(),
                ).format(DateTime(2024, 1, day)),
              )
              .join(' • ');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(habit.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(schedule),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_outline, size: 18),
                    const SizedBox(width: 6),
                    Text(l10n.habitPrivate),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      switch (habit.syncStatus) {
                        HabitSyncStatus.pending => Icons.sync,
                        HabitSyncStatus.synced => Icons.check_circle_outline,
                        HabitSyncStatus.failed => Icons.error_outline,
                      },
                      size: 18,
                      color: statusColor,
                    ),
                    const SizedBox(width: 6),
                    Text(statusLabel, style: TextStyle(color: statusColor)),
                  ],
                ),
              ],
            ),
            if (habit.rejection != null)
              Text(switch (habit.rejection!) {
                HabitRejection.invalidPayload => l10n.habitRejectedPayload,
                HabitRejection.commandReused => l10n.habitRejectedCommand,
                HabitRejection.entityExists => l10n.habitRejectedEntity,
              }),
          ],
        ),
      ),
    );
  }
}
