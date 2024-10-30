import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/lecturer/checkpunchstatus_response.dart';
import 'package:schoolworkspro_app/response/lecturer/punch_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PunchService extends ChangeNotifier {
  Future<PunchResponse> punchInOut() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.post(
      Uri.parse(api_url2 + '/staffAttendance/add'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      return PunchResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to punch');
    }
  }

  CheckPunchStatus? data2;
  Future checkPunchStatus(context) async {
    var client = http.Client();
    // var resultModel;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    print("GETTT::::${api_url2 + '/staffAttendance/getStatus'}");

    var response = await client.get(
      Uri.parse(api_url2 + '/staffAttendance/getStatus'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    var mJson = jsonDecode(response.body);
    // print(response.body);

    data2 = CheckPunchStatus.fromJson(mJson);
    notifyListeners();
  }

  // Future<CheckPunchStatus> checkPunchStatus() async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //
  //   String? token = sharedPreferences.getString('token');
  //   final response = await http.get(
  //     Uri.parse(api_url2 + 'staffAttendance/getStatus'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json; charset=utf-8',
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     return CheckPunchStatus.fromJson(jsonDecode(response.body));
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to fetch punch');
  //   }
  // }

  // Stream<CheckPunchStatus> getRefreshPunchstatus(Duration refreshTime) async* {
  //   while (true) {
  //     await Future.delayed(refreshTime);
  //     yield await checkPunchStatus();
  //   }
  // }
}
