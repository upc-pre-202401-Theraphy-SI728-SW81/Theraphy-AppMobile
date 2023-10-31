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
      required this.role});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstName,
      'lastname': lastName,
      'username': username,
      'password': password,
    };
  }

  User.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          firstName: json['firstname'],
          lastName: json['lastname'],
          username: json['username'],
          password: json['password'],
          role: json['role'],
        );
}
