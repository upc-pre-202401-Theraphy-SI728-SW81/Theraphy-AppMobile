import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/model/physiotherapist.dart';

class Therapy {
  int id;
  String therapyName;
  String description;
  int appointmentQuantity;
  String startAt;
  String finishAt;
  bool finished;
  Patient patient;
  Physiotherapist physiotherapist;

  Therapy(
      {required this.id,
      required this.therapyName,
      required this.description,
      required this.appointmentQuantity,
      required this.startAt,
      required this.finishAt,
      required this.finished,
      required this.patient,
      required this.physiotherapist
      });

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