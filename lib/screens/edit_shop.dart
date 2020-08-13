import 'dart:convert';

import 'package:buudeli/model/user_model.dart';
import 'package:buudeli/util/my_constant.dart';
import 'package:buudeli/util/style1.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
            lat==null ? Style1().showProgress() :showmap(),
            editbutton()
          ],
        ),
      );

  Widget editbutton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
        color: Style1().goldAmber,
        onPressed: () {},
        icon: Icon(Icons.edit),
        label: Text('แก้ไขรายละเอียด'),
      ),
    );
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
                IconButton(icon: Icon(Icons.add_a_photo), onPressed: null),
                Container(
                  height: 250.0,
                  width: 250.0,
                  child: Image.network('${Myconstant().domain}$imageUrl'),
                ),
                IconButton(
                    icon: Icon(Icons.add_photo_alternate), onPressed: null),
              ],
            ),
          ),
        ],
      );

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
              onChanged: (value) => nameShop = value,
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
              onChanged: (value) => nameShop = value,
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
