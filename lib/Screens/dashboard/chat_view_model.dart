import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:flutter_quill/translations.dart';
import 'package:schoolworkspro_app/api/repositories/chatbot/chat_repo.dart';
import 'package:schoolworkspro_app/response/chat_bot_response.dart';

import '../../api/api_response.dart';

class ChatViewModel extends ChangeNotifier {
  ApiResponse _classApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get classApiResponse => _classApiResponse;

  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> get messages => _messages;

  Future<void> fetchChat(dynamic datas) async {
    _classApiResponse = ApiResponse.initial("Loading");

    notifyListeners();
    try {
      List<Map<String, dynamic>> res = await ChatBotRepo().getResponse(datas);
      _messages = res;
      _classApiResponse = ApiResponse.completed(res);
      notifyListeners();
    } catch (e) {
      _classApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _lecturerChatApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get lecturerChatApiResponse => _lecturerChatApiResponse;

  List<Map<String, dynamic>> _lecturerMessages = [];
  List<Map<String, dynamic>> get lecturerMessages => _lecturerMessages;

  Future<void> fetchChatLecturer(dynamic datas) async {
    _lecturerChatApiResponse = ApiResponse.initial("Loading");

    notifyListeners();
    try {
      List<Map<String, dynamic>> res =
          await ChatBotRepo().getResponseLecturer(datas);
      _lecturerMessages = res;
      // print(_lecturerMessages.toString());
      _lecturerChatApiResponse = ApiResponse.completed(res);
      notifyListeners();
    } catch (e) {
      print(e.toString());
      _lecturerChatApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }


  ApiResponse _adminChatApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get adminChatApiResponse => _adminChatApiResponse;

  List<Map<String, dynamic>> _adminMessages = [];
  List<Map<String, dynamic>> get adminMessages => _adminMessages;

  Future<void> fetchChatAdmin(dynamic datas) async {
    _adminChatApiResponse = ApiResponse.initial("Loading");

    notifyListeners();
    try {
      List<Map<String, dynamic>> res =
          await ChatBotRepo().getResponseAdmin(datas);
      _adminMessages = res;
      _adminChatApiResponse = ApiResponse.completed(res);
      notifyListeners();
    } catch (e) {
      print(e.toString());
      _adminChatApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
