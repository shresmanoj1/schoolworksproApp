// To parse this JSON data, do
//
//     final getMessageResponse = getMessageResponseFromJson(jsonString);

import 'dart:convert';

GetMessageResponse getMessageResponseFromJson(String str) =>
    GetMessageResponse.fromJson(json.decode(str));

String getMessageResponseToJson(GetMessageResponse data) =>
    json.encode(data.toJson());

class GetMessageResponse {
  GetMessageResponse({
    this.success,
    this.allMessages,
  });

  bool? success;
  List<dynamic>? allMessages;

  factory GetMessageResponse.fromJson(Map<String, dynamic> json) =>
      GetMessageResponse(
        success: json["success"],
        allMessages: List<dynamic>.from(json["allMessages"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "allMessages": List<dynamic>.from(allMessages!.map((x) => x)),
      };
}
//
// class AllMessage {
//   AllMessage({
//     this.status,
//     this.message,
//     this.createdAt,
//     this.receiver,
//     this.sender,
//   });
//
//   String? status;
//   String? message;
//   DateTime? createdAt;
//   Receiver? receiver;
//   Receiver? sender;
//
//   factory AllMessage.fromJson(Map<String, dynamic> json) => AllMessage(
//         status: json["status"],
//         message: json["message"],
//         createdAt: DateTime.parse(json["createdAt"]),
//         receiver: Receiver.fromJson(json["receiver"]),
//         sender: Receiver.fromJson(json["sender"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "createdAt": createdAt?.toIso8601String(),
//         "receiver": receiver?.toJson(),
//         "sender": sender?.toJson(),
//       };
// }
//
// class Receiver {
//   Receiver({
//     this.username,
//     this.firstname,
//     this.lastname,
//     this.userImage,
//   });
//
//   String? username;
//   String? firstname;
//   String? lastname;
//   String? userImage;
//
//   factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
//         username: json["username"] == null ? null : json["username"],
//         firstname: json["firstname"] == null ? null : json["firstname"],
//         lastname: json["lastname"] == null ? null : json["lastname"],
//         userImage: json["userImage"] == null ? null : json["userImage"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "username": username == null ? null : username,
//         "firstname": firstname == null ? null : firstname,
//         "lastname": lastname == null ? null : lastname,
//         "userImage": userImage == null ? null : userImage,
//       };
// }
