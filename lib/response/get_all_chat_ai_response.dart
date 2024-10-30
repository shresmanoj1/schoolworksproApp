import 'dart:convert';

GetAllChatAiResponse getAllChatAiResponseFromJson(String str) =>
    GetAllChatAiResponse.fromJson(json.decode(str));

String getAllChatAiResponseToJson(GetAllChatAiResponse data) =>
    json.encode(data.toJson());

class GetAllChatAiResponse {
  Data? data;

  GetAllChatAiResponse({
    this.data,
  });

  factory GetAllChatAiResponse.fromJson(Map<String, dynamic> json) =>
      GetAllChatAiResponse(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class Data {
  bool? success;
  List<Message>? messages;

  Data({
    this.success,
    this.messages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    success: json["success"],
    messages: List<Message>.from(
        json["messages"].map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "messages": List<dynamic>.from(messages!.map((x) => x.toJson())),
  };
}

class Message {
  String role;
  String content;

  Message({
    required this.role,
    required this.content,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    role: json["role"],
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "role": role,
    "content": content,
  };
}

