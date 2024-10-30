// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.success,
    this.token,
    this.user,
    this.message,
    this.refresh,
    this.status,
  });

  bool? success;
  bool? refresh;
  String? token;
  User? user;
  String? message;
  int? status;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        success: json["success"],
        refresh: json["refresh"] == null ? null : json["refresh"],
        token: json["token"] == null ? null : json["token"],
        message: json["message"] == null ? null : json["message"],
        status: json["status"] == null ? null : json["status"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "token": token == null ? null : token,
        "message": message == null ? null : message,
        "status": status == null ? null : status,
        "user": user == null ? null : user!.toJson(),
        "refresh": refresh == null ? null : refresh,
      };
}

class User {
  User(
      {this.firstname,
      this.lastname,
      this.username,
      this.userImage,
      this.address,
      this.city,
      this.roles,
      this.type,
      this.batch,
      this.email,
      this.course,
      this.courseSlug,
      this.institution,
      this.isGuest,
      this.parent,
      this.ip,
      this.device,
      this.time,
      this.uuid,
      this.id,
      this.institutionType,
      this.parentBranch,
      this.dues,
      this.drole,
      this.droleName,
      this.dob,
      this.domains});

  String? firstname;
  String? lastname;
  String? username;
  String? userImage;
  bool? dues;
  String? course;
  String? address;
  String? city;
  List<dynamic>? roles;
  String? type;
  String? batch;
  String? email;
  String? courseSlug;
  String? institution;
  bool? isGuest;
  String? parent;
  String? ip;
  String? device;
  String? time;
  String? uuid;
  String? id;
  String? institutionType;
  String? dob;
  String? drole;
  String? droleName;
  List<dynamic>? domains;

  dynamic parentBranch;

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstname: json["firstname"],
        lastname: json["lastname"],
        dues: json['dues'],
        username: json["username"],
        userImage: json["userImage"],
        address: json["address"],
        city: json["city"],
        roles: List<dynamic>.from(json["roles"].map((x) => x)),
        domains: json["domains"] == null
            ? null
            : List<dynamic>.from(json["domains"].map((x) => x)),
        type: json["type"],
        course: json['course'],
        batch: json["batch"],
        email: json["email"],
        dob: json["dob"],
        courseSlug: json["courseSlug"],
        institution: json["institution"],
        isGuest: json["isGuest"],
        parent: json["parent"],
        ip: json["ip"],
        device: json["device"],
        time: json["time"],
        uuid: json["uuid"],
        id: json["_id"],
        drole: json["drole"],
        droleName: json["droleName"],
        institutionType: json["institution_type"],
        parentBranch: json["parentBranch"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
        "userImage": userImage,
        "address": address,
        "city": city,
        "dues": dues,
        "roles": List<dynamic>.from(roles!.map((x) => x)),
        "domains": List<dynamic>.from(domains!.map((x) => x)),
        "type": type,
        "batch": batch,
        "course": course,
        "email": email,
        "courseSlug": courseSlug,
        "institution": institution,
        "isGuest": isGuest,
        "parent": parent,
        "dob": dob,
        "ip": ip,
        "device": device,
        "time": time,
        "uuid": uuid,
        "_id": id,
        "institution_type": institutionType,
        "parentBranch": parentBranch,
        "drole": drole,
        "droleName": droleName
      };
}
