import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/lecturer/onetimeettendance_request.dart';
import 'package:schoolworkspro_app/request/lecturer/studentattendance_request.dart';
import 'package:schoolworkspro_app/response/lecturer/createnew_attendanceresponse.dart';
import 'package:schoolworkspro_app/response/lecturer/studentattendance_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PostAttendanceService {
  Future<CreateNewAttendanceResponse> addnewAttendance(
      StudentAttendanceRequest request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    print("REQUEST::::${request.toJson()}");
    try {
      print("$api_url2/attendance/add");
      inspect(request);
      return await http
          .post(Uri.parse('$api_url2/attendance/add'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(request))
          .then((data) {
        if (data.statusCode == 200) {

          print(data.statusCode);
          final response =
              CreateNewAttendanceResponse.fromJson(jsonDecode(data.body));

          inspect(jsonDecode(data.body));

          // print(api_url2 + 'attendance/$id');
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return CreateNewAttendanceResponse(success: false, message: null);
        } else {
          return CreateNewAttendanceResponse(success: false, message: null);
        }
      }).catchError((e) {
        return CreateNewAttendanceResponse(success: false, message: null);
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return CreateNewAttendanceResponse(success: false, message: null);
    } on HttpException {
      return CreateNewAttendanceResponse(success: false, message: null);
    } on FormatException {
      return CreateNewAttendanceResponse(success: false, message: null);
    }
  }

  Future<CreateNewAttendanceResponse> OneTimeAddenceservice(
      OneTimeAttendanceRequest request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse(api_url2 + '/attendance/add'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(request))
          .then((data) {
        if (data.statusCode == 200) {
          final response =
              CreateNewAttendanceResponse.fromJson(jsonDecode(data.body));

          // print(api_url2 + 'attendance/$id');
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return CreateNewAttendanceResponse(success: false, message: null);
        } else {
          return CreateNewAttendanceResponse(success: false, message: null);
        }
      }).catchError((e) {
        return CreateNewAttendanceResponse(success: false, message: null);
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return CreateNewAttendanceResponse(success: false, message: null);
    } on HttpException {
      return CreateNewAttendanceResponse(success: false, message: null);
    } on FormatException {
      return CreateNewAttendanceResponse(success: false, message: null);
    }
  }

  Future<StudentAttendanceResponse> changeAttendance(
      StudentAttendanceRequest request, String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    print(api_url2 + '/attendance/$id');

    print(jsonEncode(request));
    try {
      return await http
          .put(Uri.parse(api_url2 + '/attendance/$id'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: jsonEncode(request))
          .then((data) {
        if (data.statusCode == 200) {
          final response =
              StudentAttendanceResponse.fromJson(jsonDecode(data.body));
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return StudentAttendanceResponse(success: false, message: null);
        } else {
          return StudentAttendanceResponse(success: false, message: null);
        }
      }).catchError((e) {
        return StudentAttendanceResponse(success: false, message: null);
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return StudentAttendanceResponse(success: false, message: null);
    } on HttpException {
      return StudentAttendanceResponse(success: false, message: null);
    } on FormatException {
      return StudentAttendanceResponse(success: false, message: null);
    }
  }
}
