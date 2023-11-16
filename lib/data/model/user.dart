class User {
  final int id;
  String firstname;
  final String lastname;
  String username;
  final String password;
  final String role;
  User(
      {required this.id,
      required this.firstname,
      required this.lastname,
      required this.username,
      required this.password,
      required this.role});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'password': password
    };
  }

  User.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          firstname: json['firstname'],
          lastname: json['lastname'],
          username: json['username'],
          password: json['password'],
          role: json['role'],
        );
}
