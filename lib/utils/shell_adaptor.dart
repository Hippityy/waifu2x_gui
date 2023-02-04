library waifu_gui.shell_adaptor;

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:process_run/shell.dart';

import 'package:waifu_gui/utils/file_config.dart';
import 'package:waifu_gui/utils/imported_files.dart';

String directory = Directory.current.path;

Future<bool> waifuExeExists() async {
  directory = Directory.current.path;
  final String waifuExePath = '$directory\\upscaler\\waifu2x-ncnn-vulkan.exe';
  debugPrint('waifuExePath: $waifuExePath');
  return File(waifuExePath).exists();
}

void upscale() async {
  var shell = Shell();
  bool exeExists = await waifuExeExists();
  if (!exeExists) {
    debugPrint("exe not founds");
    return;
  }
  await shell.run(shellCommand());
  debugPrint('Done!');
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
  String extension = filePath.substring(indexOfDot);
  return "$fileNameWithoutExtension-output${fileConfig.extension.string}";
}
// remove the extension from a input file path

