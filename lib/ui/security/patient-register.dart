import 'package:flutter/material.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_theraphy/ui/security/login-in.dart';
import 'package:mobile_app_theraphy/ui/security/patient-web-back.dart';

class PatientRegister extends StatefulWidget {
  const PatientRegister({super.key});

  @override
  State<PatientRegister> createState() => _PatientRegisterState();
}

class _PatientRegisterState extends State<PatientRegister> {
  DateTime? selectedDate;
  final _formKey = GlobalKey<FormState>();
  String? dni;
  String? age;
  String? location;
  String? selectedDateAsString;

  HttpHelper? httpHelper;

  @override
  void initState() {
    httpHelper = HttpHelper();
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      if (picked.isBefore(DateTime.now().subtract(Duration(days: 365 * 18)))) {
        setState(() {
          selectedDate = picked;
          selectedDateAsString = DateFormat('yyyy/MM/dd').format(picked);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You must be 18 years or older.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      height: 235,
                      child: Image.asset(
                        'assets/logotheraphy.png',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Welcome, you are registering as a patient",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold, // Add this line for bold text
                ),
                textAlign:
                    TextAlign.center, // Add this line for center alignment
              ),
              SizedBox(height: 30),
              Text(
                "Please enter your personal information",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length != 8) {
                                return '8 digits';
                              }
                              return null;
                            },
                            onSaved: (value) => dni = value,
                            // Add your controller and other properties
                            decoration: InputDecoration(
                              labelText: 'DNI',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(400),
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(400),
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(20),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  int.tryParse(value) == null ||
                                  int.parse(value) < 18) {
                                return 'Must be 18 or older';
                              }
                              return null;
                            },
                            onSaved: (value) => age = value,
                            // Add your controller and other properties
                            decoration: InputDecoration(
                              labelText: 'Age',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(400),
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(400),
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(20),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: TextFormField(
                        readOnly: true,
                        onTap: () =>
                            _selectDate(context), // Open date picker on tap
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your birthdate';
                          }
                        },
                        onSaved: (value) =>
                            selectedDate = DateTime.tryParse(value ?? ''),
                        decoration: InputDecoration(
                          labelText: 'Birthdate',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(400),
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(400),
                              width: 2.0,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(20),
                          isDense: true,
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.calendar_today,
                              color: Colors
                                  .black, // Change the color to a darker shade
                            ),
                            onPressed: () => _selectDate(context),
                          ),
                        ),
                        controller: TextEditingController(
                          text: selectedDate != null
                              ? DateFormat('yyyy/MM/dd').format(selectedDate!)
                              : '',
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your location';
                          }
                          return null;
                        },
                        onSaved: (value) => location = value,
                        // Add your controller and other properties
                        decoration: InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(400),
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(400),
                              width: 2.0,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(20),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
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
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      print("object");
                      setState(() {
                        try {
                          httpHelper?.createPatient(
                            dni,
                            age,
                            selectedDateAsString,
                            location
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WebPatient(),
                            ));
                      } catch (e) {
                        print("Error al registar el physioterapeuta: $e");
                      }
                      });
                      
                    }
                  },
                  child: const Text("Create Account"),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
