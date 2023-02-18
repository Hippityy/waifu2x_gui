library waifu_gui.shell_adaptor;

import 'package:flutter/rendering.dart';
import 'package:waifu_gui/utils/flushbar_helper.dart';
import 'package:process_run/shell.dart';

import 'package:waifu_gui/utils/waifu_2x_updater.dart';
import 'package:waifu_gui/utils/globals.dart';

void upscale() async {
  if (!waifuExeExists) {
    showErrorFlushbar(
        duration: 3,
        text:
            'Waifu2x-ncnn-vulkan.exe not found at \n $directory\\upscaler\\waifu2x-ncnn-vulkan.exe');
    return;
  }
  if (importedFilesList.isEmpty) {
    showErrorFlushbar(text: 'No image files to upscale');
    return;
  }

  showInfoFlushbar(text: 'Running.');

  var shell = Shell();
  await shell.run(shellCommand());
  showInfoFlushbar(
      text: 'Done. Output to ${outputPath(importedFilesList[0].path)}');
}

String shellCommand() {
  late final String outputFileName;
  final bool listEmpty = importedFilesList.isEmpty;
  if (!listEmpty) {
    outputFileName = outputPath(importedFilesList[0].path);
  }
  return '${config.exePath} -i ${listEmpty ? '' : importedFilesList[0].path} -o ${listEmpty ? '' : outputFileName} -n ${fileConfig.noise} -s ${fileConfig.scale} ${fileConfig.tta ? '-x' : ''}';
}

String outputPath(String filePath) {
  int indexOfDot = filePath.lastIndexOf(".");
  String fileNameWithoutExtension = filePath.substring(0, indexOfDot);
  return "$fileNameWithoutExtension-output${fileConfig.extension.string}";
}
// remove the extension from a input file path
