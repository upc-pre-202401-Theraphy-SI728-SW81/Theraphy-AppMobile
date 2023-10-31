import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobile_app_theraphy/data/model/available_hour.dart';

class AvailableHourService {
  final String baseUrl = 'http://192.168.43.158:8080/api/v1/available-hours';

  Future<List<AvailableHour>?> getAll() async {
    final http.Response response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> maps = jsonResponse['content'];
      return maps.map((map) => AvailableHour.fromJson(map)).toList();
    } else {
      return List.empty();
    }
  }

  void createAvailableHour(
      int id, String hours, String day, int physiotherapistId) async {
    final availableHour = AvailableHour(
        id: id, hours: hours, day: day, physiotherapistId: physiotherapistId);

    final result = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(availableHour.toJson()),
    );

    if (result.statusCode == HttpStatus.created) {
      // Solicitud exitosa
      print('Solicitud exitosa');
      print('Respuesta del servidor: ${result.body}');
    } else {
      // Solicitud fallida
      print('Solicitud fallida');
      print('Código de error: ${result.statusCode}');
    }
  }

  Future<void> updateAvailableHour(
      int resourceId, String updatedDay, String updatedHour) async {
    final String url = '$baseUrl/$resourceId';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> data = {
      'day': updatedDay,
      'hours': updatedHour,
    };

    final http.Response response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data), // Convierte el mapa de datos a JSON
    );

    if (response.statusCode == 200) {
      print('Solicitud PUT exitosa');
    } else {
      print('Error en la solicitud PUT: ${response.statusCode}');
    }
  }
}
