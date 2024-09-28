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
        home: const MyHomePage(title: 'Menu'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                                    Text('Are you sure you want to edit it?'),
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
                                          return EditScreen(dStatement: statement,);
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
                    title: Text('${statement.title} - ${statement.resta}'),
                    subtitle: Text(DateFormat('dd/MM/yyyy hh:mm:ss aaa')
                        .format(statement.date)),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color.fromARGB(124, 255, 230, 146),
                      child: FittedBox(
                        child: Text('${statement.rating}/5.0'),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
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
                                          provider.deleteTransaction(statement);
                                        },
                                        child: Text('Delete'),
                                        style: TextButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.red)),
                                  ],
                                ));
                      },
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
