import 'package:floor/floor.dart';
import 'package:final_project/entity/Customer.dart';

@dao
abstract class CustomerDao {
  @Query('SELECT * FROM Customer')
  Future<List<Customer>> findAllCustomers();

  @Query('DELETE FROM Customer WHERE id = :id')
  Future<void> deleteCustomerById(int id);

  @Query('DELETE FROM Customer')
  Future<void> clearAllCustomers();

  @insert
  Future<void> insertCustomer(Customer customer);

  @update
  Future<int> updateCustomer(Customer customer);

  @delete
  Future<void> deleteCustomer(Customer customer);
}
