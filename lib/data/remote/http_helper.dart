import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_app_theraphy/data/model/appointment.dart';
import 'package:mobile_app_theraphy/data/model/consultation.dart';
import 'package:mobile_app_theraphy/data/model/diagnosis.dart';
import 'package:mobile_app_theraphy/data/model/iot_Result.dart';
import 'package:mobile_app_theraphy/data/model/iot_device.dart';
import 'package:mobile_app_theraphy/data/model/medical_history.dart';
import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/model/physiotherapist.dart';
import 'package:mobile_app_theraphy/data/model/review.dart';
import 'package:mobile_app_theraphy/data/model/therapy.dart';
import 'package:mobile_app_theraphy/data/model/treatment.dart';
import 'package:mobile_app_theraphy/data/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpHelper {
  //final String urlBase = 'http://ec2-52-90-129-137.compute-1.amazonaws.com:8080/api/v1';

  final String urlBase = 'http://192.168.74.60:8080/api/v1';

  Future<void> register(int id, String firstName, String lastName,
      String username, String password, String _selectedRole) async {
    const endpoint = '/security/auth/registration';
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

  Future<int> login(String username, String password) async {
    final credentials = {'username': username, 'password': password};
    const endpoint = '/security/auth/authentication';
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
          return 1;
        } else {
          //throw Exception('Access token not found in the response.');
          return 2;
        }
      } else {
        //throw Exception('Failed to log in. Status code: ${response.statusCode}');
        return 3;
      }
    } catch (exception) {
      print('Error: $exception');
      // Manejar el error, por ejemplo, mostrar un mensaje de error al usuario.
      return 4;
    }
  }

  void createPatient(dni, age, selectedDateAsString, location) async {
    const reference = '/profile';
    const createPatientEndpoint = '/patients/registration-patient';
    final String createPatientUrl = '$urlBase$reference$createPatientEndpoint';
    final patient = CPatient(
        id: 0,
        dni: dni,
        age: age,
        photoUrl: "",
        birthdayDate: selectedDateAsString,
        appointmentQuantity: 0,
        location: location);
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
        body: jsonEncode(patient.toCJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
      } else {
        throw Exception(
            'Failed to create patient. Status code: ${response.statusCode}');
      }
    } catch (exception) {
      print('Error: $exception');
      throw Exception('Failed to create patient.');
    }
  }

  void createPhysiotherapist(dni, age, specialization, selectedDateAsString,
      location, fees, experience) async {
    const reference = '/profile';
    final physiotherapist = CPhysiotherapist(
        id: 0,
        dni: dni ?? "",
        specialization: specialization ?? "",
        age: age != null ? int.parse(age.toString()) : 0,
        location: location ?? "",
        photoUrl: "",
        birthdayDate: selectedDateAsString ?? "",
        rating: 0,
        consultationQuantity: 0,
        patientQuantity: 0,
        yearsExperience:
            experience != null ? int.parse(experience.toString()) : 0,
        fees: fees != null ? double.parse(fees.toString()) : 0);
    const createPhysiotherapistEndpoint =
        '/physiotherapists/registration-physiotherapist';
    final String createPhysiotherapistUrl =
        '$urlBase$reference$createPhysiotherapistEndpoint';
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');
    print(jwtToken);
    print(createPhysiotherapistUrl);
    print(physiotherapist.age);
    print(physiotherapist.dni);
    print(physiotherapist.specialization);
    print(physiotherapist.location);
    print(physiotherapist.photoUrl);
    print(physiotherapist.birthdayDate);
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
        body: jsonEncode(physiotherapist.toCJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
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
    const reference = '/profile/physiotherapists';
    const getPhysiotherapistLoggedEndpoint = '/PhysiotherapistLogget';
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

  Future<Physiotherapist> getPhysiotherapist() async {
    const reference = '/profile/physiotherapists';
    const getPhysiotherapistLoggedEndpoint = '/PhysiotherapistLogget';
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
        final decodedData = utf8.decode(response.bodyBytes);
        final jsonResponse = json.decode(decodedData);
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

    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final decodedData = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedData);
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

    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final decodedData = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedData);
      final List<dynamic> consultationsMap = jsonResponse['content'];
      List<Consultation> consultations =
          consultationsMap.map((map) => Consultation.fromJson(map)).toList();
      consultations = consultations.reversed.toList();
      return consultations;
    } else {
      return null;
    }
  }

  ////////////////////////////////

  Future<List<Consultation>?> getMyConsultationsDone(
      int physiotherapistId) async {
    String endpoint = '/consultations/byPhysiotherapistId/$physiotherapistId';
    final String url = '$urlBase$endpoint';

    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final decodedData = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedData);
      final List<dynamic> consultationsMap = jsonResponse['content'];
      List<Consultation> consultations =
          consultationsMap.map((map) => Consultation.fromJson(map)).toList();
      consultations = consultations.reversed.toList();
      List<Consultation> myConsultationsDone = consultations
          .where((consultation) => consultation.done == true)
          .toList();
      return myConsultationsDone;
    } else {
      return null;
    }
  }

  Future<List<Consultation>?> getMyConsultationsNoDone(
      int physiotherapistId) async {
    String endpoint = '/consultations/byPhysiotherapistId/$physiotherapistId';
    final String url = '$urlBase$endpoint';

    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final decodedData = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedData);
      final List<dynamic> consultationsMap = jsonResponse['content'];
      List<Consultation> consultations =
          consultationsMap.map((map) => Consultation.fromJson(map)).toList();
      consultations = consultations.reversed.toList();
      List<Consultation> myConsultationsNoDone = consultations
          .where((consultation) => consultation.done == false)
          .toList();
      return myConsultationsNoDone;
    } else {
      return null;
    }
  }

  Future<List<Patient>?> getMyPatientsWithTheraphy(
      int physiotherapistId) async {
    const String endpoint = '/therapy/therapies';
    final String url = '$urlBase$endpoint';

    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final decodedData = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedData);
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
        print(therapy.patient.user.firstname);
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
        '/therapy/therapies/byPhysioAndPatient/$physiotherapistId/$patientId';
    final String url = '$urlBase$endpoint';

    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      final decodedData = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedData);

      return Therapy.fromJson(jsonResponse);
    } else {
      return null;
    }
  }

  void addTherapy(
      String therapyName,
      String description,
      String appointmentQuantity,
      String startAt,
      String finishAt,
      int patientId) async {
    const String endpoint = '/therapy/therapies';
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
    print(response.body);
    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
    } else {
      throw Exception(
          'Failed to create Therapy. Status code: ${response.statusCode}');
    }
  }

  void addAppointment(String topic, String date, String hour, String place,
      int therapyId) async {
    const String endpoint = '/therapy/appointments';
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
      print(jsonResponse);
    } else {
      throw Exception(
          'Failed to create physiotherapist. Status code: ${response.statusCode}');
    }
  }

  Future<Appointment?> getApppointmentByTherapyAndDate(
      int theraphyId, String date) async {
    var endpoint = '/therapy/appointments/byDate/$date/TherapyId/$theraphyId';
    final String url = '$urlBase$endpoint';

    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      final decodedData = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedData);

      return Appointment.fromJson(jsonResponse);
    } else {
      return null;
    }
  }

  void addTreatment(int therapyId, String videoUrl, String duration,
      String title, String description, String day) async {
    const String endpoint = '/therapy/treatments';
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
      print(jsonResponse);
    } else {
      throw Exception(
          'Failed to create physiotherapist. Status code: ${response.statusCode}');
    }
  }

  Future<Treatment?> getTreatmentByTherapyAndDate(
      int theraphyId, String date) async {
    var endpoint = '/therapy/treatments/byDate/$date/TherapyId/$theraphyId';
    final String url = '$urlBase$endpoint';

    print(url);
    print("HOLA BEBE");

    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    print(response.body);
    if (response.statusCode == HttpStatus.ok) {
      final decodedData = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedData);

      return Treatment.fromJson(jsonResponse);
    } else {
      return null;
    }
  }

  Future<List<Patient>?> getMyPatientsOnlyConsultation(
      int physiotherapistId) async {
    String endpoint = '/consultations/byPhysiotherapistId/$physiotherapistId';
    final String url = '$urlBase$endpoint';

    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final decodedData = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedData);
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

      const String endpoint = '/therapy/therapies';
      final String url = '$urlBase$endpoint';

      http.Response response2 =
          await http.get(Uri.parse(url), headers: headers);

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
    final endpoint = '/health-expertise/diagnoses/byPatientId/$patientId';
    final String url = '$urlBase$endpoint';

    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final decodedData = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedData);
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
    final endpoint = '/therapy/therapies/byPatientId/$patientId';
    final String url = '$urlBase$endpoint';

    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final decodedData = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedData);
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
    String endpoint =
        '/health-expertise/medical-histories/byPatientId/$patientId';
    final String url = '$urlBase$endpoint';

    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final decodedData = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedData);
      final MedicalHistory medicalHistory =
          MedicalHistory.fromJson(jsonResponse);

      return medicalHistory;
    } else {
      return null;
    }
  }

  Future<List<IotResult>?> getIotResultsByTherapyIdandDate(
      int therapyId, String date) async {
    final endpoint = '/iot-data/iotResults/byTherapyId/$therapyId/Date/$date';
    final String url = '$urlBase$endpoint';

    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == HttpStatus.ok) {
      final decodedData = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedData);
      final List<dynamic> iotResultsMap = jsonResponse['content'];
      List<IotResult> iotresults =
          iotResultsMap.map((map) => IotResult.fromJson(map)).toList();

      return iotresults;
    }

    return null;
  }

  void createMedicalHistory(
      String gender,
      double size,
      double weight,
      String birthplace,
      String hereditaryHistory,
      String nonPathologicalHistory,
      String pathologicalHistory,
      int patientId) async {
    const String endpoint = '/health-expertise/medical-histories';
    final String url = '$urlBase$endpoint';

    final Map<String, dynamic> requestBody = {
      "gender": gender,
      "size": size,
      "weight": weight,
      "birthplace": birthplace,
      "hereditaryHistory": hereditaryHistory,
      "nonPathologicalHistory": nonPathologicalHistory,
      "pathologicalHistory": pathologicalHistory,
      "patientId": patientId
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
      print(jsonResponse);
    } else {
      throw Exception(
          'Failed to create medical history. Status code: ${response.statusCode}');
    }
  }

  Future<List<Appointment>?> getMyAppointments(int physiotherapistId) async {
    String endpoint =
        '/therapy/appointments/appointment/therapy-physiotherapist/$physiotherapistId';
    final String url = '$urlBase$endpoint';

    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final decodedData = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedData);
      final List<dynamic> appointmentsMap = jsonResponse['content'];
      List<Appointment> appointments =
          appointmentsMap.map((map) => Appointment.fromJson(map)).toList();
      appointments = appointments.reversed.toList();
      return appointments;
    } else {
      return null;
    }
  }

  Future<List<Appointment>?> getAllAppointmentsByPhysiotherapistId(
      int physiotherapistId) async {
    String endpoint = '/therapy/appointments';
    final String url = '$urlBase$endpoint';

    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final decodedData = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedData);
      final List<dynamic> appointmentsMap = jsonResponse['content'];
      List<Appointment> appointments =
          appointmentsMap.map((map) => Appointment.fromJson(map)).toList();
      appointments = appointments.reversed.toList();

      List<Appointment> myAppointments = appointments
          .where((appointment) =>
              appointment.therapy.physiotherapist.id == physiotherapistId)
          .toList();
      return myAppointments;
    } else {
      return null;
    }
  }

  Future<List<Appointment>?> getAllAppointmentsByPhysiotherapistIdNoDone(
      int physiotherapistId) async {
    String endpoint = '/therapy/appointments';
    final String url = '$urlBase$endpoint';

    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final decodedData = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedData);
      final List<dynamic> appointmentsMap = jsonResponse['content'];
      List<Appointment> appointments =
          appointmentsMap.map((map) => Appointment.fromJson(map)).toList();
      appointments = appointments.reversed.toList();

      List<Appointment> myAppointments = appointments
          .where((appointment) =>
              appointment.therapy.physiotherapist.id == physiotherapistId)
          .toList();
      List<Appointment> myAppointmentsNoDone = appointments
          .where((appointment) => appointment.done == false)
          .toList();
      return myAppointmentsNoDone;
    } else {
      return null;
    }
  }

  Future<void> updateDiagnosis(int appointmentId, String diagnosis) async {
    String endpoint = '/therapy/appointments/$appointmentId';
    final String url = '$urlBase$endpoint';

    final Map<String, dynamic> requestBody = {
      "diagnosis": diagnosis,
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

    try {
      final response = await http.patch(
        Uri.parse(url),
        body: encodedBody,
        headers: headers,
      );

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        // Puedes manejar la respuesta como desees, dependiendo de tu lógica de la aplicación.
        print(jsonResponse);
      } else {
        throw Exception(
            'Failed to update diagnosis. Status code: ${response.statusCode}');
      }
    } catch (exception) {
      print('Error: $exception');
      // Puedes manejar el error aquí, por ejemplo, mostrar un mensaje de error al usuario.
    }
  }

  Future<void> updateDiagnosisCosultation(
      int consultationId, String diagnosis) async {
    String endpoint = '/consultations/updateDiagnosis/$consultationId';
    final String url = '$urlBase$endpoint';

    final String requestBody = diagnosis;

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
      final response = await http.patch(
        Uri.parse(url),
        body: requestBody,
        headers: headers,
      );

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd').format(now);
        final Map<String, dynamic> requestBody = {
          "patientId": jsonResponse['patientId']['id'],
          "date": formattedDate,
          "diagnosis": jsonResponse['diagnosis'],
        };

        final encodedBody = json.encode(requestBody);

        String endpoint2 = '/health-expertise/diagnoses';
        final String url2 = '$urlBase$endpoint2';

        try {
          final response2 = await http.post(
            Uri.parse(url2),
            body: encodedBody,
            headers: headers,
          );

          print("diagonsis" + response2.body);

          if (response2.statusCode == 201) {
            final jsonResponse = json.decode(response2.body);
          } else {
            throw Exception(
                'Failed to create diagnosis in table. Status code: ${response.statusCode}');
          }
        } catch (exception) {
          print('Error creating diagnosis: $exception');
        }
      } else {
        throw Exception(
            'Failed to update diagnosis for consultation. Status code: ${response.statusCode}');
      }
    } catch (exception) {
      print('Error updating consultation: $exception');
    }
  }

  Future<List<Review>?> getMyReviews(int physiotherapistId) async {
    String endpoint = '/social/reviews/byPhysiotherapistId/$physiotherapistId';
    final String url = '$urlBase$endpoint';

    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final decodedData = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedData);
      final List<dynamic> reviewsMap = jsonResponse['content'];
      final List<Review> reviews =
          reviewsMap.map((map) => Review.fromJson(map)).toList();

      return reviews;
    } else {
      return null;
    }
  }

  Future<List<IotDevice>?> getMyIotDevices(int physiotherapistId) async {
    String endpoint =
        '/iot-data/iotDevice/byPhysiotherapistId/$physiotherapistId';
    final String url = '$urlBase$endpoint';

    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final decodedData = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedData);
      final List<dynamic> iotdevicesmap = jsonResponse['content'];
      final List<IotDevice> myiotdevices =
          iotdevicesmap.map((map) => IotDevice.fromJson(map)).toList();

      return myiotdevices;
    } else {
      return null;
    }
  }

  Future<void> creatIoTDevice(int physioId, int patientId) async {
    String endpoint = '/iot-data/iotDevice';
    final String url = '$urlBase$endpoint';

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
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        final id = jsonResponse['id'];

        assignIotDeviceAgain(id, physioId, patientId);
      } else {
        throw Exception(
            'Failed to create iot. Status code: ${response.statusCode}');
      }
    } catch (exception) {
      print('Error: $exception');
    }
  }

  Future<void> assignIotDeviceAgain(
      int iotdeviceId, int physioId, int patientId) async {
    Therapy? therapy = await getTherapyByPhysioAndPatient(physioId, patientId);

    String endpoint =
        '/iot-data/iotDevice/assign/$iotdeviceId/to/${therapy?.id}';
    final String url = '$urlBase$endpoint';

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
        Uri.parse(url),
        headers: headers,
      );

      print(response.body);
      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
      } else {
        throw Exception(
            'Failed to assign iot. Status code: ${response.statusCode}');
      }
    } catch (exception) {
      print('Error: $exception');
    }
  }
}
