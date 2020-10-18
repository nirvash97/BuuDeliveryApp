import 'dart:io';
import 'dart:math';

import 'package:buudeli/util/dialog.dart';
import 'package:buudeli/util/my_constant.dart';
import 'package:buudeli/util/style1.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFoodMenu extends StatefulWidget {
  @override
  _AddFoodMenuState createState() => _AddFoodMenuState();
}

class _AddFoodMenuState extends State<AddFoodMenu> {
  File file;
  String foodName, price, info, urlImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มรายการอาหาร'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            headerText('Add Food Image'),
            groupImage(),
            headerText('รายละเอียดอาหาร'),
            Style1().mysizebox(),
            nameform(),
            Style1().mysizebox(),
            priceform(),
            Style1().mysizebox(),
            foodInfoform(),
            Style1().mysizebox(),
            saveButton()
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      width: 300.0,
      child: RaisedButton.icon(
        color: Colors.amber,
        onPressed: () {
          if (file == null) {
            normaldialog(context, 'กรุณาเลือกรูปภาพ');
          } else if (foodName == null || foodName.isEmpty) {
            normaldialog(context, 'กรุณาใส่ชื่ออาหาร');
          } else if (price == null || price.isEmpty) {
            normaldialog(context, 'กรุณาเพิ่มราคาอาหาร');
          } else if (info == null || info.isEmpty) {
            normaldialog(context, 'กรุณาใส่รายละเอียดของอาหารอาหาร');
          } else {
            uploadFoodPhoto();
          }
        },
        icon: Icon(Icons.save),
        label: Text('บันทึกข้อมูล'),
      ),
    );
  }

  Future<Null> uploadFoodPhoto() async {
    String url = 'https://cgm.informatics.buu.ac.th/~buuzap/Buudeli/foodImg.php';
    Random x = Random();
    int i = x.nextInt(999999999);
    String lmgName = 'Food$i.jpg';
    try {
      Map<String, dynamic> map = Map();
      map['file'] = await MultipartFile.fromFile(file.path, filename: lmgName);
      FormData formData = FormData.fromMap(map);
      await Dio().post('$url', data: formData).then((value) {
        print('Res = $value');
        urlImage = '/Buudeli/Foodpic/$lmgName';
        print('ImageUrl = https://cgm.informatics.buu.ac.th/~buuzap$urlImage');
        insertToDB();
      });
    } catch (e) {}
  }

  Future<Null> insertToDB() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idShop = preferences.getString('id');
    String url =
        '${Myconstant().domain}/Buudeli/addFood.php?isAdd=true&idShop=$idShop&foodName=$foodName&imgPath=$urlImage&price=$price&info=$info';
    await Dio().get(url).then((value) => Navigator.pop(context));
  }

  Widget nameform() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => foodName = value.trim(),
          decoration: InputDecoration(
            labelText: 'ชื่ออาหาร',
            prefixIcon: Icon(Icons.fastfood),
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget priceform() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => price = value.trim(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'ราคา',
            prefixIcon: Icon(Icons.attach_money),
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget foodInfoform() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => info = value.trim(),
          keyboardType: TextInputType.multiline,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: 'รายละเอียด',
            prefixIcon: Icon(Icons.info),
            border: OutlineInputBorder(),
          ),
        ),
      );

  Container groupImage() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Style1().adjustBox(5, 10),
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () => chooseThread(ImageSource.camera),
          ),
          Container(
            width: 250.0,
            height: 250.0,
            child: file == null
                ? Image.asset('images/addfood2.png')
                : Image.file(file),
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () => chooseThread(ImageSource.gallery),
          ),
          Style1().adjustBox(5, 10),
        ],
      ),
    );
  }

  Future<Null> chooseThread(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );

      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Widget headerText(String text) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Style1().showname(text),
        ],
      ),
    );
  }
}
