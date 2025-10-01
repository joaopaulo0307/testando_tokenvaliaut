import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://sua-api.com"; // Troque pela URL real da sua API

  Future<List<dynamic>> getData() async {
    final response = await http.get(Uri.parse("\$baseUrl/items"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro ao buscar dados: \${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> postData(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("\$baseUrl/items"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro ao enviar dados: \${response.statusCode}");
    }
  }
}
