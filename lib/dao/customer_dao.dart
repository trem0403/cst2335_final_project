import 'package:floor/floor.dart';
import 'package:final_project/entity/customer.dart';

/// Data Access Object (DAO) for performing operations on the `Customer` entity.
@dao
abstract class CustomerDao {

  /// Retrieves all customers from the `Customer` table.
  ///
  /// Returns a `Future` list of `Customer` objects.
  @Query('SELECT * FROM Customer')
  Future<List<Customer>> findAllCustomers();

  /// Deletes a customer from the `Customer` table by their ID.
  ///
  /// [id] The unique identifier of the customer to delete.
  @Query('DELETE FROM Customer WHERE id = :id')
  Future<void> deleteCustomerById(int id);

  /// Clears all records from the `Customer` table.
  ///
  /// This will remove all customers from the database.
  @Query('DELETE FROM Customer')
  Future<void> clearAllCustomers();

  /// Inserts a new customer into the `Customer` table.
  ///
  /// [customer] The `Customer` object to insert.
  @insert
  Future<void> insertCustomer(Customer customer);

  /// Updates an existing customer in the `Customer` table.
  ///
  /// [customer] The `Customer` object with updated details.
  @update
  Future<void> updateCustomer(Customer customer);

  /// Deletes a specific customer from the `Customer` table.
  ///
  /// [customer] The `Customer` object to delete.
  @delete
  Future<void> deleteCustomer(Customer customer);
}
