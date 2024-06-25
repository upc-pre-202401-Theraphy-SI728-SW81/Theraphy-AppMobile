import 'package:mobile_app_theraphy/data/model/user.dart';

class Patient{
    int id;
    String dni;
    int age;
    String photoUrl;
    String birthdayDate;
    int appointmentQuantity;
    String location; 
    User user;   
    
  Patient({
    required this.id,
    required this.dni,
    required this.age,
    required this.photoUrl,
    required this.birthdayDate,
    required this.appointmentQuantity,
    required this.location,
    required this.user
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dni': dni,
      'age': age,
      'photoUrl': photoUrl,
      'birthdayDate': birthdayDate,
      'appointmentQuantity': appointmentQuantity,
      'location': location
    };
  }

   Patient.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            dni: json['dni'],
            age: json['age'],
            photoUrl: json['photoUrl'],
            birthdayDate: json['birthdayDate'],
            appointmentQuantity: json['appointmentQuantity'],
            location: json['location'],
            user: User.fromJson(json['user'])
            );

}

class CPatient{
    int id;
    String dni;
    int age;
    String photoUrl;
    String birthdayDate;
    int appointmentQuantity;
    String location; 
    
  CPatient({
    required this.id,
    required this.dni,
    required this.age,
    required this.photoUrl,
    required this.birthdayDate,
    required this.appointmentQuantity,
    required this.location,
  });
  
  Map<String, dynamic> toCJson() {
    return {
      'id': id,
      'dni': dni,
      'age': age,
      'photoUrl': photoUrl,
      'birthdayDate': birthdayDate,
      'appointmentQuantity': appointmentQuantity,
      'location': location
    };
  }

   CPatient.fromCJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            dni: json['dni'],
            age: json['age'],
            photoUrl: json['photoUrl'],
            birthdayDate: json['birthdayDate'],
            appointmentQuantity: json['appointmentQuantity'],
            location: json['location']
            );

}