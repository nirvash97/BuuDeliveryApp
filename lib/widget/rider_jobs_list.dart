import 'dart:async';
import 'dart:convert';
import 'package:buudeli/model/order_model.dart';
import 'package:buudeli/model/user_model.dart';
import 'package:buudeli/screens/nav_gps.dart';
import 'package:buudeli/util/my_constant.dart';
import 'package:buudeli/util/style1.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RiderJobsList extends StatefulWidget {
  @override
  _RiderJobsListState createState() => _RiderJobsListState();
}

class _RiderJobsListState extends State<RiderJobsList> {
  UserModel userModel;
  String idUser;
  bool orderStatus = true;
  List<OrderModel> orderModels = List();
  List<List<String>> listMenuFoods = List();
  List<List<String>> listPriceFoods = List();
  List<List<String>> listAmountFoods = List();
  List<List<String>> listSumFoods = List();
  List<String> processFoods = List();
  List<int> totalInt = List();
  List<int> statusCode = List();
  List<String> riders = List();
  List<int> transports = List();
  List<String> shopId = List();
  List<String> userId = List();
  OrderModel globalModels = OrderModel();
  String nameRider;

  @override
  void initState() {
    findOrder();

    super.initState();
  }

  Future<Null> checkJobs() async {
    int count = orderModels.length;
    for (var i = 0; i < count; i++) {
      if (orderModels[i].rider == nameRider &&
          orderModels[i].process == "Cooking") {
        routeToGPS(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return orderStatus ? Style1().showProgress() : buildContent();
  }

  Widget buildContent() => ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: orderModels.length,
        // ignore: unrelated_type_equality_checks
        itemBuilder: (context, index) => riders[index] == "NONE"
            ? processFoods[index] == "UserOrder"
                ? orderCards(globalModels, index)
                : Container()
            // : riders[index] == "$nameRider"
            //     ? processFoods[index] == "Cooking" ? Container() : Container()
            : Container(),
      );

  Widget orderCards(OrderModel orderModel, int index) {
    return Column(
      children: [
        callOrderID(index),
        Row(
          children: [
            Style1()
                .titleWidget('Order Time : ${orderModels[index].orderDate}'),
          ],
        ),
        Row(
          children: [
            Style1().titleWidget('ค่าส่ง : ${transports[index]}'),
            // Style1().titleWidget('riderId : $nameRider'),
          ],
        ),
        buildHead(),
        listViewFood(index),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Style1().titleBoldWidget1("รวมร้านค้า = ${totalInt[index]}"),
            Style1().adjustBox(45, 1),
            Style1().titleBoldWidget1("คนขับ = ${riders[index]}"),
            // Style1().titleBoldWidget1(
            //     "Process Food ===> ${processFoods[index]}")
          ],
        ),
        Row(
          children: [
            Style1().titleBoldWidget1(
                "รวมราคาส่ง = ${totalInt[index] + transports[index]}"),
          ],
        ),
        Style1().adjustBox(1, 10),
        Row(
          children: [
            Style1().adjustBox(10, 1),
            RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.amber,
                onPressed: () {
                  //routeToGPS(index);
                  editOrderThread(index);
                },
                icon: Icon(Icons.check_box),
                label: Text('รับงานนี้')),
            Style1().adjustBox(20, 1),
          ],
        ),
      ],
    );
  }

  Row callOrderID(int index) {
    return Row(
      children: [
        Style1().titleCustom('Order หมายเลข : ${orderModels[index].id}', 20,
            Colors.amber, FontWeight.bold),
      ],
    );
  }

  ListView listViewFood(int index) => ListView.builder(
        padding: EdgeInsets.only(bottom: 15),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: listMenuFoods[index].length,
        itemBuilder: (context, index2) => Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(listMenuFoods[index][index2]),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(listPriceFoods[index][index2]),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(listAmountFoods[index][index2]),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(listSumFoods[index][index2]),
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

  Future<Null> findOrder() async {
    orderModels.clear();
    listMenuFoods.clear();
    listPriceFoods.clear();
    listAmountFoods.clear();
    listSumFoods.clear();
    processFoods.clear();
    totalInt.clear();
    statusCode.clear();
    riders.clear();
    transports.clear();
    shopId.clear();
    userId.clear();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameRider = preferences.getString("name");
    });
    String url = "${Myconstant().domain}/Buudeli/getOrder.php?isAdd=true";
    Response response = await Dio().get(url);
    if (response.toString() != 'null') {
      var result = json.decode(response.data);

      for (var map in result) {
        OrderModel model = OrderModel.fromJson(map);
        List<String> menuFoods = arrayConvert(model.nameFood);
        List<String> price = arrayConvert(model.price);
        List<String> amount = arrayConvert(model.amount);
        List<String> sum = arrayConvert(model.sum);
        String xrider = model.rider;
        int total = 0;
        String process = model.process;
        int tran = int.parse(model.transport);
        String sId = model.idShop;
        String uId = model.idUser;
        for (var item in sum) {
          total = total + int.parse(item);
        }
        setState(() {
          orderStatus = false;
          orderModels.add(model);
          listMenuFoods.add(menuFoods);
          listPriceFoods.add(price);
          listAmountFoods.add(amount);
          listSumFoods.add(sum);
          totalInt.add(total);
          processFoods.add(process);
          riders.add(xrider);
          transports.add(tran);
          shopId.add(sId);
          userId.add(uId);
        });
      }
    } else {
      orderStatus = true;
    }
    await Future.delayed(Duration(seconds: 1));
    checkJobs();
  }

  Future<Null> editOrderThread(int index) async {
    String idOrder = orderModels[index].id;
    String process = "Cooking";
    String preRider = nameRider;
    String url =
        "${Myconstant().domain}/Buudeli/editRiderNProcessWhereOrderId.php?isAdd=true&idOrder=$idOrder&process=$process&rider=$preRider";
    Dio().get(url).then((value) {
      print("Get Value ===> $value");
      findOrder();
    });
  }

  Future<Null> routeToGPS(int index) async {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => NavGps(
        orderModel: orderModels[index],
      ),
    );
    Navigator.push(context, route).then((value) {
      findOrder();
    });
  }
}
