import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CourseService {
  static const String baseUrl = "https://api.devthigas.shop";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // Buscar todos os cursos (público)
  static Future<List<dynamic>?> getCourses() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/courses"),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('❌ Erro ao buscar cursos: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Erro no getCourses: $e');
      return null;
    }
  }

  // Criar curso (apenas admin)
  static Future<Map<String, dynamic>?> createCourse(
      String name, String desc, double price) async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await http.post(
        Uri.parse("$baseUrl/courses"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "desc": desc,
          "price": price,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('❌ Erro ao criar curso: $e');
      return null;
    }
  }

  // Atualizar curso (apenas admin)
  static Future<bool> updateCourse(
      String courseId, String name, String desc, double price) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.put(
        Uri.parse("$baseUrl/courses/$courseId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "desc": desc,
          "price": price,
        }),
      ).timeout(const Duration(seconds: 30));

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Erro ao atualizar curso: $e');
      return false;
    }
  }

  // Deletar curso (apenas admin)
  static Future<bool> deleteCourse(String courseId) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.delete(
        Uri.parse("$baseUrl/courses/$courseId"),
        headers: {"Authorization": "Bearer $token"},
      ).timeout(const Duration(seconds: 30));

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Erro ao deletar curso: $e');
      return false;
    }
  }
}