import 'package:account/models/transactions.dart';
import 'package:account/provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditScreen extends StatelessWidget {

  

  // String _title = 'title';
  // String _resta = 'resta';
  // double _price = 99.9;

  double _rating = 3;
  EditScreen({super.key});

  final formKey = GlobalKey<FormState>();

  TextEditingController _titleEditingController = new TextEditingController()..text = 'default title';
  TextEditingController _restaEditingController = new TextEditingController()..text = 'default resta';
  TextEditingController _priceEditingController = new TextEditingController()..text = '999';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 150, 255),
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
        ),
        title: const Text(
          'Edit',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
            key: formKey,
            child: Column(children: [
              TextFormField(
                // initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Menu',
                ),
                autofocus: true,
                controller: _titleEditingController,
                validator: (String? str) {
                  if (str!.isEmpty) {
                    return 'Please Insert Info';
                  }
                  return null;
                },
              ),
              TextFormField(
                // initialValue: _resta,
                decoration: InputDecoration(
                  labelText: 'Restaurant',
                ),
                autofocus: true,
                controller: _restaEditingController,
                validator: (String? str) {
                  if (str!.isEmpty) {
                    return 'Please Insert Info';
                  }
                  return null;
                },
              ),
              TextFormField(
                // initialValue: _price.toString(),
                decoration: const InputDecoration(
                  labelText: 'Price',
                ),
                keyboardType: TextInputType.number,
                controller: _priceEditingController,
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
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                  _rating = rating;
                },
              ),
              SizedBox(height: 15),
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 150, 255),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Save',
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // create transaction data object
                      var statement = Transactions(
                          title: _titleEditingController.text,
                          resta: _restaEditingController.text,
                          rating: _rating,
                          price: double.parse(_priceEditingController.text),
                          date: DateTime.now());

                      // add transaction data object to provider
                      var provider = Provider.of<TransactionProvider>(context,
                          listen: false);

                      provider.editTransaction(statement);
                      print(statement.title);
                      print(statement.resta);
                      print(statement.rating);
                      print(statement.price);
                      print(statement.date);
                      Navigator.pop(context);
                    }
                  })
            ])),
      ),
    );
  }
}
