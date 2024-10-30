import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:schoolworkspro_app/response/assignment_details_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/preference_utils.dart';
import '../../response/assignment_play_response.dart';
import '../../response/assignment_response.dart';
import '../../response/assignment_submission_response.dart';
import '../../response/lecturer/assignment_play_report_response.dart';
import '../../response/lecturer/lecturer_assignment_submission_response.dart';
import '../api.dart';
import '../api_exception.dart';
import '../endpoints.dart';
import 'package:http/http.dart' as http;

class AssignmentRepository {
  API api = API();

  Future<AssignmentResponse> getAllAssignment(
      String moduleSlug) async {
    dynamic response;
    AssignmentResponse res;

    String data = jsonEncode({
      "moduleSlug": moduleSlug,
    });

    try {
      response =
      await api.postDataWithToken(data, Endpoints.assignment);

      res = AssignmentResponse.fromJson(response);
    } catch (e) {
      res = AssignmentResponse.fromJson(response);
    }
    return res;
  }

  Future<GetReportPlagResponse> getReportStudentPlag(String id) async {
    final Dio dio = Dio();

    print("[POST] ::  https://plagiarism.schoolworkspro.com/api/get-report-list");
    final SharedPreferences localStorage = PreferenceUtils.instance;

    var token = localStorage.getString('token');

    FormData formData = FormData.fromMap({
      "assignment_id": id,
    });

    try {
      final Response response = await dio.post("https://plagiarism.schoolworkspro.com/api/get-report-list",
        data: formData,
        options: Options(
          contentType: 'application/json',
          headers: <String, String>{
            'Authorization': 'Bearer ${token!}'
          },
        ),
      );
      if (response.statusCode == 200) {
        print(response.data);
        return GetReportPlagResponse.fromJson(response.data);
      } else {
        throw ApiException(response.data);
      }
    } on SocketException {
      throw ApiException("No Internet Connection");
    } catch (e) {
      print("RESPOSE ERR :: " + e.toString());
      return Future.error(e.toString());
    }
  }

  // Future<LecturerAssignmentResponse> getAllLecturerAssignment(
  //     String moduleSlug) async {
  //   dynamic response;
  //   LecturerAssignmentResponse res;
  //
  //   String data = jsonEncode({
  //     "moduleSlug": moduleSlug,
  //   });
  //
  //   try {
  //     response =
  //     await api.postDataWithToken(data, Endpoints.assignment);
  //
  //     res = LecturerAssignmentResponse.fromJson(response);
  //   } catch (e) {
  //     res = LecturerAssignmentResponse.fromJson(response);
  //   }
  //   return res;
  // }
  //

  Future<LecturerAssignmentDetailsResponse> getLecturerAssignmentDetails(String id,String batch) async {
    API api = new API();
    dynamic response;
    LecturerAssignmentDetailsResponse res;
    try {

      final data = jsonEncode({
        "id": id,
        "batch": batch
      });
      response =
      await api.postDataWithToken(data ,"/assignments/batch-submissions");

      res = LecturerAssignmentDetailsResponse.fromJson(response);
    } catch (e) {
      res = LecturerAssignmentDetailsResponse.fromJson(response);
    }
    return res;
  }

  Future<AssignmentSubmissionResponse> assignmentSubmission(
      Map<String, String> data, List<String> files) async {
    dynamic response;
    AssignmentSubmissionResponse res;

    try {
      response = await api.postDataWithTokenAndFiles(
          data, Endpoints.assignmentSubmission, [
        {"files": files}
      ]);
      res = AssignmentSubmissionResponse.fromJson(response);
    } catch (e) {
      print("CATCH:::: ${e.toString()}");
      res = AssignmentSubmissionResponse.fromJson(response);
    }
    return res;
  }
  //
  Future<AssignmentDetailsResponse> getAssignmentDetail(
      String id) async {
    dynamic response;
    AssignmentDetailsResponse res;

    try {
      response =
      await api.getWithToken("${Endpoints.assignmentPlay}/$id");
      res = AssignmentDetailsResponse.fromJson(response);
    } catch (e) {
      res = AssignmentDetailsResponse.fromJson(response);
    }
    return res;
  }
  //
  Future<AssignmentPlagResultResponse> getAssignmentPlagResult(
      String username, String id) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    String data = jsonEncode({
      "username": username,
    });

    print(
        "POSTTTTT::::::::  https://plagiarism.schoolworkspro.com/api/result/by-submission-id/${username + id}");

    final response = await http.post(
      Uri.parse(
          "https://plagiarism.schoolworkspro.com/api/result/by-submission-id/${username + id}"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: data,
    );

    if (response.statusCode == 200) {
      return AssignmentPlagResultResponse.fromJson(
          jsonDecode(response.body));
    } else {
      throw Exception('Failed to load ');
    }
  }
}
