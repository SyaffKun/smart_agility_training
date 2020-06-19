import 'package:flutter/material.dart';

class DeviceStatus extends StatelessWidget {
  DeviceStatus({
    @required this.onPress,
    @required this.colour,
    @required this.time,
    @required this.voltage,
    this.image,
  });

  final Function onPress;
  final Color colour;
  final double time;
  final double voltage;
  final AssetImage image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colour,
      ),
      child: Column(
        children: <Widget>[
          FlatButton(
            onPressed: onPress,
            child: Image(
              image: image == null ? AssetImage("images/device.png") : image,
            ),
          ),
          Text('Battery : ' + voltage.toString() + 'V'),
          Text(time.toString() + 'ms'),
        ],
      ),
    );
  }
}