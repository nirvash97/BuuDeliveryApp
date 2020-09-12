import 'dart:convert';

import 'package:buudeli/model/user_model.dart';
import 'package:buudeli/screens/show_menu.dart';
import 'package:buudeli/util/my_constant.dart';
import 'package:buudeli/util/style1.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
class ShowListAllShop extends StatefulWidget {
  @override
  _ShowListAllShopState createState() => _ShowListAllShopState();
}

class _ShowListAllShopState extends State<ShowListAllShop> {


  List<UserModel> userModels = List();
  List<Widget> shopCard = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readShopList();
  }
  
  @override
  Widget build(BuildContext context) {
    return shopCard.length == 0
          ? Style1().showProgress()
          : GridView.extent(
              maxCrossAxisExtent: 150.0,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 5.0,
              children: shopCard,
            );
  }


  Future<Null> readShopList() async {
    String url =
        "${Myconstant().domain}/Buudeli/getDataUserWhereType.php?isAdd=true&usertype=Owner";
    await Dio().get(url).then((value) {
      var res = jsonDecode(value.data);
      int index = 0;
      for (var map in res) {
        UserModel model = UserModel.fromJson(map);
        String nameShop = model.nameShop;
        if (nameShop.isNotEmpty) {
          print('${model.nameShop}');
          setState(() {
            userModels.add(model);
            shopCard.add(createCard(model, index));
            index++;
          });
        }
      }
    });
  }


   Widget createCard(UserModel userModel, int index) {
    return GestureDetector(
      onTap: () {
        print('Tap index at $index');
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ShowShopMenu(
            userModel: userModels[index],
          ),
        );
        Navigator.push(context, route);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 80.0,
            height: 80.0,
            child: CircleAvatar(
              backgroundImage:
                  NetworkImage('${Myconstant().domain}${userModel.imageUrl}'),
            ),
          ),
          Style1().mysizebox(),
          Style1().titleBoldWidget1(userModel.nameShop),
        ],
      ),
    );
  }
}