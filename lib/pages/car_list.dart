import 'package:flutter/material.dart';

class CarListPage extends StatefulWidget {
  const CarListPage({super.key});

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


