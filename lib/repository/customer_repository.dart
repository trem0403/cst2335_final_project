import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class CustomerRepository {
  static String firstName = "";
  static String lastName = "";
  static String address = "";
  static String birthday = "";

  static final EncryptedSharedPreferences prefs = EncryptedSharedPreferences();

  static Future<void> loadData() async {
    firstName = await prefs.getString('firstName');
    lastName = await prefs.getString('lastName');
    address = await prefs.getString('address');
    birthday = await prefs.getString('birthday');
  }

  static Future<void> saveData() async {
    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    await prefs.setString('address', address);
    await prefs.setString('birthday', birthday);
  }
}
