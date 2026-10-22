import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:streak_up/features/auth/presentation/sheets/sign_out_warning_sheet.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_buttons.dart';
import 'package:streak_up/features/shell/presentation/widgets/feature_placeholder.dart';

class ProfilePlaceholder extends StatelessWidget {
  const ProfilePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isSubmitting = context.select(
      (AuthCubit cubit) => cubit.state.isSubmitting,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FeaturePlaceholder(
            key: const ValueKey<String>('global_host_profile'),
            title: l10n.screenProfileTitle,
            description: l10n.screenProfilePlaceholderBody,
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: AppSpacing.md),
          AuthSecondaryPillButton(
            key: const ValueKey<String>('profile_sign_out_button'),
            label: l10n.authSignOutAction,
            isDestructive: true,
            onPressed: isSubmitting
                ? null
                : () async {
                    final confirmed = await SignOutWarningSheet.show(context);
                    if (!confirmed || !context.mounted) return;
                    context.read<AuthCubit>().signOut();
                  },
          ),
        ],
      ),
    );
  }
}
