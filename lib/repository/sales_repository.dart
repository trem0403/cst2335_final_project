import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class SalesRepository {
  static String customerID = "";
  static String carID = "";
  static String carDealershipID = "";
  static String dateOfPurchase = "";


  static final EncryptedSharedPreferences prefs = EncryptedSharedPreferences();

  static Future<void> loadData() async {
    customerID = await prefs.getString('customerID');
    carID = await prefs.getString('carID');
    carDealershipID = await prefs.getString('carDealershipID');
    dateOfPurchase = await prefs.getString('dateOfPurchase');
  }

  static Future<void> saveData() async {
    await prefs.setString('customerID', customerID);
    await prefs.setString('carID', carID);
    await prefs.setString('carDealershipID', carDealershipID);
    await prefs.setString('dateOfPurchase', dateOfPurchase);

  }
}
