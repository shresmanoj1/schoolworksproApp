import 'dart:convert';
import 'dart:io';
import 'package:fluttericon/elusive_icons.dart';
import 'package:http_parser/http_parser.dart';
import "package:http/http.dart" as http;
import 'package:image_picker/image_picker.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/addrequest_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddRequestPrincipalService {
  Future<Addrequestresponse> addticketprincipalwithimage(
      String requestss,
      String severity,
      String topic,
      String subject,
      PickedFile? file,
      String username,
      bool assigned_to) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    var postUri = Uri.parse(api_url2 + '/requests/add');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    if (assigned_to == true) {
      var request = http.MultipartRequest("POST", postUri)
        ..fields['request'] = requestss
        ..fields['severity'] = severity
        ..fields['topic'] = topic
        ..fields['subject'] = subject
        ..fields['assignedTo'] = username
        ..files.add(http.MultipartFile.fromBytes(
            'files', await File.fromUri(Uri.parse(file!.path)).readAsBytes(),
            contentType: MediaType('image', 'jpg'), filename: 'image.jpg'))
        ..headers.addAll(headers);

      return await request.send().then((data) async {
        if (data.statusCode == 200) {
          var responseData = await data.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          final response =
              Addrequestresponse.fromJson(jsonDecode(responseString));

          // String userData = jsonEncode(response.authUser);
          // sharedPreferences.setString("user", userData);

          return response;
        } else {
          return Addrequestresponse(
            success: false,
            message: "Some error has occured",
          );
        }
      }).catchError((e) {
        return Addrequestresponse(
          success: false,
          message: "Some error has occured",
        );
      });
    }
    var request = http.MultipartRequest("POST", postUri)
      ..fields['request'] = requestss
      ..fields['severity'] = severity
      ..fields['topic'] = topic
      ..fields['subject'] = subject
      ..files.add(http.MultipartFile.fromBytes(
          'files', await File.fromUri(Uri.parse(file!.path)).readAsBytes(),
          contentType: MediaType('image', 'jpg'), filename: 'image.jpg'))
      ..headers.addAll(headers);

    return await request.send().then((data) async {
      if (data.statusCode == 200) {
        var responseData = await data.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        final response =
            Addrequestresponse.fromJson(jsonDecode(responseString));

        // String userData = jsonEncode(response.authUser);
        // sharedPreferences.setString("user", userData);

        return response;
      } else {
        return Addrequestresponse(
          success: false,
          message: "Some error has occured",
        );
      }
    }).catchError((e) {
      return Addrequestresponse(
        success: false,
        message: "Some error has occured",
      );
    });
  }

  Future<Addrequestresponse> addticketprincipalwithoutimage(
      String requestss,
      String severity,
      String topic,
      String subject,
      String username,
      bool assigned_to) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    var postUri = Uri.parse(api_url2 + '/requests/add');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    if (assigned_to == true) {
      var request = http.MultipartRequest("POST", postUri)
        ..fields['request'] = requestss
        ..fields['severity'] = severity
        ..fields['topic'] = topic
        ..fields['subject'] = subject
        ..fields['assignedTo'] = username
        ..headers.addAll(headers);

      return await request.send().then((data) async {
        if (data.statusCode == 200) {
          var responseData = await data.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          final response =
              Addrequestresponse.fromJson(jsonDecode(responseString));

          // String userData = jsonEncode(response.authUser);
          // sharedPreferences.setString("user", userData);

          return response;
        } else {
          return Addrequestresponse(
            success: false,
            message: "Some error has occured",
          );
        }
      }).catchError((e) {
        return Addrequestresponse(
          success: false,
          message: "Some error has occured",
        );
      });
    }

    var request = http.MultipartRequest("POST", postUri)
      ..fields['request'] = requestss
      ..fields['severity'] = severity
      ..fields['topic'] = topic
      ..fields['subject'] = subject
      ..headers.addAll(headers);

    return await request.send().then((data) async {
      if (data.statusCode == 200) {
        var responseData = await data.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        final response =
            Addrequestresponse.fromJson(jsonDecode(responseString));

        // String userData = jsonEncode(response.authUser);
        // sharedPreferences.setString("user", userData);

        return response;
      } else {
        return Addrequestresponse(
          success: false,
          message: "Some error has occured",
        );
      }
    }).catchError((e) {
      return Addrequestresponse(
        success: false,
        message: "Some error has occured",
      );
    });
  }
}
