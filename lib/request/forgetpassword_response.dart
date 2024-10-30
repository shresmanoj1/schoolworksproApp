// import 'package:flutter/foundation.dart';

class Forgetpasswordrequest {
  final String email;

  Forgetpasswordrequest({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {"email": email};
  }
}
