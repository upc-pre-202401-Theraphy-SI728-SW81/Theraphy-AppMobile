import 'package:flutter/material.dart';

class PhysiotherapistRegister extends StatefulWidget { 
  const PhysiotherapistRegister({super.key});

  @override
  State<PhysiotherapistRegister> createState() => _PhysiotherapistRegisterState();
}

class _PhysiotherapistRegisterState extends State<PhysiotherapistRegister> {

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
              "Physiotherapist Register",
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