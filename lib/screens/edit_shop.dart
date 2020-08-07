import 'package:flutter/material.dart';

class EditShopInfo extends StatefulWidget {
  @override
  _EditShopInfoState createState() => _EditShopInfoState();
}

class _EditShopInfoState extends State<EditShopInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('แก้ไขรายละเอียดร้าน'),),
    );
  }
}