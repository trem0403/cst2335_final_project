import 'package:flutter/material.dart';
import 'package:final_project/database/database.dart';
import 'package:final_project/dao/sales_dao.dart';
import 'package:final_project/entity/sales.dart';
import 'package:final_project/pages/add_sales.dart';

class SalesListPage extends StatefulWidget {
  final AppDatabase database;

  const SalesListPage({super.key, required this.database});

  @override
  State<SalesListPage> createState() => SalesListPageState();
}

class SalesListPageState extends State<SalesListPage> {
  late SalesDao dao;
  Sales? selectedSales;
  List<Sales> sales = [];
  int currentIndex = 0; // Index for bottom navigation

  //Colours
  var navColour = 0xFF14213D;
  var accentColour = 0xFFFCA311;
  var backgroundColour = 0xFF000000;
  var gridColour = 0xFFE5E5E5;

  @override
  void initState() {
    super.initState();
    dao = widget.database.salesDao;
    loadSales();
  }

  void loadSales() async {
    var list = await dao.findAllSales();
    setState(() {
      sales = list;
    });
  }

  void handleNavigation(int index) {
    setState(() {
      currentIndex = index;
    });

    switch (index) {
      case 0: // Insert
        insertSales();
        break;
      case 1: // Update
        updateSales();
        break;
      case 2: // Delete
        showDeleteDialog();
        break;
    }
  }

  void insertSales() async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddSalesPage(
              database: widget.database,
              sales: sales,
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

    // Reload the sales list if a new sales was added
    if (result == true) {
      loadSales();
    }
  }

  void updateSales() async {
    if (selectedSales == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No sales selected for update")),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddSalesPage(
              database: widget.database,
              sales: sales,
              salesToEdit: selectedSales,
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

    // Reload the sales list if a sales was updated
    if (result == true) {
      loadSales();
      setState(() {
        selectedSales = null; // Clear the selection
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sale updated successfully")),
      );
    }
  }


  void deleteSales() async {

    await dao.deleteSales(selectedSales!);
    setState(() {
      selectedSales = null; // Clear selection
    });
    loadSales();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sale deleted successfully")));
  }

  void showDeleteDialog() {
    if (selectedSales == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No sales selected for deletion")));
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Sale ${selectedSales?.id.toString()}" ),
        content: const Text("Are you sure you want to delete this sale?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              deleteSales();
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
        title: const Text('Sales List', style: TextStyle(color: Colors.white),),
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
          Expanded(flex: 1, child: salesList()),
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
      if (selectedSales == null) {
        return salesList();
      } else {
        // Something is selected
        return detailsPage();
      }
    }
  }

  Widget detailsPage() {


    if (selectedSales == null) {
      return const Center(
        child: Text(
          "Please select a Sales from the list",
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
                "Sales Details",
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
                    buildDetailCard("ID", selectedSales!.id.toString()),
                    buildDetailCard("Customer ID", selectedSales!.customerID.toString()),
                    buildDetailCard("Car ID", selectedSales!.carID.toString()),
                    buildDetailCard("Car Dealership ID", selectedSales!.carDealershipID.toString()),
                    buildDetailCard("Date of Purchase", selectedSales!.dateOfPurchase),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Align(

                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedSales = null; // Clear the selection
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

  Widget salesList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          Flexible(
            child: sales.isEmpty
                ? const Center(
              child: Text(
                "There are no sales available",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            )
                : ListView.separated(
              itemCount: sales.length,
              separatorBuilder: (context, index) => const Divider(
                thickness: 0.5,
                color: Colors.grey,
              ), // Add a line separator
              itemBuilder: (context, index) {
                final sale = sales[index];
                return ListTile(
                  onTap: () {
                    setState(() {
                      selectedSales = sales[index];
                    });
                  },
                  title: Text(
                    "Sale #${sale.id}",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  subtitle: Text(
                    sale.dateOfPurchase,
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                  leading: const CircleAvatar(
                    child: Text(
                      "S",
                      style: TextStyle(fontWeight: FontWeight.bold),
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
