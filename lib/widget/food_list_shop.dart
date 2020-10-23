import 'dart:convert';

import 'package:buudeli/model/food_model.dart';
import 'package:buudeli/screens/add_food_menu.dart';
import 'package:buudeli/screens/edit_food.dart';
import 'package:buudeli/util/my_constant.dart';
import 'package:buudeli/util/style1.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodListShop extends StatefulWidget {
  @override
  _FoodListShopState createState() => _FoodListShopState();
}

class _FoodListShopState extends State<FoodListShop> {
  bool status = true;
  bool load = true;
  List<FoodModel> foodModels = List();

  @override
  void initState() {

    super.initState();
    readFoodList();
  }

  Future<Null> readFoodList() async {
    if (foodModels.length != 0) {
      foodModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idShop = preferences.getString('id');
    String url =
        '${Myconstant().domain}/Buudeli/getFoodWhereShopId.php?isAdd=true&idShop=$idShop';
    await Dio().get(url).then((value) {
      setState(() {
        load = false;
      });

      if (value.toString() != 'null') {
        var result = json.decode(value.data);
        print('result = $result');
        for (var map in result) {
          FoodModel foodModel = FoodModel.fromJson(map);
          setState(() {
            foodModels.add(foodModel);
          });
        }
      } else {
        setState(() {
          status = false;
          print('No Food in your list');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        load ? Style1().showProgress() : showContent(),
        addMenuButton(),
      ],
    );
  }

  Widget showContent() {
    return status
        ? showlistfood()
        : Center(
            child: Text('ไม่มีอาหารในร้านของท่าน'),
          );
  }

  Widget showlistfood() => ListView.builder(
        itemCount: foodModels.length,
        itemBuilder: (context, index) => Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.4,
              child: Image.network(
                '${Myconstant().domain}${foodModels[index].imgPath}',
                fit: BoxFit.contain,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.4,
              child: SingleChildScrollView(
                child: Column(
          
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Style1().foodmaintitle1(foodModels[index].foodName),
                    Style1().foodtitle1('ราคา : ${foodModels[index].price}'),
                    Style1().foodtitle1('${foodModels[index].info}'),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            MaterialPageRoute route = MaterialPageRoute(
                              builder: (context) => EditFood(foodModel: foodModels[index],),
                            );
                            Navigator.push(context, route).then(
                              (value) => readFoodList(),
                            );
                          },
                        ),
                        IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => delFood(foodModels[index].id)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Future<Null> delFood(String foodID) async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Style1().titleWidget('ต้องการลบอาหารนี้ใช่หรือไม่ ?'),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () => delThread(foodID),
                      child: Text('Confirm'),
                    ),
                    FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    )
                  ],
                )
              ],
            ));
  }

  Future<Null> delThread(String foodID) async {
    String delurl =
        '${Myconstant().domain}/Buudeli/delFoodWhereID.php?isAdd=true&id=$foodID';
    await Dio().get(delurl).then((value) => readFoodList());
    Navigator.pop(context);
  }

  Widget addMenuButton() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 16.0, right: 16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    MaterialPageRoute route =
                        MaterialPageRoute(builder: (context) => AddFoodMenu());
                    Navigator.push(context, route)
                        .then((value) => readFoodList());
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      );
}
