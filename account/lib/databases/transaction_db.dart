import 'dart:io';
import 'package:account/models/transactions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
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
    // เปิด database บันทึกไว้ที่ db
    var db = await this.openDatabase();

    //สร้างตัวแปร ที่ไปยัง database ที่ชื่อ expense
    var store = intMapStoreFactory.store('expense');

    // json
    var keyID = store.add(db, {
      "title": transaction.title,
      "resta": transaction.resta,
      "rating": transaction.rating,
      "price": transaction.price,
      "date": transaction.date.toIso8601String(),
    });
    db.close();
    return keyID;
  }

  Future deleteDatabase(Transactions transaction) async{
    // เปิด database บันทึกไว้ที่ db
    var db = await this.openDatabase();
    //สร้างตัวแปร ที่ไปยัง database ที่ชื่อ expense
    var store = intMapStoreFactory.store('expense');
    
    // json
    await store.delete(db, finder: Finder(
      filter: Filter.and([
        Filter.equals('title', transaction.title),
        Filter.equals('resta', transaction.resta),
        Filter.equals('rating', transaction.rating),
        Filter.equals('price', transaction.price),
        Filter.equals('date', transaction.date.toIso8601String()),
      ])
    ));

    db.close();
    // return keyID;
  }

  Future updateDatabase(Transactions dTransaction, Transactions updatedTransaction) async{
    // เปิด database บันทึกไว้ที่ db
    var db = await this.openDatabase();
    //สร้างตัวแปร ที่ไปยัง database ที่ชื่อ expense
    var store = intMapStoreFactory.store('expense');

    db.close();
  }

  Future<List<Transactions>> loadAllData() async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store('expense');

    // ในวงเล็บของ find จะดึง db ที่ใช้ Finder ในการเรียงข้อมูล (sortOrder) เป็น false กล่าวคือให้ key กลับจากมากไปน้อย (ข้อมูลที่ถูกบันทึกที่หลัง ไปยังข้อมูลที่เก่ากว่า)
    var snapshot = await store.find(db, finder: Finder(sortOrders: [SortOrder(Field.key, false)]));

    // print(snapshot);

    // สร้างตัวแปรไว้เก็บข้อมูล transaction
    List<Transactions> transactionList = [];

    // ลูปเพิ่มข้อมูลจาก snapshot ไปยังตัวแปร transactionList
    for (var record in snapshot) {
      transactionList.add(Transactions(
        title: record['title'].toString(),
        resta: record['resta'].toString(),
        rating: double.parse(record['rating'].toString()),
        price: double.parse(record['price'].toString()),
        date: DateTime.parse(record['date'].toString()),
      ));
    }
    return transactionList;
  }
}
