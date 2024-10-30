import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/postmessage_request.dart';
import 'package:schoolworkspro_app/response/getmessage_response.dart';
import 'package:schoolworkspro_app/response/post_messageresponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageService extends ChangeNotifier {
  GetMessageResponse? data;
  Future getAuthentication(context) async {
    var client = http.Client();
    // var resultModel;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    var response = await client.get(
      Uri.parse(api_url2 + '/quick-message/my-messages'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    var mJson = jsonDecode(response.body);
    // print(response.body);

    data = GetMessageResponse.fromJson(mJson);
    notifyListeners();
  }

  Future<PostMessageResponse> sendMessage(PostMessageRequest request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .post(Uri.parse(api_url2 + '/quick-message'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = PostMessageResponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return PostMessageResponse(
            message: null,
            success: false,
          );
        }
      }).catchError((e) {
        return PostMessageResponse(
          message: null,
          success: false,
        );
      });
    } on SocketException catch (e) {
      return PostMessageResponse(
        message: null,
        success: false,
      );
    } on HttpException {
      return PostMessageResponse(
        message: null,
        success: false,
      );
    } on FormatException {
      return PostMessageResponse(
        message: null,
        success: false,
      );
    }
  }
}
