import 'package:flutter/material.dart';

class CheckboxWidget extends StatefulWidget {
  final String _title;
  final ValueChanged<bool> onChanged;
  bool value;
  @override
  CheckboxWidget({
    Key? key,
    required title,
    required this.value,
    required this.onChanged,
  })  : _title = title,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0, bottom: 8.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget._title,
                style: const TextStyle(
                    color: Color.fromARGB(255, 238, 238, 238), fontSize: 16)),
            Checkbox(
                value: widget.value,
                onChanged: (checkValue) {
                  if (checkValue != null) {
                    debugPrint('value : $widget.value ');
                    setState(() {
                      widget.value = checkValue;
                    });
                    widget.onChanged(widget.value);
                  }
                }),
          ]),
    );
  }
}
