import 'package:flutter/material.dart';

class SliderWidget extends StatefulWidget {
  final List<int> _intervals;
  final String _title;
  final ValueChanged<int> onChanged;
  @override
  const SliderWidget({
    Key? key,
    required title,
    required intervals,
    required this.onChanged,
  })  : _intervals = intervals,
        _title = title,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
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
            Text(
              widget._title,
            ),
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
