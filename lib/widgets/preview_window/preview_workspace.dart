import 'dart:io';
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:cross_file/cross_file.dart';

import '/utils/globals.dart';

import '/widgets/preview_window/upload_widget.dart';

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
