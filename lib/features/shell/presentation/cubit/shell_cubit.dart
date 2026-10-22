import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:streak_up/core/localization/active_locale_resolver.dart';

/// Immutable presentation state for the root shell.
@immutable
class ShellState {
  const ShellState({this.explicitLocaleOverride});

  final Locale? explicitLocaleOverride;

  ShellState copyWith({
    Locale? explicitLocaleOverride,
    bool clearLocaleOverride = false,
  }) {
    return ShellState(
      explicitLocaleOverride: clearLocaleOverride
          ? null
          : (explicitLocaleOverride ?? this.explicitLocaleOverride),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShellState &&
        other.explicitLocaleOverride == explicitLocaleOverride;
  }

  @override
  int get hashCode => explicitLocaleOverride.hashCode;
}

/// Presentation-only locale input for the shell.
/// Navigation state belongs exclusively to GoRouter.
@lazySingleton
class ShellCubit extends Cubit<ShellState> {
  ShellCubit() : super(const ShellState());

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

  /// Resets presentation overrides before a new account
  /// scope is activated.
  void resetForAccountTransition() {
    emit(const ShellState());
  }

  @override
  @disposeMethod
  Future<void> close() => super.close();
}
