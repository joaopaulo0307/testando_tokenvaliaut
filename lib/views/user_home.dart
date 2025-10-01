import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class UserHome extends StatelessWidget {
  final User user;
  final AuthService _authService = AuthService();

  UserHome({Key? key, required this.user}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    await _authService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Conta'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Olá, ${user.name}!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text('E-mail'),
                      subtitle: Text(user.email),
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Função'),
                      subtitle: Text(user.role),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildUserMenuItem(
                    'Meus Cursos',
                    Icons.school,
                    () {
                      // Navegar para tela de cursos do usuário
                    },
                  ),
                  _buildUserMenuItem(
                    'Meu Perfil',
                    Icons.person,
                    () {
                      // Navegar para tela de perfil
                    },
                  ),
                  _buildUserMenuItem(
                    'Configurações',
                    Icons.settings,
                    () {
                      // Navegar para tela de configurações
                    },
                  ),
                  _buildUserMenuItem(
                    'Ajuda',
                    Icons.help,
                    () {
                      // Navegar para tela de ajuda
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserMenuItem(String title, IconData icon, VoidCallback onTap) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}