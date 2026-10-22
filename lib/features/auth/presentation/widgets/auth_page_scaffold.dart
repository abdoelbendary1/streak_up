import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_spacing.dart';
import 'package:streak_up/core/presentation/widgets/streak_up_wordmark.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_illustrations.dart';

class AuthPageScaffold extends StatelessWidget {
  const AuthPageScaffold({
    super.key,
    required this.child,
    this.showTopWordmark = true,
    this.wordmarkGap = 32,
    this.centerContentVertically = false,
  });

  final Widget child;
  final bool showTopWordmark;
  final double wordmarkGap;
  final bool centerContentVertically;

  static const maxContentWidth = AppSpacing.maxReadableContentWidth;

  @override
  Widget build(BuildContext context) {
    final isCompact =
        MediaQuery.sizeOf(context).width < AppSpacing.compactWidthMax;
    final horizontalPadding = isCompact ? AppSpacing.md : AppSpacing.lg;
    final topPadding = isCompact ? AppSpacing.md : 18.0;

    final content = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxContentWidth),
        child: Column(
          mainAxisAlignment: centerContentVertically
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showTopWordmark) ...[
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: StreakUpWordmark(height: 100),
              ),
              SizedBox(
                height: isCompact ? wordmarkGap.clamp(0, 24) : wordmarkGap,
              ),
            ],
            child,
          ],
        ),
      ),
    );

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: AuthBackgroundArtwork()),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Scaffold already resizes for the keyboard; do not add its inset again.
                final minHeight = centerContentVertically
                    ? (constraints.maxHeight - topPadding - AppSpacing.xl)
                          .clamp(0.0, double.infinity)
                    : 0.0;

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    topPadding,
                    horizontalPadding,
                    AppSpacing.xl,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: minHeight),
                    child: content,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
