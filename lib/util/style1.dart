import 'package:buudeli/screens/show_cart.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Style1 {
  Color goldAmber = Colors.amberAccent;
  Color littleGray = Colors.grey[400];
  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  SizedBox mysizebox() => SizedBox(
        width: 8.0,
        height: 10.0,
      );
  SizedBox adjustBox(double w, double h) => SizedBox(
        width: w,
        height: h,
      );

  Text showname(String title) => Text(title,
      style: TextStyle(
        fontSize: 24.0,
        color: Colors.amberAccent,
        fontWeight: FontWeight.bold,
      ));

  Text titleWidget(String title) => Text(title,
      style: TextStyle(
        fontSize: 14.0,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ));

  Text titleCustom(String title, double fontsize, var c, var fw) => Text(title,
      style: TextStyle(
        fontSize: fontsize,
        color: c,
        fontWeight: fw,
      ));

  Text foodmaintitle1(String title) => Text(title,
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ));

  Text foodmaintitle2(String title) => Text(title,
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.amberAccent,
        fontWeight: FontWeight.bold,
      ));

  Text foodtitle1(String title) => Text(title,
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ));

  Text titleWidget2(String title) => Text(title,
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ));

  Text titleBoldWidget1(String title) => Text(title,
      style: TextStyle(
        fontSize: 14.0,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ));

  Widget titleCenter(BuildContext context, String title) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  BoxDecoration myBoxDeco(String picName) {
    return BoxDecoration(
      image: DecorationImage(
          image: AssetImage('images/$picName'), fit: BoxFit.cover),
    );
  }

  Container showlogo() {
    return Container(
      width: 120.0,
      child: Image.asset('images/mainicons.png'),
    );
  }

  Widget iconShowShop(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.add_shopping_cart),
        onPressed: () {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => ShowCart(),
          );
          Navigator.push(context, route);
        });
  }

  void showToast(BuildContext context, String msg) {
    Toast.show(msg, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  Style1();
}
