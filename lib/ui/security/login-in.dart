import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget { 
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}


class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final HttpHelper httpHelper = HttpHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/logotheraphy.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Campo de entrada de nombre de usuario
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              // Campo de entrada de contraseña
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
              ),
              // Botón de inicio de sesión
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  String username = usernameController.text;
                  String password = passwordController.text;
                  try {
                    await httpHelper.login(username, password);
                    // Si el inicio de sesión fue exitoso, puedes navegar a la siguiente página aquí
                    // Por ejemplo: Navigator.pushNamed(context, '/dashboard');
                  } catch (error) {
                    // Maneja el error, por ejemplo, muestra un mensaje de error al usuario
                    print('Error de inicio de sesión: $error');
                  }
                },
                child: Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
