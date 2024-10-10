import 'package:account/databases/img_path.dart';
import 'package:account/main.dart';
import 'package:account/models/transactions.dart';
import 'package:account/provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditScreen extends StatefulWidget {
  final Transactions statement;
  EditScreen({required this.statement});
  // super.key,
  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();

  var Enum = ImgPath.food;

  final titleController = TextEditingController();
  final restaController = TextEditingController();
  final priceController = TextEditingController();
  late double _rating = 0;
  late String imgPath;

  @override
  // ฟังก์ชั่นติดตั้งข้อมูลเบื้องต้น เมื่อที่นี่เริ่มทำงาน
  void initState() {
    super.initState();
    imgPath = widget.statement.imgPath;
    _rating = widget.statement.rating;

    switch (imgPath) {
      case 'assets/images/food.png':
        {
          Enum = ImgPath.food;
        }
        break;
      case 'assets/images/fruit.png':
        {
          Enum = ImgPath.fruit;
        }
        break;
      case 'assets/images/snack.png':
        {
          Enum = ImgPath.snack;
        }
        break;
      case 'assets/images/beverage.png':
        {
          Enum = ImgPath.beverage;
        }
        break;
      default:
        {
          Enum = ImgPath.food;
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = widget.statement.title;
    restaController.text = widget.statement.resta;
    priceController.text = widget.statement.price.toString();
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
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
                key: formKey,
                child: Column(children: [
                  SizedBox(
                    height: 20,
                  ),
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
                    // initialValue: _resta,
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
                      decoration: InputDecoration(label: Text("Type")),
                      value: Enum,
                      items: ImgPath.values.map((key) {
                        return DropdownMenuItem(
                            value: key, child: Text(key.title));
                      }).toList(),
                      onChanged: (type) {
                        imgPath = type!.imgPath.toString();
                        // print(updatedImgPath);
                      }),
                  SizedBox(height: 15),
                  RatingBar.builder(
                    initialRating: widget.statement.rating,
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
                      // print(rating);
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
                              keyID: widget.statement.keyID,
                              title: titleController.text,
                              resta: restaController.text,
                              rating: _rating,
                              price: double.parse(priceController.text),
                              date: widget.statement.date,
                              imgPath: imgPath);

                          // add transaction data object to provider
                          var provider = Provider.of<TransactionProvider>(
                              context,
                              listen: false);

                          provider.updateTransaction(statement);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MyHomePage();
                              },
                            ),
                          );
                        }
                      })
                ])),
          ),
        ));
  }
}
