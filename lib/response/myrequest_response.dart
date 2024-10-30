// To parse this JSON data, do
//
//     final myrequestResponse = myrequestResponseFromJson(jsonString);

import 'dart:convert';

MyrequestResponse myrequestResponseFromJson(String str) =>
    MyrequestResponse.fromJson(json.decode(str));

String myrequestResponseToJson(MyrequestResponse data) =>
    json.encode(data.toJson());

class MyrequestResponse {
  MyrequestResponse({
    this.success,
    this.response,
  });

  bool? success;
  Response? response;

  factory MyrequestResponse.fromJson(Map<String, dynamic> json) =>
      MyrequestResponse(
        success: json["success"],
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "response": response!.toJson(),
      };
}

class Response {
  Response({
    this.response,
    this.id,
    this.postedBy,
    this.createdAt,
  });

  String? response;
  String? id;
  PostedBy? postedBy;
  DateTime? createdAt;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        response: json["response"],
        id: json["_id"],
        postedBy: PostedBy.fromJson(json["postedBy"]),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "_id": id,
        "postedBy": postedBy!.toJson(),
        "createdAt": createdAt!.toIso8601String(),
      };
}

class PostedBy {
  PostedBy({
    this.type,
    this.username,
    this.firstname,
    this.lastname,
    this.userImage,
  });

  String? type;
  String? username;
  String? firstname;
  String? lastname;
  String? userImage;

  factory PostedBy.fromJson(Map<String, dynamic> json) => PostedBy(
        type: json["type"],
        username: json["username"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        userImage: json["userImage"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
        "userImage": userImage,
      };
}
