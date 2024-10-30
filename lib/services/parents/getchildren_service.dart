import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/book_response.dart';
import 'package:schoolworkspro_app/response/parents/getchildren_response.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Getchildrenservice {
  Future<Getchildrenresponse> getchildren() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse('${api_url2}/parents/children/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    if (response.statusCode == 200) {
      return Getchildrenresponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load book');
    }
  }
}
