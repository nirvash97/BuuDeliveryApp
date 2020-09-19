import 'package:buudeli/model/cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLite {
  final String dbName = 'BuuDeli.db';
  final String dbtable = 'orderTable';
  int version = 1;
  final String idColumn = 'id';
  final String idShop = 'idShop';
  final String nameShop = 'nameShop';
  final String idFood = 'idFood';
  final String nameFood = 'nameFood';
  final String price = 'price';
  final String amount = 'amount';
  final String sum = 'sum';
  final String distance = 'distance';
  final String dec = 'dec'; //delivery cost

  SQLite() {
    initDatabase();
  }

  Future<Null> initDatabase() async {
    await openDatabase(join(await getDatabasesPath(), dbName),
        onCreate: (db, version) => db.execute(
            'CREATE TABLE $dbtable ($idColumn INTEGER PRIMARY KEY, $idShop TEXT, $nameShop TEXT, $idFood TEXT, $nameFood TEXT, $price TEXT, $amount TEXT, $sum TEXT, $distance TEXT, $dec TEXT)'),
        version: version);
  }

  Future<Database> connectDatabase() async {
    return openDatabase(join(await getDatabasesPath(), dbName));
  }

  Future<Null> insertDatabase(CartModel cartModel) async {
    Database database = await connectDatabase();
    try {
      database.insert(dbtable, cartModel.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print("error = ${e.toString()}");
    }
  }

  Future<List<CartModel>> readSQLiteData() async {
    Database database = await connectDatabase();
    List<CartModel> cartModels = List();

    List<Map<String, dynamic>> maps = await database.query(dbtable);
    for (var map in maps) {
      CartModel cartModel = CartModel.fromJson(map);
      cartModels.add(cartModel);
    }
    return cartModels;
  }

      Future<Null> delSQLiteWhereID(int id) async {
      Database database = await connectDatabase();
      try {
        await database.delete(dbtable , where: '$idColumn = $id');
      } catch (e) {
        print(e.toString());
      }
    }

      Future<Null> clearSQLite() async {
      Database database = await connectDatabase();
      try {
        await database.delete(dbtable );
      } catch (e) {
        print(e.toString());
      }
    }

}
