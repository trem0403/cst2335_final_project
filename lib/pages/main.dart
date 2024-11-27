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
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF14213D)),
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
  final String title;

  const MyHomePage({super.key, required this.database, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Customer List',
      'icon': Icons.person,
      'page': (context, database) => CustomerListPage(database: database),
    },
    {
      'title': 'Car List',
      'icon': Icons.directions_car,
      'page': (context, database) => CarListPage(database: database),
    },
    {
      'title': 'Car Dealership List',
      'icon': Icons.storefront,
      'page': (context, database) => CarDealershipListPage(database: database),
    },
    {
      'title': 'Sales List',
      'icon': Icons.attach_money,
      'page': (context, database) => SalesListPage(database: database),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF14213D),
        leading: const Icon(
          Icons.home,
          color: Color(0xFFFCA311),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          buildPositionedCard(
            context,
            menuItems[0],
            Alignment.topLeft,
          ),
          buildPositionedCard(
            context,
            menuItems[1],
            Alignment.topRight,
          ),
          buildPositionedCard(
            context,
            menuItems[2],
            Alignment.bottomLeft,
          ),
          buildPositionedCard(
            context,
            menuItems[3],
            Alignment.bottomRight,
          ),
        ],
      ),
    );
  }

  Widget buildPositionedCard(
      BuildContext context, Map<String, dynamic> item, Alignment alignment) {
    // Get the media query orientation
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    // Adjust width and height based on orientation
    double cardWidth = isPortrait
        ? MediaQuery.of(context).size.width * 0.45  // 45% of the screen width in portrait
        : MediaQuery.of(context).size.width * 0.48; // 48% of the screen width in landscape
    double cardHeight = isPortrait
        ? MediaQuery.of(context).size.height * 0.43  // 43% of the screen height in portrait
        : MediaQuery.of(context).size.height * 0.35; // 35% of the screen height in landscape

    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => item['page'](context, widget.database),
                ),
              );
            },
            child: Card(
              color: Color(0xFFFCA311),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'], size: 48, color: Colors.white),
                  const SizedBox(height: 12),
                  Text(
                    item['title'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
