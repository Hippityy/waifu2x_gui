library waifu_gui.shell_adaptor;

import 'dart:io';

import 'package:process_run/shell.dart';
import 'package:open_filex/open_filex.dart';

import 'package:waifu_gui/utils/globals.dart';
import 'package:waifu_gui/utils/image_extensions.dart';
import 'package:waifu_gui/utils/flushbar_helper.dart';

void upscale() async {
  if (!waifuExeExists) {
    showErrorFlushbar(
        duration: 3,
        text:
            'Waifu2x-ncnn-vulkan.exe not found at \n $directory${Platform.pathSeparator}upscaler${Platform.pathSeparator}waifu2x-ncnn-vulkan.exe \n Try restarting to auto-download the exe.');
    return;
  }
  if (importedFilesList.isEmpty) {
    showErrorFlushbar(text: 'No image files to upscale');
    return;
  }

  showInfoFlushbar(text: 'Running.');

  var shell = Shell();
  await shell.run(shellCommand());
  showButtonFlushbar(
    text: 'Done. Output to ${outputPath()}',
    buttonText: 'Open Folder',
    onPressed: () => OpenFilex.open(config.get('imagePath')),
  );
}

String shellCommand() {
  late final String outputFileName;
  final bool listEmpty = importedFilesList.isEmpty;
  if (!listEmpty) {
    outputFileName = outputPath();
  }
  return '${config.get('exePath')} -i ${listEmpty ? '' : importedFilesList[0].path} -o ${listEmpty ? '' : outputFileName} -n ${config.get('noise')} -s ${config.get('scale')} ${config.get('tta') ? '-x' : ''}';
}

String outputPath({bool directoryPath = false}) {
  Extension extension = config.get('extension');
  String dirPath = config.get('imagePath');
  if (directoryPath) {
    return dirPath;
  }
  return "$dirPath${config.get('imageName')}-output${extension.valid ? extension.string : '.png'}";
}
