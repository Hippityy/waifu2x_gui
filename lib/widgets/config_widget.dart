import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:waifu_gui/utils/shell_adaptor.dart';
import 'package:waifu_gui/widgets/config_widgets/checkbox_widget.dart';
import 'package:waifu_gui/widgets/config_widgets/slider_widget.dart';
import 'package:waifu_gui/utils/globals.dart';

class ConfigWidget extends StatelessWidget {
  const ConfigWidget({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.25 * width,
      height: double.infinity,
      constraints: const BoxConstraints(
        minWidth: 280,
        maxWidth: 400,
      ),
      decoration: const BoxDecoration(
        color: Color(0xff252526),
      ),
      child: Column(children: [
        if (kDebugMode) Text('${directory}\\upscaler\\waifu2x-ncnn-vulkan.exe'),
        SliderWidget(
          title: "De-noise",
          intervals: const [-1, 0, 1, 2, 3],
          onChanged: (int value) => {fileConfig.noise = value},
        ),
        SliderWidget(
          title: "Scale",
          intervals: const [1, 2, 4, 8, 16, 32],
          onChanged: (int value) => {fileConfig.scale = value},
        ),
        CheckboxWidget(
          title: "TTA",
          value: fileConfig.tta,
          onChanged: (bool value) {
            fileConfig.tta = value;
            debugPrint('TTA: $value | ${fileConfig.tta}');
          },
        ),
        ElevatedButton(
          onPressed: () {
            upscale();
            debugPrint(shellCommand());
          },
          style: ElevatedButton.styleFrom(
              elevation: 6.0, textStyle: const TextStyle(color: Colors.white)),
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Text('Upscale'),
          ),
        )
      ]),
    );
  }
}
