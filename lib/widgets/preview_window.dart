library preview_window;

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:cross_file/cross_file.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';

import '../utils/image_extensions.dart';
import '../utils/imported_files.dart';

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
    for (final file in files) {
      // If file extension is supported
      try {
        final extension = supportedExtensions
            .firstWhere((e) => e.extension == p.extension(file.path));
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
