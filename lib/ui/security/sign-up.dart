import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app_theraphy/ui/security/patient-register.dart';
import 'package:mobile_app_theraphy/ui/security/physiotherapist-register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/patient.dart';
import '../../data/model/physiotherapist.dart';
import '../../data/model/user.dart';
import '../../data/remote/http_helper.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _selectedRole = 'Patient';
  bool _passwordVisible = false;
  bool _acceptTerms = false;
  String firstName = "";
  String lastName= "";
  String username= "";
  String password= "";

  TextEditingController? _fullnameController;
  TextEditingController? _usernameController;
  TextEditingController? _passwordController;
  TextEditingController? _lastnameController; // Controlador para el campo de apellido

  HttpHelper? httpHelper;

  @override
  void initState() {
    httpHelper = HttpHelper();
    _fullnameController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _lastnameController = TextEditingController(); // Inicializar el controlador para el apellido

    super.initState();
  }

  @override
  void dispose() {
    _usernameController?.dispose();
    _passwordController?.dispose();
    _fullnameController?.dispose();
    _lastnameController?.dispose(); // Dispose del controlador para el apellido

    super.dispose();
  }

  navigateTo({required Widget widget}) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      ((route) => false),
    );
  }

  createUser() async {}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var acceptTerms = _acceptTerms;
    return Scaffold(
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.only(top: 80),
          height: 150,
          child: Image.asset(
            'assets/background.png',
            width: 350,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 20, top: 20),
        child: Text(
          "Sign Up",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 34,
          ),
        ),
      ),
      SizedBox(height: 15),
      Row(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _usernameController,
                onChanged: (value) {
                  firstName = value;
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: 'FirstName',
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
      SizedBox(height: 15),
      Row(
          children: [
            Expanded(
              flex: 7,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _lastnameController,
                  onChanged: (value) {
                    lastName = value;
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Lastname',
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
      SizedBox(height: 15),
      Row(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _fullnameController,
                onChanged: (value) {
                  username = value;
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: 'Username',
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
      SizedBox(height: 15),
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
                  setState(() {});
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
      SizedBox(height: 15),
      Expanded(
        flex: 3,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: SizedBox(
                      height:
                          54, // Establecer la misma altura que los TextField
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            border: InputBorder.none,
                          ),
                          value: _selectedRole,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedRole = newValue!;
                            });
                          },
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36,
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          items: <String>['Patient', 'Physiotherapist']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Text(
                                    value,
                                    style: TextStyle(
                                      color: Colors
                                          .grey[600], // Color menos oscuro
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top:
                        -3.5, // Ajustar la posición vertical según tus necesidades
                    left:
                        15, // Ajustar la posición horizontal según tus necesidades
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Rol',
                        style: TextStyle(
                          color: Colors.grey, // Color del texto "Rol"
                          fontSize: 13, // Tamaño del texto "Rol"
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value!;
                        });
                      },
                    ),
                    Text("I accept the terms and conditions"),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 0)
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      if (_acceptTerms) {
                        if(_selectedRole == "Physiotherapist"){
                          await httpHelper?.register(
                            0,
                            firstName,
                            lastName,
                            username,
                            password,
                            "PHYSIOTHERAPIST"
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PhysiotherapistRegister(),
                            ));
                        }else{
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PatientRegister(),
                            ));
                        }
                    } else {
                      print('Error de inicio de sesión');
                    }
                  } catch (error) {
                    // Maneja el error, por ejemplo, muestra un mensaje de error al usuario
                    print('Error de registar: $error');
                  }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[700],
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Join Us Before?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        " Log In",
                        style: TextStyle(
                          fontWeight: FontWeight
                              .bold, 
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ]));
  }
}