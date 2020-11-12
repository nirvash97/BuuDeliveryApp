import 'dart:async';
import 'dart:convert';

import 'package:buudeli/model/order_model.dart';
import 'package:buudeli/model/user_model.dart';
import 'package:buudeli/util/my_constant.dart';
import 'package:buudeli/util/style1.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class NavGps extends StatefulWidget {
  final OrderModel orderModel;
  NavGps({Key key, this.orderModel}) : super(key: key);
  @override
  _NavGpsState createState() => _NavGpsState();
}

class _NavGpsState extends State<NavGps> {
  double customerLat, customerLng;
  OrderModel orderModel;
  double rlat, rlng, slat, slng, clat, clng;
  CameraPosition position;
  BitmapDescriptor pinLocationIcon1;
  BitmapDescriptor pinLocationIcon2;
  BitmapDescriptor pinLocationIcon3;
  UserModel userModels;
  String shopName, customerName;
  String customerTel, shopTel;
  List<String> foodName = List();
  List<String> foodPrice = List();
  List<String> foodAmount = List();
  List<String> foodSum = List();
  int total = 0;
  int tran = 0;
  @override
  void initState() {
    findUlatlng();
    // TODO: implement initState
    orderModel = widget.orderModel;
    super.initState();
    //findUlatlng();
    setCustomerPin();
    setRiderPin();
    setShopPin();
    getAllLat();
    putItemArray();
  }

  List<String> arrayConvert(String arrayData) {
    List<String> list = List();
    String tmp = arrayData.substring(1, arrayData.length - 1);
    // print('convert = $tmp');
    list = tmp.split(',');
    int index = 0;
    for (var string in list) {
      list[index] = string.trim();
      index++;
    }
    return list;
  }

  Future<Null> putItemArray() async {
    setState(() {
      foodName = arrayConvert(orderModel.nameFood);
      foodPrice = arrayConvert(orderModel.price);
      foodAmount = arrayConvert(orderModel.amount);
      foodSum = arrayConvert(orderModel.sum);
      tran = int.parse(orderModel.transport);
      for (var item in foodSum) {
        total = total + int.parse(item);
      }
    });
  }

  Future<Null> getAllLat() async {
    await getCustomerLATLNG();
    await getShopLATLNG();
  }

  Future<Null> getCustomerLATLNG() async {
    String customerId = orderModel.idUser;
    String customerUrl =
        "${Myconstant().domain}/Buudeli/getDataUserWhereId.php?isAdd=true&id=$customerId";
    try {
      Response response = await Dio().get(customerUrl);
      var result = json.decode(response.data);
      for (var item in result) {
        UserModel userModel = UserModel.fromJson(item);
        setState(() {
          customerName = userModel.name;

          clat = double.parse(userModel.lat);
          clng = double.parse(userModel.lng);
          customerTel = userModel.phone;
        });
        print("CLAT =$clat CLNG = $clng");
        print("Customer Tel ===> $customerTel");
      }
    } catch (e) {}
  }

  Future<Null> getShopLATLNG() async {
    String shopId = orderModel.idShop;
    String customerUrl =
        "${Myconstant().domain}/Buudeli/getDataUserWhereId.php?isAdd=true&id=$shopId";
    try {
      Response response = await Dio().get(customerUrl);
      var result = json.decode(response.data);
      for (var item in result) {
        UserModel userModel = UserModel.fromJson(item);
        setState(() {
          shopName = userModel.name;
          slat = double.parse(userModel.lat);
          slng = double.parse(userModel.lng);
          shopTel = userModel.phone;
        });
        print("shop Tel ===> $shopTel");
        print("SLAT =$slat SLNG = $slng");
      }
    } catch (e) {}
  }

