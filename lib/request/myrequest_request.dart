// import 'package:flutter/foundation.dart';

class Addresponserequest {
  String? response;

  Addresponserequest({
    this.response,
  });

  Map<String, dynamic> toJson() {
    return {
      "response": response,
    };
  }
}
