import 'package:flutter/material.dart';

class PatientRegister extends StatefulWidget { 
  const PatientRegister({super.key});

  @override
  State<PatientRegister> createState() => _PatientRegisterState();
}

class _PatientRegisterState extends State<PatientRegister> {

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
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Text(
              "Patient Register",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 34,
              ),
            ),
          ),
        ],
      ),
    );
  }
}