import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/admin/adminchangestatus_request.dart';
import 'package:schoolworkspro_app/response/admin/adminchangeticketstatus_response.dart';
import 'package:schoolworkspro_app/response/admin/adminrequest_response.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AssignedSupportService extends ChangeNotifier {
  AdminRequestResponse? data;
  Future getAssignedSupport(context, username) async {
    var client = http.Client();
    // var resultModel;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    var response = await client.get(
      Uri.parse(api_url2 + '/support/assigned/$username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    var mJson = jsonDecode(response.body);
    // print(response.body);

    data = AdminRequestResponse.fromJson(mJson);
    notifyListeners();
  }
  // Future<AdminRequestResponse> getAssignedTickets(String username) async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //
  //   String? token = sharedPreferences.getString('token');
  //   final response = await http.get(
  //     Uri.parse(api_url2 + 'requests/assigned/$username'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json; charset=utf-8',
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     // print(response.body);
  //     return AdminRequestResponse.fromJson(jsonDecode(response.body));
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load assigned request');
  //   }
  // }
  //
  // Stream<AdminRequestResponse> getRefreshAssignedTickets(
  //     Duration refreshTime,String username) async* {
  //   while (true) {
  //     await Future.delayed(refreshTime);
  //     yield await getAssignedTickets(username);
  //   }
  // }

  Future<AdminChangeTicketStatusResponse> updateStatus(
      AdminChangeTicketStatusRequest request, String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .put(Uri.parse(api_url2 + '/support/update-status/$id'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response =
              AdminChangeTicketStatusResponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return AdminChangeTicketStatusResponse(
            request: null,
            success: false,
          );
        }
      }).catchError((e) {
        return AdminChangeTicketStatusResponse(
          request: null,
          success: false,
        );
      });
    } on SocketException catch (e) {
      return AdminChangeTicketStatusResponse(
        request: null,
        success: false,
      );
    } on HttpException {
      return AdminChangeTicketStatusResponse(
        request: null,
        success: false,
      );
    } on FormatException {
      return AdminChangeTicketStatusResponse(
        request: null,
        success: false,
      );
    }
  }
  //
  // AdminRequestDetailResponse? data2;
  // Future ticketdetails(context, id) async {
  //   var client = http.Client();
  //   // var resultModel;
  //   final SharedPreferences sharedPreferences =
  //   await SharedPreferences.getInstance();
  //   String? token = sharedPreferences.getString('token');
  //
  //   var response = await client.get(
  //     Uri.parse(api_url2 + 'requests/$id'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json; charset=utf-8',
  //     },
  //   );
  //   var mJson2 = jsonDecode(response.body);
  //   // print(response.body);
  //
  //   data2 = AdminRequestDetailResponse.fromJson(mJson2);
  //   notifyListeners();
  // }

// Future<AdminRequestDetailResponse> ticketdetails(String id) async {
//   final SharedPreferences sharedPreferences =
//       await SharedPreferences.getInstance();
//
//   String? token = sharedPreferences.getString('token');
//   final response = await http.get(
//     Uri.parse(api_url2 + 'requests/$id'),
//     headers: {
//       'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json; charset=utf-8',
//     },
//   );
//
//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     // print(response.body);
//     return AdminRequestDetailResponse.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load request detail');
//   }
// }
}
