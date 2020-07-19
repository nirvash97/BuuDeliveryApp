import 'dart:io';

import 'package:buudeli/util/logout_process.dart';
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
              icon: Icon(Icons.exit_to_app), onPressed: () => logoutProcess())
        ],
      ),
    );
  }
}
