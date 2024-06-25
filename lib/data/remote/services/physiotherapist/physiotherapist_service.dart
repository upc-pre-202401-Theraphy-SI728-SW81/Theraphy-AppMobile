import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobile_app_theraphy/data/model/physiotherapist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhysiotherapistService {
  final String baseUrl =
      'https://api-iotheraphy-production.up.railway.app/api/v1/physiotherapists';

  Future<List<Physiotherapist>?> getAll() async {
    final http.Response response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> maps = jsonResponse['content'];
      return maps.map((map) => Physiotherapist.fromJson(map)).toList();
    } else {
      return List.empty();
    }
  }

  Future<Physiotherapist?> getPhysiotherapistById(int physiotherapistId) async {
    final String url = '$baseUrl/$physiotherapistId';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final Physiotherapist physiotherapist =
          Physiotherapist.fromJson(jsonResponse);
      return physiotherapist;
    } else {
      return null;
    }
  }

  Future<void> patchImageUrlToPhysiotherapist(
      int physiotherapistId, String photoUrl) async {
    final String url = '$baseUrl/$physiotherapistId';

    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('accessToken');

    if (jwtToken == null) {
      throw Exception('JWT Token not found in SharedPreferences.');
    }

    final headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };

    final bodyData = jsonEncode({'photoUrl': photoUrl});

    http.Response response =
        await http.patch(Uri.parse(url), headers: headers, body: bodyData);

    if (response.statusCode == 201) {
      // El PATCH fue exitoso
      print('PATCH exitoso');

      ///return true;
    } else {
      // Ocurrió un error durante el PATCH
      print('Error en el PATCH: ${response.statusCode}');
      //return false;
    }
  }

  Future<bool> patchPhysiotherapist(
      int physiotherapistId, Physiotherapist physiotherapist) async {
    final String url = '$baseUrl/$physiotherapistId';

    final bodyData = jsonEncode({
      'user': {'firstname': physiotherapist.user.firstname},
      'specialization': physiotherapist.specialization
    });

    final headers = {'Content-Type': 'application/json'};

    http.Response response =
        await http.patch(Uri.parse(url), headers: headers, body: bodyData);

    if (response.statusCode == 201) {
      // El PATCH fue exitoso
      print('PATCH exitoso');
      return true;
    } else {
      // Ocurrió un error durante el PATCH
      print('Error en el PATCH: ${response.statusCode}');
      return false;
    }
  }
}
