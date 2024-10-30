// To parse this JSON data, do
//
//     final paymentmethodresponse = paymentmethodresponseFromJson(jsonString);

import 'dart:convert';

Paymentmethodresponse paymentmethodresponseFromJson(String str) => Paymentmethodresponse.fromJson(json.decode(str));

String paymentmethodresponseToJson(Paymentmethodresponse data) => json.encode(data.toJson());

class Paymentmethodresponse {
  Paymentmethodresponse({
    this.success,
    this.message,
    this.payment,
  });

  bool ? success;
  String ? message;
  List<dynamic> ? payment;

  factory Paymentmethodresponse.fromJson(Map<String, dynamic> json) => Paymentmethodresponse(
    success: json["success"],
    message: json["message"],
    payment: List<dynamic>.from(json["payment"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "payment": List<dynamic>.from(payment!.map((x) => x)),
  };
}
