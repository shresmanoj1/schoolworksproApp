// import 'package:flutter/foundation.dart';

class Commentrequest {
  String? comment;

  Commentrequest({
    this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      "comment": comment,
    };
  }
}
