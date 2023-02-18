library waifu_gui.shell_adaptor;

import 'dart:io';
import 'package:waifu_gui/utils/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';

import 'package:waifu_gui/utils/globals.dart';

Future<bool> waifuExeExists() async {
  final String waifuExePath = '$directory\\upscaler\\waifu2x-ncnn-vulkan.exe';
  debugPrint('waifuExePath: $waifuExePath');
  return File(waifuExePath).exists();
}

void upscale() async {
  var shell = Shell();

  bool exeExists = await waifuExeExists();
  if (!exeExists) {
    showErrorFlushbar(
        duration: 3,
        text:
            'Waifu2x-ncnn-vulkan.exe not found at \n $directory\\upscaler\\waifu2x-ncnn-vulkan.exe');
    return;
  }
  showInfoFlushbar(text: 'Running.');
  await shell.run(shellCommand());
  showInfoFlushbar(
      text: 'Done. Output to ${outputPath(importedFilesList[0].path)}');
}

String shellCommand() {
  final String exeDirectory = '$directory\\upscaler\\waifu2x-ncnn-vulkan.exe';
  late final String outputFileName;
  final bool listEmpty = importedFilesList.isEmpty;
  if (!listEmpty) {
    outputFileName = outputPath(importedFilesList[0].path);
  }
  return '$exeDirectory -i ${listEmpty ? '' : importedFilesList[0].path} -o ${listEmpty ? '' : outputFileName} -n ${fileConfig.noise} -s ${fileConfig.scale} ${fileConfig.tta ? '-x' : ''}';
}

String outputPath(String filePath) {
  int indexOfDot = filePath.lastIndexOf(".");
  String fileNameWithoutExtension = filePath.substring(0, indexOfDot);
  return "$fileNameWithoutExtension-output${fileConfig.extension.string}";
}
// remove the extension from a input file path
