library preview_window;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'package:path/path.dart' as p;

import '/utils/image_extensions.dart';
import '/utils/globals.dart';

import '/widgets/preview_window/info_row.dart';
import '/widgets/preview_window/preview_workspace.dart';

class PreviewWindow extends StatefulWidget {
  const PreviewWindow({
    Key? key,
  }) : super(key: key);

  _PreviewWindowState createState() => _PreviewWindowState();
}

class _PreviewWindowState extends State<PreviewWindow> {
  void _setFileList(List<XFile> files) async {
    if (files.isEmpty) {
      setState(() {});
      return;
    }

    for (final file in files) {
      // If file extension is supported
      try {
        final extension = supportedExtensions.firstWhere(
            (e) => e.string == p.extension(file.path).toLowerCase());
      } on StateError catch (e) {
        debugPrint('StateError: ${e.message}');
        return;
      }
      setState(() {
        if (importedFilesList.isEmpty) {
          importedFilesList.add(file);
        } else {
          importedFilesList[0] = file;
        }

        int indexOfDot = file.path.lastIndexOf(".");
        int indexOfLastSlash = file.path.lastIndexOf(Platform.pathSeparator);

        String filePathWithoutExtension = file.path.substring(0, indexOfDot);
        String filePathWithoutFileName =
            filePathWithoutExtension.substring(0, indexOfLastSlash + 1);
        String fileName =
            filePathWithoutExtension.substring(indexOfLastSlash + 1);
        String extension = file.path.substring(indexOfDot);

        config.put('imagePath', filePathWithoutFileName);
        config.put('imageName', fileName);
        config.put('extension', Extension(extension));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: PreviewWorkspace(
            width: double.infinity,
            onChanged: (files) {
              _setFileList(files);
            },
          ),
        ),
        InfoRow(
          onChanged: (files) {
            _setFileList(files);
          },
        ),
      ],
    );
  }
}
