import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
class ShapesPainter extends CustomPainter {
  Color lineColor;
  bool spaces;
  int effect;
  ShapesPainter({this.lineColor, this.spaces, this.effect});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    double radius = 50.0;
    // set the color property of the paint
    paint.color = lineColor;
    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Offset(size.width / 2, size.height / 2);
    var rect = Rect.fromPoints(
        Offset(size.width / 2 - 5, size.height / 2 + radius.toInt() - 10),
        Offset(size.width / 2 + 5, size.height / 2 + radius.toInt() + 10));
    var rect1 = Rect.fromPoints(
        Offset(size.width / 2 - 5, size.height / 2 - radius.toInt() - 10),
        Offset(size.width / 2 + 5, size.height / 2 - radius.toInt() + 10));
    // draw the circle on centre of canvas having radius 75.0
    //canvas.drawCircle(center, 75.0, paint);
    canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = paint.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5.0);
    if (spaces && effect!=5) {
      canvas.drawRect(rect, Paint()..color = Colors.white);
      canvas.drawRect(rect1, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}


class MoodShow extends StatefulWidget {
  final ValueChanged<int> onEffectChanged;
  final ValueChanged<List<bool>> onSettingChanged;
  final ValueListenable<int> effect;
  final bool buttons;
  MoodShow({this.effect, this.buttons, this.onEffectChanged, this.onSettingChanged});
  @override
  _MoodShowState createState() {
    return new _MoodShowState(effect: effect, buttons: buttons);
  }
}

class _MoodShowState extends State<MoodShow> {
  Color lineColor;
  Timer timer;
  int brightness = 255;
  bool spaces = true;
  bool dir = true;
  bool dir1 = true;
  bool fade = true;
  ValueListenable<int> effect;
  bool buttons;
  List<bool> settings = List(2); // 0 -fade 1 - spaces
  _MoodShowState({this.effect, this.buttons});

  void initState() {
    super.initState();
    settings = [true, true];
    lineColor = Color.fromARGB(255, 255, 0, 0);
    timer = Timer.periodic(new Duration(milliseconds: 100), (Timer t) {
      Color effectColor = Color.fromARGB(0, 255, 255, 255);
      if (effect.value == 0) {
        effectColor = Color.fromARGB(255, 0, 0, 255);
      }
      if (effect.value == 1 || effect.value == 2) {
        effectColor = Colors.amber;
      }
      if (effect.value == 3 || effect.value == 4) {
        effectColor = Color.fromARGB(255, 255, 0, 0);
      }
      if (effect.value == 5) {
        if (dir1) {
          dir1 = false;
          effectColor = Color.fromARGB(255, 255, 0, 0);
        }
        else {
          dir1 = true;
          effectColor = Color.fromARGB(0, 255, 0, 0);
        }
      }
      if (settings[0] && effect.value != 5) {
        lineColor = effectColor.withAlpha(brightness);
      } else {
        lineColor = effectColor;
      }
      if (dir) {
        brightness += 15;
        if (brightness >= 255) {
          dir = false;
        }
      } else {
        brightness -= 15;
        if (brightness <= 40) {
          dir = true;
        }
      }
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Center(
        child:
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buttons ? IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: (){
                        widget.onEffectChanged(-1);
                      },
                    ) : Divider(),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CustomPaint(
                        painter: new ShapesPainter(lineColor: lineColor, spaces: settings[1], effect: effect.value),
                        child: Container(
                          height: 140,
                          width: 200,
                        ),
                      ),
                    ),
                    buttons ? IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: (){
                        widget.onEffectChanged(1);
                      },
                    ) : Divider(),
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.autorenew),
                      onPressed: (){
                        setState(() {
                          settings[1] = !settings[1];
                          widget.onSettingChanged(settings);

                        });
                      },
                    ),
                    Container(
                      height: 30,
                      width: 1,
                    ),
                    IconButton(
                      icon: Icon(Icons.timelapse),
                      onPressed: (){
                        setState(() {
                          settings[0] = !settings[0];
                          widget.onSettingChanged(settings);
                        });
                      },
                    ),
                  ]
              )
            ]

        )
    );
  }
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
