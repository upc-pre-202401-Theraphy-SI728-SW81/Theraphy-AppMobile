import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_theraphy/ui/patients/patients-list.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';

class PhysiotherapistRegister extends StatefulWidget {
  const PhysiotherapistRegister({super.key});

  @override
  State<PhysiotherapistRegister> createState() =>
      _PhysiotherapistRegisterState();
}

class _PhysiotherapistRegisterState extends State<PhysiotherapistRegister> {
  DateTime? selectedDate;
  final _formKey = GlobalKey<FormState>();
  String? dni;
  String? age;
  String? specialization;
  String? location;
  String? fees;
  String? experience;
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
      child: SingleChildScrollView(
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
                      height: 135,
                      child: Image.asset(
                        'assets/logotheraphy.png',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Welcome, you are registering as a physiotherapist",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
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
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your specialization';
                        }
                        return null;
                      },
                      onSaved: (value) => specialization = value,
                      decoration: InputDecoration(
                        labelText: 'Specialization',
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
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: TextFormField(
                        readOnly: true,
                        onTap: () => _selectDate(context),
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
                              color: Colors.black,
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
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your fees';
                              }
                              return null;
                            },
                            onSaved: (value) => fees = value,
                            decoration: InputDecoration(
                              labelText: 'Fees',
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
                              if (value == null || value.isEmpty) {
                                return 'Please enter your experience';
                              }
                              return null;
                            },
                            onSaved: (value) => experience = value,
                            decoration: InputDecoration(
                              labelText: 'Experience',
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
                  ],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: 365,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[700],
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      print("object");
                      print(dni);
                      print(age);
                      print(specialization);
                      print(selectedDateAsString);
                      print(location);
                      print(fees);
                      print(experience);
                      setState(() {
                         try {
                         httpHelper?.createPhysiotherapist(
                          dni,
                          age,
                          specialization,
                          selectedDateAsString,
                          location,
                          fees,
                          experience,
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PatientsList(),
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
    ));
  }
}
