import 'dart:io';
import 'dart:math';

import 'package:buudeli/model/food_model.dart';
import 'package:buudeli/util/dialog.dart';
import 'package:buudeli/util/my_constant.dart';
import 'package:buudeli/util/style1.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditFood extends StatefulWidget {
  final FoodModel foodModel;
  EditFood({Key key, this.foodModel}) : super(key: key);

  @override
  _EditFoodState createState() => _EditFoodState();
}

class _EditFoodState extends State<EditFood> {
  File file;
  FoodModel foodModel;
  String foodName, price, info, imgPath;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foodModel = widget.foodModel;
    foodName = foodModel.foodName;
    price = foodModel.price;
    info = foodModel.info;
    imgPath = foodModel.imgPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Food : ${foodModel.foodName}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            headerText('Add Food Image'),
            groupImage(),
            headerText('รายละเอียดอาหาร'),
            foodNameForm(),
            priceForm(),
            infoForm(),
            Style1().adjustBox(10, 15),
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
          if (foodName.isEmpty ||
              price.isEmpty ||
              info.isEmpty ||
              imgPath.isEmpty) {
            normaldialog(context, "กรุณากรอกข้อมูลให้ครบทุกช่อง");
          } else {
            confirmEdit();
          }
        },
        icon: Icon(Icons.save),
        label: Text('บันทึกข้อมูล'),
      ),
    );
  }

  Future<Null> pushThread() async {
    String id = foodModel.id;
    String url =
        "${Myconstant().domain}/Buudeli/editFoodWhereId.php?isAdd=true&id=$id&foodName=$foodName&imgPath=$imgPath&price=$price&info=$info";
    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        print('$info');
        Navigator.pop(context);
      } else {
        normaldialog(context, 'Upload Data Failed , Try again');
      }
    });
  }

  Future<Null> confirmEdit() async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Style1().titleWidget('ต้องการแก้ไขอาหารนี้ใช่หรือไม่ ?'),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    FlatButton.icon(
                      onPressed: () {
                        uploadFoodPhoto();
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.check),
                      label: Text('Confirm'),
                    ),
                    FlatButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.cancel),
                      label: Text('Cancel'),
                    )
                  ],
                )
              ],
            ));
  }

  Widget groupImage() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () => chooseImage(ImageSource.camera)),
          Container(
            padding: EdgeInsets.all(10.0),
            width: 250.0,
            height: 250.0,
            child: file == null
                ? Image.network(
                    '${Myconstant().domain}${foodModel.imgPath}',
                    fit: BoxFit.cover,
                  )
                : Image.file(file),
          ),
          IconButton(
              icon: Icon(Icons.add_photo_alternate),
              onPressed: () => chooseImage(ImageSource.gallery)),
        ],
      );

  Future<Null> chooseImage(ImageSource source) async {
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

  Future<Null> uploadFoodPhoto() async {
    String url = '${Myconstant().domain}/Buudeli/foodImg.php';
    Random x = Random();
    int i = x.nextInt(999999999);
    String lmgName = 'FoodEdit$i.jpg';
    try {
      Map<String, dynamic> map = Map();
      map['file'] = await MultipartFile.fromFile(file.path, filename: lmgName);
      FormData formData = FormData.fromMap(map);
      await Dio().post('$url', data: formData).then((value) {
        print('Res = $value');
        imgPath = '/Buudeli/Foodpic/$lmgName';
        print('ImageUrl = ${Myconstant().domain}$imgPath');
        pushThread();
      });
    } catch (e) {}
  }

  Widget foodNameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => foodName = value.trim(),
              initialValue: foodModel.foodName,
              decoration: InputDecoration(
                labelText: 'ชื่ออาหาร',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget priceForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => price = value.trim(),
              initialValue: foodModel.price,
              decoration: InputDecoration(
                labelText: 'ราคาอาหาร',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget infoForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => info = value.trim(),
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              initialValue: foodModel.info,
              decoration: InputDecoration(
                labelText: 'รายละเอียดอาหาร',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

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
