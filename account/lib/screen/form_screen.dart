import 'package:account/databases/img_path.dart';
import 'package:account/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/transaction_provider.dart';

// ignore: must_be_immutable
class FormScreen extends StatelessWidget {
  double _rating = 3;
  String _imgPath = 'assets/images/food.png';

  FormScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final restaController = TextEditingController();
  final priceController = TextEditingController();

  

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
            'Form',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Padding(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
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

                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          label: Text("Type")
                        ),
                          value: ImgPath.food,
                          items: ImgPath.values.map((key) {
                            return DropdownMenuItem(
                              value: key,
                              child: Text(key.title));
                          }).toList(),
                          onChanged: (type) {
                            _imgPath = type!.imgPath.toString();
                            print(_imgPath);
                          }
                      ),

                      SizedBox(height: 15),
                      RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        glow: false,
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
                                  title: titleController.text,
                                  resta: restaController.text,
                                  rating: _rating,
                                  price: double.parse(priceController.text),
                                  date: DateTime.now(),
                                  imgPath: _imgPath);

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
            )));
  }
}
