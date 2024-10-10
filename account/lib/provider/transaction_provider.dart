import 'package:account/databases/transaction_db.dart';
import 'package:flutter/foundation.dart';
import 'package:account/models/transactions.dart';

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

    // var keyID = 
    await db.insertDatabase(transaction);
    transactions = await db.loadAllData();

    notifyListeners();
  }

  void deleteTransaction(int keyID) async{
    var db = await TransactionDB(dbName: 'transactions.db');
    await db.deleteDatabase(keyID);
    transactions = await db.loadAllData();

    notifyListeners(); 
  }

  void updateTransaction(Transactions transaction) async{
    var db = await TransactionDB(dbName: 'transactions.db');
    await db.updateDatabase(transaction);
    transactions = await db.loadAllData();

    notifyListeners();
  }
}