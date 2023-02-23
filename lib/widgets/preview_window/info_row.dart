import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';

import '/utils/globals.dart';
import '/widgets/preview_window/upload_widget.dart';

class InfoRow extends StatefulWidget {
  final ValueChanged<List<XFile>> onChanged;

  const InfoRow({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<InfoRow> createState() => _InfoRowState();
}

class _InfoRowState extends State<InfoRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Container(
              height: importedFilesList.isEmpty ? 0 : 44,
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UploadWidget(
                      text: 'Select A Different Image',
                      onlyButton: true,
                      onChanged: (files) {
                        widget.onChanged(files);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              importedFilesList.clear();
                              widget.onChanged(importedFilesList);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 6.0,
                              backgroundColor: Colors.grey[800],
                              foregroundColor: Colors.grey[200],
                              textStyle: const TextStyle(color: Colors.white)),
                          child: Text("Clear Image")),
                    ),
                  ])),
        )
      ],
    );
  }
}
