import 'package:flutter/material.dart';
import 'package:final_project/database/database.dart';
import 'package:final_project/dao/car_dealership_dao.dart';
import 'package:final_project/entity/car_dealership.dart';
import 'package:final_project/repository/car_dealership_repository.dart';


class AddCarDealershipPage extends StatefulWidget {
  final AppDatabase database;
  final List<CarDealership> carDealerships;
  final CarDealership? carDealershipToEdit; // Nullable CarDealership for editing

  const AddCarDealershipPage({super.key, required this.database, required this.carDealerships, this.carDealershipToEdit,});

  @override
  State<AddCarDealershipPage> createState() => AddCarDealershipPageState();
}

class AddCarDealershipPageState extends State<AddCarDealershipPage> {
  late CarDealershipDao dao;

  // Text controllers for form fields
  late TextEditingController nameController;
  late TextEditingController streetAddressController;
  late TextEditingController cityController;
  late TextEditingController zipController;

  //Colours
  var navColour = 0xFF14213D;
  var accentColour = 0xFFFCA311;
  var forGroundColour = 0xFF000000;
  var gridColour = 0xFFE5E5E5;

  @override
  void initState() {
    super.initState();
    dao = widget.database.carDealershipDao;

    nameController = TextEditingController();
    streetAddressController = TextEditingController();
    cityController = TextEditingController();
    zipController = TextEditingController();

    // Prepopulate fields if editing
    if (widget.carDealershipToEdit != null) {
      nameController.text = widget.carDealershipToEdit!.name;
      streetAddressController.text = widget.carDealershipToEdit!.streetAddress;
      cityController.text = widget.carDealershipToEdit!.city;
      zipController.text = widget.carDealershipToEdit!.zip;

      // Check if there are existing CarDealerships and show the dialog
    } else if (widget.carDealerships.isNotEmpty) {
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
          title: const Text("Copy Last CarDealership?"),
          content: const Text(
            "Do you want to copy details from the last CarDealership entry?",
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
      loadDataFromLastCarDealership();
    }
  }

  void loadDataFromLastCarDealership() async {
    setState(() {
      nameController.text = CarDealershipRepository.name;
      streetAddressController.text = CarDealershipRepository.streetAddress;
      cityController.text = CarDealershipRepository.city;
      zipController.text = CarDealershipRepository.zip;

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Car Dealership Data Loaded!"))
      );
    });
  }

  void saveDataForNextCarDealership() async {
    CarDealershipRepository.name = nameController.text;
    CarDealershipRepository.streetAddress = streetAddressController.text;
    CarDealershipRepository.city = cityController.text;
    CarDealershipRepository.zip = zipController.text;

    CarDealershipRepository.saveData();
  }

  void addCarDealership() async {
    // Validate that all fields are filled
    if (nameController.text.isEmpty ||
        streetAddressController.text.isEmpty ||
        cityController.text.isEmpty ||
        zipController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Validate ZIP code format (U.S. format: 12345 or 12345-6789)
    final String zip = zipController.text.trim();
    final RegExp zipRegEx = RegExp(r'^\d{5}(-\d{4})?$');
    if (!zipRegEx.hasMatch(zip)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid ZIP code. Use format: 12345 or 12345-6789.')),
      );
      return;
    }

    final int newId = CarDealership.ID; // Use static ID
    CarDealership.ID++; // Increment the static ID

    // Create a new CarDealership object
    final newCarDealership = CarDealership(
      newId,
      nameController.text.trim(),
      streetAddressController.text.trim(),
      zipController.text.trim(),
      cityController.text.trim(),
    );

    // Insert the CarDealership into the database
    await dao.insertCarDealership(newCarDealership);

    // Save CarDealership data for next CarDealership entry
    saveDataForNextCarDealership();

    // Go back to the previous page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('CarDealership added successfully!')),
    );
    Navigator.pop(context, true); // Return 'true' to indicate a new CarDealership was added

    // Clear fields for next input
    nameController.clear();
    streetAddressController.clear();
    cityController.clear();
    zipController.clear();
  }

  void updateCarDealership() async {

    // Saves updates CarDealership information into a new record
    addCarDealership();

    // Delete CarDealership with outdated information
    await dao.deleteCarDealershipById(widget.carDealershipToEdit!.id);
  }


  @override
  void dispose() {
    // Dispose controllers to free resources
    nameController.dispose();
    streetAddressController.dispose();
    cityController.dispose();
    zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.carDealershipToEdit != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit CarDealership' : 'Add CarDealership', style: const TextStyle(color: Colors.white),),
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
                      isEditing ? 'Edit Car Dealership Details' : 'Car Dealership Details',

                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Dealership Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: streetAddressController,
                      decoration: const InputDecoration(
                        labelText: 'Street Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: zipController,
                      decoration: const InputDecoration(
                        labelText: 'ZIP Code',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isEditing ? updateCarDealership : addCarDealership,
                      child: Text(isEditing ? 'Save Changes' : 'Add Car Dealership'),
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
