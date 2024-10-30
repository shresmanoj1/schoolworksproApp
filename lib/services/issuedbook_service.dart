import 'dart:convert';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/response/issuedbook_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Issuedbookservice {
  Future<Issuedbookresponse> getmyissuedbook(String username) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse('${api_url2}/library/physical/history/$username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 201) {
      return Issuedbookresponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load issued book');
    }
  }
}
