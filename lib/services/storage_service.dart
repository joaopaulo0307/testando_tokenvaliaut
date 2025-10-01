import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'dart:convert'; // Importar para usar json.encode e json.decode

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    // Converter o User para Map e depois para JSON string
    final userJson = user.toJson();
    final userString = json.encode(userJson);
    await prefs.setString(_userKey, userString);
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    
    if (userString != null) {
      try {
        // Converter JSON string para Map e depois para User
        final userMap = json.decode(userString) as Map<String, dynamic>;
        return User.fromJson(userMap);
      } catch (e) {
        print('Erro ao decodificar usuário: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
}
