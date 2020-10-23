import 'package:buudeli/util/logout_process.dart';
import 'package:buudeli/util/style1.dart';
import 'package:buudeli/widget/rider_history.dart';
import 'package:buudeli/widget/rider_jobs_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainRider extends StatefulWidget {
  @override
  _MainRiderState createState() => _MainRiderState();
}

class _MainRiderState extends State<MainRider> {
  String nameRider;
  Widget currentWidget = RiderJobsList();

  @override
  void initState() {
    // TODO: implement initState
    findUser();
    super.initState();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameRider = preferences.getString('name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main Rider'), actions: <Widget>[
        IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => logoutProcess(context))
      ]),
      drawer: showDrawer(),
      body: currentWidget,
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHeader(),
            jobsMenu(),
            jobsDone(),
          ],
        ),
      );

  ListTile jobsMenu() => ListTile(
        leading: Icon(Icons.directions_bike),
        title: Text('รายการงานที่รับได้'),
        subtitle: Text('รายการงานที่พร้อมให้คุณบริการ !!!'),
        onTap: () {
          setState(() {
            currentWidget = RiderJobsList();
          });
          Navigator.pop(context);
        },
      );

  ListTile jobsDone() => ListTile(
        leading: Icon(Icons.attach_money),
        title: Text('ประวัติงานที่สำเร็จ'),
        subtitle: Text('ประวัติงานของคุณอยู่ที่นี่แล้ว !!'),
        onTap: () {
          setState(() {
            currentWidget = RiderHistory();
          });
          Navigator.pop(context);
        },
      );


  UserAccountsDrawerHeader showHeader() {
    return UserAccountsDrawerHeader(
      decoration: Style1().myBoxDeco('rider2.jpg'),
      currentAccountPicture: Style1().showlogo(),
      accountName: Text('$nameRider', style: TextStyle(color: Colors.amber)),
      accountEmail: Text('Welcome back !! Are you ready to work ?',
          style: TextStyle(color: Colors.amber)),
    );
  }
}
