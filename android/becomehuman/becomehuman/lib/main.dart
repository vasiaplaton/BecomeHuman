import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/services.dart';
import './SelectBondedDevicePage.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:toast/toast.dart';
import 'PaletteValuePickerPage.dart';
import 'dart:async';
import 'WorkWithBl.dart';
import 'MoodShow.dart';
import 'PulsePicker.dart';
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(), // main page
    );
  }
}

class Tab1 extends StatefulWidget {

  @override
  _Tab1State createState() {
    return new _Tab1State();
  }
}

class _Tab1State extends State<Tab1> {
  WorkWithBl blAdapter;
  List<int> pulseBorders = new List(3);
  Timer blTimer;
  void sendBorders(){
    String str;
    for(int i=0; i<pulseBorders.length; i++){
      str = pulseBorders[i].toString();
      while(str.length < 3) str = '0' + str;
      str = "p" + i.toString() + str;
      blAdapter.sendMessage(str);
    }
  }

  @override
  void initState() {
    super.initState();
    this.setState(() {
      blAdapter = MyHomePage.blAdapter;
    });
    pulseBorders = [60, 90, 120];
    sendBorders();
    blTimer = Timer.periodic(new Duration(milliseconds: 4000), (Timer t) {
      sendBorders();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PulsePicker(
              onNumberChanged: (newValue) {
                pulseBorders[0] = newValue;
              },
              string:  " Low stress below\n Medium stress from",
              initialValue: pulseBorders[0],
            ),
            Divider(),
            PulsePicker(
              onNumberChanged: (newValue) {
                pulseBorders[1] = newValue;
              },
              string:  " Medium stress below\n High stress from",
              initialValue: pulseBorders[1],
            ),
            Divider(),
            PulsePicker(
              onNumberChanged: (newValue) {
                pulseBorders[2] = newValue;
              },
              string:  " High stress below\n Extremely high stress from",
              initialValue: pulseBorders[2],
            ),
            Divider(),
            FlatButton(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Open graph", style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic)),
                  Icon(Icons.show_chart)
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Graph()),
                );
                },
            ),
          ],
        )
        ),
    );
  }
  @override
  void dispose(){
    super.dispose();
    blTimer.cancel();

  }
}

class Graph extends StatefulWidget {

  @override
  _GraphState createState() {
    return new _GraphState();
  }
}

class GraphPainter extends CustomPainter {

  List<int> values;
  GraphPainter({this.values});

  @override
  void paint(Canvas canvas, Size size) {
    int max = 1;
    //Float32List points = [0, ];
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.square;
    for(int i=0; i<values.length; i++){
      if(values[i] > max) max = values[i];
    }
    TextSpan span = new TextSpan(style: new TextStyle(color: Colors.red[800], fontSize: 50, height: 1), text: max.toString());
    TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, new Offset(5.0, 5.0));

    double coefVal = size.height/max;
    Offset buffer = Offset(0, size.height);
    for(int i=0; i< _GraphState.numValues; i++){
      var stop = Offset(i*2*size.width/(_GraphState.numValues*2), size.height-values[i]*coefVal);
      canvas.drawLine(buffer, stop, paint);
      buffer = stop;

    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _GraphState extends State<Graph> {
  static int numValues = 500;
  List<int> values = new List(numValues);
  WorkWithBl blAdapter;
  Random rand = Random(40);
  static double height  = 400.0;
  Timer timer;
  @override
  void initState() {
    super.initState();
    this.setState(() {
      blAdapter = MyHomePage.blAdapter;
    });
    blAdapter.sendMessage("g1");
    print("g1");
    values = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 24, 37,  53, 55, 59, 58, 49, 46,
      37, 28, 25, 15, 10, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 2, 0, 2, 2, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 11, 22, 40, 49, 56,
      62, 56, 54, 50, 40, 37, 26, 18, 16, 6, 4, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 9, 5, 6, 8, 2, 4, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 11, 20,
      38, 49, 55, 61, 56, 53, 50, 39, 35, 29, 20, 19, 11, 7, 7, 0, 1, 1, 0, 1, 0, 0, 3,
      0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1, 1, 4, 0, 0, 1, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 6, 20, 31, 48, 55, 57, 60, 53, 49, 44, 34, 31, 22, 15, 14, 6, 4, 4,
      0, 0, 0, 0, 1, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 2,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 17, 31, 41, 54, 56, 57, 57, 48, 44, 39, 29,
      26, 18, 11, 11, 3, 2, 2, 0, 0, 0];
    timer = Timer.periodic(new Duration(milliseconds: 1000), (Timer t) {
      String stringToParse = "";
      /*for(int i=0; i<50; i++) {
        stringToParse += rand.nextInt(30).toString();
        stringToParse += "\r\n";
      }*/
      stringToParse = blAdapter.getMessage();
        List<int> listInt = [];
        String intString = "";
        for (int i = 0; i < stringToParse.length; i++) {
          if (stringToParse[i] == '\r' || stringToParse == '\n') {
            if (intString != "") {
              listInt.add(int.parse(intString));
            }
            intString = "";
          }
          else {
            intString += stringToParse[i];
          }
        }
      for(int i=0; i < (numValues-listInt.length); i++){
        values[i] = values[i+listInt.length];
      }
      int counter = 0;
      for(int i=(numValues-listInt.length); i<numValues; i++){
        values[i] = listInt[counter];
        counter++;
      }
      setState(() {
      });
    });
  }
  @override
  void dispose(){
    super.dispose();
    blAdapter.sendMessage("g0");
    print("g0");
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Graph'),
        ),
      body:  Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [

                    Padding(
                      padding: EdgeInsets.all(8.0),
                     child: CustomPaint(
                        painter: new GraphPainter(values: values),
                        child: Container(
                          height: height,

                        ),
                      ),
                    ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: []
              )
            ]

        )
    );
  }
}

