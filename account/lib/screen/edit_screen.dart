import 'package:account/models/transactions.dart';
import 'package:account/provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditScreen extends StatefulWidget {
  final Transactions dStatement;
  EditScreen({required this.dStatement});
  // super.key,
  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late final String dTitle;
  late final String dResta;
  late final double dPrice;
  late final double dRating;
  late final DateTime dDate;
  late final String dImgPath;

  late String? updatedTitle;
  late String? updatedResta;
  late double? updatedPrice;
  late double? updatedRating;
  late String? updatedImgPath;

  late TextEditingController _titleEditingController;
  late TextEditingController _restaEditingController;
  late TextEditingController _priceEditingController;

  @override
  // ฟังก์ชั่นติดตั้งข้อมูลเบื้องต้น เมื่อที่นี่เริ่มทำงาน
  void initState() {
    super.initState();
    dTitle = widget.dStatement.title;
    dResta = widget.dStatement.resta;
    dPrice = widget.dStatement.price;
    dRating = widget.dStatement.rating;
    dDate = widget.dStatement.date;
    dImgPath = widget.dStatement.imgPath;

    _titleEditingController = TextEditingController(text: dTitle);
    _restaEditingController = TextEditingController(text: dResta);
    _priceEditingController = TextEditingController(text: dPrice.toString());

    updatedTitle = dTitle;
    updatedResta = dResta;
    updatedPrice = dPrice;
    updatedRating = dRating;
    updatedImgPath = dImgPath;
  }

  final formKey = GlobalKey<FormState>();

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
          child: SingleChildScrollView(
            child: Form(
                key: formKey,
                child: Column(children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Menu',
                    ),
                    autofocus: true,
                    controller: _titleEditingController,
                    onChanged: (value) {
                      setState(() {
                        updatedTitle = value;
                      });
                    },
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
                    onChanged: (value) {
                      setState(() {
                        updatedResta = value;
                      });
                    },
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
                    onChanged: (value) {
                      setState(() {
                        // เช็ค null
                        if (value.isEmpty) {
                          updatedPrice = 0.0;
                        } else {
                          updatedPrice = double.parse(value);
                        }
                        // updatedPrice = double.parse(value);
                      });
                    },
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
                    initialRating: dRating,
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
                      updatedRating = rating;
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
                          var dStatement = Transactions(
                              title: dTitle,
                              resta: dResta,
                              rating: dRating,
                              price: dPrice,
                              date: dDate,
                              imgPath: dImgPath);

                          var updatedStatement = Transactions(
                              title: updatedTitle!,
                              resta: updatedResta!,
                              rating: updatedRating!,
                              price: updatedPrice!,
                              date: dDate,
                              imgPath: updatedImgPath!);

                          // add transaction data object to provider
                          var provider = Provider.of<TransactionProvider>(
                              context,
                              listen: false);

                          provider.updateTransaction(
                              dStatement, updatedStatement);

                          Navigator.pop(context);
                        }
                      })
                ])),
          ),
        ));
  }
}
