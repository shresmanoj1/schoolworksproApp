import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/comment_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CommentServiceprovider extends ChangeNotifier {
  Commentresponse? data;

  Future getCommentsprovider(String lessonSlug, context) async {
    var client = http.Client();

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    var response = await client.get(
      Uri.parse('$api_url2/comments/$lessonSlug/comments/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    var mJson = jsonDecode(response.body);
    // print(response.body);
    data = Commentresponse.fromJson(mJson);
    notifyListeners();
  }
}
