import 'package:account/screen/delete_screen.dart';
import 'package:account/screen/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:account/screen/form_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/transaction_provider.dart';

class Menus extends StatelessWidget {
  const Menus({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return TransactionProvider();
        }),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 150, 255)),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        title: '',
        home: const MenusScreen(title: 'Menu'),
      ),
    );
  }
}

class MenusScreen extends StatefulWidget {
  const MenusScreen({super.key, required this.title});

  final String title;

  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
  // โหลดข้อมูลก่อนสร้างหน้าต่าง
  @override
  void initState() {
    super.initState();

    // น่าจะเป็นการสร้างตัวแปรที่ดึงข้อมูลจาก class TransactionProvider ได้
    var provider = Provider.of<TransactionProvider>(context, listen: false);
    // เรียกใช้ initData() จาก class TransactionProvider
    provider.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DeleteScreen(title: 'Delete');
          }));
          // DeleteScreen(title: 'Delete');
        },
        backgroundColor: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 150, 255),
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
        ),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
            return const Center(
              child: Text('No Information'),
            );
          } else {
            return ListView.builder(
              itemCount: provider.transactions.length,
              itemBuilder: (context, index) {
                var statement = provider.transactions[index];
                return Card(
                  elevation: 2.5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: ListTile(
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: Text(
                                    '${statement.title} - ${statement.resta}'),
                                content:
                                    Text('Are you sure you want to edit it'),
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
                                          backgroundColor: Colors.green)),
                                ],
                              ));
                    },
                    title: Text(
                      '${statement.title} - ${statement.resta}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(DateFormat('dd/MM/yyyy hh:mm:ss aaa')
                        .format(statement.date), style: TextStyle(fontSize: 11),),
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          size: 25,
                          color: Colors.amber,
                        ),
                        Text(statement.rating.toString()),
                      ],
                    ),
                    trailing: FittedBox(
                      child: Text(
                        statement.price.toString(),
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}


// CircleAvatar(
//                       radius: 30,
//                       backgroundColor: const Color.fromARGB(124, 255, 230, 146),
//                       child: FittedBox(
//                         child: Text('${statement.rating}'),
//                       ),
//                     ),