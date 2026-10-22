import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/core/presentation/app_notifier.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_schedule.dart';
import '../../domain/failures/habit_failure.dart';
import '../cubit/create_habit_cubit.dart';

class CreateHabitForm extends StatefulWidget {
  const CreateHabitForm({super.key, required this.onCreated});
  final VoidCallback onCreated;
  @override
  State<CreateHabitForm> createState() => _CreateHabitFormState();
}

class _CreateHabitFormState extends State<CreateHabitForm> {
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _target = TextEditingController();
  HabitFrequency _frequency = HabitFrequency.daily;
  final _weekdays = <int>{};
  HabitCategory? _category;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _target.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final success = await context.read<CreateHabitCubit>().create(
      name: _name.text,
      description: _description.text,
      category: _category,
      targetMinutes: _target.text,
      frequency: _frequency,
      weekdays: _frequency == HabitFrequency.daily ? [] : _weekdays,
    );
    if (success && mounted) widget.onCreated();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<CreateHabitCubit>().state;
    final busy = state.isSubmitting;
    final labels = [
      l10n.habitExercise,
      l10n.habitWater,
      l10n.habitReading,
      l10n.habitMindfulness,
      l10n.habitSleep,
    ];
    return BlocListener<CreateHabitCubit, CreateHabitState>(
      listenWhen: (previous, current) => previous.failure != current.failure,
      listener: (context, state) {
        if (state.failure == HabitFailure.timezoneUnavailable) {
          AppNotifier.error(context, l10n.habitTimezoneError);
        }
        if (state.failure == HabitFailure.storage) {
          AppNotifier.error(context, l10n.habitStorageError);
        }
        if (state.failure == HabitFailure.accountUnavailable) {
          AppNotifier.error(context, l10n.habitAccountUnavailable);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FormSection(
            title: l10n.habitDetails,
            children: [
              TextField(
                controller: _name,
                enabled: !busy,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: l10n.habitName,
                  errorText: state.failure == HabitFailure.invalidName
                      ? l10n.habitInvalidName
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _description,
                enabled: !busy,
                maxLines: 3,
                decoration: InputDecoration(labelText: l10n.habitDescription),
              ),
            ],
          ),
          _FormSection(
            title: l10n.habitCategory,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final category in HabitCategory.values)
                    ChoiceChip(
                      label: Text(labels[category.index]),
                      selected: _category == category,
                      onSelected: busy
                          ? null
                          : (selected) => setState(() {
                              _category = selected ? category : null;
                            }),
                    ),
                ],
              ),
            ],
          ),
          _FormSection(
            title: l10n.habitSchedule,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final frequency in HabitFrequency.values)
                    ChoiceChip(
                      label: Text(
                        frequency == HabitFrequency.daily
                            ? l10n.habitDaily
                            : l10n.habitSelectedDays,
                      ),
                      selected: _frequency == frequency,
                      onSelected: busy
                          ? null
                          : (_) => setState(() {
                              _frequency = frequency;
                            }),
                    ),
                ],
              ),
              if (_frequency == HabitFrequency.selectedWeekdays)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (var day = 1; day <= 7; day++)
                      FilterChip(
                        label: Text(
                          DateFormat.E(
                            Localizations.localeOf(context).toString(),
                          ).format(DateTime(2024, 1, day)),
                        ),
                        selected: _weekdays.contains(day),
                        onSelected: busy
                            ? null
                            : (selected) => setState(() {
                                if (selected) {
                                  _weekdays.add(day);
                                } else {
                                  _weekdays.remove(day);
                                }
                              }),
                      ),
                  ],
                ),
              if (state.failure == HabitFailure.invalidSchedule)
                Text(
                  l10n.habitInvalidSchedule,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
            ],
          ),
          _FormSection(
            title: l10n.habitTarget,
            children: [
              TextField(
                controller: _target,
                enabled: !busy,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  errorText: state.failure == HabitFailure.invalidTarget
                      ? l10n.habitInvalidTarget
                      : null,
                ),
              ),
            ],
          ),
          _FormSection(
            title: l10n.habitPrivate,
            children: [Text(l10n.habitPrivateDescription)],
          ),
          FilledButton(
            onPressed: busy ? null : _submit,
            child: busy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.habitCreateTitle),
          ),
        ],
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    ),
  );
}
