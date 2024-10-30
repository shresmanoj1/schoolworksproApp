import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/admin/assignticket_request.dart';
import 'package:schoolworkspro_app/response/admin/addsupportrequest_response.dart';
import 'package:schoolworkspro_app/response/admin/admin_requestdetailsresponse.dart';
import 'package:schoolworkspro_app/response/admin/assignsupportticket_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Supportservice extends ChangeNotifier {
  Future<AddSupportRequestResponse> addsupportwithimage(
      String requests, String topic, PickedFile file) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    var postUri = Uri.parse(api_url2 + '/support/add');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var request = http.MultipartRequest("POST", postUri)
      ..fields['request'] = requests
      ..fields['topic'] = topic
      ..files.add(http.MultipartFile.fromBytes(
          'file', await File.fromUri(Uri.parse(file.path)).readAsBytes(),
          contentType: MediaType('image', 'jpg'), filename: 'image.jpg'))
      ..headers.addAll(headers);

    return await request.send().then((data) async {
      if (data.statusCode == 200) {
        var responseData = await data.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        final response =
            AddSupportRequestResponse.fromJson(jsonDecode(responseString));

        return response;
      } else {
        return AddSupportRequestResponse(
          request: null,
          message: "some error has occured",
          success: false,
        );
      }
    }).catchError((e) {
      // print(e);
      return AddSupportRequestResponse(
        request: null,
        message: "some error has occured",
        success: false,
      );
    });
  }

  Future<AddSupportRequestResponse> addsupportwithoutimage(
      String requests, String topic) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    var postUri = Uri.parse(api_url2 + '/support/add');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var request = http.MultipartRequest("POST", postUri)
      ..fields['request'] = requests
      ..fields['topic'] = topic
      ..headers.addAll(headers);

    return await request.send().then((data) async {
      if (data.statusCode == 200) {
        var responseData = await data.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        final response =
            AddSupportRequestResponse.fromJson(jsonDecode(responseString));

        return response;
      } else {
        return AddSupportRequestResponse(
          request: null,
          message: "some error has occured",
          success: false,
        );
      }
    }).catchError((e) {
      // print(e);
      return AddSupportRequestResponse(
        request: null,
        message: "some error has occured",
        success: false,
      );
    });
  }

  Future<AssignSupportTicketResponse> assignTicket(
      AssignSupportTicketRequest request, String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .put(Uri.parse(api_url2 + '/support/assign-ticket/$id'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response =
              AssignSupportTicketResponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return AssignSupportTicketResponse(
              request: null, success: false, message: "some error has occured");
        }
      }).catchError((e) {
        return AssignSupportTicketResponse(
            request: null, success: false, message: "some error has occured");
      });
    } on SocketException catch (e) {
      return AssignSupportTicketResponse(
          request: null, success: false, message: "some error has occured");
    } on HttpException {
      return AssignSupportTicketResponse(
          request: null, success: false, message: "some error has occured");
    } on FormatException {
      return AssignSupportTicketResponse(
          request: null, success: false, message: "some error has occured");
    }
  }

  AdminRequestDetailResponse? data2;
  Future supportticketdetails(context, id) async {
    var client = http.Client();
    // var resultModel;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    var response = await client.get(
      Uri.parse(api_url2 + '/support/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    var mJson2 = jsonDecode(response.body);
    // print(response.body);

    data2 = AdminRequestDetailResponse.fromJson(mJson2);
    notifyListeners();
  }
}
