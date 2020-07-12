import 'package:buudeli/util/style1.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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

  Widget loginButton() => Container(
      width: 250.0,
      child: RaisedButton(
        color: Style1().littleGray,
        onPressed: () {},
        child: Text(
          'Login',
          style: TextStyle(color: Colors.black),
        ),
      ));

  Widget userform() => Container(
        width: 250.0,
        height: 50.0,
        child: TextField(
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
