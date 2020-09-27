import 'dart:convert';

import 'package:buudeli/model/order_model.dart';
import 'package:buudeli/screens/index.dart';
import 'package:buudeli/util/my_constant.dart';
import 'package:buudeli/util/style1.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowStatusOrder extends StatefulWidget {
  @override
  _ShowStatusOrderState createState() => _ShowStatusOrderState();
}

class _ShowStatusOrderState extends State<ShowStatusOrder> {
  String idUser;
  bool orderStatus = true;
  List<OrderModel> orderModels = List();
  List<List<String>> listMenuFoods = List();
  List<List<String>> listPriceFoods = List();
  List<List<String>> listAmountFoods = List();
  List<List<String>> listSumFoods = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  @override
  Widget build(BuildContext context) {
    return orderStatus ? noOrder() : buildContent();
  }

  Widget buildContent() => ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: orderModels.length,
        itemBuilder: (context, index) => Column(
          children: [
            callNameShop(index),
            Row(
              children: [
                Style1()
                    .titleWidget('Order Time ${orderModels[index].orderDate}'),
              ],
            ),
            Row(
              children: [
                Style1().titleCustom(
                    'Distance : ${orderModels[index].distance}',
                    14,
                    Colors.black,
                    FontWeight.normal),
              ],
            ),
            Row(
              children: [
                Style1().titleCustom(
                    'ค่าขนส่ง : ${orderModels[index].transport}',
                    14,
                    Colors.black,
                    FontWeight.normal),
              ],
            ),
            buildHead(),
            listViewFood(index),
          ],
        ),
      );

  ListView listViewFood(int index) => ListView.builder(padding: EdgeInsets.only(bottom: 15),
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
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(listPriceFoods[index][index2]),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(listAmountFoods[index][index2]),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
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

  Row callNameShop(int index) {
    return Row(
      children: [
        Style1().titleCustom('ร้าน ${orderModels[index].nameShop}', 20,
            Colors.amber, FontWeight.bold),
      ],
    );
  }

  Center noOrder() => Center(child: Text('You have no order'));

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUser = preferences.getString('id');
    });
    print(idUser);
    readOrder();
  }

  List<String> arrayConvert(String arrayData) {
    List<String> list = List();
    String tmp = arrayData.substring(1, arrayData.length - 1);
    print('convert = $tmp');
    list = tmp.split(',');
    int index = 0;
    for (var string in list) {
      list[index] = string.trim();
      index++;
    }
    return list;
  }

  Future<Null> readOrder() async {
    if (idUser != null) {
      String url =
          '${Myconstant().domain}/Buudeli/getOrderWhereUserId.php?isAdd=true&idUser=$idUser';
      Response response = await Dio().get(url);

      if (response.toString() != 'null') {
        var result = json.decode(response.data);
        print("response = $result");
        for (var map in result) {
          OrderModel model = OrderModel.fromJson(map);
          List<String> menuFoods = arrayConvert(model.nameFood);
          List<String> price = arrayConvert(model.price);
          List<String> amount = arrayConvert(model.amount);
          List<String> sum = arrayConvert(model.sum);
          print('sum = ${model.sum}');
          print(menuFoods);
          setState(() {
            orderStatus = false;
            orderModels.add(model);
            listMenuFoods.add(menuFoods);
            listPriceFoods.add(price);
            listAmountFoods.add(amount);
            listSumFoods.add(sum);
          });
        }
      }
    }
  }
}
