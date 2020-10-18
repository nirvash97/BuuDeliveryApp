import 'dart:convert';

import 'package:buudeli/model/order_model.dart';
import 'package:buudeli/model/user_model.dart';
import 'package:buudeli/util/my_constant.dart';
import 'package:buudeli/util/style1.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderListShop extends StatefulWidget {
  @override
  _OrderListShopState createState() => _OrderListShopState();
}

class _OrderListShopState extends State<OrderListShop> {
  UserModel userModel;
  String idUser;
  bool orderStatus = true;
  List<OrderModel> orderModels = List();
  List<List<String>> listMenuFoods = List();
  List<List<String>> listPriceFoods = List();
  List<List<String>> listAmountFoods = List();
  List<List<String>> listSumFoods = List();
  List<int> totalInt = List();
  List<int> statusCode = List();
  @override
  void initState() {
    // TODO: implement initState
    findShopOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  Row callOrderID(int index) {
    return Row(
      children: [
        Style1().titleCustom('Order หมายเลข : ${orderModels[index].id}', 20,
            Colors.amber, FontWeight.bold),
      ],
    );
  }

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

  Widget buildContent() => ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: orderModels.length,
        itemBuilder: (context, index) => Column(
          children: [
            callOrderID(index),
            Row(
              children: [
                Style1().titleWidget(
                    'Order Time : ${orderModels[index].orderDate}'),
              ],
            ),
            buildHead(),
            listViewFood(index),
            Row(
              children: [
                RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.amber,
                    onPressed: () {},
                    icon: Icon(Icons.check_box),
                    label: Text('ยืนยันการส่ง Order')),
                RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.amber,
                    onPressed: () {},
                    icon: Icon(Icons.check_box),
                    label: Text('ยกเลิก Order Order')),
              ],
            ),
          ],
        ),
      );

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

  Future<Null> findShopOrder() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idShop = preferences.getString('id');
    String url =
        "${Myconstant().domain}/Buudeli/getOrderWhereShopId.php?isAdd=true&idShop=$idShop";
    Response response = await Dio().get(url);
    if (response.toString() != 'null') {
      var result = json.decode(response.data);

      for (var map in result) {
        OrderModel model = OrderModel.fromJson(map);
        List<String> menuFoods = arrayConvert(model.nameFood);
        List<String> price = arrayConvert(model.price);
        List<String> amount = arrayConvert(model.amount);
        List<String> sum = arrayConvert(model.sum);
        int total = 0;
        int status = 0;
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
          statusCode.add(status);
        });
      }
    }
  }
}
