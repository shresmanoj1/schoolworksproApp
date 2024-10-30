import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/like_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Likeservice {
  Future<Likereponse> putlikes(String commentid) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.put(
      Uri.parse(api_url2 + '/comments/' + commentid + '/like'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      return Likereponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update likes');
    }
  }

  Stream<Likereponse> getrefreshticket(
      Duration refreshTime, String commentid) async* {
    while (true) {
      await Future.delayed(refreshTime);
      yield await putlikes(commentid);
    }
  }
}
