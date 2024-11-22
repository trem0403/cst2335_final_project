import 'package:flutter/material.dart';
import 'package:final_project/database/database.dart';
import 'package:final_project/dao/customer_dao.dart';
import 'package:final_project/entity/customer.dart';

class CustomerListPage extends StatefulWidget {
  final AppDatabase database;

  const CustomerListPage({super.key, required this.database});

  @override
  State<CustomerListPage> createState() => CustomerListPageState();
}

class CustomerListPageState extends State<CustomerListPage> {
  late CustomerDao dao;
  Customer? selectedCustomer;
  List<Customer> customers = [];

  @override
  void initState() {
    super.initState();
    dao = widget.database.customerDao;
    loadCustomers();
  }

  void loadCustomers() async {
    var list = await dao.findAllCustomers();
    setState(() {
      customers = list;
    });
  }

  void insertCustomer() async {
    // Example logic to add a customer
    loadCustomers();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Customer added successfully")));
  }

  void updateCustomer() async {
    if (selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No customer selected for update")));
      return;
    }
    loadCustomers();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Customer updated successfully")));
  }

  void deleteCustomer() async {
    if (selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No customer selected for deletion")));
      return;
    }
    await dao.deleteCustomer(selectedCustomer!);
    setState(() {
      selectedCustomer = null; // Clear selection
    });
    loadCustomers();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Customer deleted successfully")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer List'),
      ),
      body: Center(
        child: reactiveLayout(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: "btnInsert",
              onPressed: insertCustomer,
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
              tooltip: "Insert Customer",
            ),
            FloatingActionButton(
              heroTag: "btnUpdate",
              onPressed: updateCustomer,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.edit),
              tooltip: "Update Customer",
            ),
            FloatingActionButton(
              heroTag: "btnDelete",
              onPressed: deleteCustomer,
              backgroundColor: Colors.red,
              child: const Icon(Icons.delete),
              tooltip: "Delete Customer",
            ),
          ],
        ),
      ),
    );
  }

  Widget reactiveLayout() {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    if ((width > height) && (width > 720)) {
      // Landscape
      return Row(
        children: [
          Expanded(flex: 1, child: customerList()),
          Expanded(flex: 2, child: detailsPage()),
        ],
      );
    } else {
      // Portrait
      if (selectedCustomer == null) {
        return customerList();
      } else {
        // Something is selected
        return detailsPage();
      }
    }
  }

  Widget detailsPage() {
    TextStyle st = const TextStyle(fontSize: 30.0);

    return Column(
      children: [
        if (selectedCustomer == null)
          Text("Please select a Customer from the list", style: st)
        else
          Text("You selected Customer : ${selectedCustomer!.id}", style: st),
        ElevatedButton(
          child: const Text("Ok"),
          onPressed: () {
            // Update GUI
            setState(() {
              selectedCustomer = null; // Clear the selection
            });
          },
        ),
      ],
    );
  }

  Widget customerList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          const Text(
            "Customers:",
            style: TextStyle(fontSize: 15),
          ),
          Flexible(
            child: customers.isEmpty
                ? const Center(child: Text("There are no customers available"))
                : ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCustomer = customers[index];
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 5.0),
                    child: Text(
                      "Customer: ${customer.id}",
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
