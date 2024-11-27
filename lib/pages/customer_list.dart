import 'package:flutter/material.dart';
import 'package:final_project/database/database.dart';
import 'package:final_project/dao/customer_dao.dart';
import 'package:final_project/entity/customer.dart';
import 'package:final_project/pages/add_customer.dart';

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
  int currentIndex = 0; // Index for bottom navigation

  //Colours
  var navColour = 0xFF14213D;
  var accentColour = 0xFFFCA311;
  var backgroundColour = 0xFF000000;
  var gridColour = 0xFFE5E5E5;

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

  void handleNavigation(int index) {
    setState(() {
      currentIndex = index;
    });

    switch (index) {
      case 0: // Insert
        insertCustomer();
        break;
      case 1: // Update
        updateCustomer();
        break;
      case 2: // Delete
        showDeleteDialog();
        break;
    }
  }

  void insertCustomer() async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddCustomerPage(
              database: widget.database,
              customers: customers,
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
      loadCustomers();
    }
  }

  void updateCustomer() async {
    if (selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No customer selected for update")),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddCustomerPage(
              database: widget.database,
              customers: customers,
              customerToEdit: selectedCustomer,
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
      loadCustomers();
      setState(() {
        selectedCustomer = null; // Clear the selection
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Customer updated successfully")),
      );
    }
  }


  void deleteCustomer() async {

    await dao.deleteCustomer(selectedCustomer!);
    setState(() {
      selectedCustomer = null; // Clear selection
    });
    loadCustomers();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Customer deleted successfully")));
  }

  void showDeleteDialog() {
    if (selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No customer selected for deletion")));
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Customer ${selectedCustomer?.id.toString()}" ),
        content: const Text("Are you sure you want to delete this customer?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              deleteCustomer();
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
        title: const Text('Customer List', style: TextStyle(color: Colors.white),),
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
          Expanded(flex: 1, child: customerList()),
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
      if (selectedCustomer == null) {
        return customerList();
      } else {
        // Something is selected
        return detailsPage();
      }
    }
  }

  Widget detailsPage() {


    if (selectedCustomer == null) {
      return const Center(
        child: Text(
          "Please select a Customer from the list",
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
                "Customer Details",
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
                    buildDetailCard("ID", selectedCustomer!.id.toString()),
                    buildDetailCard("First Name", selectedCustomer!.firstName),
                    buildDetailCard("Last Name", selectedCustomer!.lastName),
                    buildDetailCard("Birthday", selectedCustomer!.birthday),
                    buildDetailCard("Address", selectedCustomer!.address),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Align(

                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedCustomer = null; // Clear the selection
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

  Widget customerList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          Flexible(
            child: customers.isEmpty
                ? const Center(
              child: Text(
                "There are no customers available",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            )
                : ListView.separated(
              itemCount: customers.length,
              separatorBuilder: (context, index) => const Divider(
                thickness: 0.5,
                color: Colors.grey,
              ), // Add a line separator
              itemBuilder: (context, index) {
                final customer = customers[index];
                return ListTile(
                  onTap: () {
                    setState(() {
                      selectedCustomer = customers[index];
                    });
                  },
                  title: Text(
                    "${customer.firstName} ${customer.lastName}",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  subtitle: Text(
                    "ID: ${customer.id}",
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                  leading: CircleAvatar(
                    child: Text(
                      customer.firstName[0], // Use the first letter of the first name
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
