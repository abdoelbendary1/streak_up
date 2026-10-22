import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_spacing.dart';

class AuthPageHeader extends StatelessWidget {
  const AuthPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.centered = false,
    this.titleMaxWidth,
    this.subtitleGap = AppSpacing.xs,
  });

  final String title;
  final String subtitle;
  final bool centered;
  final double? titleMaxWidth;
  final double subtitleGap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: centered
              ? Alignment.center
              : AlignmentDirectional.centerStart,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: titleMaxWidth ?? double.infinity,
            ),
            child: Text(
              title,
              textAlign: centered ? TextAlign.center : TextAlign.start,
              style: textTheme.headlineLarge,
            ),
          ),
        ),
        SizedBox(height: subtitleGap),
        Text(
          subtitle,
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: textTheme.bodyLarge,
        ),
      ],
    );
  }
}
