import 'dart:convert';
import 'dart:io';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/parent/getfeesparent_request.dart';
import 'package:schoolworkspro_app/response/addproject_response.dart';
import 'package:schoolworkspro_app/response/parents/getfessparent_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ParentFeeService {
  Future<Addprojectresponse> transactiondatastart(
      GetFeesForParentsRequest request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .post(Uri.parse(api_url2 + '/fees/get-my-financial-data-start'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = Addprojectresponse.fromJson(jsonDecode(data.body));
          print(data.body);
          print(jsonEncode(request));
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

  Future<GetFeesResponse> transactiondatafinish(
      GetFeesForParentsRequest request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .post(Uri.parse(api_url2 + '/fees/get-my-financial-data-finish'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = GetFeesResponse.fromJson(jsonDecode(data.body));
          print(jsonEncode(request));
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

  Future<Addprojectresponse> duedatastart(
      GetFeesForParentsRequest request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .post(Uri.parse(api_url2 + '/fees/get-my-financial-due-data-start'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(request.toJson()))
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

  Future<GetFeesResponse> duedatafinish(
      GetFeesForParentsRequest request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .post(Uri.parse(api_url2 + '/fees/get-my-financial-due-data-finish'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          print(data.body);
          print(jsonEncode(request));
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
