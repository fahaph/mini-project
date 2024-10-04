import 'package:account/screen/edit_screen.dart';
import 'package:account/screen/form_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/transaction_provider.dart';

class MenusScreen1 extends StatefulWidget {
  const MenusScreen1({super.key});

  @override
  State<MenusScreen1> createState() => _MenusScreen1State();
}
// ==============================================================================================================

class _MenusScreen1State extends State<MenusScreen1> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 15,
        backgroundColor: Color.fromARGB(255, 0, 150, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
        ),
        title: Row(children: [
          Image.asset(
            'assets/icon/icon2.png',
            width: 40,
            height: 40,
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            'Yummie',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ]),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.white,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FormScreen();
              }));
            },
          )
        ],
      ),
      body: Consumer<TransactionProvider>(
          builder: (context, provider, Widget? child) {
        if (provider.transactions.isEmpty) {
          return Center(
            child: Text('No data'),
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: GridView.builder(
              itemCount: provider.transactions.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                // crossAxisCount: 2,
                maxCrossAxisExtent: 225,
                // mainAxisSpacing: 10,
                // crossAxisSpacing: 10,
                childAspectRatio: 2.95 / 5,
              ),
              itemBuilder: (context, index) {
                var statement = provider.transactions[index];
                return Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: const Color.fromARGB(100, 0, 0, 0),
                            blurRadius: 5,
                            offset: Offset(3, 3))
                      ]),
                  child: Column(
                    children: [
                      Image.asset(
                        statement.imgPath,
                        width: 100,
                        height: 100,
                      ),
                      
                      SizedBox(
                        height: 4,
                      ),

                      RatingBar.builder(
                        initialRating: statement.rating,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        glow: false,
                        ignoreGestures: true,
                        itemSize: 15,
                        itemPadding: EdgeInsets.symmetric(horizontal: 2),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      // Text(statement.rating.toString()),

                      Container(
                        // color: Colors.green,
                        width: 150,
                        height: 30,
                        child: Center(
                          child: AutoSizeText(
                            statement.title,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            minFontSize: 1,
                          ),
                        ),
                      ),

                      Container(
                        // color: Colors.blue,
                        width: 150,
                        height: 17,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              '  ${statement.resta}',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                              maxLines: 1,
                              minFontSize: 1,
                            )
                          ],
                        ),
                      ),
                      Container(
                        // color: Colors.red,
                        width: 150,
                        height: 17,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              '  ${statement.price.toString()}',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                              maxLines: 1,
                              minFontSize: 1,
                            )
                          ],
                        ),
                      ),
                      Container(
                        // color: Colors.green,
                        width: 150,
                        height: 17,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              '  ${DateFormat('dd/MM/yy hh:mm aaa').format(statement.date)}',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                              maxLines: 1,
                              minFontSize: 1,
                            ),
                          ],
                        ),
                      ),

                      Container(
                        // color: Colors.green,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // FilledButton.icon(onPressed: onPressed, label: label)
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: Text(
                                              '${statement.title} - ${statement.resta}'),
                                          content: Text(
                                              'Are you sure you want to edit it'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Cancel')),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return EditScreen(
                                                      dStatement: statement,
                                                    );
                                                  }));
                                                  // provider.deleteTransaction(statement);
                                                },
                                                child: Text('Edit'),
                                                style: TextButton.styleFrom(
                                                    foregroundColor: Colors.white,
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 0, 150, 255))),
                                          ],
                                        ));
                              },
                              icon: Icon(Icons.edit),
                              iconSize: 17,
                              color: Color.fromARGB(255, 0, 150, 255),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: Text(
                                              '${statement.title} - ${statement.resta}'),
                                          content: Text(
                                              'Are you sure you want to delete it?'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Cancel')),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  provider.deleteTransaction(
                                                      statement.keyID!);
                                                  // print('deleting by keyID: ${statement.keyID}');
                                                },
                                                child: Text('Delete'),
                                                style: TextButton.styleFrom(
                                                    foregroundColor: Colors.white,
                                                    backgroundColor: Colors.red)),
                                          ],
                                        ));
                              },
                              icon: Icon(Icons.delete),
                              iconSize: 17,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }
}