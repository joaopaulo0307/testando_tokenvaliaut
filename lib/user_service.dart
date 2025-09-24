import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String baseUrl = "https://api.devthigas.shop";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // Buscar todos os usuários (apenas admin)
  static Future<List<dynamic>?> getUsers() async {
    try {
      final token = await _getToken();
      if (token == null) {
        print('❌ Token não disponível');
        return null;
      }

      final response = await http.get(
        Uri.parse("$baseUrl/users"), // Ajuste a rota conforme sua API
        headers: {"Authorization": "Bearer $token"},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('❌ Erro ao buscar usuários: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Erro no getUsers: $e');
      return null;
    }
  }
}