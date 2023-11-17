import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobile_app_theraphy/data/model/available_hour.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvailableHourService {
  final String baseUrl = 'https://api-iotheraphy-production.up.railway.app/api/v1/available-hours';

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

  Future<List<AvailableHour>?> getByPhysiotherapistId(int id) async {
    final String url = '$baseUrl/byPhysiotherapistId/$id';
    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> maps = jsonResponse['content'];
      return maps.map((map) => AvailableHour.fromJson(map)).toList();
    } else {
      return List.empty();
    }
  }

  Future<bool> createAvailableHour(
      int id, String hours, String day, int physiotherapistId) async {
    final availableHour = AvailableHour(
        id: id, hours: hours, day: day, physiotherapistId: physiotherapistId);

    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }
    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    final result = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode(availableHour.toJson()),
      headers: headers,
    );

    if (result.statusCode == HttpStatus.created) {
      // Solicitud exitosa
      print('Solicitud exitosa');
      print('Respuesta del servidor: ${result.body}');
      return true;
    } else {
      // Solicitud fallida
      print('Solicitud fallida');
      print('Código de error: ${result.statusCode}');
      return false;
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
