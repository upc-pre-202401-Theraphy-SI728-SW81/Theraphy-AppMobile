import 'package:mobile_app_theraphy/data/model/therapy.dart';

class IotDevice {
  int id;
  Therapy? therapy;
  String? assignmentDate;
  int? therapyQuantity;

  IotDevice(
      {required this.id,
      this.therapy,
      this.assignmentDate,
      this.therapyQuantity});

  IotDevice.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            therapy: Therapy.fromJson(json['therapy']),
            assignmentDate: json['assignmentDate'],
            therapyQuantity: json['therapyQuantity']);
}
