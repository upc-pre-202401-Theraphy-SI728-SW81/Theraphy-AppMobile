import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/model/physiotherapist.dart';

class Therapy {
  int id;
  String therapyName;
  String description;
  String appointmentQuantity;
  String startAt;
  String finishAt;
  bool finished;
  Patient patient;
  Physiotherapist physiotherapist;
  int? patientId;

  Therapy(
      {required this.id,
      required this.therapyName,
      required this.description,
      required this.appointmentQuantity,
      required this.startAt,
      required this.finishAt,
      required this.finished,
      required this.patient,
      required this.physiotherapist,
      this.patientId,
      });


Map<String, dynamic> toJson() {
    return {
      'id': id,
      'therapyName': therapyName,
      'description': description,      
      'appointmentQuantity': appointmentQuantity,
      'startAt': startAt,
      'finishAt':finishAt,
      'finished':finished,
      'patientId':patientId
    };
  }

  Therapy.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            therapyName: json['therapyName'],
            description: json['description'],
            appointmentQuantity: json['appointmentQuantity'],
            startAt: json['startAt'],
            finishAt: json['finishAt'],
            finished: json['finished'],
            patient: Patient.fromJson(json['patient']),
            physiotherapist: Physiotherapist.fromJson(json['physiotherapist'])
            );
           
}