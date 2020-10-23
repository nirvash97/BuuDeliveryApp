import 'package:buudeli/screens/main_rider.dart';
import 'package:buudeli/screens/main_shop.dart';
import 'package:buudeli/screens/main_user.dart';
import 'package:buudeli/screens/signIn.dart';
import 'package:buudeli/screens/signup.dart';
import 'package:buudeli/util/dialog.dart';
import 'package:buudeli/util/my_constant.dart';
import 'package:buudeli/util/style1.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  String message;
  String finalToken;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";

  @override
  void initState() {
    message = "No message.";

    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOS = IOSInitializationSettings(
        // ignore: missing_return
        onDidReceiveLocalNotification: (id, title, body, payload) {
      print("onDidReceiveLocalNotification called.");
    });
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) {
      // when user tap on notification.
      print("onSelectNotification called.");
      setState(() {
        message = payload;
      });
    });
    // TODO: implement initState
    super.initState();
    initFirebaseMessaging();
    checkPreferences();
  }

  sendNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('10000',
        'FLUTTER_NOTIFICATION_CHANNEL', 'FLUTTER_NOTIFICATION_CHANNEL_DETAIL',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      111,
      '$title',
      '$body',
      platformChannelSpecifics,
    );
  }

  void initFirebaseMessaging() {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        Map mapNotification = message["notification"];
        String title = mapNotification["title"];
        String body = mapNotification["body"];
        sendNotification(title, body);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      
      setState(() {
        finalToken = token;
      });
      print("Final Token : $finalToken");
    });
  }

  Future<Null> checkPreferences() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String checkType = preferences.getString('usertype');
      String idLogin = preferences.getString('id');
      print('ID =====> $idLogin');
      if (idLogin != null || idLogin.isNotEmpty) {
        String url =
            "${Myconstant().domain}/Buudeli/editTokenWhereID.php?isAdd=true&id=$idLogin&Token=$finalToken";
        await Dio().get(url).then(
            (value) => print("===========Token Has been updated============"));
      }

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
      decoration: Style1().myBoxDeco('guest.jpg'),
      currentAccountPicture: Style1().showlogo(),
      accountName: Text('Guest', style: TextStyle(color: Colors.amber)),
      accountEmail:
          Text('Please Sign-In', style: TextStyle(color: Colors.amber)),
    );
  }
}
