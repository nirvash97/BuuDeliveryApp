import 'package:buudeli/screens/signIn.dart';
import 'package:buudeli/screens/signup.dart';
import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: showDrawer(),
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHeader(),
            signInMenu(),
            signUpMenu(),
          ],
        ),
      );

  ListTile signInMenu() => ListTile(
    leading: Icon(Icons.android),
    title: Text('Sign In'),onTap: () {
      Navigator.pop(context);
      MaterialPageRoute route = MaterialPageRoute(builder: (value) => SignIn());
      Navigator.push(context,route);

    },
    );

  ListTile signUpMenu() => ListTile(
    leading: Icon(Icons.android),
    title: Text('Sign Up'),onTap: () {
      Navigator.pop(context);
      MaterialPageRoute route = MaterialPageRoute(builder: (value) => SignUp());
      Navigator.push(context,route);

    },
    );

  UserAccountsDrawerHeader showHeader() {
    return UserAccountsDrawerHeader(
        accountName: Text('Guest'), 
        accountEmail: Text('Please Sign-In'),
        
        );
  }
}
