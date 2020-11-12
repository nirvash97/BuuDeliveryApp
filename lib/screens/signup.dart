import 'package:buudeli/util/dialog.dart';
import 'package:buudeli/util/my_constant.dart';
import 'package:buudeli/util/style1.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String usertype, name, username, password, phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: <Widget>[
          logopart(),
          Style1().mysizebox(),
          showtitle(),
          Style1().mysizebox(),
          reguserform(),
          Style1().mysizebox(),
          regnameform(),
          Style1().mysizebox(),
          phoneform(),
          Style1().mysizebox(),
          regpasswordform(),
          Style1().mysizebox(),
          Text(
            'ต้องการเป็น :',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          userrole1(),
          userrole2(),
          userrole3(),
          Style1().mysizebox(),
          registerButton(),
        ],
      ),
    );
  }

  Widget registerButton() => Container(
      width: 250.0,
      child: RaisedButton(
        color: Style1().littleGray,
        onPressed: () {
          print(
              'name = $name , user = $username , password = $password , Type = $usertype');
          if (name == null ||
              name.isEmpty ||
              username == null ||
              username.isEmpty ||
              password == null ||
              password.isEmpty ||
              phone == null ||
              phone.isEmpty) {
            print('Please Input All Data');
            normaldialog(context, 'ข้อมูลไม่ครบถ้วน');
          } else if (usertype == null || usertype.isEmpty) {
            normaldialog(context, 'กรุณาเลือกชนิดผู้ใช้');
          } else {
            checkUser();
          }
        },
        child: Text(
          'Register',
          style: TextStyle(color: Colors.black),
        ),
      ));

  Future<Null> checkUser() async {
    String url =
        '${Myconstant().domain}/Buudeli/getUser.php?isAdd=true&User=$username';

    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'null') {
        registerThread();
      } else {
        normaldialog(context,
            'This username $username is not avialable Please Change !');
      }
    } catch (e) {}
  }

  Widget userrole1() => Row(
        //Customer Selection
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'User',
                  groupValue: usertype,
                  onChanged: (value) {
                    setState(() {
                      usertype = value;
                    });
                  },
                ),
                Text('ผู้สั่งอาหาร',
                    style: TextStyle(
                      color: Colors.black,
                    ))
              ],
            ),
          ),
        ],
      );

  Widget userrole2() => Row(
        //Shop Owner Selection
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'Owner',
                  groupValue: usertype,
                  onChanged: (value) {
                    setState(() {
                      usertype = value;
                    });
                  },
                ),
                Text('ผู้ประกอบการ',
                    style: TextStyle(
                      color: Colors.black,
                    ))
              ],
            ),
          ),
        ],
      );

  Widget userrole3() => Row(
        //Rider Selection
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'Rider',
                  groupValue: usertype,
                  onChanged: (value) {
                    setState(() {
                      usertype = value;
                    });
                  },
                ),
                Text('ผู้ส่ง',
                    style: TextStyle(
                      color: Colors.black,
                    ))
              ],
            ),
          ),
        ],
      );

  Row showtitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Style1().showname('Buu Delivery'),
      ],
    );
  }

  Widget logopart() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Style1().showlogo(),
        ],
      );

  Widget reguserform() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            height: 50.0,
            child: TextField(
              onChanged: (value) => username = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.account_box, color: Style1().littleGray),
                labelStyle: TextStyle(color: Style1().littleGray),
                labelText: 'Username :',
                enabledBorder: OutlineInputBorder(
                    borderSide: (BorderSide(color: Style1().goldAmber))),
                focusedBorder: OutlineInputBorder(
                  borderSide: (BorderSide(color: Style1().goldAmber)),
                ),
              ),
            ),
          ),
        ],
      );

  Widget regnameform() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            height: 50.0,
            child: TextField(
              onChanged: (value) => name = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.face, color: Style1().littleGray),
                labelStyle: TextStyle(color: Style1().littleGray),
                labelText: 'Fullname :',
                enabledBorder: OutlineInputBorder(
                    borderSide: (BorderSide(color: Style1().goldAmber))),
                focusedBorder: OutlineInputBorder(
                  borderSide: (BorderSide(color: Style1().goldAmber)),
                ),
              ),
            ),
          ),
        ],
      );

  Widget phoneform() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            height: 50.0,
            child: TextField(
              onChanged: (value) => phone = value.trim(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone, color: Style1().littleGray),
                labelStyle: TextStyle(color: Style1().littleGray),
                labelText: 'เบอร์โทรศัพท์ :',
                enabledBorder: OutlineInputBorder(
                    borderSide: (BorderSide(color: Style1().goldAmber))),
                focusedBorder: OutlineInputBorder(
                  borderSide: (BorderSide(color: Style1().goldAmber)),
                ),
              ),
            ),
          ),
        ],
      );

  Widget regpasswordform() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            height: 50.0,
            child: TextField(
              onChanged: (value) => password = value.trim(),
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock, color: Style1().littleGray),
                labelStyle: TextStyle(color: Style1().littleGray),
                labelText: 'Password :',
                enabledBorder: OutlineInputBorder(
                    borderSide: (BorderSide(color: Style1().goldAmber))),
                focusedBorder: OutlineInputBorder(
                  borderSide: (BorderSide(color: Style1().goldAmber)),
                ),
              ),
            ),
          ),
        ],
      );

  Future<Null> registerThread() async {
    String url =
        '${Myconstant().domain}/Buudeli/addData.php?isAdd=true&username=$username&password=$password&usertype=$usertype&phone=$phone&name=$name';
    try {
      Response response = await Dio().get(url);
      print('res = $response');
      if (response.toString() == 'true') {
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
      print('not clear');
      normaldialog(context, 'Register Fail. Please try again.');
    }
  }
}
