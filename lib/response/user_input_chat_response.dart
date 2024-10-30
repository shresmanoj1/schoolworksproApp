// To parse this JSON data, do
//
//     final userInputChatResponse = userInputChatResponseFromJson(jsonString);

import 'dart:convert';

UserInputChatResponse userInputChatResponseFromJson(String str) => UserInputChatResponse.fromJson(json.decode(str));

String userInputChatResponseToJson(UserInputChatResponse data) => json.encode(data.toJson());

class UserInputChatResponse {
  InputData ? data;

  UserInputChatResponse({
    this.data,
  });

  factory UserInputChatResponse.fromJson(Map<String, dynamic> json) => UserInputChatResponse(
    data: InputData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class InputData {
  bool ? success;
  String ? response;

  InputData({
    this.success,
    this.response,
  });

  factory InputData.fromJson(Map<String, dynamic> json) => InputData(
    success: json["success"],
    response: json["response"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "response": response,
  };
}
