import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/Screens/prinicpal/news%20and%20announcement/markasread_response.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Markreadrepo {
  Future<Commonresponse> deletemynotice(String id) async {
    API api = API();
    dynamic response;
    Commonresponse res;
    try {
      response = await api.deleteWithToken('/notices/$id');

      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<Markasreadresponse> markread(String id) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    final response = await http.post(
      Uri.parse(api_url2 + '/notices/$id/mark-as-read'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      return Markasreadresponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to mark as read ');
    }
  }




}
