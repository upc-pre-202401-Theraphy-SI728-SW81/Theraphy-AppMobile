import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobile_app_theraphy/data/model/physiotherapist.dart';

class PhysiotherapistService {
  final String baseUrl = 'http://192.168.18.7:8080/api/v1/physiotherapists';

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
}
