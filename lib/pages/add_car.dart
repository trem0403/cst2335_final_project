import 'package:flutter/material.dart';
import 'package:final_project/database/database.dart';
import 'package:final_project/dao/car_dao.dart';
import 'package:final_project/entity/car.dart';
import 'package:final_project/repository/car_repository.dart';

class AddCarPage extends StatefulWidget {
  final AppDatabase database;
  final List<Car> cars;
  final Car? carToEdit; // Nullable car for editing

  const AddCarPage({
    super.key,
    required this.database,
    required this.cars,
    this.carToEdit,
  });

  @override
  State<AddCarPage> createState() => AddCarPageState();
}

class AddCarPageState extends State<AddCarPage> {
  late CarDao dao;

  // Text controllers for form fields
  late TextEditingController brandController;
  late TextEditingController modelController;
  late TextEditingController numOfPassengersController;
  late TextEditingController fuelSizeController;

  // Colors
  var navColour = 0xFF14213D;
  var accentColour = 0xFFFCA311;
  var gridColour = 0xFFE5E5E5;

  // Fuel type selection
  String selectedFuelType = 'Battery'; // Default fuel type
  final List<String> fuelTypes = ['Battery', 'Gas'];

  @override
  void initState() {
    super.initState();
    dao = widget.database.carDao;

    brandController = TextEditingController();
    modelController = TextEditingController();
    numOfPassengersController = TextEditingController();
    fuelSizeController = TextEditingController();

    // Prepopulate fields if editing
    if (widget.carToEdit != null) {
      brandController.text = widget.carToEdit!.brand;
      modelController.text = widget.carToEdit!.model;
      numOfPassengersController.text = widget.carToEdit!.numberOfPassengers.toString();
      selectedFuelType = widget.carToEdit!.fuelType;
      fuelSizeController.text = widget.carToEdit!.fuelSize.toString();
    } else if (widget.cars.isNotEmpty) {
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
          title: const Text("Copy Last Car?"),
          content: const Text("Do you want to copy details from the last car entry?"),
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
      loadDataFromLastCar();
    }
  }

  void loadDataFromLastCar() async {
    if (CarRepository.brand.isNotEmpty &&
        CarRepository.model.isNotEmpty &&
        CarRepository.numberOfPassengers.isNotEmpty &&
        CarRepository.fuelType.isNotEmpty &&
        CarRepository.fuelSize.isNotEmpty) {
      setState(() {
        brandController.text = CarRepository.brand;
        modelController.text = CarRepository.model;
        numOfPassengersController.text = CarRepository.numberOfPassengers;
        selectedFuelType = CarRepository.fuelType;
        fuelSizeController.text = CarRepository.fuelSize;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Car Data Loaded!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No data to load")),
      );
    }
  }

  void saveDataForNextCar() async {
    CarRepository.brand = brandController.text;
    CarRepository.model = modelController.text;
    CarRepository.numberOfPassengers = numOfPassengersController.text;
    CarRepository.fuelType = selectedFuelType;
    CarRepository.fuelSize = fuelSizeController.text;

    CarRepository.saveData();
  }

  void addCar() async {
    // Validate that all fields are filled
    if (brandController.text.isEmpty ||
        modelController.text.isEmpty ||
        numOfPassengersController.text.isEmpty ||
        selectedFuelType.isEmpty ||
        fuelSizeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Parse controllers into integer and double
    final numberOfPassengers = int.tryParse(numOfPassengersController.text.trim());
    final fuelSize = double.tryParse(fuelSizeController.text.trim());



    final int newId = Car.ID++; // Use and incre\ment static ID
    final newCar = Car(
      newId,
      brandController.text.trim(),
      modelController.text.trim(),
      numberOfPassengers!,
      selectedFuelType.trim(),
      fuelSize!,
    );

    try {
      await dao.insertCar(newCar);
      saveDataForNextCar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car added successfully!')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add car: $e')),
      );
    }
  }

  void updateCar() async {
    addCar(); // Save updated car as a new entry
    if (widget.carToEdit != null) {
      await dao.deleteCarById(widget.carToEdit!.id);
    }
  }

  @override
  void dispose() {
    brandController.dispose();
    modelController.dispose();
    numOfPassengersController.dispose();
    fuelSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.carToEdit != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            isEditing ? 'Edit Car' : 'Add Car',
            style: const TextStyle(
                color: Colors.white
            ),
        ),
        backgroundColor: Color(navColour),
        iconTheme: const IconThemeData(color: Color(0xFFFCA311)),
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
                  children: [
                    Text(
                      isEditing ? 'Edit Car Details' : 'Car Details',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: brandController,
                      decoration: const InputDecoration(
                        labelText: 'Brand Name',
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: modelController,
                      decoration: const InputDecoration(
                        labelText: 'Model',
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: numOfPassengersController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: '# of Passengers',
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        // Ensure that only valid integer values are entered
                        if (int.tryParse(value) == null && value.isNotEmpty) {
                          // Reset value
                          numOfPassengersController.text = '';
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedFuelType,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedFuelType = newValue!;
                        });
                      },
                      items: fuelTypes.map((type) {
                        return DropdownMenuItem(value: type, child: Text(type, style: const TextStyle(color: Colors.white)));
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Fuel Type',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      dropdownColor: Color(navColour), // This changes the background color of the dropdown menu
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: fuelSizeController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Fuel Size (kWh / litres)',
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        // Ensure that only valid decimal values are entered
                        if (double.tryParse(value) == null && value.isNotEmpty) {
                          // Reset value
                          fuelSizeController.text = '';
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isEditing ? updateCar : addCar,
                      child: Text(
                        isEditing ? 'Save Changes' : 'Add Car',
                        style: const TextStyle(color: Colors.black),
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
