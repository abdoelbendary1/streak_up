import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/features/shell/presentation/models/shell_destination.dart';
import 'package:streak_up/features/shell/presentation/widgets/shell_bottom_navigation.dart';
import 'package:streak_up/features/shell/presentation/widgets/shell_top_bar.dart';

/// Composes shared shell chrome around destination content.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onOpenInbox,
    required this.onOpenProfile,
    required this.child,
  });

  final int selectedIndex;
  final ValueChanged<ShellDestination> onDestinationSelected;
  final VoidCallback onOpenInbox;
  final VoidCallback onOpenProfile;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding =
            constraints.maxWidth < AppSpacing.compactWidthMax
            ? AppSpacing.sm
            : AppSpacing.md;

        return Scaffold(
          // Destinations handle keyboard insets in their own viewport. Keeping
          // chrome out of that resize keeps navigation stable while typing.
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSpacing.maxReadableContentWidth,
                ),
                child: Column(
                  children: [
                    ShellTopBar(
                      onInboxPressed: onOpenInbox,
                      onProfilePressed: onOpenProfile,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          horizontalPadding,
                          AppSpacing.xs,
                          horizontalPadding,
                          AppSpacing.lg,
                        ),
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: ShellBottomNavigation(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
          ),
        );
      },
    );
  }
}
