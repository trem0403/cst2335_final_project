import 'package:floor/floor.dart';

@Entity(tableName: 'CarDealership')
class CarDealership {
  static int ID = 1; //This tracks the IDs for the program


  @PrimaryKey()
  final int id;

  final String name;
  final String streetAddress;
  final String city;
  final String zip;

  CarDealership(this.id, this.name, this.streetAddress, this.city, this.zip)
  {
    if(id >= ID) {
      ID = id + 1;
    }
  }
}


