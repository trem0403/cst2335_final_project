import 'package:floor/floor.dart';

@Entity(tableName: 'Sales')
class Sales {
  static int ID = 1; //This tracks the IDs for the program


  @PrimaryKey()
  final int id;

  final int customerID;
  final int carID;
  final int carDealershipID;
  final String dateOfPurchase;

  Sales(this.id, this.customerID, this.carID, this.carDealershipID, this.dateOfPurchase)
  {
    if(id >= ID) {
      ID = id + 1;
    }
  }
}


