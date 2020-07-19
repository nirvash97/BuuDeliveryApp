import 'package:buudeli/util/logout_process.dart';
import 'package:flutter/material.dart';
class MainRider extends StatefulWidget {
  @override
  _MainRiderState createState() => _MainRiderState();
}

class _MainRiderState extends State<MainRider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: Text('Main Rider'),
      actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app), onPressed: () => logoutProcess())
        ]
      ),
    );
  }
}