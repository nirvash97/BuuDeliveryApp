import 'dart:math';

import 'package:buudeli/model/user_model.dart';
import 'package:buudeli/util/my_api.dart';
import 'package:buudeli/util/my_constant.dart';
import 'package:buudeli/util/style1.dart';
import 'package:buudeli/widget/showMenuFood.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class AboutShop extends StatefulWidget {
  final UserModel userModel;
  AboutShop({Key key, this.userModel}) : super(key: key);
  @override
  _AboutShopState createState() => _AboutShopState();
}

class _AboutShopState extends State<AboutShop> {
  UserModel userModel;
  double ulat, ulng, slat, slng, distance;
  String distanceString;
  int costFinal;
  CameraPosition position;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
    findUlatlng();
  }

  Future<Null> findUlatlng() async {
    LocationData locationData = await findLocationData();
    setState(() {
      ulat = locationData.latitude;
      ulng = locationData.longitude;
      slat = double.parse(userModel.lat);
      slng = double.parse(userModel.lng);
      print('User lat = $ulat , User lng = $ulng');
      print('Shop lat = $slat , Shop lng = $slng');
      distance = MyAPI().calculateDistance(ulat, ulng, slat, slng);
      var changeFormat = NumberFormat('#0.0#', 'en_US');
      distanceString = changeFormat.format(distance);
      print('Distance = $distance');
      costFinal = MyAPI().findDeliveryCost(distance);
      print('Delivery Cost = $costFinal');
    });
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.all(20.0),
                  width: 200.0,
                  height: 200.0,
                  child: Image.network(
                    '${Myconstant().domain}${userModel.imageUrl}',
                    fit: BoxFit.cover,
                  )),
            ],
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(userModel.address),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(userModel.phone),
          ),
          ListTile(
            leading: Icon(Icons.directions_bike),
            title: Text(distance == null ? ' ' : '$distanceString  Km.'),
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text(costFinal == null ? ' ' : '$costFinal  Bath.'),
          ),
          showMap()
        ],
      ),
    );
  }

  Container showMap() {
    if (ulat != null) {
      
      LatLng latLng1 = LatLng(ulat, ulng);
      position = CameraPosition(
        target: latLng1,
        zoom: 13.5,
      );
    }
    Marker uMarker() {
      return Marker(
        markerId: MarkerId('User Marker'),
        position: LatLng(ulat, ulng),
        icon: BitmapDescriptor.defaultMarkerWithHue(90.0),
        infoWindow: InfoWindow(
          title: 'ตำแหน่งของคุณ',
          snippet: 'latitude : $ulat , longitude: $ulng',
        ),
      );
    }

    Marker shopMarker() {
      return Marker(
        markerId: MarkerId('Shop Marker'),
        position: LatLng(slat, slng),
        icon: BitmapDescriptor.defaultMarkerWithHue(30.0),
        infoWindow: InfoWindow(
          title: 'ตำแหน่งร้านค้า',
          snippet: 'latitude : $slat , longitude: $slng',
        ),
      );
    }

    Set<Marker> mySet() {
      return <Marker>[uMarker(),shopMarker()].toSet();
    }

    return Container(
      margin: EdgeInsets.all(15.0),
      height: 300.0,
      child: ulat == null
          ? Style1().showProgress()
          : GoogleMap(
              initialCameraPosition: position,
              mapType: MapType.normal,
              onMapCreated: (controller) {},markers: mySet() ,
            ),
    );
  }
}
