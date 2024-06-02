import 'package:mobile_app_theraphy/data/model/therapy.dart';

class Appointment {
  int id;
  bool done;
  String topic;
  String diagnosis;
  String date;
  String hour;
  String place;
  Therapy therapy;

  Appointment({
    required this.id,
    required this.done,
    required this.topic,
    required this.diagnosis,
    required this.date,
    required this.hour,
    required this.place,
    required this.therapy,
  });

  Appointment.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          done: json['done'],
          topic: json['topic'],
          diagnosis: json['diagnosis'],
          date: json['date'],
          hour: json['hour'],
          place: json['place'],
          therapy: Therapy.fromJson(json['therapy']),
        );

}
