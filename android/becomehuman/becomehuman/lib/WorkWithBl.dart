import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';
import 'dart:convert';

class WorkWithBl {
  static int clientID = 0;
  BluetoothConnection connection;
  String databuffer = "";
  bool isConnecting = true;

  bool get isConnected => connection != null && connection.isConnected;
  bool isDisconnecting = false;

  void init(BluetoothDevice server) {
    BluetoothConnection.toAddress(server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      isConnecting = false;
      isDisconnecting = false;
      connection.input.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  void destroy() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }
    String dataString = String.fromCharCodes(buffer);
    databuffer += dataString;
  }

  String getMessage() {
    String buffer = databuffer;
    databuffer = '';
    return buffer;
  }

  void sendMessage(String text) async {
    print("sended by bluetooth"+text);
    text = text.trim();
    if (isConnected) {
      if (text.length > 0) {
        try {
          connection.output.add(utf8.encode(text + "\r\n"));
          await connection.output.allSent;
        } catch (e) {
          // Ignore error, but notify state
          print("Error message send");
        }
      }
    } else {
      print("not connected");
    }
  }

  void sendRawText(String text) async {
    text = text.trim();
    if (isConnected) {
      if (text.length > 0) {
        try {
          connection.output.add(utf8.encode(text));
          await connection.output.allSent;
        } catch (e) {
          // Ignore error, but notify state
          print("Error message send");
        }
      }
    } else {
      print("not connected");
    }
  }

  void sendByte(List<int> g) async {
    var list = new Uint8List.fromList(g);

    if (isConnected) {
      try {
        connection.output.add(list);
        await connection.output.allSent;
      } catch (e) {
        // Ignore error, but notify state
        print("Error message send");
      }
    } else {
      print("not connected");
    }
  }
}
