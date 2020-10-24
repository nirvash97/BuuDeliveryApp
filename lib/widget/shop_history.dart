import 'dart:convert';

import 'package:buudeli/model/order_model.dart';
import 'package:buudeli/util/my_constant.dart';
import 'package:buudeli/util/style1.dart';
import 'package:buudeli/widget/shop_history2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopHistory extends StatefulWidget {
  @override
  _ShopHistoryState createState() => _ShopHistoryState();
}

class _ShopHistoryState extends State<ShopHistory> {
  bool orderStatus = true;
  List<OrderModel> orderModels = List();
  List<List<String>> listMenuFoods = List();
  List<List<String>> listPriceFoods = List();
  List<List<String>> listAmountFoods = List();
  List<List<String>> listSumFoods = List();
  int totalSum = 0;
  String shopID;
  String customerID;

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
                "รายได้ของร้านคุณทั้งหมด", 16, Colors.black, FontWeight.bold),
            Style1().adjustBox(10, 20),
            Style1().titleCustom(
                "$totalSum  Bath.", 24, Colors.amber, FontWeight.bold),
            Style1().adjustBox(10, 20),
            RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.amber,
                onPressed: () {
                  routeToHistory();
                },
                icon: Icon(Icons.schedule_outlined),
                label: Text('ดูประวัติการขายของคุณ')),
          ],
        ),
      ],
    );
  }

    Future<Null> routeToHistory() async {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => (ShopHistory2()),
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
    String idShop = preferences.getString("id");
    String url =
        "${Myconstant().domain}/Buudeli/getFinishOrderWhereShopId.php?idShop=$idShop&isAdd=true";
    await Dio().get(url).then((value) {
      if (value.toString() != null) {
        var result = json.decode(value.data);
        for (var map in result) {
          OrderModel model = OrderModel.fromJson(map);
          List<String> sum = arrayConvert(model.sum);
          for (var i = 0; i < sum.length; i++) {
            setState(() {
              totalSum = totalSum + int.parse(sum[i]);
            });    
          }
        }
      }
    });
  }
}
