import 'package:floor/floor.dart';
import 'package:final_project/entity/car_dealership.dart';

@dao
abstract class CarDealershipDao {
  @Query('SELECT * FROM CarDealership')
  Future<List<CarDealership>> findAllCarDealerships();

  @Query('DELETE FROM CarDealership WHERE id = :id')
  Future<void> deleteCarDealershipById(int id);

  @Query('DELETE FROM CarDealership')
  Future<void> clearAllCarDealerships();

  @insert
  Future<void> insertCarDealership(CarDealership carDealership);

  @update
  Future<int> updateCarDealership(CarDealership carDealership);

  @delete
  Future<void> deleteCarDealership(CarDealership carDealership);
}
