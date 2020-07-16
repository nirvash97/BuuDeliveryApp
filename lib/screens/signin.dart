import 'dart:convert';

import 'package:buudeli/model/user_model.dart';
import 'package:buudeli/screens/main_rider.dart';
import 'package:buudeli/screens/main_shop.dart';
import 'package:buudeli/screens/main_user.dart';
import 'package:buudeli/util/dialog.dart';
import 'package:buudeli/util/style1.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //Field
  String username, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign-in'),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Style1().showlogo(),
              Style1().mysizebox(),
              Style1().showname('Buu Delivery'),
              Style1().mysizebox(),
              userform(),
              Style1().mysizebox(),
              passwordform(),
              Style1().mysizebox(),
              loginButton(),

            ],
          ),
        )));
  }

  Future<Null> authen() async {
    String url= 'http://192.168.56.1/Buudeli/getUser.php?isAdd=true&User=$username';
    try {
      Response response = await Dio().get(url) ;
      print('Res = $response');

      var result = json.decode(response.data);
      print('result = $result');
      for (var map in result) {
        UserModel userModel = UserModel.fromJson(map);
        if (password == userModel.password) {
          String usertype = userModel.usertype;
          if(usertype == 'User'){
            routetoService(MainUser() , userModel);
          }
          else if (usertype == 'Owner'){
            routetoService(MainShop(), userModel);
          }
          else if (usertype == 'Rider'){
            routetoService(MainRider(), userModel);
          }
          else {
            normaldialog(context, 'Please Try again');
          }
        } else {
          normaldialog(context, 'Password is incorrect Try again');
        }
      }

    } catch (e) {
    }
  }

  Future<Null> routetoService(Widget myWidget, UserModel userModel) async{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('id', userModel.id);
      preferences.setString('usertype', userModel.usertype);
      preferences.setString('name', userModel.name);



     MaterialPageRoute route = MaterialPageRoute(builder: (context) => myWidget,);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Widget loginButton() => Container(
      width: 250.0,
      child: RaisedButton(
        color: Style1().littleGray,
        onPressed: () {
          if (username == null || username.isEmpty || password==null || password.isEmpty) {
            normaldialog(context, 'Please Input Username and Password');
          } else {
            authen();
          }
        },
        child: Text(
          'Login',
          style: TextStyle(color: Colors.black),
        ),
      ));

  Widget userform() => Container(
        width: 250.0,
        height: 50.0,
        child: TextField(
          onChanged: (value) => username = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.account_box, color: Style1().littleGray),
            labelStyle: TextStyle(color: Style1().littleGray),
            labelText: 'Username :',
            enabledBorder: OutlineInputBorder(
                borderSide: (BorderSide(color: Style1().goldAmber))),
            focusedBorder: OutlineInputBorder(
              borderSide: (BorderSide(color: Style1().goldAmber)),
            ),
          ),
        ),
      );

  Widget passwordform() => Container(
        width: 250.0,
        height: 50.0,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock, color: Style1().littleGray),
            labelStyle: TextStyle(color: Style1().littleGray),
            labelText: 'Password :',
            enabledBorder: OutlineInputBorder(
                borderSide: (BorderSide(color: Style1().goldAmber))),
            focusedBorder: OutlineInputBorder(
              borderSide: (BorderSide(color: Style1().goldAmber)),
            ),
          ),
        ),
      );
}
