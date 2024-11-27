import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class CarDealershipRepository {
  static String name = "";
  static String streetAddress = "";
  static String city = "";
  static String zip = "";


  static final EncryptedSharedPreferences prefs = EncryptedSharedPreferences();

  static Future<void> loadData() async {
    name = await prefs.getString('name');
    streetAddress = await prefs.getString('streetAddress');
    city = await prefs.getString('city');
    zip = await prefs.getString('zip');
  }

  static Future<void> saveData() async {
    await prefs.setString('name', name);
    await prefs.setString('streetAddress', streetAddress);
    await prefs.setString('city', city);
    await prefs.setString('zip', zip);
  }
}
