import "package:flutter/material.dart";
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
 
class PaletteValuePickerPage extends StatefulWidget {
  final ValueChanged<HSVColor> onColorChanged;
  HSVColor startingcolor;

  PaletteValuePickerPage({Key key, this.onColorChanged, this.startingcolor}) : super(key: key);
  @override
  PaletteValuePickerPageState createState() => new PaletteValuePickerPageState(bcolor: startingcolor);
}

class PaletteValuePickerPageState extends State<PaletteValuePickerPage> {
 
  HSVColor color =new HSVColor.fromColor(Colors.white);
  PaletteValuePickerPageState({HSVColor bcolor}){
    if (bcolor != null){
      color = bcolor;
    }
  }
  void onChanged(HSVColor value) => this.color=value;

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Container(
        width: 500,
        child: new Card(
          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0.0))),
          elevation: 2.0,
          child: new Padding(
            padding: const EdgeInsets.all(10),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new FloatingActionButton(
                  onPressed: (){},
                  backgroundColor: this.color.toColor(),
                ),
                new Divider(),

                ///---------------------------------
                new PaletteValuePicker(
                  color: this.color,
                  onChanged: (value) { super.setState(()=>this.onChanged(value));
                  widget.onColorChanged(this.color);

                  },
                )
                ///---------------------------------

              ]
            )
          )
        )
      )
    );
  }
}
  