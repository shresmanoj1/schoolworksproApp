import 'dart:convert';

import 'package:schoolworkspro_app/api/api.dart';

import '../../../response/chat_bot_response.dart';
import '../../../response/delete_chat_v2_response.dart';
import '../../../response/get_all_chat_ai_response.dart';
import '../../../response/user_input_chat_response.dart';
import '../../endpoints.dart';

class ChatBotRepo {
  API api = API();

  Future<List<Map<String, dynamic>>> getResponse(dynamic datas) async {
    API api = API();
    dynamic response;
    List<Map<String, dynamic>> res;
    try {
      response = await api.postChat(datas);
      res = List<Map<String, dynamic>>.from(
          response.map((element) => Map<String, dynamic>.from(element)));

    } catch (e) {
      print(e.toString());
      res = List<Map<String, dynamic>>.from(
          response.map((element) => Map<String, dynamic>.from(element)));
    }
    return res;
  }

  Future<List<Map<String, dynamic>>> getResponseLecturer(dynamic datas) async {
    API api = API();
    dynamic response;
    List<Map<String, dynamic>> res;
    try {
      response = await api.postChatLecturer(datas);
      res = List<Map<String, dynamic>>.from(
          response.map((element) => Map<String, dynamic>.from(element)));

    } catch (e) {
      print(e.toString());
      res = List<Map<String, dynamic>>.from(
          response.map((element) => Map<String, dynamic>.from(element)));
    }
    return res;
  }


  Future<List<Map<String, dynamic>>> getResponseAdmin(dynamic datas) async {
    API api = API();
    dynamic response;
    List<Map<String, dynamic>> res;
    try {
      response = await api.postChatAdmin(datas);
      res = List<Map<String, dynamic>>.from(
          response.map((element) => Map<String, dynamic>.from(element)));

    } catch (e) {
      print(e.toString());
      res = List<Map<String, dynamic>>.from(
          response.map((element) => Map<String, dynamic>.from(element)));
    }
    return res;
  }

  ///v2
  Future<GetAllChatAiResponse> getAllMessagesV2(String username) async {
    API api = API();
    dynamic response;
    GetAllChatAiResponse res;
    try {
      response = await api.getWithToken(Endpoints.kGetAllMessages + username);

      res = GetAllChatAiResponse.fromJson(response);
    } catch (e) {
      res = GetAllChatAiResponse.fromJson(response);
    }
    return res;
  }

  Future<UserInputChatResponse> sendUserInput(String params,bool student) async {
    API api = API();
    dynamic response;
    UserInputChatResponse res;
    try {
      response = await api.getWithToken(student ? Endpoints.kGetUserInputStudent + params : Endpoints.kGetUserInputAdmin + params);
      res = UserInputChatResponse.fromJson(response);
    } catch (e) {
      res = UserInputChatResponse.fromJson(response);
    }
    return res;
  }

  Future<DeleteChatV2Response> deleteHistory(String username) async {
    API api = API();
    dynamic response;
    DeleteChatV2Response res;
    try {
      response = await api.getWithToken(Endpoints.kDeleteChat + username);
      res = DeleteChatV2Response.fromJson(response);
    } catch (e) {
      res = DeleteChatV2Response.fromJson(response);
    }
    return res;
  }
}
