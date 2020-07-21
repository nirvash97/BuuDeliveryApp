import 'package:flutter/material.dart';

class AddShopInfo extends StatefulWidget {
  @override
  _AddShopInfoState createState() => _AddShopInfoState();
}

class _AddShopInfoState extends State<AddShopInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Shop Information')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            nameForm(),
            addressForm(),
            phoneForm(),
            groupImage(),
          ],
        ),
      ),
    );
  }

  Row groupImage() {
    return Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(icon: Icon(Icons.add_a_photo , size: 30.0,), onPressed: () {}),
        Container(
          width: 200.0,
          child: Image.asset('images/t1.png'),
        ), IconButton(icon: Icon(Icons.add_photo_alternate ,size: 36.0,), onPressed: (){},)
      ],
    );
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0),
            width: 250.0,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'ชื่อของร้านค้า',
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0),
            width: 250.0,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'ที่อยู่ของร้านค้า',
                prefixIcon: Icon(Icons.account_box),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}

Widget phoneForm() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10.0 , bottom: 10.0),
          width: 250.0,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'เบอร์โทรของร้านค้า',
              prefixIcon: Icon(Icons.account_box),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
