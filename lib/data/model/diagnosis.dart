import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/model/physiotherapist.dart';

class Diagnosis {
  int id;
  Physiotherapist physiotherapist;
  Patient patient;
  String diagnosis;
  String date;

  Diagnosis(
      {required this.id,
      required this.physiotherapist,
      required this.patient,
      required this.diagnosis,
      required this.date});

  Diagnosis.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            physiotherapist: Physiotherapist.fromJson(json['physiotherapist']),
            patient: Patient.fromJson(json['patient']),
            diagnosis: json['diagnosis'],
            date: json['date']);
}
