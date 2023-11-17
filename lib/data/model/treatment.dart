import 'package:mobile_app_theraphy/data/model/therapy.dart';

class Treatment {
  int id;
  Therapy therapy;
  String videoUrl;
  String duration;
  String title;
  String description;
  String day;
  bool viewed;

  Treatment({
    required this.id,
    required this.therapy,
    required this.videoUrl,
    required this.duration,
    required this.title,
    required this.description,
    required this.day,
    required this.viewed
    });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'therapy': therapy,
      'videoUrl': videoUrl,
      'duration': duration,
      'title': title,
      'description': description,
      'day': day,
      'viewed': viewed,
    };
  }

  Treatment.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            therapy: Therapy.fromJson(json['therapy']),
            videoUrl: json['videoUrl'],
            duration: json['duration'],
            title: json['title'],
            description: json['description'],
            day: json['day'],
            viewed: json['viewed'],
            );


}