class User {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String password;
  final String role;
  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.username,
      required this.password,
      required this.role
      }
  );
     

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,      
      'usename': username,
      'password': password,
      'role': role,
    };
  }

  User.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          firstName: json['firstName'],
          lastName: json['lastName'],          
          username: json['usename'],
          password: json['password'],
          role: json['role'],
        );
}