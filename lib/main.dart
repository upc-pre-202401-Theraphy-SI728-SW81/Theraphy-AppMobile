import 'package:flutter/material.dart';
import 'package:mobile_app_theraphy/ui/security/login-in.dart';
import 'package:mobile_app_theraphy/ui/therapy/my-therapy.dart';
import 'package:mobile_app_theraphy/ui/therapy/new-therapy.dart';
void main() {
  runApp(const MainApp()); 
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Login()
    );
  }
}