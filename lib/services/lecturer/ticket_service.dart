import 'dart:convert';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/lecturer/lecturerrequest_response.dart';
import 'package:schoolworkspro_app/response/lecturer/lecturerticketddetail_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LecturerRequestService {
  Future<LecturerRequestResponse> gettickets() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/requests/my-requests'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      return LecturerRequestResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch request');
    }
  }

  Stream<LecturerRequestResponse> getRefreshticket(
      Duration refreshTime) async* {
    while (true) {
      await Future.delayed(refreshTime);
      yield await gettickets();
    }
  }

  Future<LecturerRequestdetailResponse> getticketdetails(String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/requests/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      return LecturerRequestdetailResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch request detail');
    }
  }

  Stream<LecturerRequestdetailResponse> getRefreshticketdetail(
      Duration refreshTime, String id) async* {
    while (true) {
      await Future.delayed(refreshTime);
      yield await getticketdetails(id);
    }
  }
}
