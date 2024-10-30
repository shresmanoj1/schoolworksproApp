import 'dart:convert';
import 'dart:io';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/lecturer/overtime_request.dart';
import 'package:schoolworkspro_app/response/lecturer/addovertime_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OvertimeService {
  Future<AddOvertimeResponse> postovertime(OvertimeRequest request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse(api_url2 + '/overtime/add'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(request))
          .then((data) {
        print(api_url2 + 'overtime/add');
        if (data.statusCode == 200) {
          final response = AddOvertimeResponse.fromJson(jsonDecode(data.body));

          print("data posted");

          // print(api_url2 + 'attendance/$id');
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return AddOvertimeResponse(
              success: false, message: null, overtime: null);
        } else {
          return AddOvertimeResponse(
              success: false, message: null, overtime: null);
        }
      }).catchError((e) {
        print(e.toString());
        return AddOvertimeResponse(
            success: false, message: null, overtime: null);
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return AddOvertimeResponse(success: false, message: null, overtime: null);
    } on HttpException {
      return AddOvertimeResponse(success: false, message: null, overtime: null);
    } on FormatException {
      return AddOvertimeResponse(success: false, message: null, overtime: null);
    }
  }
}
