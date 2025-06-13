import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PathUtil {
  static final String _configRelativePath = 'config';

  static String? _basePath;
  static String? _configPath;

  static Future<String> getBasePath() async {
    if (_basePath != null) {
      return _basePath!;
    }

    final direction = await getApplicationSupportDirectory();
    _basePath = direction.path;
    return direction.path;
  }

  static Future<String> getConfigPath() async {
    if (_configPath != null) {
      return _configPath!;
    }

    final basePath = await getBasePath();

    final configDir = Directory('$basePath/$_configRelativePath');
    if (!await configDir.exists()) {
      await configDir.create(recursive: true);
    }

    _configPath = configDir.path;
    return configDir.path;
  }
}
