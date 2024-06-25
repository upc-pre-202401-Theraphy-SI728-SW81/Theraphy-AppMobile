import 'dart:ffi';

import 'package:mobile_app_theraphy/data/model/physiotherapist.dart';
import 'package:mobile_app_theraphy/data/model/patient.dart';

class Review {
  int id;
  String content;
  int score;
  Physiotherapist physiotherapist;
  Patient patient;

  Review(
      {required this.id,
      required this.content,
      required this.score,
      required this.physiotherapist,
      required this.patient});

  Review.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            content: json['content'],
            score: json['score'],
            physiotherapist: Physiotherapist.fromJson(json['physiotherapist']),
            patient: Patient.fromJson(json['patient']));
}
