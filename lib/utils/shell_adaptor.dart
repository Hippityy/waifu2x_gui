library waifu_gui.shell_adaptor;

import 'dart:io';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:context_holder/context_holder.dart';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:another_flushbar/flushbar.dart';

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
    showSnackBar(
        duration: 5,
        text:
            'Waifu2x-ncnn-vulkan.exe not found at \n $directory\\upscaler\\waifu2x-ncnn-vulkan.exe');
    return;
  }
  showSnackBar(text: 'Running.');
  await shell.run(shellCommand());
  showSnackBar(
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

void showSnackBar({required String text, int duration = 2}) {
  Flushbar flushbar = Flushbar(
    message: text,
    icon: const Icon(
      Icons.info_outline,
      size: 20.0,
      color: Colors.blue,
    ),
    margin: EdgeInsets.all(8),
    maxWidth: 350,
    duration: Duration(seconds: duration),
    boxShadows: [
      BoxShadow(
        color: Color(0x000).withOpacity(0.4),
        offset: Offset(0, 0),
        blurRadius: 3.0,
      )
    ],
    leftBarIndicatorColor: Colors.blue,
  )..show(ContextHolder.currentContext);
}
