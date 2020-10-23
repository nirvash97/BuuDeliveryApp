import 'dart:convert';

import 'package:buudeli/model/cart_model.dart';
import 'package:buudeli/model/food_model.dart';
import 'package:buudeli/model/user_model.dart';
import 'package:buudeli/util/dialog.dart';
import 'package:buudeli/util/my_api.dart';
import 'package:buudeli/util/my_constant.dart';
import 'package:buudeli/util/sqLite.dart';
import 'package:buudeli/util/style1.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:toast/toast.dart';

class ShowMenuFood extends StatefulWidget {
  final UserModel userModel;
  ShowMenuFood({Key key, this.userModel}) : super(key: key);
  @override
  _ShowMenuFoodState createState() => _ShowMenuFoodState();
}

class _ShowMenuFoodState extends State<ShowMenuFood> {
  UserModel userModel;

  List<FoodModel> foodModels = List();
  int amount = 1;
  String idShop;
  double ulat, ulng, slat, slng;
  Location location = Location();
  @override
  void initState() {

    super.initState();
    userModel = widget.userModel;
    readFoodMenu();
    findLocation();
  }

  Future<Null> findLocation() async {
    location.onLocationChanged.listen((event) {
      ulat = event.latitude;
      ulng = event.longitude;
      slat = double.parse(userModel.lat);
      slng = double.parse(userModel.lng);
      // print('User lat = $ulat , User lng = $ulng');
      // print('Shop lat = $slat , Shop lng = $slng');
    });
  }

  Future<Null> readFoodMenu() async {
    idShop = userModel.id;
    String url =
        '${Myconstant().domain}/Buudeli/getFoodWhereShopId.php?isAdd=true&idShop=$idShop';
    await Dio().get(url).then((value) {
      var res = json.decode(value.data);
      // print('Decoded ===> $res');

      for (var map in res) {
        FoodModel foodModel = FoodModel.fromJson(map);
        setState(() {
          foodModels.add(foodModel);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return foodModels.length == 0
        ? Style1().showProgress()
        : ListView.builder(
            itemCount: foodModels.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                // print('Click index = $index');
                amount = 1;
                confirmOrder(index);
              },
              child: Row(
                children: [
                  createFoodCards(context, index),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Style1().foodmaintitle2(foodModels[index].foodName),
                          ],
                        ),
                        Text('${foodModels[index].price} Bath'),
                        Row(
                          children: [
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 0.5 - 20,
                              child: Text('${foodModels[index].info}'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Future<Null> confirmOrder(int index) async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Style1().foodmaintitle2(foodModels[index].foodName),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.all(5.0),
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                      image: NetworkImage(
                        '${Myconstant().domain}${foodModels[index].imgPath}',
                      ),
                      fit: BoxFit.cover),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      size: 36.0,
                      color: Colors.amberAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        amount++;
                      });
                    },
                  ),
                  Style1().foodmaintitle1(amount.toString()),
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      size: 36.0,
                      color: Colors.amberAccent,
                    ),
                    onPressed: () {
                      if (amount > 1) {
                        setState(() {
                          amount--;
                        });
                      }
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: () {
                      Navigator.pop(context);
                      // print('amount = $amount');
                      // print('order ${foodModels[index].foodName}');
                      addTocart(index);
                    },
                    child: Text('Confirm'),
                  ),
                  Style1().adjustBox(20, 1),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancle'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Container createFoodCards(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 5.0, top: 10.0),
      width: MediaQuery.of(context).size.width * 0.5 - 16.0,
      height: MediaQuery.of(context).size.height * 0.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        image: DecorationImage(
            image: NetworkImage(
              '${Myconstant().domain}${foodModels[index].imgPath}',
            ),
            fit: BoxFit.cover),
      ),
    );
  }

  Future<Null> addTocart(int index) async {
    String nameShop = userModel.nameShop;
    String idFood = foodModels[index].id;
    String foodName = foodModels[index].foodName;
    String price = foodModels[index].price;
    int priceInt = int.parse(price);
    int sumInt = priceInt * amount;
    double distance = MyAPI().calculateDistance(ulat, ulng, slat, slng);

    var changeFormat = NumberFormat('#0.0#', 'en_US');
    String distanceString = changeFormat.format(distance);
    int transport = MyAPI().findDeliveryCost(distance);
    // print(
    //     'idShop = $idShop , ShopName = $nameShop , idFood = $idFood , namefood = $foodName \n price = $price , amount= $amount , sum = $sumInt , distance =$distanceString , dec = $transport');
    Map<String, dynamic> map = Map();
    map['idShop'] = idShop;
    map['nameShop'] = nameShop;
    map['idFood'] = idFood;
    map['nameFood'] = foodName;
    map['price'] = price;
    map['amount'] = amount.toString();
    map['sum'] = sumInt.toString();
    map['distance'] = distanceString;
    map['dec'] = transport.toString();
    print('Map = ${map.toString()}');
    CartModel cartModel = CartModel.fromJson(map);
    var obj = await SQLite().readSQLiteData();
    print('obj length = ${obj.length}');

    if (obj.length == 0) {
      await SQLite().insertDatabase(cartModel).then((value) {
        print('Insert Success');
        showToast('Item Add Tp Cart');
      });
    } else {
      String idShopLite = obj[0].idShop;
      print("idShop = $idShopLite");
      if (idShop == idShopLite) {
        await SQLite().insertDatabase(cartModel).then((value) {
          print('Insert Check Success');
          showToast('Item Add Tp Cart');
        });
      } else {
        normaldialog(context,
            "กรุณาชำระรายการอาหารของร้าน${obj[0].nameShop}ก่อนใช้บริการร้านถัดไป");
      }
    }
  }

  void showToast(String msg) {
    Toast.show('Cart has been added',context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER );
  }
}
