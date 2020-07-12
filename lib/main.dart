import 'package:buudeli/screens/index.dart';
import 'package:flutter/material.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BuuDelivery',
      home: Index(),
    );
  }
}