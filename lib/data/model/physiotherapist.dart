import 'package:mobile_app_theraphy/data/model/user.dart';

class Physiotherapist {
  final int id;
  final String dni;
  String specialization;
  final int age;
  final String location;
  final String photoUrl;
  final String birthdayDate;
  final double rating;
  final int consultationQuantity;
  final int patientQuantity;
  final int yearsExperience;
  final double fees;
  final User user;

  Physiotherapist(
      {required this.id,
      required this.dni,
      required this.specialization,
      required this.age,
      required this.location,
      required this.photoUrl,
      required this.birthdayDate,
      required this.rating,
      required this.consultationQuantity,
      required this.patientQuantity,
      required this.yearsExperience,
      required this.fees,
      required this.user});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dni': dni,
      'specialization': specialization,
      'age': age,
      'location': location,
      'photoUrl': photoUrl,
      'birthdayDate': birthdayDate,
      'rating': rating,
      'consultationQuantity': consultationQuantity,
      'patientQuantity': patientQuantity,
      'yearsExperience': yearsExperience,
      'fees': fees,
    };
  }

  Physiotherapist.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            dni: json['dni'],
            specialization: json['specialization'],
            age: json['age'],
            location: json['location'],
            photoUrl: json['photoUrl'],
            birthdayDate: json['birthdayDate'],
            rating: json['rating'],
            consultationQuantity: json['consultationQuantity'],
            patientQuantity: json['patientQuantity'],
            yearsExperience: json['yearsExperience'],
            fees: json['fees'],
            user: User.fromJson(json['user']));
}

class CPhysiotherapist {
  final int id;
  final String dni;
  final String specialization;
  final int age;
  final String location;
  final String photoUrl;
  final String birthdayDate;
  final double rating;
  final int consultationQuantity;
  final int patientQuantity;
  final int yearsExperience;
  final double fees;

  const CPhysiotherapist(
      {required this.id,
      required this.dni,
      required this.specialization,
      required this.age,
      required this.location,
      required this.photoUrl,
      required this.birthdayDate,
      required this.rating,
      required this.consultationQuantity,
      required this.patientQuantity,
      required this.yearsExperience,
      required this.fees});

  Map<String, dynamic> toCJson() {
    return {
      'id': id,
      'dni': dni,
      'specialization': specialization,
      'age': age,
      'location': location,
      'photoUrl': photoUrl,
      'birthdayDate': birthdayDate,
      'rating': rating,
      'consultationQuantity': consultationQuantity,
      'patientQuantity': patientQuantity,
      'yearsExperience': yearsExperience,
      'fees': fees,
    };
  }

  CPhysiotherapist.fromCJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            dni: json['dni'],
            specialization: json['specialization'],
            age: json['age'],
            location: json['location'],
            photoUrl: json['photoUrl'],
            birthdayDate: json['birthdayDate'],
            rating: json['rating'],
            consultationQuantity: json['consultationQuantity'],
            patientQuantity: json['patientQuantity'],
            yearsExperience: json['yearsExperience'],
            fees: json['fees']);
}
