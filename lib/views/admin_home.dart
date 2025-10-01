import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class AdminHome extends StatelessWidget {
  final User user;
  final AuthService _authService = AuthService();

  AdminHome({Key? key, required this.user}) : super(key: key);

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
        title: Text('Painel Administrativo'),
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
                      'Bem-vindo, Administrador!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text('Nome: ${user.name}'),
                    Text('E-mail: ${user.email}'),
                    Text('Função: ${user.role}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                children: [
                  _buildAdminCard(
                    'Gerenciar Usuários',
                    Icons.people,
                    Colors.green,
                    () {
                      // Navegar para tela de gerenciamento de usuários
                    },
                  ),
                  _buildAdminCard(
                    'Relatórios',
                    Icons.analytics,
                    Colors.orange,
                    () {
                      // Navegar para tela de relatórios
                    },
                  ),
                  _buildAdminCard(
                    'Configurações',
                    Icons.settings,
                    Colors.purple,
                    () {
                      // Navegar para tela de configurações
                    },
                  ),
                  _buildAdminCard(
                    'Cursos',
                    Icons.school,
                    Colors.red,
                    () {
                      // Navegar para tela de cursos
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

  Widget _buildAdminCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}