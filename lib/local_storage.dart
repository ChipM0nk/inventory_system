import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static write(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> read(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
    // return storage.read(key: key);
  }

  static deletAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // await storage.deleteAll();
  }
}
