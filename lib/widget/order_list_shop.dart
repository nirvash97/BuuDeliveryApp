import 'dart:async';
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
  List<String> processFoods = List();
  List<int> totalInt = List();
  List<int> statusCode = List();
  List<String> riders = List();

  @override
  void initState() {

    findShopOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return orderStatus ? Style1().showProgress() : buildContent();
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

  Future<Null> confirmCancel(int index) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text("ต้องการปฏิเสธ Order นี้ใช่หรือไม่ ? "),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton.icon(
                color: Colors.green.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () {
                  delOrderThread(index);
                },
                icon: Icon(Icons.check),
                label: Text("ใช่"),
              ),
              RaisedButton.icon(
                color: Colors.red.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.cancel),
                label: Text("ไม่"),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> confirmSend(int index) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text("ยืนยันการส่ง Order นี้ใช่หรือไม่ ? "),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton.icon(
                color: Colors.green.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () {
                  sendThread(index);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.check),
                label: Text("ใช่"),
              ),
              RaisedButton.icon(
                color: Colors.red.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.cancel),
                label: Text("ไม่"),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildContent() => ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: orderModels.length,
        // ignore: unrelated_type_equality_checks
        itemBuilder: (context, index) => processFoods[index] == 'Cooking'
            // ignore: unrelated_type_equality_checks
            ? riders[index] != "NONE" ? checkProcess(index) : Container()
            : Container(),
      );

  Widget checkProcess(int index) {
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Style1().titleBoldWidget1("รวม = ${totalInt[index]}"),
            Style1().titleBoldWidget1("คนขับ = ${riders[index]}"),
            // Style1().titleBoldWidget1(
            //     "Process Food ===> ${processFoods[index]}")
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
                  confirmSend(index);
                },
                icon: Icon(Icons.check_box),
                label: Text('ยืนยันการส่ง Order')),
            Style1().adjustBox(20, 1),
            RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.amber,
                onPressed: () {
                  confirmCancel(index);
                },
                icon: Icon(Icons.cancel),
                label: Text('ยกเลิก Order')),
          ],
        ),
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
        String xrider = model.rider;
        int total = 0;
        String process = model.process;
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
        });
      }
    } else {
      orderStatus = true;
    }
  }

  Future<Null> delOrderThread(int index) async {
    String idOrder = orderModels[index].id;
    print('$idOrder');
    String url =
        '${Myconstant().domain}/Buudeli/delOrderWhereOrderId.php?isAdd=true&idOrder=$idOrder';
    await Dio().get(url).then((value) {
      setState(() {
        processFoods[index] = null;
      });
      Navigator.pop(context);
    });
  }

  Future<Null> sendThread(int index) async {
    String idOrder = orderModels[index].id;
    print("IdORder ===> $idOrder");
    String url =
        '${Myconstant().domain}/Buudeli/editProcessWhereOrderId.php?isAdd=true&idOrder=$idOrder&process=Delivery';
    await Dio().get(url).then((value) async {
      print("Status ====> $value");

      setState(() {
        processFoods[index] = null;
      });
      await Future.delayed(Duration(seconds: 1));
    });
  }
}
