import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:buudeli/model/user_model.dart';
import 'package:buudeli/util/dialog.dart';
import 'package:buudeli/util/my_constant.dart';
import 'package:buudeli/util/style1.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditShopInfo extends StatefulWidget {
  @override
  _EditShopInfoState createState() => _EditShopInfoState();
}

class _EditShopInfoState extends State<EditShopInfo> {
  UserModel userModel;
  String nameShop, address, phone, imageUrl;
  Location location = Location();
  double lat, lng;
  File file;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readCurrentInfo();
    location.onLocationChanged.listen((event) {
      setState(() {
        lat = event.latitude;
        lng = event.longitude;
        // print('lat = $lat lng = $lng');
      });
    });
  }

  Future<Null> readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');
    String url =
        '${Myconstant().domain}/Buudeli/getDataUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      print('Res decoded is  = $result');

      for (var map in result) {
        //นำข้อมูลเข้า userModel แต่ละตัว
        setState(() {
          userModel = UserModel.fromJson(map);
          nameShop = userModel.nameShop;
          address = userModel.address;
          phone = userModel.phone;
          imageUrl = userModel.imageUrl;
        });
        print('name shop = ${userModel.name}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userModel == null ? Style1().showProgress() : showContain(),
      appBar: AppBar(
        title: Text('แก้ไขรายละเอียดร้าน'),
      ),
    );
  }

  Widget showContain() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            nameshopform(),
            showPic(),
            addressform(),
            phoneform(),
            lat == null ? Style1().showProgress() : showmap(),
            editbutton()
          ],
        ),
      );

  Widget editbutton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
        color: Style1().goldAmber,
        onPressed: () => confirmDialog(),
        icon: Icon(Icons.edit),
        label: Text('แก้ไขรายละเอียด'),
      ),
    );
  }

  Future<Null> confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text("Are you sure about that ?"),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlineButton(
                onPressed: () {
                  Navigator.pop(context);
                  editThread();
                },
                child: Text("Sure"),
              ),
              OutlineButton(
                onPressed: () => Navigator.pop(context),
                child: Text("No!!"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> editThread() async {
    Random random = Random();
    int x = random.nextInt(10000000);
    String namefile = 'FixShop$x.jpg';

    Map<String, dynamic> map = Map();
    map['file'] = await MultipartFile.fromFile(file.path, filename: namefile);
    FormData formData = FormData.fromMap(map);
    String imageupload = '${Myconstant().domain}/Buudeli/addShopPhoto.php';
    await Dio().post(imageupload, data: formData).then((value) async {
      imageUrl = '/Buudeli/ShopBanner/$namefile';

      String id = userModel.id;
      String url =
          '${Myconstant().domain}/Buudeli/editDataId.php?isAdd=true&id=$id&NameShop=$nameShop&Address=$address&Phone=$phone&ImageUrl=$imageUrl&Lat=$lat&Lng=$lng';
      Response response = await Dio().get(url);
      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normaldialog(context, 'Updating Failed');
      }
    });
  }

  Container showmap() {
    CameraPosition cameraPosition =
        CameraPosition(target: LatLng(lat, lng), zoom: 16.0);

    return Container(
      margin: EdgeInsets.only(top: 20.0),
      height: 250.0,
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

  Widget showPic() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: () => chooseImage(ImageSource.camera)),
                Container(
                  height: 250.0,
                  width: 250.0,
                  child: file == null
                      ? Image.network('${Myconstant().domain}$imageUrl')
                      : Image.file(file),
                ),
                IconButton(
                    icon: Icon(Icons.add_photo_alternate),
                    onPressed: () => chooseImage(ImageSource.gallery)),
              ],
            ),
          ),
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

  Widget nameshopform() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 15.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => nameShop = value,
              initialValue: nameShop,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ชื่อร้าน',
              ),
            ),
          ),
        ],
      );

  Widget addressform() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 15.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => address = value,
              initialValue: address,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ที่อยู่ของร้าน',
              ),
            ),
          ),
        ],
      );

  Widget phoneform() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 15.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => phone = value,
              initialValue: phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'เบอร์โทรศัพท์ของร้าน',
              ),
            ),
          ),
        ],
      );
}
