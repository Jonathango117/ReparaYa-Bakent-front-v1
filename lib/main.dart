
import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'screens/login_screens.dart';

void main() {
  runApp(const ReparaYaApp());
}

class ReparaYaApp extends StatelessWidget {
  const ReparaYaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReparaYa',
      debugShowCheckedModeBanner: false,

      // Tema claro
      theme: AppTheme.lightTheme,

      // Tema oscuro
      darkTheme: AppTheme.darkTheme,

      // Detecta automáticamente el tema del celular
      themeMode: ThemeMode.system,

      home: const LoginScreen(),
    );
  }
}
