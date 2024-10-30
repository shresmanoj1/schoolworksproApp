import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/addrequest_response.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../response/student_leave_response.dart';

class Addrequestservice {
  Future<Addrequestresponse> addmyrequestwithimage(
      String requestss,
      String severity,
      String topic,
      String subject,
      String institution,
      PickedFile? file) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    var postUri = Uri.parse('$api_url2/requests/add');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var request = http.MultipartRequest("POST", postUri)
      ..fields['request'] = requestss
      ..fields['severity'] = severity
      ..fields['topic'] = topic
      ..fields['subject'] = subject
      ..fields['institution'] = institution
      ..files.add(http.MultipartFile.fromBytes('files',
          await File.fromUri(Uri.parse(file!.path)).readAsBytes(),
          contentType: MediaType('image', 'jpg'),
          filename: 'image.jpg'))
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

  Future<Addrequestresponse> addmyrequestwithoutimage(
      String requestss,
      String severity,
      String topic,
      String subject,
      String institution) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    var postUri = Uri.parse('$api_url2/requests/add');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    print(institution);
    print(requestss);
    print(severity);
    print(topic);
    print(subject);

    var request = http.MultipartRequest("POST", postUri)
      ..fields['request'] = requestss
      ..fields['severity'] = severity
      ..fields['topic'] = topic
      ..fields['subject'] = subject
      ..fields['institution'] = institution
      ..headers.addAll(headers);

    return await request.send().then((data) async {
      if (data.statusCode == 200) {
        var responseData = await data.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        final response =
            Addrequestresponse.fromJson(jsonDecode(responseString));

        return response;
      } else {
        return Addrequestresponse(
          success: false,
          message: "Some error has occured",
        );
      }
    }).catchError((e) {
      print(e.toString());
      return Addrequestresponse(
        success: false,
        message: "Some error has occured",
      );
    });
  }

  Future<StudentLeaveResponse> addLeaveWithImage(
      data, PickedFile? file) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    var postUri = Uri.parse('$api_url2/leaves/student/add');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var request = http.MultipartRequest("POST", postUri);
    if (file != null) {
      request.files.add(http.MultipartFile.fromBytes('files',
          await File.fromUri(Uri.parse(file.path)).readAsBytes(),
          contentType: MediaType('image', 'jpg'),
          filename: 'image.jpg'));
    }
    request.fields['request'] = data["request"];
    request.fields['severity'] = data["severity"];
    request.fields['topic'] = data["topic"];
    request.fields['subject'] = data["subject"];
    request.fields['startDate'] = data["startDate"];
    request.fields['endDate'] = data["endDate"];
    request.fields['allDay'] = data["allDay"];
    request.fields['routines'] = data["routines"];

    print("REQUEST::::$request");
    request.headers.addAll(headers);

    print("DATA:::$data");

    return await request.send().then((data) async {
      if (data.statusCode == 200) {
        var responseData = await data.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        final response =
            StudentLeaveResponse.fromJson(jsonDecode(responseString));

        return response;
      } else {
        print(data);
        return StudentLeaveResponse(
          success: false,
          message: "Some error has occured",
        );
      }
    }).catchError((e) {
      print(e.toString());
      return StudentLeaveResponse(
        success: false,
        message: "Some error has occured",
      );
    });
  }

  Future<Commonresponse> updateLeaveRequest(
      data, PickedFile? file, String id) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    var postUri = Uri.parse('$api_url2/leaves/student/update/$id');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var request = http.MultipartRequest("PUT", postUri);
    if (file != null) {
      request.files.add(http.MultipartFile.fromBytes('files',
          await File.fromUri(Uri.parse(file.path)).readAsBytes(),
          contentType: MediaType('image', 'jpg'),
          filename: 'image.jpg'));
    }
    request.fields['request'] = data["request"];
    request.fields['severity'] = data["severity"];
    request.fields['topic'] = data["topic"];
    request.fields['subject'] = data["subject"];
    request.fields['startDate'] = data["startDate"];
    request.fields['endDate'] = data["endDate"];
    request.fields['allDay'] = data["allDay"];
    request.fields['routines'] = data["routines"];

    print("REQUEST::::$request");
    request.headers.addAll(headers);

    print("DATA:::$data");

    return await request.send().then((data) async {
      if (data.statusCode == 200) {
        var responseData = await data.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        final response =
        Commonresponse.fromJson(jsonDecode(responseString));

        return response;
      } else {
        print(data);
        return Commonresponse(
          success: false,
          message: "Some error has occured",
        );
      }
    }).catchError((e) {
      print(e.toString());
      return Commonresponse(
        success: false,
        message: "Some error has occured",
      );
    });
  }


  Future<Commonresponse> updateMyRequestWithImage(
      String requestss,
      String severity,
      String topic,
      String subject,
      String institution,
      PickedFile? file, String id) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    var postUri = Uri.parse('$api_url2/requests/update/$id');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var request = http.MultipartRequest("PUT", postUri);
      request.fields['request'] = requestss;
      request.fields['severity'] = severity;
      request.fields['topic'] = topic;
      request.fields['subject'] = subject;
      request.fields['institution'] = institution;
    if (file != null) {
      request.files.add(http.MultipartFile.fromBytes('files',
          await File.fromUri(Uri.parse(file.path)).readAsBytes(),
          contentType: MediaType('image', 'jpg'),
          filename: 'image.jpg'));
    }
      request.headers.addAll(headers);

    return await request.send().then((data) async {
      if (data.statusCode == 200) {
        var responseData = await data.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        final response =
        Commonresponse.fromJson(jsonDecode(responseString));

        return response;
      } else {
        return Commonresponse(
          success: false,
          message: "Some error has occured",
        );
      }
    }).catchError((e) {
      return Commonresponse(
        success: false,
        message: "Some error has occured",
      );
    });
  }
}
