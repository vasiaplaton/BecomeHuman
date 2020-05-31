import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
class PulsePicker extends StatefulWidget {
  final ValueChanged<int> onNumberChanged;
  final String string;
  final int initialValue;
  PulsePicker({this.onNumberChanged, this.string, this.initialValue});
  @override
  _PulsePickerState createState() {
    return new _PulsePickerState(string: string, currentValue: initialValue);
  }
}

class _PulsePickerState extends State<PulsePicker> {
  String string;
  int currentValue = 1;
  _PulsePickerState({this.string, this.currentValue});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(string, style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
        Expanded(child: Divider(),),
        ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 130),
            child:
            new NumberPicker.integer(
                initialValue: currentValue,
                minValue: 0,
                maxValue: 230,
                onChanged: (newValue){
                  setState(() => currentValue = newValue);
                  widget.onNumberChanged(newValue);
                }
            )),
      ],

    );
  }
}