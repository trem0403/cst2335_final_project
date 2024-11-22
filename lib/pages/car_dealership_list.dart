import 'package:flutter/material.dart';

class CarDealershipListPage extends StatefulWidget {
  const CarDealershipListPage({super.key});

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


