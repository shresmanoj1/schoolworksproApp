import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/admin/assignticket_request.dart';
import 'package:schoolworkspro_app/response/admin/addrequest_response.dart';
import 'package:schoolworkspro_app/response/admin/assignsupportticket_response.dart';
import 'package:schoolworkspro_app/response/admin/assignticket_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AdminTicketService {
  Future<AddRequestResponse> addticketwithimage(
      String requests,
      String topic,
      String severity,
      String subject,
      PickedFile file,
      dynamic assigned_to,
      dynamic assigned_date) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    var postUri = Uri.parse(api_url2 + '/requests/add');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    if (assigned_to == null) {
      var request = http.MultipartRequest("POST", postUri)
        ..fields['request'] = requests
        ..fields['topic'] = topic
        ..fields['severity'] = severity
        ..fields['subject'] = subject
        ..files.add(http.MultipartFile.fromBytes(
            'files', await File.fromUri(Uri.parse(file.path)).readAsBytes(),
            contentType: MediaType('image', 'jpg'), filename: 'image.jpg'))
        ..headers.addAll(headers);

      return await request.send().then((data) async {
        if (data.statusCode == 200) {
          var responseData = await data.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          final response =
              AddRequestResponse.fromJson(jsonDecode(responseString));

          return response;
        } else {
          return AddRequestResponse(
            request: null,
            message: "some error has occured",
            success: false,
          );
        }
      }).catchError((e) {
        // print(e);
        return AddRequestResponse(
          request: null,
          message: "some error has occured",
          success: false,
        );
      });
    } else {
      var request = http.MultipartRequest("POST", postUri)
        ..fields['request'] = requests
        ..fields['topic'] = topic
        ..fields['severity'] = severity
        ..fields['subject'] = subject
        ..fields['assignedTo'] = assigned_to
        ..fields['assignedDate'] = assigned_date.toString()
        ..files.add(http.MultipartFile.fromBytes(
            'files', await File.fromUri(Uri.parse(file.path)).readAsBytes(),
            contentType: MediaType('image', 'jpg'), filename: 'image.jpg'))
        ..headers.addAll(headers);

      return await request.send().then((data) async {
        if (data.statusCode == 200) {
          var responseData = await data.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          final response =
              AddRequestResponse.fromJson(jsonDecode(responseString));

          return response;
        } else {
          return AddRequestResponse(
            request: null,
            message: "some error has occured",
            success: false,
          );
        }
      }).catchError((e) {
        // print(e);
        return AddRequestResponse(
          request: null,
          message: "some error has occured",
          success: false,
        );
      });
    }
  }

  Future<AddRequestResponse> addticketwithoutimage(
      String requests,
      String topic,
      String severity,
      String subject,
      dynamic assigned_to,
      dynamic assigned_date) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    var postUri = Uri.parse(api_url2 + '/requests/add');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };


    if (assigned_to == null) {
      var request = http.MultipartRequest("POST", postUri)
        ..fields['request'] = requests
        ..fields['topic'] = topic
        ..fields['severity'] = severity
        ..fields['subject'] = subject
        ..headers.addAll(headers);

      return await request.send().then((data) async {
        if (data.statusCode == 200) {
          var responseData = await data.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          final response =
              AddRequestResponse.fromJson(jsonDecode(responseString));

          return response;
        } else {
          return AddRequestResponse(
            request: null,
            message: "some error has occured",
            success: false,
          );
        }
      }).catchError((e) {
        // print(e);
        return AddRequestResponse(
          request: null,
          message: "some error has occured",
          success: false,
        );
      });
    } else {
      var request = http.MultipartRequest("POST", postUri)
        ..fields['request'] = requests
        ..fields['topic'] = topic
        ..fields['severity'] = severity
        ..fields['subject'] = subject
        ..fields['assignedTo'] = assigned_to
        ..fields['assignedDate'] = assigned_date.toString()
        ..headers.addAll(headers);

      return await request.send().then((data) async {
        if (data.statusCode == 200) {
          var responseData = await data.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          final response =
              AddRequestResponse.fromJson(jsonDecode(responseString));

          return response;
        } else {
          return AddRequestResponse(
            request: null,
            message: "some error has occured",
            success: false,
          );
        }
      }).catchError((e) {
        // print(e);
        return AddRequestResponse(
          request: null,
          message: "some error has occured",
          success: false,
        );
      });
    }
  }

  Future<AssignTicketResponse> assignTicket(
      AssignSupportTicketRequest request, String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .put(Uri.parse(api_url2 + '/requests/assign-ticket/$id'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = AssignTicketResponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return AssignTicketResponse(
              request: null,
              success: false,
              assignedTo: null,
              assignedBy: null);
        }
      }).catchError((e) {
        return AssignTicketResponse(
            request: null, success: false, assignedTo: null, assignedBy: null);
      });
    } on SocketException catch (e) {
      return AssignTicketResponse(
          request: null, success: false, assignedTo: null, assignedBy: null);
    } on HttpException {
      return AssignTicketResponse(
          request: null, success: false, assignedTo: null, assignedBy: null);
    } on FormatException {
      return AssignTicketResponse(
          request: null, success: false, assignedTo: null, assignedBy: null);
    }
  }
}
