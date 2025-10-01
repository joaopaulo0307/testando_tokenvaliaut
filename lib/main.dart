import 'package:flutter/material.dart';
import 'views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Adicionando construtor const

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Autenticação',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(), // Também const
      debugShowCheckedModeBanner: false,
    );
  }
}