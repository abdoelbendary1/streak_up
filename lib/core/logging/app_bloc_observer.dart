import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_up/core/logging/app_logger.dart';

///
/// Logs only runtime type names and lifecycle stages. Raw state instances,
/// event payloads, and exception messages are never serialized to logs.
@lazySingleton
class AppBlocObserver extends BlocObserver {
  AppBlocObserver(this._logger);

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
