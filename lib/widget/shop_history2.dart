import 'dart:convert';
import 'package:buudeli/model/order_model.dart';
import 'package:buudeli/util/my_constant.dart';
import 'package:buudeli/util/style1.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopHistory2 extends StatefulWidget {
  @override
  _ShopHistory2State createState() => _ShopHistory2State();
}

class _ShopHistory2State extends State<ShopHistory2> {
  bool orderStatus = true;
  List<OrderModel> orderModels = List();
  List<List<String>> listMenuFoods = List();
  List<List<String>> listPriceFoods = List();
  List<List<String>> listAmountFoods = List();
  List<List<String>> listSumFoods = List();
  List<int> totalInOrder = List();

  @override
  void initState() {
    // TODO: implement initState
    getOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("รายการOrder ที่สำเร็จในร้านของคุณ"),
      ),
      body: buildContent(),
    );
  }

  Widget buildContent() => ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: orderModels.length,
        // ignore: unrelated_type_equality_checks
        itemBuilder: (context, index) => orderCards(index),
      );

  Widget orderCards(int index) {
    return Column(
      children: [
        callOrderID(index),
        Row(
          children: [
            Style1()
                .titleWidget('Order Time : ${orderModels[index].orderDate}'),
          ],
        ),
        buildHead(),
        listViewFood(index),
        Row(
          children: [
            Style1().titleWidget('รายรับจากOrder: ${totalInOrder[index]}'),
          ],
        )
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

  Row callOrderID(int index) {
    return Row(
      children: [
        Style1().titleCustom('Order หมายเลข : ${orderModels[index].id}', 20,
            Colors.amber, FontWeight.bold),
      ],
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
          List<String> menuFoods = arrayConvert(model.nameFood);
          List<String> price = arrayConvert(model.price);
          List<String> amount = arrayConvert(model.amount);
          List<String> sum = arrayConvert(model.sum);
          int totalSum = 0;
          for (var i = 0; i < sum.length; i++) {
            totalSum = totalSum + int.parse(sum[i]);
          }
          setState(() {
            orderStatus = false;
            orderModels.add(model);
            listMenuFoods.add(menuFoods);
            listPriceFoods.add(price);
            listAmountFoods.add(amount);
            listSumFoods.add(sum);
            totalInOrder.add(totalSum);
          });
        }
      } else {
        orderStatus = true;
      }
    });
  }
}
