import 'dart:convert';
import 'dart:io';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/institution_request.dart';
import 'package:schoolworkspro_app/request/parent/getfeesparent_request.dart';
import 'package:schoolworkspro_app/response/addproject_response.dart';
import 'package:schoolworkspro_app/response/parents/getfessparent_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FeeService {
  Future<Addprojectresponse> transactionDateStart(
      String request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    print("GET::::::${api_url2 + '/fees/get-my-financial-data-start'}");

    try {
      return await http
          .post(Uri.parse(api_url2 + '/fees/get-my-financial-data-start'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode({"institution":request}))
          .then((data) {
        if (data.statusCode == 200) {
          final response = Addprojectresponse.fromJson(jsonDecode(data.body));
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return Addprojectresponse(success: false, message: null);
        } else {
          return Addprojectresponse(success: false, message: null);
        }
      }).catchError((e) {
        return Addprojectresponse(success: false, message: null);
      });
    } on SocketException catch (e) {
      return Addprojectresponse(success: false, message: null);
    } on HttpException {
      return Addprojectresponse(success: false, message: null);
    } on FormatException {
      return Addprojectresponse(success: false, message: null);
    }
  }

  Future<GetFeesResponse> transactionDaeFinish(
      String request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    print("GET::::::${api_url2 + '/fees/get-my-financial-data-finish'}");

    try {
      return await http
          .post(Uri.parse(api_url2 + '/fees/get-my-financial-data-finish'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode({"institution":request}))
          .then((data) {
        if (data.statusCode == 200) {
          final response = GetFeesResponse.fromJson(jsonDecode(data.body));

          print(data.body);
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return GetFeesResponse(success: false, message: null, data: null);
        } else {
          return GetFeesResponse(success: false, message: null, data: null);
        }
      }).catchError((e) {
        return GetFeesResponse(success: false, message: null, data: null);
      });
    } on SocketException catch (e) {
      return GetFeesResponse(success: false, message: null, data: null);
    } on HttpException {
      return GetFeesResponse(success: false, message: null, data: null);
    } on FormatException {
      return GetFeesResponse(success: false, message: null, data: null);
    }
  }

  Future<Addprojectresponse> dueDataStart(String request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    print("checkkkkk" + jsonEncode(request));

    print("GET::::::${api_url2 + '/fees/get-my-financial-due-data-start'}");

    try {
      return await http
          .post(Uri.parse(api_url2 + '/fees/get-my-financial-due-data-start'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode({"institution":request}))
          .then((data) {
        if (data.statusCode == 200) {
          final response = Addprojectresponse.fromJson(jsonDecode(data.body));
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return Addprojectresponse(success: false, message: null);
        } else {
          return Addprojectresponse(success: false, message: null);
        }
      }).catchError((e) {
        return Addprojectresponse(success: false, message: null);
      });
    } on SocketException catch (e) {
      return Addprojectresponse(success: false, message: null);
    } on HttpException {
      return Addprojectresponse(success: false, message: null);
    } on FormatException {
      return Addprojectresponse(success: false, message: null);
    }
  }

  Future<GetFeesResponse> dueDataFinish(String request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    print("GET::::::${api_url2 + '/fees/get-my-financial-due-data-finish'}");

    try {
      return await http
          .post(Uri.parse(api_url2 + '/fees/get-my-financial-due-data-finish'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode({"institution":request}))
          .then((data) {
        if (data.statusCode == 200) {
          final response = GetFeesResponse.fromJson(jsonDecode(data.body));

          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return GetFeesResponse(success: false, message: null, data: null);
        } else {
          return GetFeesResponse(success: false, message: null, data: null);
        }
      }).catchError((e) {
        return GetFeesResponse(success: false, message: null, data: null);
      });
    } on SocketException catch (e) {
      return GetFeesResponse(success: false, message: null, data: null);
    } on HttpException {
      return GetFeesResponse(success: false, message: null, data: null);
    } on FormatException {
      return GetFeesResponse(success: false, message: null, data: null);
    }
  }
}
