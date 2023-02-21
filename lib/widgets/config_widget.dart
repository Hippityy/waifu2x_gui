import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

import '/utils/globals.dart';
import '/utils/shell_adaptor.dart';
import '/widgets/config_widgets/checkbox_widget.dart';
import '/widgets/config_widgets/slider_widget.dart';

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
        if (kDebugMode)
          Text(
              '$directory${Platform.pathSeparator}upscaler${Platform.pathSeparator}waifu2x-ncnn-vulkan.exe'),
        SliderWidget(
          title: "De-noise",
          intervals: const [-1, 0, 1, 2, 3],
          onChanged: (int value) => config.put('noise', value),
        ),
        SliderWidget(
          title: "Scale",
          intervals: const [1, 2, 4, 8, 16, 32],
          onChanged: (int value) => config.put('scale', value),
        ),
        CheckboxWidget(
          title: "TTA",
          value: config.get('tta', defaultValue: false),
          onChanged: (bool value) {
            config.put('tta', value);
          },
        ),
        CheckboxWidget(
          title: "GPU Acceleration",
          value: config.get('hardware_accel', defaultValue: true),
          onChanged: (bool value) {
            config.put('hardware_accel', value);
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
