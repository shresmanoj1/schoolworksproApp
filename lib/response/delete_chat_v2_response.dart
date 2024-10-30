// To parse this JSON data, do
//
//     final deleteChatV2Response = deleteChatV2ResponseFromJson(jsonString);

import 'dart:convert';

DeleteChatV2Response deleteChatV2ResponseFromJson(String str) => DeleteChatV2Response.fromJson(json.decode(str));

String deleteChatV2ResponseToJson(DeleteChatV2Response data) => json.encode(data.toJson());

class DeleteChatV2Response {
  Data ? data;

  DeleteChatV2Response({
    this.data,
  });

  factory DeleteChatV2Response.fromJson(Map<String, dynamic> json) => DeleteChatV2Response(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class Data {
  bool ? success;
  int ? messages;

  Data({
    this.success,
    this.messages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    success: json["success"],
    messages: json["messages"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "messages": messages,
  };
}
