import 'dart:convert';

import 'package:buudeli/model/user_model.dart';
import 'package:buudeli/screens/edit_shop.dart';
import 'package:buudeli/screens/shop_add_info.dart';
import 'package:buudeli/util/my_constant.dart';
import 'package:buudeli/util/style1.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopInfo extends StatefulWidget {
  @override
  _ShopInfoState createState() => _ShopInfoState();
}

class _ShopInfoState extends State<ShopInfo> {
  UserModel userModel;

  @override
  void initState() {


    super.initState();
    readUserData();
  }

  Future<Null> readUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');
    String url =
        '${Myconstant().domain}/Buudeli/getDataUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      print('Decoded Value = $result');

      for (var map in result) {
        //นำข้อมูลเข้า userModel แต่ละตัว
        setState(() {
          userModel = UserModel.fromJson(map);
        });
        print('name shop = ${userModel.nameShop}');
      }
    });
  }

  void routeToaddInfo() {
    Widget widget = userModel.nameShop.isEmpty ? AddShopInfo() : EditShopInfo();
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => widget,
    );
    Navigator.push(context, route).then((value) => readUserData());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        userModel == null
            ? Style1().showProgress()
            : userModel.nameShop.isEmpty ? showBlank(context) : showlistinfo(),
        addeditbutton(),
      ],
    );
  }

  Widget showlistinfo() => Column(
        children: <Widget>[
          Style1().adjustBox(20, 15),
          showImage(),
          Style1().adjustBox(20, 15),
          Style1().titleWidget('\t รายละเอียดของร้าน ${userModel.nameShop}'),
          Style1().adjustBox(20, 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Style1().titleWidget2('\t ที่อยู่ของร้าน : '),
            ],
          ),
          Text('${userModel.address}'),
          Style1().adjustBox(20, 15),
          showmap(),
        ],
      );

  Container showImage() {
    return Container(
      width: 500.0,
      height: 200.0,
      child: Image.network('${Myconstant().domain}${userModel.imageUrl}'),
    );
  }

  Set<Marker> shopMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('shopID'),
          position: LatLng(
            double.parse(userModel.lat),
            double.parse(userModel.lng),
          ),
          infoWindow: InfoWindow(
            title: 'ตำแหน่งร้านค้า',
            snippet:
                'latitude : ${double.parse(userModel.lat)} longitude: ${double.parse(userModel.lng)}',
          ))
    ].toSet();
  }

  Widget showmap() {
    Border.all(color: Colors.black);
    double lat = double.parse(userModel.lat);
    double lng = double.parse(userModel.lng);
    LatLng latLng = LatLng(lat, lng);
    CameraPosition position = CameraPosition(target: latLng, zoom: 16.0);

    return Expanded(
      // padding: EdgeInsets.all(10.0),
      // height: 300.0,
      child: GoogleMap(
        initialCameraPosition: position,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: shopMarker(),
      ),
    );
  }

  Widget showBlank(BuildContext context) =>
      Style1().titleCenter(context, 'กรุณาเพิ่มรายละเอียดของร้านค้า');

  Row addeditbutton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () => routeToaddInfo(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
