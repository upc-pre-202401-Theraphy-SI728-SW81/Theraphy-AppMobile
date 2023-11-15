import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/model/physiotherapist.dart';

class IotResult {
  int id;
  String? temperature;
  String? distance;
  String? pulse;
  String? humidity;
  int? therapyId;
  String? date;

  IotResult(
      {required this.id,
      this.temperature,
      this.distance,
      this.pulse,
      this.humidity,
      this.therapyId,
      this.date});

  IotResult.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            temperature: json['temperature'],
            distance: json['distance'],
            pulse: json['pulse'],
            humidity: json['humidity'],
            therapyId: json['therapyId'],
            date: json['date']);
}
