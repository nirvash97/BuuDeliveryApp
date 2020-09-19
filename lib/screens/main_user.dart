import 'package:buudeli/screens/show_cart.dart';
import 'package:buudeli/util/logout_process.dart';

import 'package:buudeli/util/style1.dart';
import 'package:buudeli/widget/show_listShop.dart';
import 'package:buudeli/widget/show_statusOrder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainUser extends StatefulWidget {
  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  String nameUser;

  Widget currentWidget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentWidget = ShowListAllShop();
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
        title: Text(nameUser == null ? 'Main User' : '$nameUser login'),
        // actions: <Widget>[
        //   IconButton(
        //       icon: Icon(Icons.exit_to_app),
        //       onPressed: () => logoutProcess(context))
        // ],
        actions: <Widget>[
          Style1().iconShowShop(context),
        ],
      ),
      drawer: showDrawer(),
      body: currentWidget,
    );
  }

  Drawer showDrawer() => Drawer(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showHeader(),
                findShopBar(),
                showOrderBar(),
                showCart(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                signOutBar(),
              ],
            ),
          ],
        ),
      );

  ListTile findShopBar() {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          currentWidget = ShowListAllShop();
        });
      },
      leading: Icon(Icons.home),
      title: Text('ค้นหาร้านค้า'),
      subtitle: Text('แสดงร้านค้าใกล้ๆคุณ'),
    );
  }

  ListTile showOrderBar() {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          currentWidget = ShowStatusOrder();
        });
      },
      leading: Icon(Icons.payment),
      title: Text('แสดง Order ที่สั่ง'),
      subtitle: Text('แสดงรายการอาหารที่สั่ง'),
    );
  }

  Widget signOutBar() {
    return Container(
      decoration: BoxDecoration(color: Colors.red),
      child: ListTile(
        onTap: () => logoutProcess(context),
        leading: Icon(Icons.exit_to_app),
        title: Text('Sing out'),
        subtitle: Text('ออกจากระบบ'),
      ),
    );
  }

  UserAccountsDrawerHeader showHeader() {
    return UserAccountsDrawerHeader(
      decoration: Style1().myBoxDeco('user.jpg'),
      currentAccountPicture: Style1().showlogo(),
      accountName: Text('$nameUser', style: TextStyle(color: Colors.amber)),
      accountEmail:
          Text('Welcome to our service', style: TextStyle(color: Colors.amber)),
    );
  }

  Widget showCart() {
    return ListTile(
      leading: Icon(Icons.add_shopping_cart),
      title: Text('ตะกร้าสินค้า'),
      subtitle: Text('รายการในตระกร้าสินค้าของฉัน'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (context) => ShowCart());
        Navigator.push(context, route);
      },
    );
  }
}
