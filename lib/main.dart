import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_theraphy/firebase_options.dart';
import 'package:mobile_app_theraphy/ui/security/login-in.dart';
import 'package:mobile_app_theraphy/ui/updaload_examples.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: UploadPage()
    );
  }
}