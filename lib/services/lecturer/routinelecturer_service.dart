import 'dart:convert';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/lecturer/routinelecturer_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../api/endpoints.dart';
import '../../response/lecturer/routine_reminder_response.dart';

class RoutineLecturerService {
  Future<RoutineLecturerResponse> getroutineforlecturer(String email) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    print("GETTT::::: ${api_url2 + '/routines/lecturers/$email'}");
    final response = await http.get(
      Uri.parse(api_url2 + '/routines/lecturers/$email'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      return RoutineLecturerResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch routines');
    }
  }

  Future<RoutineReminderResponse> routineReminder(data, String id) async {
    API api = new API();

    dynamic response;
    RoutineReminderResponse res;
    try {
      print("DATAAAA::::: ${data}");
      response = await api.putDataWithToken(data, Endpoints.routineReminder+id);
      res = RoutineReminderResponse.fromJson(response);
      print("RESPONSEEE:::${res.toJson()}");
    } catch (e) {
      res = RoutineReminderResponse.fromJson(response);
    }
    return res;
  }
}
