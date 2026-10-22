import 'package:flutter/material.dart';
import 'package:streak_up/core/localization/app_localizations.dart';

/// Finite primary bottom-navigation destinations in the signed-in shell
///
/// Inbox, Profile, and Sync & Recovery are global or contextual destinations
/// and must never be added to this enum.
enum ShellDestination {
  today,
  habits,
  challenges,
  friends;

  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      ShellDestination.today => l10n.navToday,
      ShellDestination.habits => l10n.navHabits,
      ShellDestination.challenges => l10n.navChallenges,
      ShellDestination.friends => l10n.navFriends,
    };
  }

  IconData get icon {
    return switch (this) {
      ShellDestination.today => Icons.home_outlined,
      ShellDestination.habits => Icons.format_list_bulleted_rounded,
      ShellDestination.challenges => Icons.emoji_events_outlined,
      ShellDestination.friends => Icons.people_outline_rounded,
    };
  }

  IconData get selectedIcon {
    return switch (this) {
      ShellDestination.today => Icons.home_rounded,
      ShellDestination.habits => Icons.format_list_bulleted_rounded,
      ShellDestination.challenges => Icons.emoji_events_rounded,
      ShellDestination.friends => Icons.people_rounded,
    };
  }
}
