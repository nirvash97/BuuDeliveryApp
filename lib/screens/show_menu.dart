import 'package:buudeli/model/user_model.dart';
import 'package:buudeli/util/style1.dart';
import 'package:buudeli/widget/about_shop.dart';
import 'package:buudeli/widget/showMenuFood.dart';
import 'package:flutter/material.dart';

class ShowShopMenu extends StatefulWidget {
  final UserModel userModel;
  ShowShopMenu({Key key, this.userModel}) : super(key: key);
  @override
  _ShowShopMenuState createState() => _ShowShopMenuState();
}

class _ShowShopMenuState extends State<ShowShopMenu> {
  UserModel userModel;
  List<Widget> listWidgets = List(); //[AboutShop(), ShowMenuFood()];
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
    listWidgets.add(AboutShop(userModel: userModel));
    listWidgets.add(ShowMenuFood(userModel: userModel,));
  }

  BottomNavigationBarItem aboutShopNav() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.info),
      title: Text('รายละเอียดร้าน'),
    );
  }

  BottomNavigationBarItem showMenuFoodNav() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.fastfood),
      title: Text('รายการอาหาร'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userModel.nameShop),
      ),
      body: listWidgets.length == 0
          ? Style1().showProgress()
          : listWidgets[index],
      bottomNavigationBar: showButtonNav(),
    );
  }

  BottomNavigationBar showButtonNav() => BottomNavigationBar(
          currentIndex: index,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          items: <BottomNavigationBarItem>[
            aboutShopNav(),
            showMenuFoodNav(),
          ]);
}
