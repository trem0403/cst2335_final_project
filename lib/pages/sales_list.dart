import 'package:flutter/material.dart';

class SalesListPage extends StatefulWidget {
  const SalesListPage({super.key});

  @override
  State<SalesListPage> createState() => SalesListPageState();
}

class SalesListPageState extends State<SalesListPage> {
  // Text editing controllers for the text fields

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales List'),
      ),
      body: const Center(
        child: Text('Sales List Page'),
      ),
    );
  }
}


