import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/request/lecturer/logistics_feedback.dart';
import 'package:schoolworkspro_app/response/lecturer/allinventory_response.dart';
import 'package:schoolworkspro_app/response/lecturer/respondlogistics_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../api/api.dart';

class AllInventoryService extends ChangeNotifier {
  AllInventorysresponse? data;
  Future getinventory(context) async {
    var client = http.Client();
    // var resultModel;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    var response = await client.get(
      Uri.parse(api_url2 + '/inventories/inventory-requests/lecturer/new'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    var mJson = jsonDecode(response.body);
    // print(response.body);

    data = AllInventorysresponse.fromJson(mJson);
    notifyListeners();
  }

  Future<RespondLogisticsResponse> approveRequest(String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.put(
      Uri.parse(api_url2 + '/inventories/status/$id/Approved'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      return RespondLogisticsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to approve');
    }
  }

  Future<RespondLogisticsResponse> declineRequest(String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.put(
      Uri.parse(api_url2 + '/inventories/status/$id/Declined'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      return RespondLogisticsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to declined');
    }
  }

  Future<RespondLogisticsResponse> deleteRequest(String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.delete(
      Uri.parse(api_url2 + '/inventories/inventory-requests/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    print(api_url2 + '/inventories/inventory-requests/$id');

    if (response.statusCode == 200) {
      return RespondLogisticsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to remove');
    }
  }

  Future<RespondLogisticsResponse> postFeedback(
      LogisticFeedbackRequest request, String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse('$api_url2/inventories/requests/feedback/$id'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(request))
          .then((data) {
        if (data.statusCode == 200) {
          final response =
              RespondLogisticsResponse.fromJson(jsonDecode(data.body));

          // print(api_url2 + 'attendance/$id');
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return RespondLogisticsResponse(success: false, message: null);
        } else {
          return RespondLogisticsResponse(success: false, message: null);
        }
      }).catchError((e) {
        return RespondLogisticsResponse(success: false, message: null);
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      print(e);
      return RespondLogisticsResponse(success: false, message: null);
    } on HttpException {
      return RespondLogisticsResponse(success: false, message: null);
    } on FormatException {
      return RespondLogisticsResponse(success: false, message: null);
    }
  }
}
