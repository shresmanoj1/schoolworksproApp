// To parse this JSON data, do
//
//     final switchRequest = switchRequestFromJson(jsonString);

import 'dart:convert';

SwitchRequest switchRequestFromJson(String str) =>
    SwitchRequest.fromJson(json.decode(str));

String switchRequestToJson(SwitchRequest data) => json.encode(data.toJson());

class SwitchRequest {
  SwitchRequest({
    this.type,
  });

  String? type;

  factory SwitchRequest.fromJson(Map<String, dynamic> json) => SwitchRequest(
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
      };
}
