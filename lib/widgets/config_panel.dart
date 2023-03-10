import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

import '/utils/globals.dart';
import '/utils/shell_adaptor.dart';
import '/widgets/config_widgets/checkbox_widget.dart';
import '/widgets/config_widgets/slider_widget.dart';

class ConfigPanel extends StatelessWidget {
  const ConfigPanel({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      width: 0.25 * width,
      height: double.infinity,
      constraints: const BoxConstraints(
        minWidth: 280,
        maxWidth: 400,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).dialogBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
        SwitchWidget(
          title: "TTA",
          value: config.get('tta', defaultValue: false),
          onChanged: (bool value) {
            config.put('tta', value);
          },
        ),
        SwitchWidget(
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
          style: ElevatedButton.styleFrom(elevation: 6.0),
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Text('Upscale'),
          ),
        )
      ]),
    );
  }
}
