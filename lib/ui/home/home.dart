import 'package:flutter/material.dart';

class HomePhysiotherapist extends StatefulWidget {
  const HomePhysiotherapist({super.key});

  @override
  State<HomePhysiotherapist> createState() => _HomePhysiotherapistState();
}

class _HomePhysiotherapistState extends State<HomePhysiotherapist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello, Cristhian", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,), 
      
    );

  }
}