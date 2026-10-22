import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/core/presentation/app_notifier.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_messages.dart';

class AuthNotificationListener extends StatelessWidget {
  const AuthNotificationListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current.failure != null && previous.failure != current.failure,
      listener: (context, state) {
        final l10n = AppLocalizations.of(context);
        AppNotifier.error(context, state.failure!.localizedMessage(l10n));
      },
      child: child,
    );
  }
}
