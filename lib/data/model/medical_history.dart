

import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/model/physiotherapist.dart';

class MedicalHistory {
  int id;
  Patient patient;
  String gender;
  double size;
  double weight;
String birthplace;
String hereditaryHistory;
String nonPathologicalHistory;
String pathologicalHistory;


  MedicalHistory(
      {required this.id,
      required this.patient,
      required this.gender,
      required this.size,
      required this.weight,
      required this.birthplace,
      required this.hereditaryHistory,
      required this.nonPathologicalHistory,
      required this.pathologicalHistory
      });

  MedicalHistory.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            patient: Patient.fromJson(json['patient']),
            gender: json['gender'],
            size: json['size'],
            weight: json['weight'],
            birthplace: json['birthplace'],
            hereditaryHistory: json['hereditaryHistory'],
            nonPathologicalHistory: json['nonPathologicalHistory'],
            pathologicalHistory: json['pathologicalHistory']);
           
}