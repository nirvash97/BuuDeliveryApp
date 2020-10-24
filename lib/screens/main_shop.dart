

import 'package:buudeli/util/logout_process.dart';
import 'package:buudeli/util/style1.dart';
import 'package:buudeli/widget/food_list_shop.dart';
import 'package:buudeli/widget/order_list_shop.dart';
import 'package:buudeli/widget/shop_history.dart';
import 'package:buudeli/widget/shop_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainShop extends StatefulWidget {
  @override
  _MainShopState createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  Widget currentWidget = OrderListShop();

  String nameUser;
  @override
  void initState() {
 
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameUser == null ? 'Main Shop' : '$nameUser Shop login'),
      ),
      drawer: showDrawer(),
      body: currentWidget,
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHeader(),
            homeMenu(),
            menu_Manage(),
            informationMenu(),
            historyPage(),
            logout1(),
            
          ],
        ),
      );

  ListTile homeMenu() => ListTile(
        leading: Icon(Icons.home),
        title: Text('รายการ Order'),
        subtitle: Text('รายการOrderที่ยังไม่ได้ส่ง'),
        onTap: () {
          setState(() {
            currentWidget = OrderListShop();
          });
          Navigator.pop(context);
        },
      );

    ListTile historyPage() => ListTile(
        leading: Icon(Icons.account_balance),
        title: Text('Salary'),
        subtitle: Text('รายได้ของคุณ'),
        onTap: () {
          setState(() {
            currentWidget = ShopHistory();
          });
          Navigator.pop(context);
        },
      );

  ListTile menu_Manage() => ListTile(
        leading: Icon(Icons.edit),
        title: Text('จัดการอาหารของฉัน'),
        subtitle: Text('รายการอาหารของร้าน'),
        onTap: () {
          setState(() {
            currentWidget = FoodListShop();
          });
          Navigator.pop(context);
        },
      );

  ListTile informationMenu() => ListTile(
        leading: Icon(Icons.info),
        title: Text('รายระเอียดของร้าน'),
        subtitle: Text('ข้อมูลของร้าน'),
        onTap: () {
          setState(() {
            currentWidget = ShopInfo();
          });
          Navigator.pop(context);
        },
      );

  ListTile logout1() => ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Logout'),
        subtitle: Text('ออกจากระบบ'),
        onTap: () => logoutProcess(context),
      );

  UserAccountsDrawerHeader showHeader() {
    return UserAccountsDrawerHeader(
      decoration: Style1().myBoxDeco('shop.jpg'),
      currentAccountPicture: Style1().showlogo(),
      accountName: Text('$nameUser', style: TextStyle(color: Colors.amber)),
      accountEmail:
          Text('Welcome to your shop', style: TextStyle(color: Colors.amber)),
    );
  }
}
