import 'package:flutter/material.dart';

class SwitchWidget extends StatefulWidget {
  final String _title;
  final ValueChanged<bool> onChanged;
  bool value;
  @override
  SwitchWidget({
    Key? key,
    required title,
    required this.value,
    required this.onChanged,
  })  : _title = title,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0, bottom: 8.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget._title,
            ),
            Switch(
                value: widget.value,
                onChanged: (checkValue) {
                  debugPrint('value : $widget.value ');
                  setState(() {
                    widget.value = checkValue;
                  });
                  widget.onChanged(widget.value);
                }),
          ]),
    );
  }
}
