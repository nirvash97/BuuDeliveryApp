import 'package:buudeli/screens/shop_add_info.dart';
import 'package:buudeli/util/style1.dart';
import 'package:flutter/material.dart';

class ShopInfo extends StatefulWidget {
  @override
  _ShopInfoState createState() => _ShopInfoState();
}

class _ShopInfoState extends State<ShopInfo> {
  void routeToaddInfo() {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => AddShopInfo(),
    );
    Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Style1().titleCenter('กรุณาเพิ่มรายละเอียดของร้านค้า'),
        addeditbutton()
      ],
    );
  }

  Row addeditbutton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () => routeToaddInfo(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
