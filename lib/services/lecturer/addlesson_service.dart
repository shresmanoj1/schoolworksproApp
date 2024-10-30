import 'dart:convert';
import 'dart:io';
import 'package:schoolworkspro_app/request/lecturer/addlesson_request.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/lecturer/addlesson_response.dart';
import 'package:schoolworkspro_app/response/lecturer/leave_deleteresponse.dart';
import 'package:schoolworkspro_app/response/lecturer/updatelesson_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../api/api.dart';

class AddLessonService {
  // Future<AddLessonResponse> addlesson(Map<String, dynamic> request) async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //
  //   String? token = sharedPreferences.getString('token');
  //
  //   try {
  //     return await http
  //         .post(Uri.parse('{$api_url2}lessons/add'),
  //             headers: {
  //               'Authorization': 'Bearer $token',
  //               'Content-Type': 'application/json; charset=utf-8',
  //             },
  //             body: request)
  //         .then((data) {
  //       if (data.statusCode == 200) {
  //         final response = AddLessonResponse.fromJson(jsonDecode(data.body));
  //
  //         return response;
  //       } else {
  //         return AddLessonResponse(
  //           module: null,
  //           message: "some error has occured",
  //           lesson: "some error has occured",
  //           success: false,
  //         );
  //       }
  //     }).catchError((e) {
  //       return AddLessonResponse(
  //         module: null,
  //         message: "some error has occured",
  //         lesson: "some error has occured",
  //         success: false,
  //       );
  //     });
  //   } on SocketException catch (e) {
  //     return AddLessonResponse(
  //       module: null,
  //       message: "some error has occured",
  //       lesson: "some error has occured",
  //       success: false,
  //     );
  //   } on HttpException {
  //     return AddLessonResponse(
  //       module: null,
  //       message: "some error has occured",
  //       lesson: "some error has occured",
  //       success: false,
  //     );
  //   } on FormatException {
  //     return AddLessonResponse(
  //       module: null,
  //       message: "some error has occured",
  //       lesson: "some error has occured",
  //       success: false,
  //     );
  //   }
  // }

  Future<AddLessonResponse> postlesson(AddLessonRequest loginRequest) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse('$api_url2/lessons/add'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(loginRequest.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = AddLessonResponse.fromJson(jsonDecode(data.body));

          // sharedPreferences.setString('userImage', response.user.userImage);

          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return AddLessonResponse(
              success: false,
              module: null,
              message: "some error has occured",
              lesson: "some error has occured");
        } else {
          return AddLessonResponse(
              success: false,
              module: null,
              message: "some error has occured",
              lesson: "some error has occured");
        }
      }).catchError((e) {
        return AddLessonResponse(
            success: false,
            module: null,
            message: "some error has occured",
            lesson: "some error has occured");
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return AddLessonResponse(
          success: false,
          module: null,
          message: "some error has occured",
          lesson: "some error has occured");
    } on HttpException {
      return AddLessonResponse(
          success: false,
          module: null,
          message: "some error has occured",
          lesson: "some error has occured");
    } on FormatException {
      return AddLessonResponse(
          success: false,
          module: null,
          message: "some error has occured",
          lesson: "some error has occured");
    }
  }

  Future<UpdateLessonResponse> updateLesson(
      AddLessonRequest loginRequest, String slug) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .put(Uri.parse('$api_url2/lessons/$slug'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(loginRequest.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = UpdateLessonResponse.fromJson(jsonDecode(data.body));

          // sharedPreferences.setString('userImage', response.user.userImage);

          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return UpdateLessonResponse(
            success: false,
            lessonUpdate: null,
          );
        } else {
          return UpdateLessonResponse(
            success: false,
            lessonUpdate: null,
          );
        }
      }).catchError((e) {
        return UpdateLessonResponse(
          success: false,
          lessonUpdate: null,
        );
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return UpdateLessonResponse(
        success: false,
        lessonUpdate: null,
      );
    } on HttpException {
      return UpdateLessonResponse(
        success: false,
        lessonUpdate: null,
      );
    } on FormatException {
      return UpdateLessonResponse(
        success: false,
        lessonUpdate: null,
      );
    }
  }

  Future<LeaveDeleteResponse> deleteLesson(String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.delete(
      Uri.parse('${api_url2}/lessons/$id'),
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
      throw Exception('Failed to delete lessons');
    }
  }
}
