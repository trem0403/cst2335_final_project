import 'package:flutter/material.dart';
import 'package:final_project/database/database.dart';
import 'package:final_project/dao/car_dao.dart';
import 'package:final_project/entity/car.dart';
import 'package:final_project/pages/addCar.dart';

class CarListPage extends StatefulWidget {
  final AppDatabase database;

  const CarListPage({super.key, required this.database});

  @override
  State<CarListPage> createState() => CarListPageState();
}

class CarListPageState extends State<CarListPage> {
  late CarDao dao;
  Car? selectedCar;
  List<Car> cars = [];
  int currentIndex = 0; // Index for bottom navigation

  //Colours
  var navColour = 0xFF14213D;
  var accentColour = 0xFFFCA311;
  var backgroundColour = 0xFF000000;
  var gridColour = 0xFFE5E5E5;

  @override
  void initState() {
    super.initState();
    dao = widget.database.carDao;
    loadCar();
  }

  void loadCar() async {
    var list = await dao.findAllCars();
    setState(() {
      cars = list;
    });
  }

  void handleNavigation(int index) {
    setState(() {
      currentIndex = index;
    });

    switch (index) {
      case 0: // Insert
        insertCar();
        break;
      case 1: // Update
        updateCar();
        break;
      case 2: // Delete
        showDeleteDialog();
        break;
    }
  }

  void insertCar() async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddCarPage(
              database: widget.database,
              cars: cars,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // Slide from right to left
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );

    // Reload the customer list if a new customer was added
    if (result == true) {
      loadCar();
    }
  }

  void updateCar() async {
    if (selectedCar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No car selected for update")),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddCarPage(
              database: widget.database,
              cars: cars,
              carToEdit: selectedCar,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // Slide from right to left
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );

    // Reload the customer list if a customer was updated
    if (result == true) {
      loadCar();
      setState(() {
        selectedCar = null; // Clear the selection
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Car updated successfully")),
      );
    }
  }


  void deleteCar() async {

    await dao.deleteCar(selectedCar!);
    setState(() {
      selectedCar = null; // Clear selection
    });
    loadCar();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Car deleted successfully")));
  }

  void showDeleteDialog() {
    if (selectedCar == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No car selected for deletion")));
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Car ${selectedCar?.id.toString()}" ),
        content: const Text("Are you sure you want to delete this car?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              deleteCar();
              Navigator.of(context).pop();
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car List', style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(
          color: Color(0xFFFCA311), // Change the arrow color here
        ),
        backgroundColor: Color(navColour),
      ),
      body: Center(
        child: reactiveLayout(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(navColour), // BottomNav background color
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: currentIndex,
        onTap: handleNavigation,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.green),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit, color: Colors.blue),
            label: 'Edit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete, color: Colors.red),
            label: 'Delete',
          ),
        ],
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
          Expanded(flex: 1, child: carList()),
          VerticalDivider(
            color: Colors.grey.shade700, // Divider color
            thickness: 1, // Divider thickness
            width: 1,
          ),
          Expanded(flex: 2, child: detailsPage()),
        ],
      );
    } else {
      // Portrait
      if (selectedCar == null) {
        return carList();
      } else {
        // Something is selected
        return detailsPage();
      }
    }
  }

  Widget detailsPage() {


    if (selectedCar == null) {
      return const Center(
        child: Text(
          "Please select a Car from the list",
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      );
    }

    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    bool isLandscape = false;

    if ((width > height) && (width > 720)) {
      isLandscape = true;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Car Details",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xFF14213D)),              ),
              const Divider(thickness: 1, color: Colors.grey),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.count(
                  crossAxisCount: isLandscape ? 2 : 1, // 2 columns in landscape, 1 in portrait
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 6.0,
                  childAspectRatio: isLandscape ? 3.5 : 5, // Adjusted for better fit in landscape
                  children: [
                    buildDetailCard("ID", selectedCar!.id.toString()),
                    buildDetailCard("Brand Name", selectedCar!.brand),
                    buildDetailCard("Model", selectedCar!.model),
                    buildDetailCard("# of Passengers", selectedCar!.numberOfPassengers.toString()),
                    buildDetailCard("Fuel Type", selectedCar!.fuelType),
                    buildDetailCard("Fuel Size (kWh / litres)", selectedCar!.fuelSize.toString()),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Align(

                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedCar = null; // Clear the selection
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(navColour),
                  ),
                  child: const Text("Back to List", style: TextStyle(color: Colors.white),),
                ),
              ),
            ],

          );
        },
      ),
    );
  }

  Widget buildDetailCard(String title, String value) {

    return Container(
      padding: const EdgeInsets.all(12.0), // Reduced padding for a compact layout
      decoration: BoxDecoration(
        color: Color(gridColour), // Light gray background
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: const TextStyle(fontSize: 14.0),
          ),
        ],
      ),
    );
  }

  Widget carList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          Flexible(
            child: cars.isEmpty
                ? const Center(
              child: Text(
                "There are no cars available",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            )
                : ListView.separated(
              itemCount: cars.length,
              separatorBuilder: (context, index) => const Divider(
                thickness: 0.5,
                color: Colors.grey,
              ), // Add a line separator
              itemBuilder: (context, index) {
                final car = cars[index];
                return ListTile(
                  onTap: () {
                    setState(() {
                      selectedCar = cars[index];
                    });
                  },
                  title: Text(
                    "${car.brand}, ${car.model}",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  subtitle: Text(
                    "ID: ${car.id}",
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                  leading: CircleAvatar(
                    child: Text(
                      car.brand[0], // Use the first letter of the first name
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 1.0, horizontal: 16.0),
                );
              },
            ),
          )
        ],
      ),
    );
  }

}
