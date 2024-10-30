import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/postmessage_request.dart';
import 'package:schoolworkspro_app/response/getmessage_response.dart';
import 'package:schoolworkspro_app/response/post_messageresponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnreadMessageService extends ChangeNotifier {
  GetMessageResponse? data;
  Future getUnreadMessage(context) async {
    var client = http.Client();
    // var resultModel;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    var response = await client.get(
      Uri.parse(api_url2 + '/quick-message/unseen'),
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

  Future<PostMessageResponse> markasread(String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.put(
      Uri.parse(api_url2 + '/quick-message/mark-as-read/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(response.body);
      return PostMessageResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to mark as read');
    }
  }

  Future<GetMessageResponse> getunreadforcount() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/quick-message/unseen'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(response.body);
      return GetMessageResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load unread message');
    }
  }
}
