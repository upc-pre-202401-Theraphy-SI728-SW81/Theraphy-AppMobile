class Physiotherapist {
  int id;
  String dni;
  String specialization;
  int age;
  String location;
  String photoUrl;
  String birthdayDate;
  double rating;
  int consultationsQuantity;
  int patinentQuantity;
  int yearsExperience;
  int fees;


  Physiotherapist(
      {required this.id,
      required this.dni,
      required this.specialization,
      required this.age,
      required this.location,
      required this.photoUrl,
      required this.birthdayDate,
      required this.rating,
      required this.consultationsQuantity,
      required this.patinentQuantity,  
      required this.yearsExperience,
      required this.fees,
      });

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
      'consultationsQuantity': consultationsQuantity,
      'patinentQuantity': patinentQuantity,
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
          location: json ['location'],
          photoUrl: json['photoUrl'],     
          birthdayDate: json['birthdayDate'],
          rating: json['rating'],
          consultationsQuantity: json['consultationsQuantity'],
          patinentQuantity: json['patinentQuantity'],
          yearsExperience: json['yearsExperience'],
          fees: json['fees'],
        );
  
}