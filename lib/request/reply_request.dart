// import 'package:flutter/foundation.dart';

class Replyrequest {
  String? comment;

  Replyrequest({
    this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      "comment": comment,
    };
  }
}
