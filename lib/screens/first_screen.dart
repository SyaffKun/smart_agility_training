import 'package:flutter/material.dart';
import 'package:smart_agility_training/screens/welcome_screen.dart';
import 'package:smart_agility_training/backend/sign_in.dart';

class FirstScreen extends StatelessWidget {
  static const String id = 'first_Screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue[100], Colors.blue[400]],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                  "data:image/jpeg;base64,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",
                ),
                radius: 60,
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 40),
              Text(
                'NAME',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              Text(
                "name",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'EMAIL',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              Text(
                "email",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              RaisedButton(
                onPressed: () {
                  signOutGoogle();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    return WelcomeScreen();
                  }), ModalRoute.withName('/'));
                },
                color: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
