import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:hive/hive.dart';

class AuthStorage extends CognitoStorage {
  AuthStorage(this.prefix);
  final String prefix;
  final Box<String> _box = Hive.box<String>('auth');

  @override
  Future setItem(String key, value) async {
    final item = json.encode(value);
    return _box.put(key, item);
  }

  @override
  Future getItem(String key) async {
    final item = _box.get(key);
    if (item == null) {
      return null;
    }
    return json.decode(item);
  }

  @override
  Future removeItem(String key) async {
    return _box.delete(key);
  }

  @override
  Future<void> clear() async {
    await _box.clear();
  }
}
