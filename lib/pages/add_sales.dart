import 'package:flutter/material.dart';
import 'package:final_project/database/database.dart';
import 'package:final_project/dao/sales_dao.dart';
import 'package:final_project/entity/sales.dart';
import 'package:final_project/repository/sales_repository.dart';


class AddSalesPage extends StatefulWidget {
  final AppDatabase database;
  final List<Sales> sales;
  final Sales? salesToEdit; // Nullable sales for editing

  const AddSalesPage({super.key, required this.database, required this.sales, this.salesToEdit,});

  @override
  State<AddSalesPage> createState() => AddSalesPageState();
}

class AddSalesPageState extends State<AddSalesPage> {
  late SalesDao dao;

  // Text controllers for form fields
  late TextEditingController customerIDController;
  late TextEditingController carIDController;
  late TextEditingController carDealershipIDController;
  late TextEditingController dateOfPurchaseController;

  //Colours
  var navColour = 0xFF14213D;
  var accentColour = 0xFFFCA311;
  var forGroundColour = 0xFF000000;
  var gridColour = 0xFFE5E5E5;

  @override
  void initState() {
    super.initState();
    dao = widget.database.salesDao;

    customerIDController = TextEditingController();
    carIDController = TextEditingController();
    carDealershipIDController = TextEditingController();
    dateOfPurchaseController = TextEditingController();

    // Prepopulate fields if editing
    if (widget.salesToEdit != null) {
      customerIDController.text = widget.salesToEdit!.customerID.toString();
      carIDController.text = widget.salesToEdit!.carID.toString();
      carDealershipIDController.text = widget.salesToEdit!.carDealershipID.toString();
      dateOfPurchaseController.text = widget.salesToEdit!.dateOfPurchase;

      // Check if there are existing sales and show the dialog
    } else if (widget.sales.isNotEmpty) {
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
          title: const Text("Copy Last Sale?"),
          content: const Text(
            "Do you want to copy details from the last sales entry?",
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
      loadDataFromLastSales();
    }
  }

  void loadDataFromLastSales() async {
    setState(() {
      customerIDController.text = SalesRepository.customerID;
      carIDController.text = SalesRepository.carID;
      carDealershipIDController.text = SalesRepository.carDealershipID;
      dateOfPurchaseController.text = SalesRepository.dateOfPurchase;

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sales Data Loaded!"))
      );
    });
  }

  void saveDataForNextSales() async {
    SalesRepository.customerID = customerIDController.text;
    SalesRepository.carID = carIDController.text;
    SalesRepository.carDealershipID = carDealershipIDController.text;
    SalesRepository.dateOfPurchase = dateOfPurchaseController.text;

    SalesRepository.saveData();
  }

  void addSales() async {
    // Validate that all fields are filled
    if (customerIDController.text.isEmpty ||
        carIDController.text.isEmpty ||
        carDealershipIDController.text.isEmpty ||
        dateOfPurchaseController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Validate the date of purchase format (YYYY-MM-DD)
    final String dateOfPurchase = dateOfPurchaseController.text.trim();
    final RegExp dateRegEx = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegEx.hasMatch(dateOfPurchase)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid date format. Use YYYY-MM-DD.')),
      );
      return;
    }

    // Parse controllers into integers
    final customerID = int.tryParse(customerIDController.text.trim());
    final cariD = int.tryParse(carIDController.text.trim());
    final carDealershipID = int.tryParse(carDealershipIDController.text.trim());


    final int newId = Sales.ID; // Use static ID
    Sales.ID++; // Increment the static ID
    // Create a new Sales object
    final newSales = Sales(
      newId,
      customerID!,
      cariD!,
      carDealershipID!,
      dateOfPurchaseController.text.trim(),
    );

    // Insert the sale into the database
    await dao.insertSales(newSales);

    //Save sale data for next sale entry
    saveDataForNextSales();

    // Go back to the previous page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sales added successfully!')),
    );
    Navigator.pop(context, true); // Return 'true' to indicate a new sale was added
    customerIDController.clear();
    carIDController.clear();
    carDealershipIDController.clear();
    dateOfPurchaseController.clear();
  }

  void updateSales() async {

    // Saves updates sale information into a new record
    addSales();

    // Delete sale with outdated information
    await dao.deleteSalesById(widget.salesToEdit!.id);
  }


  @override
  void dispose() {
    // Dispose controllers to free resources
    customerIDController.dispose();
    carIDController.dispose();
    carDealershipIDController.dispose();
    dateOfPurchaseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.salesToEdit != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Sales' : 'Add Sales', style: const TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(
          color: Color(0xFFFCA311), // Change the arrow color here
        ),
        backgroundColor: Color(navColour),
      ),
      body: Center(
        child: Card(
          color: Color(gridColour),
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
                      isEditing ? 'Edit Sales Details' : 'Sales Details',

                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: customerIDController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Customer ID', border: OutlineInputBorder(),),
                      onChanged: (value) {
                        // Ensure that only valid integer values are entered
                        if (int.tryParse(value) == null && value.isNotEmpty) {
                          // Reset value
                          customerIDController.text = '';
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: carIDController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Car ID', border: OutlineInputBorder(),),
                      onChanged: (value) {
                        // Ensure that only valid integer values are entered
                        if (int.tryParse(value) == null && value.isNotEmpty) {
                          // Reset value
                          carIDController.text = '';
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: carDealershipIDController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Car Dealership ID', border: OutlineInputBorder(),),
                      onChanged: (value) {
                        // Ensure that only valid integer values are entered
                        if (int.tryParse(value) == null && value.isNotEmpty) {
                          // Reset value
                          carDealershipIDController.text = '';
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: dateOfPurchaseController,
                      decoration: const InputDecoration(
                        labelText: 'Date of Purchase (YYYY-MM-DD)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isEditing ? updateSales : addSales,
                      child: Text(isEditing ? 'Save Changes' : 'Add Sales'),
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
