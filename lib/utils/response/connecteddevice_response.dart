// To parse this JSON data, do
//
//     final connecteddeviceresponse = connecteddeviceresponseFromJson(jsonString);

import 'dart:convert';

Connecteddeviceresponse connecteddeviceresponseFromJson(String str) =>
    Connecteddeviceresponse.fromJson(json.decode(str));

String connecteddeviceresponseToJson(Connecteddeviceresponse data) =>
    json.encode(data.toJson());

class Connecteddeviceresponse {
  Connecteddeviceresponse({
    this.success,
    this.message,
    this.logins,
  });

  bool? success;
  String? message;
  List<Login>? logins;

  factory Connecteddeviceresponse.fromJson(Map<String, dynamic> json) =>
      Connecteddeviceresponse(
        success: json["success"],
        message: json["message"],
        logins: List<Login>.from(json["logins"].map((x) => Login.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "logins": List<dynamic>.from(logins!.map((x) => x.toJson())),
      };
}

class Login {
  Login({
    this.loggedOut,
    this.tokenDeleted,
    this.id,
    this.username,
    this.tokenId,
    this.tokenSecret,
    this.ipAddress,
    this.loggedInAt,
    this.device,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.current,
  });

  bool? loggedOut;
  bool? tokenDeleted;
  String? id;
  String? username;
  String? tokenId;
  String? tokenSecret;
  String? ipAddress;
  String? loggedInAt;
  String? device;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  bool? current;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        loggedOut: json["logged_out"],
        tokenDeleted: json["token_deleted"],
        id: json["_id"],
        username: json["username"],
        tokenId: json["token_id"],
        tokenSecret: json["token_secret"],
        ipAddress: json["ip_address"],
        loggedInAt: json["logged_in_at"],
        device: json["device"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        current: json["current"],
      );

  Map<String, dynamic> toJson() => {
        "logged_out": loggedOut,
        "token_deleted": tokenDeleted,
        "_id": id,
        "username": username,
        "token_id": tokenId,
        "token_secret": tokenSecret,
        "ip_address": ipAddress,
        "logged_in_at": loggedInAt,
        "device": device,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
        "current": current,
      };
}
