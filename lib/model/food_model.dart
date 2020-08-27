class FoodModel {
  String id;
  String idShop;
  String foodName;
  String imgPath;
  String price;
  String info;

  FoodModel(
      {this.id,
      this.idShop,
      this.foodName,
      this.imgPath,
      this.price,
      this.info});

  FoodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idShop = json['idShop'];
    foodName = json['foodName'];
    imgPath = json['imgPath'];
    price = json['price'];
    info = json['info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idShop'] = this.idShop;
    data['foodName'] = this.foodName;
    data['imgPath'] = this.imgPath;
    data['price'] = this.price;
    data['info'] = this.info;
    return data;
  }
}
