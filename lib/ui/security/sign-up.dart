import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  String email = "";
  String fullName = "";
  String password = "";

  TextEditingController? _fullnameController;
  TextEditingController? _usernameController;
  TextEditingController? _passwordController;

  HttpHelper? httpHelper;
  List<Physiotherapist>? physioterapists = [];
  List<Patient>? patients = [];
  List<User>? users = [];

  void saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    //print('Valor guardado en el almacenamiento local.');
  }

  void getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    print('Valor recuperado del almacenamiento local: $value');
  }

  @override
  void initState() {
    httpHelper = HttpHelper();
    _fullnameController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _usernameController?.dispose();
    _passwordController?.dispose();
    _fullnameController?.dispose();

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
          height: 200,
          child: Image.asset(
            'assets/background.png',
            width: 450,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 20, top: 40),
        child: Text(
          "Sign Up",
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
                  setState(() {});
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
                controller: _fullnameController,
                onChanged: (value) {
                  fullName = value;
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: 'FullName',
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
      SizedBox(height: 20),
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
              SizedBox(height: 5),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Join Us Before?"),
                    GestureDetector(
                      onTap: () {
                        getData("userId");
                        Navigator.pop(context);
                        // Manejar el evento cuando se presiona "Log In"
                        // Aquí puedes agregar la lógica para navegar a la pantalla de inicio de sesión
                      },
                      child: Text(
                        " Log In",
                        style: TextStyle(
                          fontWeight: FontWeight
                              .bold, // Aplicar negrita al texto "Log In"
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