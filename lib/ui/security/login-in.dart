import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';
import 'package:mobile_app_theraphy/ui/security/patient-register.dart';
import 'package:mobile_app_theraphy/ui/security/sign-up.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget { 
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _passwordVisible = false;
  bool _errorState = false;

  String email = "";
  String password = "";

  TextEditingController? _usernameController;
  TextEditingController? _passwordController;

  HttpHelper? httpHelper;

  @override
  void initState() {
    httpHelper = HttpHelper();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController?.dispose();
    _passwordController?.dispose();
    super.dispose();
  }

  navigateTo({required Widget widget}) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ),
        ((route) => false));
  }

  login() async {}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 80),
              height: 200,
              child: Image.asset(
                'assets/logotheraphy.png',
                width: 450,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 40),
            child: Text(
              "Login",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 34,
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _usernameController,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(400),
                          width: 2.0, // Grosor del borde
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(400),
                          width: 2.0, // Grosor del borde
                        ),
                      ),
                      contentPadding: EdgeInsets.all(20),
                      isDense: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    obscureText: !_passwordVisible,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(400),
                          width: 2.0, // Grosor del borde
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(400),
                          width: 2.0, // Grosor del borde
                        ),
                      ),
                      contentPadding: EdgeInsets.all(20),
                      isDense: true,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        child: Icon(
                          _passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, right: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Forgot password?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () async {
                  try {
                    await httpHelper?.login(email, password);
                    // Por ejemplo: Navigator.pushNamed(context, '/dashboard');
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PatientRegister(),
                    ));
                // Acción a realizar al presionar el botó
                  } catch (error) {
                    // Maneja el error, por ejemplo, muestra un mensaje de error al usuario
                    print('Error de inicio de sesión: $error');
                  }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue[700], // Color de fondo
                onPrimary: Colors.white, // Color del texto
                padding: EdgeInsets.symmetric(
                    vertical: 20), // Padding vertical del botón
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Log In",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: Colors.black,
                    thickness: 2, // Grosor de las líneas
                    height: 20,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Or",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: Colors.black,
                    thickness: 2, // Grosor de las líneas
                    height: 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  // Acción a realizar al presionar el botón
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[700], // Color de fondo
                  onPrimary: Colors.white, // Color del texto
                  padding: EdgeInsets.symmetric(
                      vertical: 20), // Padding vertical del botón
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Log in with Google",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical: 20),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUp(),
                    ));
                // Acción a realizar al presionar el botón
              },
              child: RichText(
                text: TextSpan(
                  text: "New to Therapy? ",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "Register",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
