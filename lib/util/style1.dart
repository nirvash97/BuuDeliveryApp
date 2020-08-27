import 'package:flutter/material.dart';

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
        fontSize: 20.0,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ));

  Text foodmaintitle1(String title) => Text(title,
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
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

  Style1();
}
