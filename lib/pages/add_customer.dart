import 'package:flutter/material.dart';
import 'package:final_project/database/database.dart';
import 'package:final_project/dao/customer_dao.dart';
import 'package:final_project/entity/customer.dart';
import 'package:final_project/repository/customer_repository.dart';


class AddCustomerPage extends StatefulWidget {
  final AppDatabase database;
  final List<Customer> customers;
  final Customer? customerToEdit; // Nullable customer for editing

  const AddCustomerPage({super.key, required this.database, required this.customers, this.customerToEdit,});

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

  //Colours
  var navColour = 0xFF14213D;
  var accentColour = 0xFFFCA311;
  var forGroundColour = 0xFF000000;
  var gridColour = 0xFFE5E5E5;

  @override
  void initState() {
    super.initState();
    dao = widget.database.customerDao;

    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    addressController = TextEditingController();
    birthdayController = TextEditingController();

    // Prepopulate fields if editing
    if (widget.customerToEdit != null) {
      firstNameController.text = widget.customerToEdit!.firstName;
      lastNameController.text = widget.customerToEdit!.lastName;
      addressController.text = widget.customerToEdit!.address;
      birthdayController.text = widget.customerToEdit!.birthday;

      // Check if there are existing customers and show the dialog
    } else if (widget.customers.isNotEmpty) {
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

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Customer Data Loaded!"))
      );
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

    // Validate the birthday format (YYYY-MM-DD)
    final String birthday = birthdayController.text.trim();
    final RegExp dateRegEx = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegEx.hasMatch(birthday)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid date format. Use YYYY-MM-DD.')),
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
      birthday,
      addressController.text.trim(),
    );

    // Insert the customer into the database
    await dao.insertCustomer(newCustomer);

    // Save customer data for next customer entry
    saveDataForNextCustomer();

    // Go back to the previous page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Customer added successfully!')),
    );
    Navigator.pop(context, true); // Return 'true' to indicate a new customer was added

    // Clear fields for next input
    firstNameController.clear();
    lastNameController.clear();
    addressController.clear();
    birthdayController.clear();
  }

  void updateCustomer() async {

    // Saves updates customer information into a new record
    addCustomer();

    // Delete customer with outdated information
    await dao.deleteCustomerById(widget.customerToEdit!.id);
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
    final isEditing = widget.customerToEdit != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Customer' : 'Add Customer',
          style: const TextStyle(
              color: Colors.white
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFFCA311), // Change the arrow color here
        ),
        backgroundColor: Color(navColour),
      ),
      body: Center(
        child: Card(
          color: Color(navColour),
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
                      isEditing ? 'Edit Customer Details' : 'Customer Details',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white, // Text color set to white
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        labelStyle: TextStyle(color: Colors.white70), // Set label color to white
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.white), // Set text color to white
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: TextStyle(color: Colors.white70), // Set label color to white
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.white), // Set text color to white
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        labelStyle: TextStyle(color: Colors.white70), // Set label color to white
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.white), // Set text color to white
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: birthdayController,
                      decoration: const InputDecoration(
                        labelText: 'Birthday (YYYY-MM-DD)',
                        labelStyle: TextStyle(color: Colors.white70), // Set label color to white
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.white), // Set text color to white
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isEditing ? updateCustomer : addCustomer,
                      child: Text(
                        isEditing ? 'Save Changes' : 'Add Customer',
                        style: const TextStyle(color: Colors.black), // Set button text color to white
                      ),
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
