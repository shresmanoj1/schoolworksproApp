// To parse this JSON data, do
//
//     final getActiveUsernameResponse = getActiveUsernameResponseFromJson(jsonString);

import 'dart:convert';

GetActiveUsernameResponse getActiveUsernameResponseFromJson(String str) =>
    GetActiveUsernameResponse.fromJson(json.decode(str));

String getActiveUsernameResponseToJson(GetActiveUsernameResponse data) =>
    json.encode(data.toJson());

class GetActiveUsernameResponse {
  GetActiveUsernameResponse({
    this.success,
    this.activeUsers,
  });

  bool? success;
  List<ActiveUser>? activeUsers;

  factory GetActiveUsernameResponse.fromJson(Map<String, dynamic> json) =>
      GetActiveUsernameResponse(
        success: json["success"],
        activeUsers: List<ActiveUser>.from(
            json["active_users"].map((x) => ActiveUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "active_users": List<dynamic>.from(activeUsers!.map((x) => x.toJson())),
      };
}

class ActiveUser {
  ActiveUser({
    this.username,
    this.firstname,
    this.lastname,
    this.userImage,
  });

  String? username;
  String? firstname;
  String? lastname;
  String? userImage;

  factory ActiveUser.fromJson(Map<String, dynamic> json) => ActiveUser(
        username: json["username"] == null ? null : json["username"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        userImage: json["userImage"] == null ? null : json["userImage"],
      );

  Map<String, dynamic> toJson() => {
        "username": username == null ? null : username,
        "firstname": firstname == null ? null : firstname,
        "lastname": lastname == null ? null : lastname,
        "userImage": userImage == null ? null : userImage,
      };
}
