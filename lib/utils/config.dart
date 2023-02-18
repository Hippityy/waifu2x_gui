import 'dart:convert';
import 'dart:io';

import '/utils/globals.dart';

import '/utils/image_extensions.dart';

class Config {
  String exePath = '$directory\\upscaler\\waifu2x-ncnn-vulkan.exe';

  Config([path]) {
    if (path != null) {
      exePath = path;
    }
  }

  Config.fromJson(Map<String, dynamic> json) : exePath = json['exePath'];

  Map<String, dynamic> toJson() {
    return {'exePath': exePath};
  }
}

//Saves config to config.json
Future<void> saveConfig(Config config) async {
  final file = File('config.json');
  await file.writeAsString(
    json.encode(config),
    flush: true,
  );
}

//Loads config.json into global config variable
Future<void> loadConfig() async {
  final file = File('config.json');
  if (await file.exists()) {
    final contents = await file.readAsString();
    try {
      final jsonMap = json.decode(contents);
      config = Config()..exePath = jsonMap['exePath'];
    } catch (e) {
      print(e);
      saveConfig(Config());
      loadConfig();
    }
  } else {
    // If file doesn't exist, save default config to file and recursive load.
    saveConfig(Config());
    loadConfig();
  }
}
