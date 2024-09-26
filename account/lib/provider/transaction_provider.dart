import 'package:flutter/foundation.dart';
import 'package:account/database/transaction_db.dart';
import 'package:account/models/transactions.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> transactions = [];

  List<Transaction> getTransaction() {
    return transactions;
  }

  void addTransaction(Transaction transaction) async{
    var db = await TransactionDB(dbName: 'transactions.db').openDatabase();
    transactions.add(transaction);
    notifyListeners();
  }

  void deleteTransaction(int index) {
    transactions.removeAt(index);
    notifyListeners(); 
  }
}