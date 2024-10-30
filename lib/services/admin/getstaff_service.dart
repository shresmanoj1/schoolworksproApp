import 'dart:convert';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/admin/getstaff_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StaffService {
  Future<GetStaffResponse> getStaff() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    final response = await http.get(
      Uri.parse(api_url2 + '/users/staff'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(response.body);
      return GetStaffResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load staffs/users ');
    }
  }
}