class Tab2 extends StatefulWidget {
  @override
  _Tab2State createState() {
    return new _Tab2State();
  }
}

class _Tab2State extends State<Tab2> {
  final effect = new ValueNotifier(0);
  WorkWithBl blAdapter;
  List<bool> settings = [];
  Timer blTimer;
  bool effectChanged = true;
  bool settingsChanged = true;
  bool effectChangeDir = false;
  @override
  void initState() {
     super.initState();
     blAdapter = MyHomePage.blAdapter;
     blTimer = Timer.periodic(new Duration(milliseconds: 200), (Timer t) {
       if(effectChanged){
         effectChanged = false;
         if(effectChangeDir) blAdapter.sendMessage("e+");
         else blAdapter.sendMessage("e-");
       }
       String blSettings = "s";
       if(settingsChanged && settings.isNotEmpty){
         settingsChanged = false;
         for(int i=0; i<settings.length; i++){
           print(settings[i].toString());
           if(settings[i]) blSettings += "1";
           else blSettings += "0";
         }
         blAdapter.sendMessage(blSettings);
       }
       String blAccepted = blAdapter.getMessage();
       if(blAccepted.isNotEmpty){
         if(blAccepted[0] == "e") {
           int effectAccepted = int.parse(blAccepted[1]);
           effect.value = effectAccepted;
         }
       }
     });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: effect,
        builder: (context, value, child) {
         return  MoodShow(effect: effect, buttons: true,
           onEffectChanged: (value) {
           if(value == -1){
             effectChangeDir = false;
             print("prev mode");
           }
           if(value == 1){
             effectChangeDir = true;
             print("next mode");
           }
           effectChanged = true;
          },
           onSettingChanged: (settingsAccepted) {
           settingsChanged = true;
           settings = settingsAccepted;
         },
          );
        },
      ),
    );
  }
  @override
  void dispose() {
    blTimer.cancel();
    super.dispose();
  }

}
class Tab3 extends StatelessWidget {
  HSVColor color = HSVColor.fromColor(Colors.white);
  bool colorchanged = false;

  Tab3() {
    var blAdapter = MyHomePage.blAdapter;
    print("On start, Tab3");
    Timer.periodic(new Duration(milliseconds: 200), (timer) {
      if (colorchanged) {
        Color rgbcolor = color.toColor();
        String str = "red:" +
            rgbcolor.red.toString() +
            "green:" +
            rgbcolor.green.toString() +
            "blue:" +
            rgbcolor.blue.toString();
        blAdapter.sendRawText("c");
        blAdapter.sendByte([rgbcolor.red, rgbcolor.green, rgbcolor.blue]);
        blAdapter.sendRawText("\r\n");
        print(str);
        colorchanged = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PaletteValuePickerPage(
        startingcolor: color,
        onColorChanged: (newColor) {
          color = newColor;
          colorchanged = true;
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  static var blAdapter = new WorkWithBl();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Pulse "),
                        Icon(Icons.favorite),
                      ],
                    ),
                  ),
                  Tab(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Mood "),
                        Icon(Icons.tag_faces),
                      ],
                    ),
                  ),
                  Tab(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Color "),
                        Icon(Icons.color_lens),
                      ],
                    ),
                  ),
                ],
              ),
              title: Text('Tabs Demo'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.settings_bluetooth),
                  tooltip: 'Settings',
                  onPressed: () async {
                    final BluetoothDevice selectedDevice =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return SelectBondedDevicePage(
                              checkAvailability: false);
                        },
                      ),
                    );

                    if (selectedDevice != null) {
                      print('Connect -> selected ' + selectedDevice.address);
                      blAdapter.destroy();
                      blAdapter.init(selectedDevice);
                    } else {
                      print('Connect -> no device selected');
                    }
                  },
                ),
              ],
            ),
            body: TabBarView(
              children: [
                Tab1(),
                Tab2(),
                Tab3(),
              ],
            ),
          );
        }),
      ),
    );
  }
}
