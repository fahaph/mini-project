import 'dart:io';
import 'package:account/models/transactions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
// import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class TransactionDB {
  String dbName;

  TransactionDB({required this.dbName});

  Future<Database> openDatabase() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();

    String dbLocation = join(appDirectory.path, dbName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);

    return db;
  }

  Future<int> insertDatabase(Transactions transaction) async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory
        .store('expense'); //สร้างตัวแปร ที่จะไปสร้าง db ที่ชื่อ expense

    // json
    var keyID = store.add(db, {
      "title": transaction.title,
      "amount:": transaction.amount,
      "date": transaction.date.toIso8601String(),
    });
    db.close();
    return keyID;
  }

  Future<List<Transactions>> loadAllData() async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store('expense');
    var snapshot = await store.find(db);

    // สร้างตัวแปรไว้เก็บข้อมูล transaction
    List<Transactions> transactionList = [];

    // ลูปเพิ่มข้อมูลจาก snapshot ไปยังตัวแปร transactionList
    for (var record in snapshot) {
      transactionList.add(Transactions(
        title: record['title'].toString(),
        amount: double.parse(record['amount'].toString()),
        date: DateTime.parse(record['date'].toString()),
      ));
    }
    return transactionList;
  }
}
