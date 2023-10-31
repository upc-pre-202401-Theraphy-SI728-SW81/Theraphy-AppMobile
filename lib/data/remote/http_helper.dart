import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/model/physiotherapist.dart';
import 'package:mobile_app_theraphy/data/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpHelper {
  final String urlBase = 'http://localhost:8080/api/v1';

  Future<void> register(int id, String firstName, String lastName, String username, String password, String _selectedRole) async {
    const endpoint = '/auth/registration';
    final user = User(id: id, firstname: firstName, lastname: lastName, username: username, password: password, role: _selectedRole);
    final String url = '$urlBase$endpoint';
    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()));
    print(user.toJson());
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('access_Token')) {
        final accessToken = jsonResponse['access_Token'];
        print(jsonResponse);

        // Guardar el accessToken en el almacenamiento local
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
      } else {
        throw Exception('Failed to register user');
      }
    } else {
      throw Exception('Failed to register user. Status code: ${response.statusCode}');
    }
  }

  Future<void> login(String username, String password) async {
    final credentials = {'username': username, 'password': password};
    const endpoint = '/auth/authentication';
    final String url = '$urlBase$endpoint';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode(credentials),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Response from server: $jsonResponse');

        if (jsonResponse.containsKey('access_Token')) {
          final accessToken = jsonResponse['access_Token'];
          print(jsonResponse);

          // Guardar el accessToken en el almacenamiento local
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', accessToken);
        } else {
          throw Exception('Access token not found in the response.');
        }
      } else {
        throw Exception('Failed to log in. Status code: ${response.statusCode}');
      }
    } catch (exception) {
      print('Error: $exception');
      // Manejar el error, por ejemplo, mostrar un mensaje de error al usuario.
    }
  }

  Future<Patient> createPatient(Patient patient) async {
    const reference = '/patient';
    const createPatientEndpoint = '/registration-patient';
    final String createPatientUrl = '$urlBase$reference$createPatientEndpoint';

    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse(createPatientUrl),
        headers: headers,
        body: jsonEncode(patient.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return Patient.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to create patient. Status code: ${response.statusCode}');
      }
    } catch (exception) {
      print('Error: $exception');
      throw Exception('Failed to create patient.');
    }
  }

  Future<Physiotherapist> createPhysiotherapist(Physiotherapist physiotherapist) async {
    const reference = '/physiotherapists';
    const createPhysiotherapistEndpoint = '/registration-physiotherapist';
    final String createPhysiotherapistUrl = '$urlBase$reference$createPhysiotherapistEndpoint';

    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse(createPhysiotherapistUrl),
        headers: headers,
        body: jsonEncode(physiotherapist.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return Physiotherapist.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to create physiotherapist. Status code: ${response.statusCode}');
      }
    } catch (exception) {
      print('Error: $exception');
      throw Exception('Failed to create physiotherapist.');
    }
  }

}
