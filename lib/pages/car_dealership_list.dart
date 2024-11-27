import 'package:flutter/material.dart';
import 'package:final_project/database/database.dart';
import 'package:final_project/dao/car_dealership_dao.dart';
import 'package:final_project/entity/car_dealership.dart';
import 'package:final_project/pages/add_car_dealership.dart';

class CarDealershipListPage extends StatefulWidget {
  final AppDatabase database;

  const CarDealershipListPage({super.key, required this.database});

  @override
  State<CarDealershipListPage> createState() => CarDealershipListPageState();
}

class CarDealershipListPageState extends State<CarDealershipListPage> {
  late CarDealershipDao dao;
  CarDealership? selectedCarDealership;
  List<CarDealership> carDealerships = [];
  int currentIndex = 0; // Index for bottom navigation

  //Colours
  var navColour = 0xFF14213D;
  var accentColour = 0xFFFCA311;
  var backgroundColour = 0xFF000000;
  var gridColour = 0xFFE5E5E5;

  @override
  void initState() {
    super.initState();
    dao = widget.database.carDealershipDao;
    loadCarDealerships();
  }

  void loadCarDealerships() async {
    var list = await dao.findAllCarDealerships();
    setState(() {
      carDealerships = list;
    });
  }

  void handleNavigation(int index) {
    setState(() {
      currentIndex = index;
    });

    switch (index) {
      case 0: // Insert
        insertCarDealership();
        break;
      case 1: // Update
        updateCarDealership();
        break;
      case 2: // Delete
        showDeleteDialog();
        break;
    }
  }

  void insertCarDealership() async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddCarDealershipPage(
              database: widget.database,
              carDealerships: carDealerships,
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

    // Reload the CarDealership list if a new CarDealership was added
    if (result == true) {
      loadCarDealerships();
    }
  }

  void updateCarDealership() async {
    if (selectedCarDealership == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No Car Dealership selected for update")),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddCarDealershipPage(
              database: widget.database,
              carDealerships: carDealerships,
              carDealershipToEdit: selectedCarDealership,
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

    // Reload the CarDealership list if a CarDealership was updated
    if (result == true) {
      loadCarDealerships();
      setState(() {
        selectedCarDealership = null; // Clear the selection
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("CarDealership updated successfully")),
      );
    }
  }


  void deleteCarDealership() async {

    await dao.deleteCarDealership(selectedCarDealership!);
    setState(() {
      selectedCarDealership = null; // Clear selection
    });
    loadCarDealerships();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("CarDealership deleted successfully")));
  }

  void showDeleteDialog() {
    if (selectedCarDealership == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No CarDealership selected for deletion")));
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Car Dealership ${selectedCarDealership?.id.toString()}" ),
        content: const Text("Are you sure you want to delete this Car Dealership?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              deleteCarDealership();
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
        title: const Text('Car Dealership List', style: TextStyle(color: Colors.white),),
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
        selectedItemColor: Colors.white, // Highlighted item color
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
          Expanded(flex: 1, child: carDealershipList()),
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
      if (selectedCarDealership == null) {
        return carDealershipList();
      } else {
        // Something is selected
        return detailsPage();
      }
    }
  }

  Widget detailsPage() {


    if (selectedCarDealership == null) {
      return const Center(
        child: Text(
          "Please select a Car Dealership from the list",
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
                "Car Dealership Details",
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
                    buildDetailCard("ID", selectedCarDealership!.id.toString()),
                    buildDetailCard("Name", selectedCarDealership!.name),
                    buildDetailCard("Street Address", selectedCarDealership!.streetAddress),
                    buildDetailCard("City", selectedCarDealership!.city),
                    buildDetailCard("ZIP", selectedCarDealership!.zip),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Align(

                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedCarDealership = null; // Clear the selection
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
        color: Color(accentColour),
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

  Widget carDealershipList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          Flexible(
            child: carDealerships.isEmpty
                ? const Center(
              child: Text(
                "There are no Car Dealerships available",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            )
                : ListView.separated(
              itemCount: carDealerships.length,
              separatorBuilder: (context, index) => const Divider(
                thickness: 0.5,
                color: Colors.grey,
              ), // Add a line separator
              itemBuilder: (context, index) {
                final carDealership = carDealerships[index];
                return ListTile(
                  onTap: () {
                    setState(() {
                      selectedCarDealership = carDealerships[index];
                    });
                  },
                  title: Text(
                    carDealership.name,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  subtitle: Text(
                    "ID: ${carDealership.id}",
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                  leading: CircleAvatar(
                    child: Text(
                      carDealership.name[0], // Use the first letter of the name
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
