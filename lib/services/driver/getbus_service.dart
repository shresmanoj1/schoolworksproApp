import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/driver/busdetail_response.dart';
import 'package:schoolworkspro_app/response/driver/busstatus_changeresponse.dart';
import 'package:schoolworkspro_app/response/driver/changestatus_studentresponse.dart';
import 'package:schoolworkspro_app/response/driver/getbus_response.dart';
import 'package:schoolworkspro_app/response/driver/getlstudentist_bus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusService {

  API api = API();

  Future<GetBusResponse> getBusList() async {
    dynamic response;
    GetBusResponse res;
    try {
      response = await api.getWithToken('/drivers/my-buses');
      print(response);
      res = GetBusResponse.fromJson(response);
    } catch (e) {
      res = GetBusResponse.fromJson(response);
    }
    return res;
  }

  Future<StudentBusListResponse> getBusStudentList(String id) async {
    dynamic response;
    StudentBusListResponse res;
    try {
      response = await api.getWithToken('/drivers/student-list/$id');
      print(response);
      res = StudentBusListResponse.fromJson(response);
    } catch (e) {
      res = StudentBusListResponse.fromJson(response);
    }
    return res;
  }

  Future<ChangeStudentStatusResponse> changeStatusStudent(
      Map<String, dynamic> request, String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse(api_url2 + '/bus-attendance/$id'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(request))
          .then((data) {

            print("DATA::${data.body}::::${api_url2 + '/bus-attendance/$id'}");

        if (data.statusCode == 200) {
          final response =
              ChangeStudentStatusResponse.fromJson(jsonDecode(data.body));

          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return ChangeStudentStatusResponse(
              success: false, message: null, updated: null);
        } else {
          return ChangeStudentStatusResponse(
              success: false, message: null, updated: null);
        }
      }).catchError((e) {
        return ChangeStudentStatusResponse(
            success: false, message: null, updated: null);
      });
    } on SocketException catch (e) {
      return ChangeStudentStatusResponse(
          success: false, message: null, updated: null);
    } on HttpException {
      return ChangeStudentStatusResponse(
          success: false, message: null, updated: null);
    } on FormatException {
      return ChangeStudentStatusResponse(
          success: false, message: null, updated: null);
    }
  }

  Future<BusStatusChangeResponse> changeBusStatus(
      Map<String, dynamic> request, String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      print("BUTTON CLICKED::${api_url2 + '/bus/update/$id'}");
      return await http
          .put(Uri.parse(api_url2 + '/bus/update/$id'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(request))
          .then((data) {
            print("BUS STATUS::${data.body}");
        if (data.statusCode == 200) {
          final response =
              BusStatusChangeResponse.fromJson(jsonDecode(data.body));

          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return BusStatusChangeResponse(
              success: false, message: null, bus: null);
        } else {
          return BusStatusChangeResponse(
              success: false, message: null, bus: null);
        }
      }).catchError((e) {
        print("error::${e}");
        return BusStatusChangeResponse(
            success: false, message: null, bus: null);
      });
    } on SocketException catch (e) {
      return BusStatusChangeResponse(success: false, message: null, bus: null);
    } on HttpException {
      return BusStatusChangeResponse(success: false, message: null, bus: null);
    } on FormatException {
      return BusStatusChangeResponse(success: false, message: null, bus: null);
    }
  }

  Future<GetBusDetailResponse> getBusDetailByID(String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/bus/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return GetBusDetailResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load bus detail, try again later ');
    }
  }

  Stream<GetBusDetailResponse> getRefreshBusDetailByID(
      Duration refreshTime, String id) async* {
;    while (true) {
      await Future.delayed(refreshTime);
      yield await getBusDetailByID(id);
    }
  }
}
