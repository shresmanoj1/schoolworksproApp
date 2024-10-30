import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/lecturer/leave_request.dart';
import 'package:schoolworkspro_app/response/lecturer/leave_deleteresponse.dart';
import 'package:schoolworkspro_app/response/lecturer/leave_response.dart';
import 'package:schoolworkspro_app/response/lecturer/postleave_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveService {
  Future<LeaveResponse> getleave(String username) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    // print(object)
    final response = await http.get(
      Uri.parse(api_url2 + '/leaves/$username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // print("DATA OF LEAVE:::${jsonDecode(response.body)}");
      return LeaveResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch leaves');
    }
  }

  // Future<LeaveResponse> getRefreshLeave(
  //     Duration refreshTime, String username) async* {
  //   while (true) {
  //     await Future.delayed(refreshTime);
  //     yield await getleave(username);
  //   }
  // }

  Future<PostLeaveResponse> postLeave(LeaveRequest request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      print(json.encode(request));
      return await http
          .post(Uri.parse(api_url2 + '/leaves/add'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },


              body: json.encode(request))
          .then((data) {
        if (data.statusCode == 200) {
          final response = PostLeaveResponse.fromJson(jsonDecode(data.body));

          // print(api_url2 + 'attendance/$id');
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return PostLeaveResponse(success: false, message: null, leave: null);
        } else {
          return PostLeaveResponse(success: false, message: null, leave: null);
        }
      }).catchError((e) {
        return PostLeaveResponse(success: false, message: null, leave: null);
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return PostLeaveResponse(success: false, message: null, leave: null);
    } on HttpException {
      return PostLeaveResponse(success: false, message: null, leave: null);
    } on FormatException {
      return PostLeaveResponse(success: false, message: null, leave: null);
    }
  }

  Future<LeaveDeleteResponse> deleteleave(String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.delete(
      Uri.parse(api_url2 + '/leaves/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(response.body);
      // print(response.body);
      return LeaveDeleteResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to delete leaves');
    }
  }

  Future<PostLeaveResponse> editleave(LeaveRequest request, String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .put(Uri.parse(api_url2 + '/leaves/$id'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(request))
          .then((data) {
        print(api_url2 + '/leaves/$id');
        print(data.statusCode);
        print(data.body);
        if (data.statusCode == 200) {
          final response = PostLeaveResponse.fromJson(jsonDecode(data.body));

          // print(api_url2 + 'attendance/$id');
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return PostLeaveResponse(success: false, message: null, leave: null);
        } else {
          return PostLeaveResponse(success: false, message: null, leave: null);
        }
      }).catchError((e) {
        return PostLeaveResponse(success: false, message: null, leave: null);
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return PostLeaveResponse(success: false, message: null, leave: null);
    } on HttpException {
      return PostLeaveResponse(success: false, message: null, leave: null);
    } on FormatException {
      return PostLeaveResponse(success: false, message: null, leave: null);
    }
  }
}
