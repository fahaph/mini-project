import 'package:account/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/transaction_provider.dart';

class FormScreen extends StatelessWidget {
  FormScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('แบบฟอร์มข้อมูล', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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
                      labelText: 'ชื่อรายการ',
                      // border: InputBorder.none,
                      // focusedBorder: OutlineInputBorder(
                      //   borderSide: BorderSide(
                      //       color: Color.fromARGB(255, 51, 184, 255)),
                      // ),
                    ),
                    autofocus: true,
                    controller: titleController,
                    validator: (String? str) {
                      if (str!.isEmpty) {
                        return 'กรุณากรอกข้อมูล';
                      }
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'จำนวนเงิน',
                      // focusColor: Color.fromARGB(255, 0, 150, 255),
                    ),
                    keyboardType: TextInputType.number,
                    controller: amountController,
                    validator: (String? input) {
                      try {
                        double amount = double.parse(input!);
                        if (amount < 0) {
                          return 'กรุณากรอกข้อมูลมากกว่า 0';
                        }
                      } catch (e) {
                        return 'กรุณากรอกข้อมูลเป็นตัวเลข';
                      }
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
                          var statement = Transaction(
                              title: titleController.text,
                              amount: double.parse(amountController.text),
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
