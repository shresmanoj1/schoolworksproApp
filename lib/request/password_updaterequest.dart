// import 'package:flutter/foundation.dart';

class PasswordUpdateRequest {
  String currPassword;
  String newPassword;

  PasswordUpdateRequest({
    required this.currPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "currPassword": currPassword,
      "newPassword": newPassword,
    };
  }
}
