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
}
