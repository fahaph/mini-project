import 'package:account/databases/transaction_db.dart';
import 'package:flutter/foundation.dart';
import 'package:account/models/transactions.dart';
// import 'package:account/databases/transaction_db.dart';

class TransactionProvider with ChangeNotifier {
  List<Transactions> transactions = [];

  List<Transactions> getTransaction() {
    return transactions;
  }

  void initData() async{
    var db = await TransactionDB(dbName: 'transactions.db');
    transactions = await db.loadAllData();

    notifyListeners();
  }

  void addTransaction(Transactions transaction) async{
    var db = await TransactionDB(dbName: 'transactions.db');
    await db.insertDatabase(transaction);
    transactions = await db.loadAllData();

    notifyListeners();
  }

  void deleteTransaction(int index) async{
    var db = await TransactionDB(dbName: 'transactions.db');
    await db.deleteDatabase(index);
    transactions = await db.loadAllData();

    print(index);
    notifyListeners(); 
  }
}