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
    var keyID = await store.add(db, {
      "keyID": transaction.keyID,
      "title": transaction.title,
      "resta": transaction.resta,
      "rating": transaction.rating,
      "price": transaction.price,
      "date": transaction.date.toIso8601String(),
      "imgPath": transaction.imgPath
    });

    print('Added new transaction (keyID: ${keyID})');
    db.close();
    return keyID;
  }

  Future deleteDatabase(int keyID) async {
    // เปิด database บันทึกไว้ที่ db
    var db = await this.openDatabase();
    //สร้างตัวแปร ที่ไปยัง database ที่ชื่อ expense
    var store = intMapStoreFactory.store('expense');

    await store.delete(db, finder: Finder(filter: Filter.equals(Field.key, keyID)));

    // json
    // await store.delete(db,
    //     finder: Finder(
    //         filter: Filter.and([
    //       Filter.equals('title', transaction.title),
    //       Filter.equals('resta', transaction.resta),
    //       Filter.equals('rating', transaction.rating),
    //       Filter.equals('price', transaction.price),
    //       Filter.equals('date', transaction.date.toIso8601String()),
    //       Filter.equals('imgPath', transaction.imgPath),
    //     ])));

    print('Deleted (keyID: ${keyID})');
    db.close();
    // return keyID;
  }

  // Future updateDatabase(Transactions dTransaction, Transactions updatedTransaction) async {
  //   // เปิด database บันทึกไว้ที่ db
  //   var db = await this.openDatabase();
  //   //สร้างตัวแปร ที่ไปยัง database ที่ชื่อ expense
  //   var store = intMapStoreFactory.store('expense');

  //   // ค้นหาข้อมูลที่ตรงกับ dTransaction โดยใช้ value ของมัน
  //   final finder = Finder(
  //       filter: Filter.and([
  //     Filter.equals('title', dTransaction.title),
  //     Filter.equals('resta', dTransaction.resta),
  //     Filter.equals('rating', dTransaction.rating),
  //     Filter.equals('price', dTransaction.price),
  //     Filter.equals('date', dTransaction.date.toIso8601String()),
  //     Filter.equals('imgPath', dTransaction.imgPath),
  //   ]));

  //   // ค้นหาว่า record ที่ต้องการอัปเดตมีอยู่หรือไม่
  //   final recordSnapshot = await store.findFirst(db, finder: finder);

  //   // ถ้าพบ record ที่ต้องการ
  //   if (recordSnapshot != null) {
  //     // ทำการอัปเดตข้อมูลใหม่ทับ record เดิม
  //     await store.record(recordSnapshot.key).update(db, updatedTransaction.toMap());
  //   }
  //   db.close();
  // }

  updateDatabase(Transactions statement) async{
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store('expense');
    var filter = Finder(filter: Filter.equals(Field.key, statement.keyID));
    var result = store.update(db, finder: filter,  {
      "title": statement.title,
      "resta": statement.resta,
      "rating": statement.rating,
      "price": statement.price,
      "date": statement.date.toIso8601String(),
      "imgPath": statement.imgPath
    });
    db.close();
    print('update result: $result');
  }

  Future<List<Transactions>> loadAllData() async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store('expense');

    // ในวงเล็บของ find จะดึง db ที่ใช้ Finder ในการเรียงข้อมูล (sortOrder) เป็น false กล่าวคือให้ key กลับจากมากไปน้อย (ข้อมูลที่ถูกบันทึกที่หลัง ไปยังข้อมูลที่เก่ากว่า)
    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder(Field.key, false)]));

    // สร้างตัวแปรไว้เก็บข้อมูล transaction
    List<Transactions> transactionList = [];

    // ลูปเพิ่มข้อมูลจาก snapshot ไปยังตัวแปร transactionList
    for (var record in snapshot) {
      transactionList.add(Transactions(
        keyID: record.key,
        title: record['title'].toString(),
        resta: record['resta'].toString(),
        rating: double.parse(record['rating'].toString()),
        price: double.parse(record['price'].toString()),
        date: DateTime.parse(record['date'].toString()),
        imgPath: record['imgPath'].toString(),
      ));
    }
    print(snapshot);
    return transactionList;
  }
}
