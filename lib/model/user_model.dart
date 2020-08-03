class UserModel {
  String id;
  String usertype;
  String name;
  String username;
  String password;
  String nameShop;
  String address;
  String phone;
  String imageUrl;
  String lat;
  String lng;
  String token;

  UserModel(
      {this.id,
      this.usertype,
      this.name,
      this.username,
      this.password,
      this.nameShop,
      this.address,
      this.phone,
      this.imageUrl,
      this.lat,
      this.lng,
      this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usertype = json['usertype'];
    name = json['name'];
    username = json['username'];
    password = json['password'];
    nameShop = json['NameShop'];
    address = json['Address'];
    phone = json['Phone'];
    imageUrl = json['ImageUrl'];
    lat = json['Lat'];
    lng = json['Lng'];
    token = json['Token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['usertype'] = this.usertype;
    data['name'] = this.name;
    data['username'] = this.username;
    data['password'] = this.password;
    data['NameShop'] = this.nameShop;
    data['Address'] = this.address;
    data['Phone'] = this.phone;
    data['ImageUrl'] = this.imageUrl;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    data['Token'] = this.token;
    return data;
  }
}
