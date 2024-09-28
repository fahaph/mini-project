import 'package:account/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/transaction_provider.dart';

class FormScreen extends StatelessWidget {
  FormScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final restaController = TextEditingController();
  final ratingController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Form', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor:Color.fromARGB(255, 0, 150, 255),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Menu',
                    ),
                    autofocus: true,
                    controller: titleController,
                    validator: (String? str) {
                      if (str!.isEmpty) {
                        return 'Please Insert Info';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Restaurant',
                    ),
                    autofocus: true,
                    controller: restaController,
                    validator: (String? str) {
                      if (str!.isEmpty) {
                        return 'Please Insert Info';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Rating',
                    ),
                    keyboardType: TextInputType.number,
                    controller: ratingController,
                    validator: (String? input) {
                      try {
                        double rating = double.parse(input!);
                        if (rating < 0) {
                          return 'Insert More Than or Equals 0';
                        }
                      } catch (e) {
                        return 'Please Insert Number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Price',
                    ),
                    keyboardType: TextInputType.number,
                    controller: priceController,
                    validator: (String? input) {
                      try {
                        double price = double.parse(input!);
                        if (price < 0) {
                          return 'Insert More Than or Equals 0';
                        }
                      } catch (e) {
                        return 'Please Insert Number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 0, 150, 255),
                          foregroundColor: Colors.white,
                        ),
                      child: const Text(
                        'บันทึก',
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // create transaction data object
                          var statement = Transactions(
                              title: titleController.text,
                              resta: restaController.text,
                              rating: double.parse(ratingController.text),
                              price: double.parse(priceController.text),
                              date: DateTime.now());

                          // add transaction data object to provider
                          var provider = Provider.of<TransactionProvider>(
                              context,
                              listen: false);

                          provider.addTransaction(statement);

                          Navigator.pop(context);
                        }
                      })
                ],
              )),
        ));
  }
}
