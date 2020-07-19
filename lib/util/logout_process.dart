import 'dart:io';

import 'package:buudeli/screens/index.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Null> logoutProcess(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.clear();
  // exit(0);
  MaterialPageRoute route = MaterialPageRoute(
    builder: (context) => Index(),
  );
  Navigator.pushAndRemoveUntil(context, route, (route) => false);
}
