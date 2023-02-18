library waifu_gui.waifu_2x_updater;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:context_holder/context_holder.dart';
import 'package:waifu_gui/utils/config.dart';

import '/utils/globals.dart';
import '/utils/flushbar_helper.dart';

Future<bool> updateWaifuExeExists() async {
  waifuExeExists = await File(config.exePath).exists();
  return waifuExeExists;
}

void InstallWaifuExe() async {
  const url =
      'https://api.github.com/repos/nihui/waifu2x-ncnn-vulkan/releases/latest';
  showInfoFlushbar(text: 'Installing Waifu2x from $url');
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final assets = data['assets'] as List<dynamic>;
    final asset =
        assets.firstWhere((asset) => asset['name'].endsWith('windows.zip'));
    final assetUrl = asset['browser_download_url'] as String;

    final headResponse = await http.head(Uri.parse(assetUrl));
    if (headResponse.statusCode == 200) {
      final packageSize = headResponse.headers['content-length'];
      debugPrint('Package size: $packageSize bytes');
    }

    // Use the asset URL to download the package release file
    showInfoFlushbar(text: 'Downloading');
    final packageResponse = await http.get(Uri.parse(assetUrl));

    debugPrint('status Code: ${packageResponse.statusCode}');
    if (packageResponse.statusCode == 200) {
      showInfoFlushbar(text: 'Extracting');
      debugPrint('Extracting');
      final bytes = packageResponse.bodyBytes;

      // Extract the package contents to a directory
      final archive = ZipDecoder().decodeBytes(bytes);
      final parentDirs = <String>{};

      final upscalerDirectory = Directory('$directory\\upscaler\\');
      if (!upscalerDirectory.existsSync()) {
        upscalerDirectory.createSync(recursive: true);
      }

      for (final file in archive) {
        final filePath =
            '${upscalerDirectory.path}${Platform.pathSeparator}${file.name}';
        if (file.isFile) {
          final data = file.content as List<int>;
          final outFile = File(filePath);
          outFile.createSync(recursive: true);
          outFile.writeAsBytesSync(data);
        } else {
          final outDir = Directory(filePath);
          outDir.createSync(recursive: true);
          parentDirs.add(outDir.parent.path);
        }
      }
      final topDirName =
          parentDirs.toList().last.split(Platform.pathSeparator).last;
      config.exePath =
          '$directory\\upscaler\\$topDirName\\waifu2x-ncnn-vulkan.exe';
      saveConfig(config);
      loadConfig();
      debugPrint('Top directory name: $topDirName');
    }
    showInfoFlushbar(text: 'Done');
  } else {
    showErrorFlushbar(
        text: 'Failed to download Waifu2x: ${response.reasonPhrase}');
  }
}
