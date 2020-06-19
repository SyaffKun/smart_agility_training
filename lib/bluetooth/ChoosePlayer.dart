import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:quiver/async.dart';
import 'package:smart_agility_training/components/rounded_button.dart';
import 'Device.dart';
import 'package:smart_agility_training/components/device_widget.dart';
import 'package:smart_agility_training/components/devicestatus_widget.dart';
import 'package:smart_agility_training/components/globals.dart' as globals;
import 'package:smart_agility_training/screens/countdown_screen.dart';

String rfidId = 'null';
bool trainingStart = false;
double countdown5s = 5;

Device n0 = Device();
Device n1 = Device();
Device n2 = Device();
Device n3 = Device();
Device n4 = Device();
Device n5 = Device();
Device n6 = Device();
Device n7 = Device();
Device n8 = Device();

bool isDisconnecting = false;

bool atMiddle = false;
String node2voltage = 'n/a';
String node2time = 'n/a';

BluetoothConnection connection;

bool isConnecting = true;
bool get isConnected => connection != null && connection.isConnected;

class ChoosePlayer extends StatefulWidget {
  final BluetoothDevice server;

  const ChoosePlayer({this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChoosePlayer> {
  static final clientID = 0;

  List<_Message> messages = List<_Message>();
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  var countdown;
  int actual;
  CountdownTimer countDownTimer;

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

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
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    //_timer.cancel();
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return trainingStart
        ? Scaffold(
            appBar: AppBar(
              title: (isConnecting
                  ? Text('Connecting to ' + widget.server.name + '...')
                  : isConnected
                      ? Text('Connected with ' + widget.server.name)
                      : Text('Disconnected with ' + widget.server.name)),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {
                        trainingStart = !trainingStart;
                      });
                    })
              ],
            ),
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: DeviceWidget(
                          onPress: () {
                            if (isConnected) {
                              _sendMessage('7');
                            }
                          },
                          colour: n7.colour,
                          time: n7.time,
                          voltage: n7.voltage,
                        ),
                      ),
                      Expanded(
                        child: DeviceWidget(
                          onPress: () {
                            if (isConnected) {
                              _sendMessage('8');
                            }
                          },
                          colour: n8.colour,
                          time: n8.time,
                          voltage: n8.voltage,
                        ),
                      ),
                      Expanded(
                        child: DeviceWidget(
                          onPress: () {
                            if (isConnected) {
                              _sendMessage('1');
                            }
                            n1.colour = Colors.green;
                          },
                          colour: n1.colour,
                          time: n1.time,
                          voltage: n1.voltage,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DeviceWidget(
                          onPress: () {
                            if (isConnected) {
                              _sendMessage('6');
                            }
                          },
                          colour: n6.colour,
                          time: n6.time,
                          voltage: n6.voltage,
                        ),
                      ),
                      Expanded(
                        child: DeviceWidget(
                          onPress: () {
                            if (isConnected) {
                              _sendMessage('0');
                            }
                            n0.colour = Colors.green;
                          },
                          colour: n0.colour,
                          time: n0.time,
                          voltage: n0.voltage,
                          image: AssetImage("images/master.png"),
                        ),
                      ),
                      Expanded(
                        child: DeviceWidget(
                          onPress: () {
                            if (isConnected) {
                              _sendMessage('2');
                            }
                            n2.colour = Colors.green;
                          },
                          colour: n2.colour,
                          time: n2.time,
                          voltage: n2.voltage,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DeviceWidget(
                          onPress: () {
                            if (isConnected) {
                              _sendMessage('5');
                            }
                          },
                          colour: n5.colour,
                          time: n5.time,
                          voltage: n5.voltage,
                        ),
                      ),
                      Expanded(
                        child: DeviceWidget(
                          onPress: () {
                            if (isConnected) {
                              _sendMessage('4');
                            }
                            n4.colour = Colors.green;
                          },
                          colour: n4.colour,
                          time: n4.time,
                          voltage: n4.voltage,
                        ),
                      ),
                      Expanded(
                        child: DeviceWidget(
                          onPress: () {
                            if (isConnected) {
                              _sendMessage('3');
                            }
                            n3.colour = Colors.green;
                          },
                          colour: n3.colour,
                          time: n3.time,
                          voltage: n3.voltage,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: (isConnecting
                  ? Text('Connecting to ' + widget.server.name + '...')
                  : isConnected
                      ? Text('Connected with ' + widget.server.name)
                      : Text('Disconnected with ' + widget.server.name)),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {
                        trainingStart = !trainingStart;
                      });
                    })
              ],
            ),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: DeviceStatus(
                          onPress: () {
                            if (isConnected) {
                              _sendMessage('7');
                            }
                          },
                          colour: n7.colour,
                          time: n7.time,
                          voltage: n7.voltage,
                        ),
                      ),
                      Expanded(
                        child: DeviceStatus(
                          onPress: () {
                            if (isConnected) {
                              _sendMessage('8');
                            }
                          },
                          colour: n8.colour,
                          time: n8.time,
                          voltage: n8.voltage,
                        ),
                      ),
                      Expanded(
                        child: DeviceStatus(
                          onPress: () {
                            if (isConnected) {
                              _sendMessage('1');
                            }
                            n1.colour = Colors.green;
                          },
                          colour: n1.colour,
                          time: n1.time,
                          voltage: n1.voltage,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DeviceStatus(
                          onPress: () {
                            if (isConnected) {
                              _sendMessage('6');
                            }
                          },
                          colour: n6.colour,
                          time: n6.time,
                          voltage: n6.voltage,
                        ),
                      ),
                      Expanded(
                        child: DeviceStatus(
                          onPress: () {
                            if (isConnected) {
                              _sendMessage('0');
                            }
                            n0.colour = Colors.green;
                          },
                          colour: n0.colour,
                          time: n0.time,
                          voltage: n0.voltage,
                          image: AssetImage("images/master.png"),
                        ),
                      ),
                      Expanded(
                        child: DeviceStatus(
                          onPress: () {
                            if (isConnected) {
                              _sendMessage('2');
                            }
                            n2.colour = Colors.green;
                          },
                          colour: n2.colour,
                          time: n2.time,
                          voltage: n2.voltage,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DeviceStatus(
                          onPress: () {
                            if (isConnected) {
                              _sendMessage('5');
                            }
                          },
                          colour: n5.colour,
                          time: n5.time,
                          voltage: n5.voltage,
                        ),
                      ),
                      Expanded(
                        child: DeviceStatus(
                          onPress: () {
                            if (isConnected) {
                              _sendMessage('4');
                            }
                            n4.colour = Colors.green;
                          },
                          colour: n4.colour,
                          time: n4.time,
                          voltage: n4.voltage,
                        ),
                      ),
                      Expanded(
                        child: DeviceStatus(
                          onPress: () {
                            if (isConnected) {
                              _sendMessage('3');
                            }
                            n3.colour = Colors.green;
                          },
                          colour: n3.colour,
                          time: n3.time,
                          voltage: n3.voltage,
                        ),
                      ),
                    ],
                  ),
                  RounndedButton(
                    title: 'Check Device Status',
                    colour: Colors.lightBlueAccent,
                    onPressed: () {
                      _sendMessage('c');
                      n0.colour = n1.colour = n2.colour = n3.colour =
                          n4.colour = n5.colour =
                              n6.colour = n7.colour = n8.colour = Colors.yellow;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Material(
                      elevation: 5.0,
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(30.0),
                      child: MaterialButton(
                        onPressed: () {
                          _sendMessage('r');
                          rfidId = 'null';
                          showAlertDialog(context);
                        },
                        minWidth: 200.0,
                        height: 70.0,
                        child: Text(
                          'Start Training',
                          style: TextStyle(
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  void _onDataReceived(Uint8List data) {
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    //print(buffer);
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

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);

    if (~index != 0) {
      // \r\n

      setState(() {
        String datafrommaster = backspacesCounter > 0
            ? _messageBuffer.substring(
                0, _messageBuffer.length - backspacesCounter)
            : _messageBuffer + dataString.substring(0, index);
        print(datafrommaster);

        if (datafrommaster.startsWith('\r\nMiddle')) {
          if (globals.countdown5sState == 'start') {
            globals.countdown5sState = 'running';
            Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CountDownTimer();
            }));
          }
          if (globals.countdown5sState == 'fail') {
            Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CountDownTimer();
            }));
          }
        }

        if (datafrommaster.startsWith('\r\nNotMiddle')) {
          if (globals.countdown5sState == 'running') {
            //Navigator.pop(context);
            Navigator.of(context).pop();
            globals.countdown5sState = 'start';
            print('failed');
            show5sStay(context);
          }
        }
        if (datafrommaster.startsWith('\r\nToken') && rfidId == 'null') {
          rfidId = 'Student A';
          Navigator.of(context).pop();
          n0.colour = n1.colour = n2.colour = n3.colour = n4.colour =
              n5.colour = n6.colour = n7.colour = n8.colour = Colors.white;
          globals.countdown5sState = 'start';
          trainingStart = true;
          show5sStay(context);
        }
        if (datafrommaster.startsWith('\r\nCARD') && rfidId == 'null') {
          rfidId = 'Student B';
          Navigator.of(context).pop();
          n0.colour = n1.colour = n2.colour = n3.colour = n4.colour =
              n5.colour = n6.colour = n7.colour = n8.colour = Colors.white;
          globals.countdown5sState = 'start';
          trainingStart = true;
          show5sStay(context);
        }
        if (datafrommaster.startsWith('\r\nN0V')) {
          n0.voltage = double.parse(datafrommaster.substring(5, 9));
        }
        if (datafrommaster.startsWith('\r\nN0T')) {
          n0.time = double.parse(datafrommaster.substring(5, 11));
          if (n0.time == 0) {
            n0.colour = Colors.green;
          } else {
            n0.colour = Colors.white;
          }
        }
        if (datafrommaster.startsWith('\r\nN1V')) {
          n1.voltage = double.parse(datafrommaster.substring(5, 9));
          print(n1.voltage);
        }
        if (datafrommaster.startsWith('\r\nN1T')) {
          n1.time = double.parse(datafrommaster.substring(5, 11));
          if (n1.time == 0) {
            n1.colour = Colors.green;
          } else {
            n1.colour = Colors.white;
          }
        }
        if (datafrommaster.startsWith('\r\nN2V')) {
          n2.voltage = double.parse(datafrommaster.substring(5, 9));
        }
        if (datafrommaster.startsWith('\r\nN2T')) {
          n2.time = double.parse(datafrommaster.substring(5, 11));
          if (n2.time == 0) {
            n2.colour = Colors.green;
          } else {
            n2.colour = Colors.white;
          }
        }
        if (datafrommaster.startsWith('\r\nN3V')) {
          n3.voltage = double.parse(datafrommaster.substring(5, 9));
        }
        if (datafrommaster.startsWith('\r\nN3T')) {
          n3.time = double.parse(datafrommaster.substring(5, 11));
          if (n3.time == 0) {
            n3.colour = Colors.green;
          } else {
            n3.colour = Colors.white;
          }
        }
        if (datafrommaster.startsWith('\r\nN4V')) {
          n4.voltage = double.parse(datafrommaster.substring(5, 9));
        }
        if (datafrommaster.startsWith('\r\nN4T')) {
          n4.time = double.parse(datafrommaster.substring(5, 11));
          if (n4.time == 0) {
            n4.colour = Colors.green;
          } else {
            n4.colour = Colors.white;
          }
        }
        if (datafrommaster.startsWith('\r\nN5V')) {
          n5.voltage = double.parse(datafrommaster.substring(5, 9));
        }
        if (datafrommaster.startsWith('\r\nN5T')) {
          n5.time = double.parse(datafrommaster.substring(5, 11));
        }
        if (datafrommaster.startsWith('\r\nN6V')) {
          n6.voltage = double.parse(datafrommaster.substring(5, 9));
        }
        if (datafrommaster.startsWith('\r\nN6T')) {
          n6.time = double.parse(datafrommaster.substring(5, 11));
        }
        if (datafrommaster.startsWith('\r\nN7V')) {
          n7.voltage = double.parse(datafrommaster.substring(5, 9));
        }
        if (datafrommaster.startsWith('\r\nN7T')) {
          n7.time = double.parse(datafrommaster.substring(5, 11));
        }
        if (datafrommaster.startsWith('\r\nN8V')) {
          n8.voltage = double.parse(datafrommaster.substring(5, 9));
        }
        if (datafrommaster.startsWith('\r\nN8T')) {
          n8.time = double.parse(datafrommaster.substring(5, 11));
        }

        if (datafrommaster == '\r\natMiddle') {
          atMiddle = true;
        }
        if (datafrommaster == '\r\nnotAtMiddle') {
          atMiddle = false;
        }

        messages.add(_Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index)));
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text + "\r\n"));
        await connection.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Scanning RFID"),
    content: Text("Approximate your card to the reader..."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

show5sStay(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Get Ready"),
    content: Text("Stay at middle for '$countdown5s' seconds"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
