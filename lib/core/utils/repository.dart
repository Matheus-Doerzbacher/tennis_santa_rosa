import 'package:tennis_santa_rosa/core/utils/secure_storage.dart';

class Repository {
  static Future read(String key) async {
    return SecureStorage.read(key);
  }

  static Future<void> save(String key, dynamic value) async {
    return SecureStorage.save(key, value);
  }

  static Future<void> remove(String key) async {
    return SecureStorage.remove(key);
  }
}
