library waifu_gui.waifu_2x_updater;

import 'dart:convert';
import 'dart:io';

import 'package:context_holder/context_holder.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';
import 'package:another_flushbar/flushbar.dart';

import '/utils/globals.dart';
import '/utils/flushbar_helper.dart';

Future<bool> updateWaifuExeExists() async {
  waifuExeExists = await File(config.get('exePath')).exists();
  return waifuExeExists;
}

void InstallWaifuExe(TickerProvider ticker) async {
  const url =
      'https://api.github.com/repos/nihui/waifu2x-ncnn-vulkan/releases/latest';
  showInfoFlushbar(text: 'Installing Waifu2x from $url');
  // --- LATEST RELEASE --- //
  final assetUrl = await getLatestRelease(url);
  if (assetUrl == null) {
    showErrorFlushbar(text: 'Could not fetch latest waifu2x release');
    return;
  }
  // --- HEADER INFO --- //
  final headResponse = await http.head(Uri.parse(assetUrl));
  if (headResponse.statusCode != 200) {
    showErrorFlushbar(
        text: 'Failed to get file header: ${headResponse.reasonPhrase}');
    return;
  }
  final int packageSize =
      int.parse(headResponse.headers['content-length'] ?? '1');
  debugPrint('Package size: $packageSize bytes');

  // --- DOWNLOAD PACKAGE --- //
  final request = http.Request('GET', Uri.parse(assetUrl));
  final http.StreamedResponse packageResponse =
      await http.Client().send(request);
  final int packageLength = packageResponse.contentLength ?? 1;

  AnimationController controller = AnimationController(
    duration: const Duration(seconds: 2),
    upperBound: 1.0,
    lowerBound: 0.0,
    vsync: ticker,
  )..forward();

  List<int> bytes = [];

  Flushbar flushbar = Flushbar(
    message: 'Downloading',
    icon: Icon(
      Icons.info_outline,
      size: 20.0,
      color: Theme.of(ContextHolder.currentContext).colorScheme.primary,
    ),
    margin: const EdgeInsets.all(8),
    maxWidth: 350,
    duration: null,
    boxShadows: [
      BoxShadow(
        color: Color(0x000).withOpacity(0.4),
        offset: Offset(0, 0),
        blurRadius: 3.0,
      )
    ],
    showProgressIndicator: true,
    progressIndicatorController: controller,
    progressIndicatorBackgroundColor: Colors.grey,
    leftBarIndicatorColor:
        Theme.of(ContextHolder.currentContext).colorScheme.primary,
  )..show(ContextHolder.currentContext);

  packageResponse.stream.listen(
    (List<int> value) {
      bytes.addAll(value);
      controller.animateTo(bytes.length / packageLength);
    },
    onDone: () async {
      // --- EXTRACTION --- //
      flushbar.dismiss();

      // Extract the package contents to a directory
      final archive = ZipDecoder().decodeBytes(bytes);
      final parentDirs = <String>{};

      final upscalerDirectory = Directory(
          '$directory${Platform.pathSeparator}upscaler${Platform.pathSeparator}');
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
      config.put('exePath',
          '$directory${Platform.pathSeparator}upscaler${Platform.pathSeparator}$topDirName${Platform.pathSeparator}waifu2x-ncnn-vulkan.exe');
      debugPrint('Top directory name: $topDirName');
      showInfoFlushbar(text: 'Done');
    },
    onError: (e) {
      showErrorFlushbar(text: 'Failed to download package: ${e}');
    },
    cancelOnError: true,
  );
}

Future<String?> getLatestRelease(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode != 200) {
    showErrorFlushbar(
        text: 'Failed to get latest release: ${response.reasonPhrase}');
    return null;
  }
  final data = json.decode(response.body);
  final assets = data['assets'] as List<dynamic>;
  final asset =
      assets.firstWhere((asset) => asset['name'].endsWith('windows.zip'));
  return asset['browser_download_url'] as String;
}
