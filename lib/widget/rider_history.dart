import 'dart:convert';


import 'package:buudeli/model/order_model.dart';
import 'package:buudeli/util/my_constant.dart';
import 'package:buudeli/util/style1.dart';
import 'package:buudeli/widget/rider_history2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RiderHistory extends StatefulWidget {
  @override
  _RiderHistoryState createState() => _RiderHistoryState();
}

class _RiderHistoryState extends State<RiderHistory> {
  bool orderStatus = true;
  List<OrderModel> orderModels = List();
  List<List<String>> listMenuFoods = List();
  List<List<String>> listPriceFoods = List();
  List<List<String>> listAmountFoods = List();
  List<List<String>> listSumFoods = List();
  String shopID;
  String customerID;
  int totalTran = 0;

  @override
  void initState() {
    // TODO: implement initState
    getOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Style1().adjustBox(10, 20),
            Style1().titleCustom(
                "รายได้ของคุณทั้งหมด", 16, Colors.black, FontWeight.bold),
            Style1().adjustBox(10, 20),
            Style1().titleCustom(
                "$totalTran  Bath.", 24, Colors.amber, FontWeight.bold),
            Style1().adjustBox(10, 20),
            RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.amber,
                onPressed: () {
                  routeToHistory();
                },
                icon: Icon(Icons.schedule_outlined),
                label: Text('ดูประวัติการทำงานของคุณ')),
          ],
        ),
      ],
    );
  }

  Future<Null> routeToHistory() async {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => (RiderHistory2()),
    );
    Navigator.push(context, route).then((value) {});
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

  Future<Null> getOrder() async {
    orderModels.clear();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String nameRider = preferences.getString("name");
    String url =
        "${Myconstant().domain}/Buudeli/getFinishOrderWhereRiderId.php?isAdd=true&nameRider=$nameRider";
    await Dio().get(url).then((value) {
      if (value.toString() != null) {
        var result = json.decode(value.data);
        for (var map in result) {
          OrderModel model = OrderModel.fromJson(map);
          List<String> menuFoods = arrayConvert(model.nameFood);
          List<String> price = arrayConvert(model.price);
          List<String> amount = arrayConvert(model.amount);
          List<String> sum = arrayConvert(model.sum);
          setState(() {
            shopID = model.idShop;
            customerID = model.idUser;
            orderStatus = false;
            orderModels.add(model);
            listMenuFoods.add(menuFoods);
            listPriceFoods.add(price);
            listAmountFoods.add(amount);
            listSumFoods.add(sum);
            totalTran = totalTran + int.parse(model.transport);
          });
        }
      } else {
        orderStatus = true;
      }
    });
  }
}
