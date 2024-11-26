import 'package:floor/floor.dart';

@Entity(tableName: 'Car')
class Car {
  static int ID = 1; //This tracks the IDs for the program


  @PrimaryKey()
  final int id;

  final String brand;
  final String model;
  final int numberOfPassengers;
  final String fuelType;
  final double fuelSize;

  Car(this.id, this.brand, this.model, this.numberOfPassengers, this.fuelType, this.fuelSize)
  {
    if(id >= ID) {
      ID = id + 1;
    }
  }
}



