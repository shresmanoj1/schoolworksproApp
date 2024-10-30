// import 'package:flutter/foundation.dart';

class Addprojectrequest {
  String? link;
  String? title;
  String? username;

  Addprojectrequest({
    this.link,
    this.title,
    this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      "link": link,
      "title": title,
      "username": username,
    };
  }
}
