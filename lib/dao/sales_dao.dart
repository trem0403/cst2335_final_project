import 'package:floor/floor.dart';
import 'package:final_project/entity/sales.dart';

@dao
abstract class SalesDao {
  @Query('SELECT * FROM Sales')
  Future<List<Sales>> findAllSales();

  @Query('DELETE FROM Sales WHERE id = :id')
  Future<void> deleteSalesById(int id);

  @Query('DELETE FROM Car')
  Future<void> clearAllSales();

  @insert
  Future<void> insertSales(Sales sales);

  @update
  Future<int> updateSales(Sales sales);

  @delete
  Future<void> deleteSales(Sales sales);
}
