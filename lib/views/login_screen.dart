import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'admin_home.dart';
import 'user_home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authResponse = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

  
      if (authResponse.user != null) {

        if (authResponse.user!.isAdmin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminHome(user: authResponse.user!)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserHome(user: authResponse.user!)),
          );
        }
      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: Não foi possível obter dados do usuário')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro no login: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }


  void _fillCredentials(String email, String password) {
    _emailController.text = email;
    _passwordController.text = password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')), 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Campo de Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite seu e-mail';
                  }
                  if (!value.contains('@')) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Campo de Senha
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite sua senha';
                  }
                  if (value.length < 6) {
                    return 'Senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              
              // Botão de Login
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: Text('Entrar'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
              
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 10),
              

              Text(
                'Credenciais de Teste:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              SizedBox(height: 10),
              
              OutlinedButton(
                onPressed: () => _fillCredentials('teste1@email.com', '123456'),
                child: Text('teste1@email.com / 123456'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: BorderSide(color: Colors.blue),
                ),
              ),
              
              SizedBox(height: 10),
              Text(
                'Use o botão acima para preencher as credenciais de teste',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}