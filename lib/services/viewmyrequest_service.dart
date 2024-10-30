import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/request_letter_response.dart';
import 'package:schoolworkspro_app/response/viewmyrequest_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../response/AssignedToUserResponse.dart';

class Viewmyrequestservice {
  Future<Viewmyrequestresponse> getmyrequest() async {
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
      return Viewmyrequestresponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load request');
    }
  }

  Future<RequestLetterResponse> getRequestLetter() async {
    API api = API();
    dynamic response;
    RequestLetterResponse res;
    try {
      response = await api.getWithToken("/letter/my-letters");

      res = RequestLetterResponse.fromJson(response);
    } catch (e) {
      res = RequestLetterResponse.fromJson(response);
    }
    return res;
  }

  Future<AssignedToUserResponse> getAssignedToUser() async {
    API api = API();
    dynamic response;
    AssignedToUserResponse res;
    try {
      response = await api.getWithToken("/requests/assigned-to-user");

      res = AssignedToUserResponse.fromJson(response);
    } catch (e) {
      res = AssignedToUserResponse.fromJson(response);
    }
    return res;
  }

  Stream<Viewmyrequestresponse> getrefreshrequest(Duration refreshTime) async* {
    while (true) {
      await Future.delayed(refreshTime);
      yield await getmyrequest();
    }
  }
}
