import 'package:buudeli/util/style1.dart';
import 'package:flutter/material.dart';

class AddFoodMenu extends StatefulWidget {
  @override
  _AddFoodMenuState createState() => _AddFoodMenuState();
}

class _AddFoodMenuState extends State<AddFoodMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มรายการอาหาร'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            headerText('Add Food Image'),
            groupImage(),
            headerText('รายละเอียดอาหาร'),
            Style1().mysizebox(),
            nameform(),
            Style1().mysizebox(),
            priceform(),
            Style1().mysizebox(),
            foodInfoform(),
            Style1().mysizebox(),
            saveButton()
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      width: 300.0,
      child: RaisedButton.icon(
        color: Colors.amber,
        onPressed: () {},
        icon: Icon(Icons.save),
        label: Text('บันทึกข้อมูล'),
      ),
    );
  }

  Widget nameform() => Container(
        width: 250.0,
        child: TextField(
          decoration: InputDecoration(
            labelText: 'ชื่ออาหาร',
            prefixIcon: Icon(Icons.fastfood),
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget priceform() => Container(
        width: 250.0,
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'ราคา',
            prefixIcon: Icon(Icons.attach_money),
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget foodInfoform() => Container(
        width: 250.0,
        child: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: 'รายละเอียด',
            prefixIcon: Icon(Icons.info),
            border: OutlineInputBorder(),
          ),
        ),
      );

  Container groupImage() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Style1().adjustBox(5, 10),
          IconButton(icon: Icon(Icons.add_a_photo), onPressed: null),
          Container(
            width: 250.0,
            height: 250.0,
            child: Image.asset('images/addfood2.png'),
          ),
          IconButton(icon: Icon(Icons.add_photo_alternate), onPressed: null),
          Style1().adjustBox(5, 10),
        ],
      ),
    );
  }

  Widget headerText(String text) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Style1().showname(text),
        ],
      ),
    );
  }
}
