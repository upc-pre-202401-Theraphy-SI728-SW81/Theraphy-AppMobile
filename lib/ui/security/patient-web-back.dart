import 'package:flutter/material.dart';
import 'package:mobile_app_theraphy/ui/security/login-in.dart';

class WebPatient extends StatefulWidget {
  const WebPatient({Key? key}) : super(key: key);

  @override
  State<WebPatient> createState() => _WebPatientState();
}

class _WebPatientState extends State<WebPatient> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Centro los elementos horizontalmente
            children: [
              SizedBox(height: 10),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      height: 165,
                      child: Image.asset(
                        'assets/logotheraphy.png',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Text(
                "Unable to Access Patient Features on Mobile App",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Text(
                "For full access to patient functions, please use the web version. We apologize for any inconvenience. Thank you for choosing our platform.",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              SizedBox(
                height: 50,
                width: 365,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[700], // Color de fondo
                    onPrimary: Colors.white, // Color del texto
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ));
                  },
                  child: const Text("Back To Login"),
                ),
              ),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      height: 250,
                      child: Image.asset(
                        'assets/Thinking.png',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
