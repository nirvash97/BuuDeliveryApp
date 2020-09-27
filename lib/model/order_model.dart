class OrderModel {
  String id;
  String orderDate;
  String idUser;
  String nameUser;
  String idShop;
  String nameShop;
  String distance;
  String transport;
  String idFood;
  String nameFood;
  String price;
  String amount;
  String sum;
  String rider;
  String process;

  OrderModel(
      {this.id,
      this.orderDate,
      this.idUser,
      this.nameUser,
      this.idShop,
      this.nameShop,
      this.distance,
      this.transport,
      this.idFood,
      this.nameFood,
      this.price,
      this.amount,
      this.sum,
      this.rider,
      this.process});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderDate = json['orderDate'];
    idUser = json['idUser'];
    nameUser = json['nameUser'];
    idShop = json['idShop'];
    nameShop = json['nameShop'];
    distance = json['distance'];
    transport = json['transport'];
    idFood = json['idFood'];
    nameFood = json['nameFood'];
    price = json['price'];
    amount = json['amount'];
    sum = json['sum'];
    rider = json['rider'];
    process = json['process'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderDate'] = this.orderDate;
    data['idUser'] = this.idUser;
    data['nameUser'] = this.nameUser;
    data['idShop'] = this.idShop;
    data['nameShop'] = this.nameShop;
    data['distance'] = this.distance;
    data['transport'] = this.transport;
    data['idFood'] = this.idFood;
    data['nameFood'] = this.nameFood;
    data['price'] = this.price;
    data['amount'] = this.amount;
    data['sum'] = this.sum;
    data['rider'] = this.rider;
    data['process'] = this.process;
    return data;
  }
}
