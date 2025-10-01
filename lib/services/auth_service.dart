import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'storage_service.dart'; // IMPORTANTE: Adicionar esta linha

class AuthService {
  static const String baseUrl = 'https://api.devthigas.shop';
  
  final StorageService _storageService = StorageService();

  Future<AuthResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final authResponse = AuthResponse.fromJson(jsonResponse);
      
      // Salvar token e usuário
      await _storageService.saveToken(authResponse.token);
      await _storageService.saveUser(authResponse.user);
      
      return authResponse;
    } else {
      throw Exception('Falha no login: ${response.statusCode}');
    }
  }

  Future<User?> validateToken() async {
    final token = await _storageService.getToken();
    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final user = User.fromJson(jsonResponse);
        await _storageService.saveUser(user);
        return user;
      } else {
        await _storageService.clearAll();
        return null;
      }
    } catch (e) {
      await _storageService.clearAll();
      return null;
    }
  }

  Future<void> logout() async {
    await _storageService.clearAll();
  }
}