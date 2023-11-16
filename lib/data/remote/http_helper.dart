import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobile_app_theraphy/data/model/appointment.dart';
import 'package:mobile_app_theraphy/data/model/consultation.dart';
import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/model/physiotherapist.dart';
import 'package:mobile_app_theraphy/data/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpHelper {
  final String urlBase = 'http://192.168.1.12:8080/api/v1';

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

  Future<int> getPhysiotherapistLogged() async {
    const reference = '/physiotherapists';
    const getPhysiotherapistLoggedEndpoint = '/profile';
    final String url = '$urlBase$reference$getPhysiotherapistLoggedEndpoint';

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
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(response.body);
        return Physiotherapist.fromJson(jsonResponse).id;
      } else {
        throw Exception(
            'Failed to get physiotherapist logged. Status code: ${response.statusCode}');
      }
    } catch (exception) {
      print('Error: $exception');
      throw Exception('Failed to get physiotherapist logged.');
    }
  }

  Future<Physiotherapist> getPhysiotherapist() async {
    const reference = '/physiotherapists';
    const getPhysiotherapistLoggedEndpoint = '/profile';
    final String url = '$urlBase$reference$getPhysiotherapistLoggedEndpoint';

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
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

            if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(response.body);
        return Physiotherapist.fromJson(jsonResponse);
      } else {
        throw Exception(
            'Failed to get physiotherapist logged. Status code: ${response.statusCode}');
      }
    } catch (exception) {
      print('Error: $exception');
      throw Exception('Failed to get physiotherapist logged.');
    }
  }

  Future<List<Patient>?> getMyPatients(int physiotherapistId) async {
    String endpoint = '/consultations/byPhysiotherapistId/$physiotherapistId';
    final String url = '$urlBase$endpoint';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> consultationsMap = jsonResponse['content'];
      final List<Consultation> consultations =
          consultationsMap.map((map) => Consultation.fromJson(map)).toList();

      List<Patient> myPatients = [];
      Set<String> patientDNIs = <String>{};

      for (Consultation consultation in consultations) {
        String patientDNI = consultation.patient.dni;
        if (!patientDNIs.contains(patientDNI)) {
          patientDNIs.add(patientDNI);
          myPatients.add(consultation.patient);
        }
      }

      return myPatients;
    } else {
      return null;
    }
  }

   Future<List<Consultation>?> getMyConsultations(int physiotherapistId) async {
    String endpoint = '/consultations/byPhysiotherapistId/$physiotherapistId';
    final String url = '$urlBase$endpoint';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> consultationsMap = jsonResponse['content'];
       List<Consultation> consultations =
          consultationsMap.map((map) => Consultation.fromJson(map)).toList();
          consultations = consultations.reversed.toList();
      return consultations;
    } else {
      return null;
    }
  }

   Future<List<Consultation>?> getMyConsultationsDone(int physiotherapistId) async {
    String endpoint = '/consultations/byPhysiotherapistId/$physiotherapistId';
    final String url = '$urlBase$endpoint';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> consultationsMap = jsonResponse['content'];
       List<Consultation> consultations =
          consultationsMap.map((map) => Consultation.fromJson(map)).toList();
          consultations = consultations.reversed.toList();
      List<Consultation> myConsultationsDone =   consultations
        .where((consultation) => consultation.done == true)
        .toList();
      return myConsultationsDone;
    } else {
      return null;
    }
  }

    Future<List<Consultation>?> getMyConsultationsNoDone(int physiotherapistId) async {
    String endpoint = '/consultations/byPhysiotherapistId/$physiotherapistId';
    final String url = '$urlBase$endpoint';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> consultationsMap = jsonResponse['content'];
       List<Consultation> consultations =
          consultationsMap.map((map) => Consultation.fromJson(map)).toList();
          consultations = consultations.reversed.toList();
      List<Consultation> myConsultationsNoDone =   consultations
        .where((consultation) => consultation.done == false)
        .toList();
      return myConsultationsNoDone;
    } else {
      return null;
    }
  }

   Future<List<Appointment>?> getMyAppointments(int physiotherapistId) async {
    String endpoint = '/appointments/appointment/therapy-physiotherapist/$physiotherapistId';
    final String url = '$urlBase$endpoint';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> appointmentsMap = jsonResponse['content'];
      List<Appointment> appointments =
          appointmentsMap.map((map) => Appointment.fromJson(map)).toList();
          appointments = appointments.reversed.toList();
      return appointments;
    } else {
      return null;
    }
  }

  Future<List<Appointment>?> getAllAppointmentsByPhysiotherapistId(int physiotherapistId) async {
    String endpoint = '/appointments';
    final String url = '$urlBase$endpoint';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> appointmentsMap = jsonResponse['content'];
      List<Appointment> appointments =
          appointmentsMap.map((map) => Appointment.fromJson(map)).toList();
          appointments = appointments.reversed.toList();

      List<Appointment> myAppointments =   appointments
        .where((appointment) => appointment.therapy.physiotherapist.id == physiotherapistId)
        .toList();
      return myAppointments;
    } else {
      return null;
    }
  }

    Future<List<Appointment>?> getAllAppointmentsByPhysiotherapistIdNoDone(int physiotherapistId) async {
    String endpoint = '/appointments';
    final String url = '$urlBase$endpoint';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> appointmentsMap = jsonResponse['content'];
      List<Appointment> appointments =
          appointmentsMap.map((map) => Appointment.fromJson(map)).toList();
          appointments = appointments.reversed.toList();

      List<Appointment> myAppointments =   appointments
        .where((appointment) => appointment.therapy.physiotherapist.id== physiotherapistId)
        .toList();
      List<Appointment> myAppointmentsNoDone =   appointments
        .where((appointment) => appointment.done == false)
        .toList();
      return myAppointmentsNoDone;
      
    } else {
      return null;
    }
  }

}
