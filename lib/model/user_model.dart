class UserModel {
  String id;
  String usertype;
  String name;
  String username;
  String password;

  UserModel({this.id, this.usertype, this.name, this.username, this.password});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usertype = json['usertype'];
    name = json['name'];
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['usertype'] = this.usertype;
    data['name'] = this.name;
    data['username'] = this.username;
    data['password'] = this.password;
    return data;
  }
}
