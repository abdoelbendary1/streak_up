import 'dart:convert';
import 'dart:io';
import 'dart:ffi';
import 'package:isar_community/isar.dart';

Future<void> initializeHabitTestStorage() async {
  final configFile = File('.dart_tool/package_config.json');
  final config =
      jsonDecode(await configFile.readAsString()) as Map<String, dynamic>;
  final packages = config['packages'] as List<dynamic>;
  final package = packages.cast<Map<String, dynamic>>().singleWhere(
    (p) => p['name'] == 'isar_community_flutter_libs',
  );
  final packageUri = configFile.absolute.uri.resolve(
    package['rootUri'] as String,
  );
  final root = Uri.parse('${packageUri.toString()}/');
  if (Platform.isWindows) {
    await Isar.initializeIsarCore(
      libraries: {
        Abi.windowsX64: root.resolve('windows/libisar.dll').toFilePath(),
      },
    );
  } else if (Platform.isMacOS) {
    await Isar.initializeIsarCore(
      libraries: {
        Abi.current(): root.resolve('macos/libisar.dylib').toFilePath(),
      },
    );
  } else {
    await Isar.initializeIsarCore(download: true);
  }
}
