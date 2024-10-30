// import 'package:flutter/foundation.dart';

class Setpasswordrequest {
  final String email;
  final String username;
  final String institution;
  final String password;

  Setpasswordrequest({
    required this.username,
    required this.email,
    required this.password,
    required this.institution,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "institution": institution,
      "password": password,
    };
  }
}
