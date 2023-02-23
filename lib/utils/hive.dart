import 'dart:io';

import 'package:hive/hive.dart';

import '/utils/globals.dart';
import '/utils/image_extensions.dart';

Future<void> loadConfig() async {
  config = await Hive.openBox('config');
  checkKey(
    key: 'exePath',
    defaultValue:
        '$directory${Platform.pathSeparator}upscaler${Platform.pathSeparator}waifu2x-ncnn-vulkan.exe',
  );
  checkKey(
    key: 'noise',
    defaultValue: 0,
  );
  checkKey(
    key: 'scale',
    defaultValue: 2,
  );
  checkKey(
    key: 'tta',
    defaultValue: false,
  );
  checkKey(
    key: 'extension',
    defaultValue: Extension('.png'),
  );
  checkKey(
    key: 'overrrideExtension',
    defaultValue: Extension('.png'),
  );
  checkKey(
    key: 'hardware_accel',
    defaultValue: true,
  );
}

void checkKey({required String key, required var defaultValue}) {
  if (config.get(key) == null) {
    config.put(key, defaultValue);
  }
}
