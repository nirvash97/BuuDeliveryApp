import 'dart:io';
import 'dart:math';

import 'package:buudeli/util/dialog.dart';
import 'package:buudeli/util/my_constant.dart';
import 'package:buudeli/util/style1.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddShopInfo extends StatefulWidget {
  @override
  _AddShopInfoState createState() => _AddShopInfoState();
}

class _AddShopInfoState extends State<AddShopInfo> {
//Field
  double lat, lng;
  File file;
  String shopName, shopAddress, shopPhone, urlImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocation();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
    });
    print('lat = $lat , lng =$lng');
  }

  Future<LocationData> findLocation() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

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
            Style1().mysizebox(),
            lat == null ? Style1().showProgress() : showMap(),
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
          if (shopName == null ||
              shopName.isEmpty ||
              shopAddress == null ||
              shopAddress.isEmpty ||
              shopPhone == null ||
              shopPhone.isEmpty) {
            normaldialog(context, "กรุณากรอกข้อมูลให้ครบถ้วน");
          } else if (file == null) {
            normaldialog(context, "กรุณาเลือกรูปภาพ");
          } else {
            uploadPhoto();
          }
        },
        icon: Icon(Icons.save),
        label: Text('บันทึกข้อมูล'),
      ),
    );
  }

  Future<Null> uploadPhoto() async {
    Random random = Random();
    int x = random.nextInt(100000);
    String photoName = 'shop$x.jpg';
    String url = '${Myconstant().domain}/Buudeli/addShopPhoto.php';

    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file.path, filename: photoName);
      FormData formData = FormData.fromMap(map);
      await Dio().post('$url', data: formData).then((value) {
        print('Res = $value');
        urlImage = '/Buudeli/shopBanner/$photoName';
        print('ImageUrl = $urlImage');
        editShopProcess();
      });
    } catch (e) {
      print('Error\n $url \n $file');
      print(e);
    }
  }

  Future<Null> editShopProcess() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');
    String url =
        '${Myconstant().domain}/Buudeli/editDataId.php?isAdd=true&id=$id&NameShop=$shopName&Address=$shopAddress&Phone=$shopPhone&ImageUrl=$urlImage&Lat=$lat&Lng=$lng';
    print('$id $shopName $shopAddress $urlImage $lat $lng');
    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normaldialog(context, "Upload Failed");
      }
    });
  }

  Container showMap() {
    LatLng latLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );
    return Container(
      height: 300.0,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: gmMarker(),
      ),
    );
  }

  Set<Marker> gmMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myShop'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: 'ร้านของคุณ',
          snippet: 'latitude : $lat , longitude: $lng',
        ),
      )
    ].toSet();
  }

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10.0),
          child: IconButton(
              icon: Icon(
                Icons.add_a_photo,
                size: 30.0,
              ),
              onPressed: () => pickImage(ImageSource.camera)),
        ),
        Container(
          width: 250.0,
          child: file == null ? Image.asset('images/t1.png') : Image.file(file),
        ),
        Container(
          margin: EdgeInsets.only(right: 10.0),
          child: IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              size: 36.0,
            ),
            onPressed: () => pickImage(ImageSource.gallery),
          ),
        )
      ],
    );
  }

  Future<Null> pickImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker.pickImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );

      setState(() {
        file = object;
      });
    } catch (e) {}
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0),
            width: 250.0,
            child: TextField(
              onChanged: (value) => shopName = value.trim(),
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
              onChanged: (value) => shopAddress = value.trim(),
              decoration: InputDecoration(
                labelText: 'ที่อยู่ของร้านค้า',
                prefixIcon: Icon(Icons.account_box),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            width: 250.0,
            child: TextField(
              onChanged: (value) => shopPhone = value.trim(),
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
}
