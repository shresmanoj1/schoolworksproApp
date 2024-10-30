// To parse this JSON data, do
//
//     final sendDraftResponse = sendDraftResponseFromJson(jsonString);

import 'dart:convert';

SendDraftResponse sendDraftResponseFromJson(String str) => SendDraftResponse.fromJson(json.decode(str));

String sendDraftResponseToJson(SendDraftResponse data) => json.encode(data.toJson());

class SendDraftResponse {
  SendDraftResponse({
    this.success,
    this.lessonUpdate,
  });

  bool ? success;
  dynamic lessonUpdate;

  factory SendDraftResponse.fromJson(Map<String, dynamic> json) => SendDraftResponse(
    success: json["success"],
    lessonUpdate: json["lessonUpdate"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "lessonUpdate": lessonUpdate,
  };
}
