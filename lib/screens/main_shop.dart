import 'dart:io';

import 'package:buudeli/util/logout_process.dart';
import 'package:buudeli/util/style1.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainShop extends StatefulWidget {
  @override
  _MainShopState createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  String nameUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameUser == null ? 'Main Shop' : '$nameUser Shop login'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => logoutProcess(context))
        ],
      ),
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
      decoration: Style1().myBoxDeco('shop.jpg'),
      currentAccountPicture: Style1().showlogo(),
      accountName: Text('Guest', style: TextStyle(color: Colors.amber)),
      accountEmail: Text('Please Sign-In', style: TextStyle(color: Colors.amber)),
    );
  }
}
