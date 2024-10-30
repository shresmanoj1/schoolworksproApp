import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/offensehistory_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OffenseService {
  Future<dynamic> getOffenseHistory() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    print("[POST]:::::::::${api_url2 + '/disciplinary-history/currentLevel'}");

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/disciplinary-history/currentLevel'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsonMap = jsonDecode(response.body);
      return jsonMap;
        // OffenceHistoryResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load offense history');
    }
  }

  Future<dynamic> getCheckOneTimeAttendance() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();

    print("[POST]:::::::::${api_url2 + '/student-attendance/status'}");

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/student-attendance/status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsonMap = jsonDecode(response.body);
      return jsonMap;
      // OffenceHistoryResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load offense history');
    }
  }
}
