// import 'package:flutter/foundation.dart';

class Usernameverificationrequest {
  final String email;
  final String username;
  final String institution;

  Usernameverificationrequest({
    required this.username,
    required this.email,
    required this.institution,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "institution": institution,
    };
  }
}
