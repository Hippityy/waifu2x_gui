import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingSlider extends StatefulWidget {
  final List<int> _intervals;
  final String _title;
  final ValueChanged<int> onChanged;
  @override
  const SettingSlider({
    Key? key,
    required title,
    required intervals,
    required this.onChanged,
  })  : _intervals = intervals,
        _title = title,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingSliderState();
}

class _SettingSliderState extends State<SettingSlider> {
  int _value = 1;
  @override
  Widget build(BuildContext context) {
    final int intervals = widget._intervals.length;

    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget._title,
                style: const TextStyle(
                    color: Color.fromARGB(255, 238, 238, 238), fontSize: 16)),
            Slider(
                value: _value.toDouble(),
                min: 0,
                max: intervals.toDouble() - 1,
                divisions: intervals - 1,
                onChanged: (double value) {
                  setState(() {
                    _value = value.toInt();
                  });
                  widget.onChanged(widget._intervals[_value]);
                },
                label: widget._intervals[_value].toString()),
          ]),
    );
  }
}
