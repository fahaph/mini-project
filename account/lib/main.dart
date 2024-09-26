import 'package:flutter/material.dart';
import 'package:account/screen/form_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/transaction_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

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
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 150, 255)),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        title: '',
        home: const MyHomePage(title: 'แอพบัญชี'),
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
  // int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     // _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor:Color.fromARGB(255, 0, 150, 255),

        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //     bottomLeft: Radius.circular(10),
        //     bottomRight: Radius.circular(10),
        //   ),
        // ),

        title: Text(widget.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),

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
              child: Text('ไม่มีรายการ'),
            );
          } else {
            return ListView.builder(
              itemCount: provider.transactions.length,
              itemBuilder: (context, index) {
                var statement = provider.transactions[index];
                return Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: ListTile(
                    title: Text(statement.title),
                    subtitle: Text(DateFormat('MM/dd/yyyy hh:mm:ss')
                        .format(statement.date)),
                    leading: CircleAvatar(
                      radius: 20,
                      child: FittedBox(
                        child: Text('${statement.amount}'),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('Warning'),
                          content: Text('Are you sure you want to delete it?'),
                          actions: [
                            TextButton(onPressed: (){
                              Navigator.of(context).pop();
                              provider.deleteTransaction(index);
                            },
                            child: Text('Delete')
                            ),
                            TextButton(onPressed: (){
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel')
                            ),
                          ],
                        )
                        );
                        // provider.deleteTransaction(index);
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
