import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:streak_up/app/routing/shell_destination.dart';
import 'package:streak_up/core/localization/active_locale_resolver.dart';

/// Immutable presentation state for the root shell (`T014`, `T026`).
@immutable
class ShellState {
  const ShellState({
    this.selectedDestination = ShellDestination.today,
    this.explicitLocaleOverride,
  });

  final ShellDestination selectedDestination;
  final Locale? explicitLocaleOverride;

  Locale resolveActiveLocale(Locale? deviceLocale) {
    return ActiveLocaleResolver.resolve(
      explicitOverride: explicitLocaleOverride,
      deviceLocale: deviceLocale,
    );
  }

  ShellState copyWith({
    ShellDestination? selectedDestination,
    Locale? explicitLocaleOverride,
    bool clearLocaleOverride = false,
  }) {
    return ShellState(
      selectedDestination: selectedDestination ?? this.selectedDestination,
      explicitLocaleOverride: clearLocaleOverride
          ? null
          : (explicitLocaleOverride ?? this.explicitLocaleOverride),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShellState &&
        other.selectedDestination == selectedDestination &&
        other.explicitLocaleOverride == explicitLocaleOverride;
  }

  @override
  int get hashCode =>
      Object.hash(selectedDestination, explicitLocaleOverride);
}

/// Route-backed presentation Cubit for the root shell (`T014`, `T026`).
///
/// Reflects the active primary branch and optional presentation-only locale
/// override without storing preferences or embedding domain business rules.
@lazySingleton
class ShellCubit extends Cubit<ShellState> {
  ShellCubit() : super(const ShellState());

  void syncDestinationFromRoute(ShellDestination destination) {
    if (state.selectedDestination != destination) {
      emit(state.copyWith(selectedDestination: destination));
    }
  }

  void setLocaleOverride(Locale? locale) {
    if (locale == null) {
      emit(state.copyWith(clearLocaleOverride: true));
    } else {
      emit(
        state.copyWith(
          explicitLocaleOverride: ActiveLocaleResolver.resolve(
            explicitOverride: locale,
          ),
        ),
      );
    }
  }

  /// Resets shell destination and presentation overrides before a new account
  /// scope is activated (`T017`, `SL02-FR-008`–`011`).
  void resetForAccountTransition() {
    emit(const ShellState());
  }
}
