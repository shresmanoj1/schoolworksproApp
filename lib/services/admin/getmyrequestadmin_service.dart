import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/admin/adminchangestatus_request.dart';
import 'package:schoolworkspro_app/response/admin/admin_requestdetailsresponse.dart';
import 'package:schoolworkspro_app/response/admin/adminchangeticketstatus_response.dart';
import 'package:schoolworkspro_app/response/admin/adminmyrequest_response.dart';
import 'package:schoolworkspro_app/response/admin/adminrequest_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyRequestAdminService extends ChangeNotifier {
  AdminMyRequestResponse? data;
  Future myticketsAdmin(context) async {
    var client = http.Client();
    // var resultModel;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    var response = await client.get(
      Uri.parse(api_url2 + '/requests/my-requests'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    var mJson2 = jsonDecode(response.body);
    // print(response.body);

    data = AdminMyRequestResponse.fromJson(mJson2);
    notifyListeners();
  }

  Future<AdminMyRequestResponse> myticketAdmin() async {
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
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(response.body);
      return AdminMyRequestResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load tickets ');
    }
  }
}
