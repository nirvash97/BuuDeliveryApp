import 'package:buudeli/model/cart_model.dart';
import 'package:buudeli/util/sqLite.dart';
import 'package:buudeli/util/style1.dart';
import 'package:flutter/material.dart';

class ShowCart extends StatefulWidget {
  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<CartModel> cartModels = List();
  int cartSum = 0;
  bool stat = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readSQLite();
  }

  Future<Null> readSQLite() async {
    var obj = await SQLite().readSQLiteData();
    cartSum = 0;
    if (obj.length != 0) {
      for (var item in obj) {
        String sumString = item.sum;
        int sumInt = int.parse(sumString);
        setState(() {
          stat = false;
          cartModels = obj;
          cartSum = cartSum + sumInt;
        });
      }
    } else {
      setState(() {
        stat = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการในตระกร้าของฉัน'),
      ),
      body: stat
          ? Center(
              child: Text('ตระกรา้ของคุณไม่มีสินค้า'),
            )
          : buildPage(context),
    );
  }

  Widget buildPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Style1().titleCustom('ร้าน ${cartModels[0].nameShop} ', 20.0,
                    Colors.amber, FontWeight.bold),
              ],
            ),
            Style1().titleCustom('ระยะทาง ${cartModels[0].distance} km.', 16.0,
                Colors.black, FontWeight.bold),
            Style1().titleCustom('ค่าส่ง ${cartModels[0].dec} Bath.', 16.0,
                Colors.black, FontWeight.bold),
            Style1().adjustBox(2, 10),
            showTitle(),
            buildListFood(),
            Divider(),
            buildTotal(),
            clearOrderButtom(),
          ],
        ),
      ),
    );
  }

  Widget clearOrderButtom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RaisedButton.icon(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.amber,
            onPressed: () {
              confirmDelete();
            },
            icon: Icon(Icons.delete_forever),
            label: Text('ลบรายการอาหารทั้งหมด')),
      ],
    );
  }

  Widget buildTotal() => Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Style1().titleCustom(
                    'Total = ', 16.0, Colors.black, FontWeight.bold),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text('$cartSum  bath'),
          )
        ],
      );

  Row showTitle() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Style1().titleWidget('รายการอาหาร'),
        ),
        Expanded(
          flex: 1,
          child: Style1().titleWidget('ราคา'),
        ),
        Expanded(
          flex: 1,
          child: Style1().titleWidget('จำนวน'),
        ),
        Expanded(
          flex: 1,
          child: Style1().titleWidget('รวม'),
        ),
        Expanded(child: Style1().mysizebox())
      ],
    );
  }

  Widget buildListFood() => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: cartModels.length,
        itemBuilder: (context, index) => Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(cartModels[index].nameFood),
            ),
            Expanded(
              flex: 1,
              child: Text(cartModels[index].price),
            ),
            Expanded(
              flex: 1,
              child: Text(cartModels[index].amount),
            ),
            Expanded(
              flex: 1,
              child: Text(cartModels[index].sum),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () async {
                  int id = cartModels[index].id;
                  print("Click !! $id");
                  await SQLite().delSQLiteWhereID(id).then((value) {
                    print('Del $id = success');
                    readSQLite();
                  });
                },
              ),
            )
          ],
        ),
      );

  Future<Null> confirmDelete() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text("ต้องการลบรายการอาหารทั้งหมดใช่หรือไม่ ? "),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton.icon(
                color: Colors.green.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await SQLite().clearSQLite().then((value) {
                    readSQLite();
                  });
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
}
