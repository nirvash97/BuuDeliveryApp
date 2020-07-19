import 'package:buudeli/util/logout_process.dart';
import 'package:buudeli/util/style1.dart';
import 'package:flutter/material.dart';

class MainRider extends StatefulWidget {
  @override
  _MainRiderState createState() => _MainRiderState();
}

class _MainRiderState extends State<MainRider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main Rider'), actions: <Widget>[
        IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => logoutProcess(context))
      ]),
      drawer: showDrawer(),
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHeader(),
          ],
        ),
      );

  UserAccountsDrawerHeader showHeader() {
    return UserAccountsDrawerHeader(
      decoration:Style1().myBoxDeco('rider.jpg') ,
      currentAccountPicture: Style1().showlogo(),
      accountName: Text('Guest' , style: TextStyle(color: Colors.amber)),
      accountEmail: Text('Please Sign-In', style: TextStyle(color: Colors.amber)),
    );
  }
}
