import 'package:flutter/material.dart';
import 'package:final_project/database/database.dart';

class CarDealershipListPage extends StatefulWidget {
  final AppDatabase database;

  const CarDealershipListPage({super.key, required this.database});


  @override
  State<CarDealershipListPage> createState() => CarDealershipListPageState();
}

class CarDealershipListPageState extends State<CarDealershipListPage> {
  // Text editing controllers for the text fields

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Dealership List'),
      ),
      body: const Center(
        child: Text('Car Dealership List Page'),
      ),
    );
  }
}


