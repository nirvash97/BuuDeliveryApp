class CartModel {
  int id;
  String idShop;
  String nameShop;
  String idFood;
  String nameFood;
  String price;
  String amount;
  String sum;
  String distance;
  String dec;

  CartModel(
      {this.id,
      this.idShop,
      this.nameShop,
      this.idFood,
      this.nameFood,
      this.price,
      this.amount,
      this.sum,
      this.distance,
      this.dec});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idShop = json['idShop'];
    nameShop = json['nameShop'];
    idFood = json['idFood'];
    nameFood = json['nameFood'];
    price = json['price'];
    amount = json['amount'];
    sum = json['sum'];
    distance = json['distance'];
    dec = json['dec'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idShop'] = this.idShop;
    data['nameShop'] = this.nameShop;
    data['idFood'] = this.idFood;
    data['nameFood'] = this.nameFood;
    data['price'] = this.price;
    data['amount'] = this.amount;
    data['sum'] = this.sum;
    data['distance'] = this.distance;
    data['dec'] = this.dec;
    return data;
  }
}
