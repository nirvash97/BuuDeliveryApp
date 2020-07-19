import 'dart:io';
import 'package:buudeli/util/logout_process.dart';
import 'package:buudeli/util/style1.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainUser extends StatefulWidget {
  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
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
        title: Text(nameUser == null ? 'Main User' : '$nameUser login'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app), onPressed: () => logoutProcess(context))
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
      decoration: Style1().myBoxDeco('user.jpg'),
      currentAccountPicture: Style1().showlogo(),
      accountName: Text('Guest', style: TextStyle(color: Colors.amber)),
      accountEmail: Text('Please Sign-In', style: TextStyle(color: Colors.amber)),
    );
  }

  
}
