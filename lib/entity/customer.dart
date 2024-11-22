import 'package:floor/floor.dart';

@Entity(tableName: 'Customer')
class Customer {
  static int ID = 1; //This tracks the IDs for the program


  @PrimaryKey()
  final int id;

  final String firstName;
  final String lastName;
  final String address;
  final String birthday;




  Customer(this.id, this.firstName, this.lastName, this.address, this.birthday)
  {
    if(id >= ID) {
      ID = id + 1;
    }
  }
}


