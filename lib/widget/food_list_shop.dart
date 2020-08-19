import 'package:buudeli/screens/add_food_menu.dart';
import 'package:flutter/material.dart';

class FoodListShop extends StatefulWidget {
  @override
  _FoodListShopState createState() => _FoodListShopState();
}

class _FoodListShopState extends State<FoodListShop> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Text('รายการอาหารของร้าน'),
        addMenuButton(),
      ],
    );
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
                    Navigator.push(context, route);
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      );
}
