import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/model/physiotherapist.dart';

class Consultation {
  int id;
  bool done;
  String topic;
  String diagnosis;
  String date;
  String hour;
  String place;
  Physiotherapist physiotherapist;
  Patient patient;
 


  Consultation(
      {required this.id,
      required this.done,
      required this.topic,
      required this.diagnosis,
      required this.date,
      required this.hour,
      required this.place,
      required this.physiotherapist,
      required this.patient
      });

  Consultation.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            done: json['done'],
            topic: json['topic'],
            diagnosis: json['diagnosis'],
            date: json['date'],
            hour: json['hour'],
            place: json['place'],
             physiotherapist: Physiotherapist.fromJson(json['physiotherapistId']),
            patient: Patient.fromJson(json['patientId']));
           
}
