import 'package:flutter/material.dart';
import 'package:final_project/database/database.dart';

class CustomerListPage extends StatefulWidget {
  final AppDatabase database;

  const CustomerListPage({super.key, required this.database});

  @override
  State<CustomerListPage> createState() => CustomerListPageState();
}

class CustomerListPageState extends State<CustomerListPage> {
  // Text editing controllers for the text fields

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer List'),
      ),
      body: const Center(
        child: Text('Customer List Page'),
      ),
    );
  }
}


