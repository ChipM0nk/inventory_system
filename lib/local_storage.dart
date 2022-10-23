import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  static const storage = FlutterSecureStorage();

  static write(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  static Future<String?> read(String key) async {
    return storage.read(key: key);
  }

  static deletAll() async {
    await storage.deleteAll();
  }
}
