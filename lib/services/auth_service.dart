import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'storage_service.dart';

class AuthService {
  static const String baseUrl = 'https://api.devthigas.shop';
  
  final StorageService _storageService = StorageService();

  Future<AuthResponse> login(String email, String password) async {
    print('🔐 Tentando login real para: $email');
    
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
      final token = jsonResponse['token'];
      
      print('✅ Login real bem-sucedido! Token recebido');
      
      // Salvar token
      await _storageService.saveToken(token);
      
      // Buscar dados do usuário com o token
      final user = await _getUserData(token);
      
      if (user != null) {
        await _storageService.saveUser(user);
        print('✅ Dados do usuário obtidos: ${user.name} (${user.role})');
      }
      
      return AuthResponse(token: token, user: user);
    } else {
      print('❌ Erro no login real: ${response.statusCode} - ${response.body}');
      throw Exception('Falha no login: ${response.statusCode}');
    }
  }

  // Método auxiliar para buscar dados do usuário
  Future<User?> _getUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return User.fromJson(jsonResponse);
      } else {
        print('❌ Erro ao buscar dados do usuário: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('⚠️ Erro ao buscar dados do usuário: $e');
      return null;
    }
  }

  Future<User?> validateToken() async {
    final token = await _storageService.getToken();
    if (token == null) {
      print('❌ Nenhum token encontrado');
      return null;
    }

    print('🔍 Validando token: ${token.substring(0, 20)}...');
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final user = User.fromJson(jsonResponse);
        await _storageService.saveUser(user);
        print('✅ Token válido na API');
        return user;
      } else {
        print('❌ Token inválido na API');
        await _storageService.clearAll();
        return null;
      }
    } catch (e) {
      print('⚠️ Erro na validação: $e');
      await _storageService.clearAll();
      return null;
    }
  }

  Future<void> logout() async {
    print('🚪 Logout realizado');
    await _storageService.clearAll();
  }
}