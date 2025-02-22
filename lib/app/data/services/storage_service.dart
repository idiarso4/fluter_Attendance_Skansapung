import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';

class StorageService {
  final _box = GetStorage();
  
  static const _keyToken = 'token';
  static const _keyUser = 'user';

  // Token methods
  Future<void> saveToken(String token) async {
    await _box.write(_keyToken, token);
  }

  String? getToken() {
    return _box.read(_keyToken);
  }

  // User methods
  Future<void> saveUser(UserModel user) async {
    await _box.write(_keyUser, jsonEncode(user.toJson()));
  }

  UserModel? getUser() {
    final userStr = _box.read(_keyUser);
    if (userStr == null) return null;
    return UserModel.fromJson(jsonDecode(userStr));
  }

  // Clear all data
  Future<void> clearAll() async {
    await _box.erase();
  }
}
