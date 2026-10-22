import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:streak_up/features/habits/domain/repositories/habit_repository.dart';
import 'package:streak_up/features/habits/domain/use_cases/habit_use_cases.dart';
import 'package:streak_up/features/habits/presentation/cubit/habit_list_cubit.dart';

class HabitAccountScope extends StatefulWidget {
  const HabitAccountScope({
    super.key,
    required this.openRepository,
    required this.child,
  });
  final Future<HabitRepository> Function(String accountId) openRepository;
  final Widget child;
  @override
  State<HabitAccountScope> createState() => _HabitAccountScopeState();
}

class _HabitAccountScopeState extends State<HabitAccountScope> {
  HabitRepository? _repository;
  String? _wantedAccount;
  Future<void> _transition = Future.value();
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _bind(context.read<AuthCubit>().state);
  }

  void _bind(AuthState state) {
    final wanted = state.canAccessProtected ? state.session!.userId : null;
    if (wanted == _wantedAccount) return;
    _wantedAccount = wanted;
    _failed = false;
    // Queue close before open; compare identity again after asynchronous opening.
    _transition = _transition
        .then((_) async {
          final previous = _repository;
          await previous?.close();
          _repository = null;
          if (!mounted || wanted != _wantedAccount || wanted == null) return;
          try {
            final next = await widget.openRepository(wanted);
            if (!mounted || wanted != _wantedAccount) {
              await next.close();
              return;
            }
            setState(() {
              _repository = next;
            });
          } catch (_) {
            if (mounted && wanted == _wantedAccount) {
              setState(() {
                _failed = true;
              });
            }
          }
        })
        .catchError((Object _) {
          if (mounted) {
            setState(() {
              _failed = true;
            });
          }
        });
  }

  @override
  void dispose() {
    _wantedAccount = null;
    _transition.then((_) => _repository?.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.canAccessProtected != current.canAccessProtected ||
          previous.session?.userId != current.session?.userId,
      listener: (context, state) => setState(() {
        _bind(state);
      }),
      child: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    if (_wantedAccount == null) {
      return widget.child;
    }
    final repository = _repository;
    if (repository == null || repository.accountId != _wantedAccount) {
      return Material(
        child: Center(
          child: _failed
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(AppLocalizations.of(context).habitStorageError),
                      TextButton(
                        onPressed: () => setState(() {
                          _wantedAccount = null;
                          _bind(context.read<AuthCubit>().state);
                        }),
                        child: Text(AppLocalizations.of(context).actionRetry),
                      ),
                    ],
                  ),
                )
              : const CircularProgressIndicator(),
        ),
      );
    }
    return RepositoryProvider<HabitRepository>.value(
      value: repository,
      child: BlocProvider(
        key: ValueKey(repository),
        create: (_) => HabitListCubit(
          WatchHabitsUseCase(repository),
          deliver: DeliverPendingHabitCreatesUseCase(repository),
        ),
        child: widget.child,
      ),
    );
  }
}
