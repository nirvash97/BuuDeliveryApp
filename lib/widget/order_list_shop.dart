import 'package:buudeli/model/user_model.dart';
import 'package:flutter/material.dart';


class OrderListShop extends StatefulWidget {
  @override
  _OrderListShopState createState() => _OrderListShopState();
}

class _OrderListShopState extends State<OrderListShop> {
  UserModel userModel;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Text('แสดงOrderที่ลูกค้าสั่ง');
  }
}
