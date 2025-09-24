import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "https://api.devthigas.shop";

  // Login do usuário
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      print('🔐 Tentando login: $email');
      
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      ).timeout(const Duration(seconds: 30));

      print('📡 Status: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data["token"]);
        print('✅ Login realizado com sucesso');
        return {"success": true, "message": "Login realizado com sucesso"};
      } else {
        final error = jsonDecode(response.body);
        return {"success": false, "message": error["message"] ?? "Erro no login"};
      }
    } catch (e) {
      print('❌ Erro no login: $e');
      return {"success": false, "message": "Erro de conexão: $e"};
    }
  }

  // Obter dados do usuário logado
  static Future<Map<String, dynamic>?> getMe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        print('❌ Token não encontrado');
        return null;
      }

      final response = await http.get(
        Uri.parse("$baseUrl/me"),
        headers: {"Authorization": "Bearer $token"},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('❌ Erro ao buscar usuário: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Erro no getMe: $e');
      return null;
    }
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    print('🚪 Usuário deslogado');
  }

  // Verificar se está logado
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    return token != null;
  }
}