  void setRiderPin() async {
    pinLocationIcon1 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 0.5), 'images/pin3.png');
  }

  void setShopPin() async {
    pinLocationIcon2 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 0.5), 'images/shopPin.png');
  }

  void setCustomerPin() async {
    pinLocationIcon3 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 0.5), 'images/userPin.png');
  }

  Future<Null> findUlatlng() async {
    Location location = Location();
    location.onLocationChanged.listen((event) async {
      setState(() {
        rlat = event.latitude;
        rlng = event.longitude;
        // print('lat = $lat lng = $lng');
      });
      await Future.delayed(Duration(seconds: 1));
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Job !!"),
      ),
      body: //MapPolyLineDraw(
          //   apiKey: "AIzaSyC8ZJkMPlllC_Z-YZuaPjTs2xhJKwatVak",
          //   firstPoint: MapPoint(rlat, rlng),
          //   secondPoint: MapPoint(24.9425822, 67.0691675),
          //   lineColor: Colors.pink,
          // ),
          clat != null && slat != null
              ? buildContent()
              : Style1().showProgress(),
    );
  }

  Widget buildContent() => SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          callOrderID(),
          Style1().mysizebox(),
          orderDateBar(),
          Style1().mysizebox(),
          recieverBar(),
          Style1().mysizebox(),
          buildHead(),
          listViewFood(),
          Row(
            children: [Style1().titleBoldWidget1("ค่าจัดส่ง : $tran")],
          ),
          Style1().mysizebox(),
          Row(
            children: [
              Style1().titleBoldWidget1("รวมทั้งหมด : ${total + tran}")
            ],
          ),
          Style1().mysizebox(),
          titleShopGPS(),
          Style1().mysizebox(),
          Row(
            children: [
              Style1().titleBoldWidget1("เบอร์โทรศัพท์ร้านค้า : $shopTel")
            ],
          ),
          Style1().mysizebox(),
          showMapShop(),
          titleCustomerGPS(),
          Style1().mysizebox(),
          Row(
            children: [
              Style1().titleBoldWidget1("เบอร์โทรศัพท์ลูกค้า : $customerTel")
            ],
          ),
          Style1().mysizebox(),
          showMapCustomer(),
          Row(
            children: [
              Style1().adjustBox(10, 1),
              RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.amber,
                  onPressed: () {
                    completeThread();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.check_box),
                  label: Text('สำเร็จงานของคุณ !!')),
              Style1().adjustBox(20, 1),
            ],
          ),
        ],
      ));

  Row orderDateBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Order Date : ${orderModel.orderDate}"),
      ],
    );
  }

  Future<Null> completeThread() async {
    String idOrder = orderModel.id;
    String process = "Finish";
    String url =
        "${Myconstant().domain}/Buudeli/editProcessWhereOrderId.php?isAdd=true&idOrder=$idOrder&process=$process";
    Dio().get(url).then((value) {
      print("======process has been update =======");
      print("job done");
    });
  }

  Row recieverBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("ผู้รับ : $customerName"),
      ],
    );
  }

  ListView listViewFood() => ListView.builder(
        padding: EdgeInsets.only(bottom: 15),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: foodName.length,
        itemBuilder: (context, index) => Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(foodName[index]),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(foodPrice[index]),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(foodAmount[index]),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(foodSum[index]),
                ],
              ),
            ),
          ],
        ),
      );

  Container buildHead() {
    return Container(
      padding: EdgeInsets.only(left: 5),
      decoration: BoxDecoration(color: Colors.grey[300]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Style1().titleWidget("รายการอาหารที่สั่ง"),
          ),
          Expanded(
            flex: 1,
            child: Style1().titleWidget("ราคาอาหาร"),
          ),
          Expanded(
            flex: 1,
            child: Style1().titleWidget("จำนวน"),
          ),
          Expanded(
            flex: 1,
            child: Style1().titleWidget("ราคาสุทธิ"),
          ),
        ],
      ),
    );
  }

  Row callOrderID() {
    return Row(
      children: [
        Style1().titleCustom('Order หมายเลข : ${orderModel.id}', 20,
            Colors.amber, FontWeight.bold),
      ],
    );
  }

  Row titleShopGPS() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Style1().titleCustom("Shop Location : $shopName Shop", 18, Colors.black,
            FontWeight.bold),
      ],
    );
  }

  Row titleCustomerGPS() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Style1().titleCustom("Customer Location : คุณ $customerName", 18,
            Colors.black, FontWeight.bold),
      ],
    );
  }

  Container showMapCustomer() {
    if (rlat != null) {
      LatLng latLng1 = LatLng(rlat, rlng);
      position = CameraPosition(
        target: latLng1,
        zoom: 13.5,
      );
    }
    Marker rMarker() {
      return Marker(
        markerId: MarkerId('User Marker'),
        position: LatLng(rlat, rlng),
        icon: pinLocationIcon1,
        infoWindow: InfoWindow(
          title: 'ตำแหน่งของคุณ',
          snippet: 'latitude : $rlat , longitude: $rlng',
        ),
      );
    }

    Marker customerMarker() {
      return Marker(
        markerId: MarkerId('Shop Marker'),
        position: LatLng(clat, clng),
        icon: pinLocationIcon3,
        infoWindow: InfoWindow(
          title: 'ตำแหน่งลูกค้า',
          snippet: 'latitude : $clat , longitude: $clng',
        ),
      );
    }

    Set<Marker> mySet() {
      return <Marker>[rMarker(), customerMarker()].toSet();
    }

    return Container(
      margin: EdgeInsets.all(15.0),
      height: 300.0,
      child: rlat == null
          ? Style1().showProgress()
          : GoogleMap(
              initialCameraPosition: position,
              mapType: MapType.normal,
              onMapCreated: (controller) {},
              markers: mySet(),
            ),
    );
  }

  Container showMapShop() {
    if (rlat != null) {
      LatLng latLng1 = LatLng(rlat, rlng);
      position = CameraPosition(
        target: latLng1,
        zoom: 13.5,
      );
    }
    Marker rMarker() {
      return Marker(
        markerId: MarkerId('Rider Marker'),
        position: LatLng(rlat, rlng),
        icon: pinLocationIcon1,
        infoWindow: InfoWindow(
          title: 'ตำแหน่งของคุณ',
          snippet: 'latitude : $rlat , longitude: $rlng',
        ),
      );
    }

    Marker shopMarker() {
      return Marker(
        markerId: MarkerId('Shop Marker'),
        position: LatLng(slat, slng),
        icon: pinLocationIcon2,
        infoWindow: InfoWindow(
          title: 'ตำแหน่งร้านค้า',
          snippet: 'latitude : $slat , longitude: $slng',
        ),
      );
    }

    Set<Marker> mySet() {
      return <Marker>[rMarker(), shopMarker()].toSet();
    }

    return Container(
      margin: EdgeInsets.all(15.0),
      height: 300.0,
      child: rlat == null
          ? Style1().showProgress()
          : GoogleMap(
              initialCameraPosition: position,
              mapType: MapType.normal,
              onMapCreated: (controller) {},
              markers: mySet(),
            ),
    );
  }
}
