import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/report_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Reportservice {
  Future<Reportreponse> putreport(String commentid) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.put(
      Uri.parse(api_url2 + '/comments/' + commentid + '/report'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      return Reportreponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update report');
    }
  }

  Stream<Reportreponse> getrefreshticket(
      Duration refreshTime, String commentid) async* {
    while (true) {
      await Future.delayed(refreshTime);
      yield await putreport(commentid);
    }
  }
}
