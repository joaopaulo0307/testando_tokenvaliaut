import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'course_service.dart';
import 'login.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UserScreenState();
}

class _UserScreenState extends State<Users> {
  List<dynamic> courses = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  void _loadCourses() async {
    setState(() => loading = true);
    
    final result = await CourseService.getCourses();
    if (result != null) {
      setState(() => courses = result);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao carregar cursos")),
        );
      }
    }
    
    setState(() => loading = false);
  }

  void _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cursos Disponíveis"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Sair',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCourses,
            tooltip: 'Recarregar',
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : courses.isEmpty
              ? const Center(child: Text("Nenhum curso disponível"))
              : ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (_, index) {
                    final course = courses[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.school, color: Colors.blue),
                        title: Text(
                          course["name"] ?? "Curso sem nome",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(course["desc"] ?? "Sem descrição"),
                            const SizedBox(height: 4),
                            Text(
                              "R\$ ${course["price"]?.toStringAsFixed(2) ?? "0.00"}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    );
                  },
                ),
    );
  }
}