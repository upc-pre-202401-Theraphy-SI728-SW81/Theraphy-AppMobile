

class IotResult {
  int id;
  String? iotDeviceId;
  String? humidity;
  String? temperature;
  String? pulse;
  String? mapAmplitude;
  String? mapFrequency;
  String? mapDuration;
  String? date;

  IotResult(
      {required this.id,
      this.iotDeviceId,
      this.humidity,
      this.temperature,
      this.pulse,
      this.mapAmplitude,
      this.mapFrequency,
      this.mapDuration,
      this.date
      });

  IotResult.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            iotDeviceId: json['iotDeviceId'],
            humidity: json['humidity'],
            temperature: json['temperature'],
            pulse: json['pulse'],
            mapAmplitude: json['mapAmplitude'],
            mapFrequency: json['mapFrequency'],
            mapDuration: json['mapDuration'],
            date: json['date']);
}
