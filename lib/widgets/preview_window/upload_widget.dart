import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

import '../../utils/image_extensions.dart';

class UploadWidget extends StatefulWidget {
  final bool onlyButton;
  final String text;
  const UploadWidget({
    Key? key,
    required this.onChanged,
    this.onlyButton = false,
    this.text = 'Select Image',
  }) : super(key: key);

  final ValueChanged<List<XFile>> onChanged;

  @override
  State<StatefulWidget> createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget> {
  late List<PlatformFile>? _platformFiles;
  FileType _supportedTypes = FileType.image;
  List<String> extensionList = [];

  late final Future<List<Extension>> futureSupportedExtensions;
  @override
  void initState() {
    super.initState();
    futureSupportedExtensions = _getSupportedExtensions();
  }

  Future<List<Extension>> _getSupportedExtensions() async {
    String json = await rootBundle.loadString('assets/extensions.json');
    supportedExtensions =
        (jsonDecode(json) as List).map((e) => Extension.fromJson(e)).toList();
    return supportedExtensions;
  }

  void _pickFiles() async {
    try {
      _platformFiles = (await FilePicker.platform.pickFiles(
        type: _supportedTypes,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: extensionList.isNotEmpty
            ? extensionList.map((e) => e.substring(1)).toList()
            : ['png'],
      ))
          ?.files;
    } on PlatformException catch (e) {
      debugPrint('Unsupported operation ${e.toString()}');
    } catch (e) {
      debugPrint(e.toString());
    }
    if (!mounted) return;
    setState(() {
      if (_platformFiles != null) {
        //Returns selected files in a List<XFiles> using path
        widget.onChanged(_platformFiles!.map((e) => XFile(e.path!)).toList());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              debugPrint('Upload Pressed');
              _pickFiles();
            },
            // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
            style: ElevatedButton.styleFrom(
                elevation: 6.0,
                textStyle: const TextStyle(color: Colors.white)),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(widget.text),
            ),
          ),
        ),
        if (!widget.onlyButton)
          FutureBuilder<List<Extension>>(
              future: futureSupportedExtensions,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Extension>> snapshot) {
                if (snapshot.hasData) {
                  _supportedTypes = FileType.custom;
                  extensionList =
                      snapshot.data!.map((e) => e.extension).toList();
                  return Text(
                      style: const TextStyle(color: Colors.white),
                      'Supported image formats: ${extensionList.join(" ")}');
                } else {
                  return const Text('Loading supported image formats');
                }
              }),
      ],
    );
  }
}
