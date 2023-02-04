library preview_window;

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:cross_file/cross_file.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';
import 'package:waifu_gui/utils/file_config.dart';

import 'package:waifu_gui/utils/image_extensions.dart';
import 'package:waifu_gui/utils/imported_files.dart';
import 'package:waifu_gui/utils/globals.dart';

import 'preview_window/info_row.dart';
import 'preview_window/upload_widget.dart';

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
        final extension = supportedExtensions
            .firstWhere((e) => e.string == p.extension(file.path));
      } on StateError catch (e) {
        debugPrint(e.message);
        return;
      }
      setState(() {
        if (importedFilesList.isEmpty) {
          importedFilesList.add(file);
        } else {
          importedFilesList[0] = file;
        }

        int indexOfDot = file.path.lastIndexOf(".");
        int indexOfLastSlash = file.path.lastIndexOf("\\");

        String filePathWithoutExtension = file.path.substring(0, indexOfDot);
        String filePathWithoutFileName =
            filePathWithoutExtension.substring(0, indexOfLastSlash + 1);
        String fileName =
            filePathWithoutExtension.substring(indexOfLastSlash + 1);
        String extension = file.path.substring(indexOfDot);

        // debug print extension value
        //debugPrint('extension: $extension');
        fileConfig.output_path = filePathWithoutFileName;
        fileConfig.output_name = fileName;
        fileConfig.extension = Extension(extension);
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

class PreviewWorkspace extends StatefulWidget {
  final double height;
  final double width;
  final ValueChanged<List<XFile>> onChanged;

  const PreviewWorkspace({
    Key? key,
    required this.onChanged,
    this.height = 100,
    this.width = 100,
  }) : super(key: key);

  @override
  _PreviewWorkspaceState createState() => _PreviewWorkspaceState();
}

class _PreviewWorkspaceState extends State<PreviewWorkspace> {
  bool _dragging = false;
  Offset? offset;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
        onDragDone: (detail) async {
          setState(() {
            widget.onChanged(detail.files);
          });
        },
        onDragUpdated: (details) {
          setState(() {
            offset = details.localPosition;
          });
        },
        onDragEntered: (detail) {
          setState(() {
            _dragging = true;
            offset = detail.localPosition;
          });
        },
        onDragExited: (detail) {
          setState(() {
            _dragging = false;
            offset = null;
          });
        },
        child: Stack(
          children: [
            Positioned.fill(
                child: Container(
              color: const Color(0xff333333),
            )),
            if (importedFilesList.isNotEmpty)
              Center(
                  child: Image.file(
                File(importedFilesList[0].path),
                errorBuilder: (context, error, stackTrace) =>
                    Text(error.toString()),
              )),
            Positioned.fill(
              child: Container(
                color: _dragging
                    ? const Color(0x88252526)
                    : const Color(0x00333333),
              ),
            ),
            if (importedFilesList.isEmpty)
              Center(child: UploadWidget(
                onChanged: (files) {
                  widget.onChanged(files);
                  setState(() {});
                },
              ))
          ],
        ));
  }
}
