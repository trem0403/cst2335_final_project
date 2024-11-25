import 'package:flutter/material.dart';
import 'package:final_project/database/database.dart';
import 'package:final_project/dao/customer_dao.dart';
import 'package:final_project/entity/customer.dart';
import 'package:final_project/repository/customer_repository.dart';


class AddCustomerPage extends StatefulWidget {
  final AppDatabase database;
  final List<Customer> customers;

  const AddCustomerPage({super.key, required this.database, required this.customers});

  @override
  State<AddCustomerPage> createState() => AddCustomerPageState();
}

class AddCustomerPageState extends State<AddCustomerPage> {
  late CustomerDao dao;


  // Text controllers for form fields
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController addressController;
  late TextEditingController birthdayController;

  @override
  void initState() {
    super.initState();
    dao = widget.database.customerDao;

    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    addressController = TextEditingController();
    birthdayController = TextEditingController();

    // Check if there are existing customers and show the dialog
    if (widget.customers.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCopyDataDialog();
      });
    }
  }


  Future<void> showCopyDataDialog() async {
    final shouldCopyData = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Copy Last Customer?"),
          content: const Text(
            "Do you want to copy details from the last customer entry?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
    if (shouldCopyData == true) {
      loadDataFromLastCustomer();
    }
  }

  void loadDataFromLastCustomer() async {
    setState(() {
      firstNameController.text = CustomerRepository.firstName;
      lastNameController.text = CustomerRepository.lastName;
      addressController.text = CustomerRepository.address;
      birthdayController.text = CustomerRepository.birthday;
    });
  }

  void saveDataForNextCustomer() async {
    CustomerRepository.firstName = firstNameController.text;
    CustomerRepository.lastName = lastNameController.text;
    CustomerRepository.address = addressController.text;
    CustomerRepository.birthday = birthdayController.text;

    CustomerRepository.saveData();
  }

  void addCustomer() async {

    //Save customer data for next customer entry
    saveDataForNextCustomer();

    // Validate that all fields are filled
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        addressController.text.isEmpty ||
        birthdayController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final int newId = Customer.ID; // Use static ID
    Customer.ID++; // Increment the static ID
    // Create a new Customer object
    final newCustomer = Customer(
      newId,
      firstNameController.text.trim(),
      lastNameController.text.trim(),
      birthdayController.text.trim(),
      addressController.text.trim(),
    );

    // Insert the customer into the database
    await dao.insertCustomer(newCustomer);

    // Go back to the previous page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Customer added successfully!')),
    );
    Navigator.pop(context, true); // Return 'true' to indicate a new customer was added
    firstNameController.clear();
    lastNameController.clear();
    addressController.clear();
    birthdayController.clear();
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Customer'),
      ),
      body: Center(
        child: Card(
          elevation: 5.0,
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Customer Details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the first name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the last name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: birthdayController,
                      decoration: const InputDecoration(
                        labelText: 'Birthday (YYYY-MM-DD)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the birthday';
                        }
                        final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                        if (!regex.hasMatch(value)) {
                          return 'Enter a valid date in YYYY-MM-DD format';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: addCustomer,
                      child: const Text('Add Customer'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
