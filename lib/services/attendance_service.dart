import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/attendance_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Attendanceservice {
  Future<Attendanceresponse> getAttendance() async {
    var client = http.Client();
    var attendance;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString("token");
    try {
      var response = await client.get(
        Uri.parse('$api_url2/attendance/myAttendance'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=utf-8',
        },
      );
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);

        attendance = Attendanceresponse.fromJson(jsonMap);
      }
    } catch (exception) {
      return attendance;
    }

    return attendance;
  }
}
