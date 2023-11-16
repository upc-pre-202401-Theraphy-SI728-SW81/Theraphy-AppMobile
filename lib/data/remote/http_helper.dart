import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobile_app_theraphy/data/model/appointment.dart';
import 'package:mobile_app_theraphy/data/model/consultation.dart';
import 'package:mobile_app_theraphy/data/model/diagnosis.dart';
import 'package:mobile_app_theraphy/data/model/iot_Result.dart';
import 'package:mobile_app_theraphy/data/model/medical_history.dart';
import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/model/physiotherapist.dart';
import 'package:mobile_app_theraphy/data/model/therapy.dart';
import 'package:mobile_app_theraphy/data/model/treatment.dart';
import 'package:mobile_app_theraphy/data/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpHelper {
  final String urlBase = 'http://192.168.1.34:8080/api/v1';

  Future<void> register(int id, String firstName, String lastName,
      String username, String password, String _selectedRole) async {
    const endpoint = '/auth/registration';
    final user = User(
        id: id,
        firstname: firstName,
        lastname: lastName,
        username: username,
        password: password,
        role: _selectedRole);
    final String url = '$urlBase$endpoint';
    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()));
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
      throw Exception(
          'Failed to register user. Status code: ${response.statusCode}');
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

        if (jsonResponse.containsKey('access_Token')) {
          final accessToken = jsonResponse['access_Token'];

          // Guardar el accessToken en el almacenamiento local
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', accessToken);

          print(accessToken);
        } else {
          throw Exception('Access token not found in the response.');
        }
      } else {
        throw Exception(
            'Failed to log in. Status code: ${response.statusCode}');
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
        throw Exception(
            'Failed to create patient. Status code: ${response.statusCode}');
      }
    } catch (exception) {
      print('Error: $exception');
      throw Exception('Failed to create patient.');
    }
  }

  Future<Physiotherapist> createPhysiotherapist(
      Physiotherapist physiotherapist) async {
    const reference = '/physiotherapists';
    const createPhysiotherapistEndpoint = '/registration-physiotherapist';
    final String createPhysiotherapistUrl =
        '$urlBase$reference$createPhysiotherapistEndpoint';

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
        throw Exception(
            'Failed to create physiotherapist. Status code: ${response.statusCode}');
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
    print(jwtToken);
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print("XDD");

        final jsonResponse = json.decode(response.body);
        print(response.body);
        print("12313421321");
        print(Physiotherapist.fromJson(jsonResponse).id);
        return Physiotherapist.fromJson(jsonResponse).id;
      } else {
        print("ELSEE");

        throw Exception(
            'Failed to get physiotherapist logged. Status code: ${response.statusCode}');
      }
    } catch (exception) {
      print("chuuu");

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

  Future<List<Patient>?> getMyPatientsWithTheraphy(
      int physiotherapistId) async {
    const String endpoint = '/therapies';
    final String url = '$urlBase$endpoint';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> therapiesMap = jsonResponse['content'];
      final List<Therapy> therapies =
          therapiesMap.map((map) => Therapy.fromJson(map)).toList();

      // Filtrar las terapias que cumplan con las condiciones
      final List<Therapy> filteredTherapies = therapies.where((therapy) {
        return therapy.physiotherapist.id == physiotherapistId &&
            !therapy.finished;
      }).toList();

      // Crear una lista de 'mypatients' a partir de las terapias filtradas
      List<Patient> myPatients = [];

      // Recorrer las terapias filtradas y extraer los atributos 'patient'
      for (var therapy in filteredTherapies) {
        myPatients.add(therapy.patient);
      }
// Ahora 'myPatients' contendrá la lista de pacientes que cumplan con los requisitos
      return myPatients;
    } else {
      return null;
    }
  }

  Future<Therapy?> getTherapyByPhysioAndPatient(
      int physiotherapistId, int patientId) async {
    var endpoint =
        '/therapies/byPhysioAndPatient/$physiotherapistId/$patientId';
    final String url = '$urlBase$endpoint';

    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);

      return Therapy.fromJson(jsonResponse);
    } else {
      return null;
    }
  }

  Future<Therapy> addTherapy(
      String therapyName,
      String description,
      String appointmentQuantity,
      String startAt,
      String finishAt,
      int patientId) async {
    const String endpoint = '/therapies';
    final String url = '$urlBase$endpoint';

    final Map<String, dynamic> requestBody = {
      'therapyName': therapyName,
      'description': description,
      'appointmentQuantity': appointmentQuantity,
      'startAt': startAt,
      'finishAt': finishAt,
      'finished': false,
      'patientId': patientId
    };

    final encodedBody = json.encode(requestBody);
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    http.Response response = await http.post(
      Uri.parse(url),
      body: encodedBody,
      headers: headers,
    );

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      return Therapy.fromJson(jsonResponse);
    } else {
      throw Exception(
          'Failed to create physiotherapist. Status code: ${response.statusCode}');
    }
  }

  Future<Appointment> addAppointment(String topic, String date, String hour,
      String place, int therapyId) async {
    const String endpoint = '/appointments';
    final String url = '$urlBase$endpoint';

    final Map<String, dynamic> requestBody = {
      'done': false,
      'topic': topic,
      'diagnosis': "This appointment have not finished yet",
      'date': date,
      'hour': hour,
      'place': place,
      'therapyId': therapyId
    };

    final encodedBody = json.encode(requestBody);
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    http.Response response = await http.post(
      Uri.parse(url),
      body: encodedBody,
      headers: headers,
    );

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      return Appointment.fromJson(jsonResponse);
    } else {
      throw Exception(
          'Failed to create physiotherapist. Status code: ${response.statusCode}');
    }
  }

  Future<Appointment?> getApppointmentByTherapyAndDate(
      int theraphyId, String date) async {
    var endpoint = '/appointments/byDate/$date/TherapyId/$theraphyId';
    final String url = '$urlBase$endpoint';

    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);

      return Appointment.fromJson(jsonResponse);
    } else {
      return null;
    }
  }

  Future<Treatment> addTreatment(int therapyId, String videoUrl,
      String duration, String title, String description, String day) async {
    const String endpoint = '/treatments';
    final String url = '$urlBase$endpoint';

    final Map<String, dynamic> requestBody = {
      'therapyId': therapyId,
      'videoUrl': videoUrl,
      'duration': duration,
      'title': title,
      'description': description,
      'day': day,
      'viewed': false
    };

    final encodedBody = json.encode(requestBody);
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    http.Response response = await http.post(
      Uri.parse(url),
      body: encodedBody,
      headers: headers,
    );

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      return Treatment.fromJson(jsonResponse);
    } else {
      throw Exception(
          'Failed to create physiotherapist. Status code: ${response.statusCode}');
    }
  }

  Future<Treatment?> getTreatmentByTherapyAndDate(
      int theraphyId, String date) async {
    var endpoint = '/treatments/byDate/$date/TherapyId/$theraphyId';
    final String url = '$urlBase$endpoint';

    http.Response response = await http.get(Uri.parse(url));
    print(response);
    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);

      return Treatment.fromJson(jsonResponse);
    } else {
      return null;
    }
  }

  Future<List<Patient>?> getMyPatientsOnlyConsultation(
      int physiotherapistId) async {
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

      const String endpoint = '/therapies';
      final String url = '$urlBase$endpoint';

      http.Response response2 = await http.get(Uri.parse(url));

      if (response2.statusCode == HttpStatus.ok) {
        final jsonResponse = json.decode(response2.body);
        final List<dynamic> therapiesMap = jsonResponse['content'];
        final List<Therapy> therapies =
            therapiesMap.map((map) => Therapy.fromJson(map)).toList();

        // Filtrar las terapias que cumplan con las condiciones
        final List<Therapy> filteredTherapies = therapies.where((therapy) {
          return therapy.physiotherapist.id == physiotherapistId &&
              !therapy.finished;
        }).toList();

        // Crear una lista de 'mypatients' a partir de las terapias filtradas
        List<Patient> myPatientsWithTherapy = [];

        // Recorrer las terapias filtradas y extraer los atributos 'patient'
        for (var therapy in filteredTherapies) {
          myPatientsWithTherapy.add(therapy.patient);
        }

        for (Patient patientWithTherapy in myPatientsWithTherapy) {
          myPatients
              .removeWhere((patient) => patient.dni == patientWithTherapy.dni);
        }

        return myPatients;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<List<Diagnosis>?> getPatientDiagnoses(int patientId) async {
    final endpoint = '/diagnoses/byPatientId/$patientId';
    final String url = '$urlBase$endpoint';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> patientDiagnosesMap = jsonResponse['content'];
      List<Diagnosis> patientDiagnoses =
          patientDiagnosesMap.map((map) => Diagnosis.fromJson(map)).toList();

      patientDiagnoses = patientDiagnoses.reversed.toList();

      // Ahora 'myPatients' contendrá la lista de pacientes que cumplan con los requisitos
      return patientDiagnoses;
    }

    return null;
  }

  Future<Therapy?> getPatientTherapy(int patientId) async {
    final endpoint = '/therapies/byPatientId/$patientId';
    final String url = '$urlBase$endpoint';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> patientTherapiesMap = jsonResponse['content'];
      List<Therapy> patientTherapies =
          patientTherapiesMap.map((map) => Therapy.fromJson(map)).toList();

      Therapy? unfinishedPatientTherapy;

      for (var therapy in patientTherapies) {
        if (!therapy.finished) {
          unfinishedPatientTherapy = therapy;
          break; // Termina el bucle una vez que se encuentra el primer elemento no terminado
        }
      }
      if (unfinishedPatientTherapy != null) {
        // Has encontrado el primer elemento no terminado
        return unfinishedPatientTherapy;
      } else {
        // No se encontraron elementos no terminados
        return null;
      }
    }

    return null;
  }

  Future<MedicalHistory?> getMedicalHistoryByPatientId(int patientId) async {
    String endpoint = '/medical-histories/byPatientId/$patientId';
    final String url = '$urlBase$endpoint';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final MedicalHistory medicalHistory =
          MedicalHistory.fromJson(jsonResponse);

      return medicalHistory;
    } else {
      return null;
    }
  }

  Future<List<IotResult>?> getIotResultsByTherapyIdandDate(
      int therapyId, String date) async {
    final endpoint = '/iotDevice/byTherapyId/$therapyId/Date/$date';
    final String url = '$urlBase$endpoint';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> iotResultsMap = jsonResponse['content'];
      List<IotResult> iotresults =
          iotResultsMap.map((map) => IotResult.fromJson(map)).toList();

      return iotresults;
    }

    return null;
  }
}
