import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(initializerName: 'init', preferRelativeImports: true)
Future<GetIt> configureDependencies({GetIt? instance}) async =>
    (instance ?? getIt).init();
