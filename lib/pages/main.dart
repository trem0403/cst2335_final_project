import 'package:flutter/material.dart';
import 'package:final_project/pages/car_list.dart';
import 'package:final_project/pages/car_dealership_list.dart';
import 'package:final_project/pages/customer_list.dart';
import 'package:final_project/pages/sales_list.dart';
import 'package:final_project/database/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'Home Page',
        database: database,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final AppDatabase database;

  const MyHomePage({super.key, required this.database, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerListPage(database: widget.database),
                  ),
                );
              },
              child: const Text('Customer List'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarListPage(database: widget.database),
                  ),
                );
              },
              child: const Text('Car List'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarDealershipListPage(database: widget.database),
                  ),
                );
              },
              child: const Text('Car Dealership List'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SalesListPage(database: widget.database),
                  ),
                );
              },
              child: const Text('Sales List'),
            ),
          ],
        ),
      ),
    );
  }
}
