class AvailableHour {
  final int id;
  final String hours;
  final String day;
  final int physiotherapistId;

  const AvailableHour(
      {required this.id,
      required this.hours,
      required this.day,
      required this.physiotherapistId});

  AvailableHour.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        hours = json['hours'],
        day = json['day'],
        physiotherapistId = json["physiotherapist"]["id"];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hours': hours,
      'day': day,
      'physiotherapistId': physiotherapistId
    };
  }
}
