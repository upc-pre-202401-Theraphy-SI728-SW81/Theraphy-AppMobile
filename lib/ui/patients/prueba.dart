import 'package:flutter/material.dart';
import 'package:mobile_app_theraphy/data/model/diagnosis.dart';
import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';
import 'package:mobile_app_theraphy/ui/patients/patients-list.dart';

class PatientProfile2 extends StatefulWidget {
  const PatientProfile2({Key? key, required this.patient}) : super(key: key);
  final Patient patient;

  @override
  State<PatientProfile2> createState() => _PatientProfile2State();
}

class _PatientProfile2State extends State<PatientProfile2> {
  int selectedIndex = 1;
  HttpHelper? _httpHelper;
  List<Diagnosis>? patientDiagnoses = [];

  List<Widget> pages = const [
    PatientsList(),
  ];

  Future initialize() async {
    patientDiagnoses =
        await _httpHelper?.getPatientDiagnoses(widget.patient.id);

    setState(() {
      patientDiagnoses = patientDiagnoses;
    });
  }

  @override
  void initState() {
    _httpHelper = HttpHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1.0,
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color.fromRGBO(1, 77, 191, 1),
                        width: 1,
                      ),
                      bottom: BorderSide(
                        color: Color.fromRGBO(1, 77, 191, 1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Gender ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              "${widget.patient.age}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Size ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              "${widget.patient.location}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Weight ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              "${widget.patient.location}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Birthday Place ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              "${widget.patient.location}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromRGBO(1, 77, 191, 1),
                            width: 1.0,
                          ),
                        ),
                      ),
                      margin: const EdgeInsets.only(
                        right: 10,
                        left: 10.0,
                        top: 20,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Diagnoses",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView.builder(
                    itemCount: patientDiagnoses?.length,
                    itemBuilder: (context, index) {
                      return DiagnosisItem(
                        diagnosis: patientDiagnoses![index],
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView.builder(
                    itemCount: patientDiagnoses?.length,
                    itemBuilder: (context, index) {
                      return DiagnosisItem(
                        diagnosis: patientDiagnoses![index],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DiagnosisItem extends StatefulWidget {
  const DiagnosisItem({Key? key, required this.diagnosis}) : super(key: key);
  final Diagnosis diagnosis;

  @override
  State<DiagnosisItem> createState() => _DiagnosisItemState();
}

class _DiagnosisItemState extends State<DiagnosisItem> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        elevation: 4,
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.diagnosis.diagnosis}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Location: ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 121, 121, 121),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${widget.diagnosis.date}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
