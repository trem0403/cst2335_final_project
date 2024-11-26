import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class CarRepository {
  static String brand = "";
  static String model = "";
  static String numberOfPassengers = "";
  static String fuelType = "";
  static String fuelSize = "";


  static final EncryptedSharedPreferences prefs = EncryptedSharedPreferences();

  static Future<void> loadData() async {
    brand = await prefs.getString('brand');
    model = await prefs.getString('model');
    numberOfPassengers = await prefs.getString('numberOfPassengers');
    fuelType = await prefs.getString('fuelType');
    fuelSize = await prefs.getString('fuelSize');
  }

  static Future<void> saveData() async {
    await prefs.setString('brand', brand);
    await prefs.setString('model', model);
    await prefs.setString('numberOfPassengers', numberOfPassengers);
    await prefs.setString('fuelType', fuelType);
    await prefs.setString('fuelSize', fuelSize);

  }
}
