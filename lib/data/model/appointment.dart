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
  int? therapyId;
 

  Appointment(
      {required this.id,
      required this.done,
      required this.topic,
      required this.diagnosis,
      required this.date,
      required this.hour,
      required this.place,
      required this.therapy,
      this.therapyId,
      });

Map<String, dynamic> toJson() {
    return {
      'id': id,
      'done': done,
      'topic': topic,      
      'diagnosis': diagnosis,
      'date': date,
      'hour':hour,
      'place':place,
      'therapyId':therapyId
    };
  }


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