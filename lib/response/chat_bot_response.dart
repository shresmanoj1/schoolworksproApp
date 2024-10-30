// To parse this JSON data, do
//
//     final chatbotResponse = chatbotResponseFromJson(jsonString);

import 'dart:convert';

List<ChatbotResponse> chatbotResponseFromJson(String str) =>
    List<ChatbotResponse>.from(
        json.decode(str).map((x) => ChatbotResponse.fromJson(x)));

String chatbotResponseToJson(List<ChatbotResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatbotResponse {
  ChatbotResponse({
    this.recipientId,
    this.text,
    this.buttons,
  });

  String? recipientId;
  String? text;
  List<Button>? buttons;

  factory ChatbotResponse.fromJson(Map<String, dynamic> json) =>
      ChatbotResponse(
        recipientId: json["recipient_id"],
        text: json["text"],
        buttons:
            List<Button>.from(json["buttons"].map((x) => Button.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "recipient_id": recipientId,
        "text": text,
        "buttons": List<dynamic>.from(buttons!.map((x) => x.toJson())),
      };
}

class Button {
  Button({
    this.title,
    this.payload,
  });

  String? title;
  String? payload;

  factory Button.fromJson(Map<String, dynamic> json) => Button(
        title: json["title"],
        payload: json["payload"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "payload": payload,
      };
}
