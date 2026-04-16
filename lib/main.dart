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
      title: 'Repara Ya',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}