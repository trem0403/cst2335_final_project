import 'package:floor/floor.dart';
import 'package:final_project/entity/car.dart';

@dao
abstract class CarDao {
  @Query('SELECT * FROM Car')
  Future<List<Car>> findAllCars();

  @Query('DELETE FROM Car WHERE id = :id')
  Future<void> deleteCarById(int id);

  @Query('DELETE FROM Car')
  Future<void> clearAllCars();

  @insert
  Future<void> insertCar(Car car);

  @update
  Future<int> updateCar(Car car);

  @delete
  Future<void> deleteCar(Car car);
}
