import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'user_service.dart';
import 'login.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<Admin> {
  List<dynamic> users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    setState(() => loading = true);
    
    final result = await UserService.getUsers();
    if (result != null) {
      setState(() => users = result);
    } else {
      // Se não conseguir carregar usuários, mostra mensagem
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao carregar usuários")),
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
        title: const Text("Admin - Usuários"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Sair',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
            tooltip: 'Recarregar',
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(child: Text("Nenhum usuário encontrado"))
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (_, index) {
                    final user = users[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(user["name"]?[0] ?? "U"),
                        ),
                        title: Text(user["name"] ?? "Sem nome"),
                        subtitle: Text(user["email"] ?? "Sem email"),
                        trailing: Chip(
                          label: Text(
                            user["role"] ?? "USER",
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: user["role"] == "ADMIN"
                              ? Colors.red
                              : Colors.blue,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}