import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import '../../domain/repositories/habit_repository.dart';
import '../../domain/use_cases/habit_use_cases.dart';
import '../cubit/create_habit_cubit.dart';
import '../widgets/create_habit_form.dart';

class CreateHabitScreen extends StatelessWidget {
  const CreateHabitScreen({super.key, required this.onCreated});
  final VoidCallback onCreated;
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => CreateHabitCubit(
      CreateHabitUseCase(context.read<HabitRepository>()),
      readTimezone: () async =>
          (await FlutterTimezone.getLocalTimezone()).identifier,
    ),
    child: Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).habitCreateTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: CreateHabitForm(onCreated: onCreated),
            ),
          ),
        ),
      ),
    ),
  );
}
