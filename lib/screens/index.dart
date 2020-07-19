import 'package:buudeli/screens/main_rider.dart';
import 'package:buudeli/screens/main_shop.dart';
import 'package:buudeli/screens/main_user.dart';
import 'package:buudeli/screens/signIn.dart';
import 'package:buudeli/screens/signup.dart';
import 'package:buudeli/util/dialog.dart';
import 'package:buudeli/util/style1.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPreferences();
  }

  Future<Null> checkPreferences() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String checkType = preferences.getString('usertype');
      if (checkType != null && checkType.isNotEmpty) {
        if (checkType == 'User') {
          print('$checkType Role Access');
          routetoservice(MainUser());
        } else if (checkType == 'Owner') {
          routetoservice(MainShop());
        } else if (checkType == 'Rider') {
          routetoservice(MainRider());
        } else {
          normaldialog(context, 'Usertype Error !!');
        }
      } else {
        print('Error checkType = $checkType');
      }
    } catch (e) {
      print('Check Preference Error');
    }
  }

  void routetoservice(Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

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
        leading: Icon(Icons.vpn_key),
        title: Text('Sign In'),
        onTap: () {
          Navigator.pop(context);
          MaterialPageRoute route =
              MaterialPageRoute(builder: (value) => SignIn());
          Navigator.push(context, route);
        },
      );

  ListTile signUpMenu() => ListTile(
        leading: Icon(Icons.group_add),
        title: Text('Sign Up'),
        onTap: () {
          Navigator.pop(context);
          MaterialPageRoute route =
              MaterialPageRoute(builder: (value) => SignUp());
          Navigator.push(context, route);
        },
      );

  UserAccountsDrawerHeader showHeader() {
    return UserAccountsDrawerHeader(
      decoration: Style1().myBoxDeco('guest.jpg') ,
      currentAccountPicture: Style1().showlogo(),
      accountName: Text('Guest', style: TextStyle(color: Colors.amber)),
      accountEmail: Text('Please Sign-In', style: TextStyle(color: Colors.amber)),
    );
  }
}
