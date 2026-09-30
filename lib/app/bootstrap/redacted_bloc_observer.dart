import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:streak_up/app/bootstrap/app_logger.dart';

/// Privacy-safe global [BlocObserver] (Architecture A-05, A-09; SL01-FR-017).
///
/// Logs only runtime type names and lifecycle stages. Raw state instances,
/// event payloads, and exception messages are never serialized to logs.
@lazySingleton
class RedactedBlocObserver extends BlocObserver {
  RedactedBlocObserver(this._logger);

  final AppLogger _logger;

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    _logger.info(
      'bloc.lifecycle',
      metadata: <String, Object?>{
        'lifecycle': 'onCreate',
        'blocType': bloc.runtimeType.toString(),
      },
    );
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    _logger.info(
      'bloc.event',
      metadata: <String, Object?>{
        'blocType': bloc.runtimeType.toString(),
        'eventType': event.runtimeType.toString(),
      },
    );
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    _logger.info(
      'bloc.change',
      metadata: <String, Object?>{
        'blocType': bloc.runtimeType.toString(),
        'currentStateType': change.currentState.runtimeType.toString(),
        'nextStateType': change.nextState.runtimeType.toString(),
      },
    );
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    _logger.info(
      'bloc.transition',
      metadata: <String, Object?>{
        'blocType': bloc.runtimeType.toString(),
        'eventType': transition.event.runtimeType.toString(),
        'currentStateType': transition.currentState.runtimeType.toString(),
        'nextStateType': transition.nextState.runtimeType.toString(),
      },
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _logger.error(
      'bloc.error',
      metadata: <String, Object?>{
        'blocType': bloc.runtimeType.toString(),
        'errorType': error.runtimeType.toString(),
      },
    );
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    _logger.info(
      'bloc.lifecycle',
      metadata: <String, Object?>{
        'lifecycle': 'onClose',
        'blocType': bloc.runtimeType.toString(),
      },
    );
    super.onClose(bloc);
  }
}
