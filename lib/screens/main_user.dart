import 'dart:convert';
import 'dart:io';
import 'package:buudeli/model/user_model.dart';
import 'package:buudeli/util/logout_process.dart';
import 'package:buudeli/util/my_constant.dart';
import 'package:buudeli/util/style1.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainUser extends StatefulWidget {
  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  String nameUser;
  List<UserModel> userModels = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
    readShopList();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('name');
    });
  }

  Future<Null> readShopList() async {
    String url =
        "${Myconstant().domain}/Buudeli/getDataUserWhereType.php?isAdd=true&usertype=Owner";
    await Dio().get(url).then((value) {
      var res = jsonDecode(value.data);
      for (var map in res) {
        UserModel model = UserModel.fromJson(map);
        
        String nameShop = model.nameShop;
        if (nameShop.isNotEmpty) {
          print('${model.nameShop}');
          setState(() {
          userModels.add(model);
        });
        } else {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameUser == null ? 'Main User' : '$nameUser login'),
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
      decoration: Style1().myBoxDeco('user.jpg'),
      currentAccountPicture: Style1().showlogo(),
      accountName: Text('$nameUser', style: TextStyle(color: Colors.amber)),
      accountEmail:
          Text('Welcome to our service', style: TextStyle(color: Colors.amber)),
    );
  }
}
