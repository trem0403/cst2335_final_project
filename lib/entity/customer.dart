import 'package:floor/floor.dart';

/// Represents a `Customer` entity for the database.
@Entity(tableName: 'Customer')
class Customer {
  /// Static variable to track unique IDs for each customer.
  static int ID = 1;

  /// The primary key for the customer.
  @PrimaryKey()
  final int id;

  /// Customer's first name.
  final String firstName;

  /// Customer's last name.
  final String lastName;

  /// Customer's address.
  final String address;

  /// Customer's birthday in the format YYYY-MM-DD.
  final String birthday;

  /// Constructor to create a new `Customer` object.
  ///
  /// The constructor also updates the static `ID` variable if the current
  /// `id` is greater than or equal to the tracked `ID`, ensuring unique IDs
  /// for subsequent customers.
  Customer(this.id, this.firstName, this.lastName, this.birthday, this.address) {
    if (id >= ID) {
      ID = id + 1; // Increment the static ID if necessary.
    }
  }
}
