import 'package:flutter/material.dart';
import 'package:final_project/database/database.dart';

class CarListPage extends StatefulWidget {
  final AppDatabase database;

  const CarListPage({super.key, required this.database});

  @override
  State<CarListPage> createState() => CarListPageState();
}

class CarListPageState extends State<CarListPage> {
  // Text editing controllers for the text fields

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car List'),
      ),
      body: const Center(
        child: Text('Car List Page'),
      ),
    );
  }
}


