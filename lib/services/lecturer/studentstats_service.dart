import 'dart:convert';
import 'dart:io';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/lecturer/penalize_request.dart';
import 'package:schoolworkspro_app/request/lecturer/progressstats_request.dart';
import 'package:schoolworkspro_app/response/addproject_response.dart';
import 'package:schoolworkspro_app/response/lecturer/get_all_student_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getalluser_studentstats_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getdisciplinaryforstats_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getdocument_stats_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getperformance_stats_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getprogressstats_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getsubmissionforstats_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getsubmissionquizforstats_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../request/lecturer/stats_request.dart';
import '../../response/admin/allUserAssignemntResponse.dart';
import '../../response/admin/get_all_active_students_response.dart';
import '../../response/principal/sisciplinary_level_details.dart';
import '../../response/principal/student_disciplinary_action_response.dart';

class StudentStatsLecturerService {
  Future<GetAllUserStudentStatsResponse> getAllStudentforStats() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    print("STUDENT::${response.statusCode}");
    print("STUDENT::${response.body}");

    if (response.statusCode == 200) {
      return GetAllUserStudentStatsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch user');
    }
  }

  Future<GetAllUserStudentStatsResponse> activeStudentList() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/users/active-students'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    print("STUDENT::${api_url2 + '/users/active-students'}");
    print("STUDENT::${token}");

    if (response.statusCode == 200) {
      var students = jsonDecode(response.body);
      students["users"] = students["active_students"];
      return GetAllUserStudentStatsResponse.fromJson(students);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch user');
    }
  }


  Future<GetAllStudentStatsResponse> getAllStudentForLecturerStats(String batch) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();

    print(api_url2 + '/batch/$batch/student');
    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/batch/$batch/student'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );


    if (response.statusCode == 200) {


      return GetAllStudentStatsResponse.fromJson(jsonDecode(response.body));

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch user');
    }
  }

  Future<GetAllActiveStudentResponse> getAllActiveStudentStats(String batch) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();

    print("URLLLL::::::{$api_url2/exams/bulk-print}");

    String? token = sharedPreferences.getString('token');
    final response = await http
        .post(Uri.parse(api_url2 + '/exams/bulk-print'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({'batch': batch}));

    // http.get(
    //   Uri.parse(api_url2 + '/exams/bulk-print'),
    //   headers: {
    //     'Authorization': 'Bearer $token',
    //     'Content-Type': 'application/json; charset=utf-8',
    //     'batch': batch
    //   },
    // );

    if (response.statusCode == 200) {

      return GetAllActiveStudentResponse.fromJson(jsonDecode(response.body));

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch user');
    }
  }

  Future<GetAllUserStudentStatsResponse> getStudentsAspercourse(
      String course_slug) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/courses/getStudents/$course_slug'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      return GetAllUserStudentStatsResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch user');
    }
  }

  Future<GetDocumentForStatsResponse> getUserDocuments(
      StudentStatsRequest request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse(api_url2 + '/users/get-user-documents'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(request))
          .then((data) {
        if (data.statusCode == 200) {
          final response =
              GetDocumentForStatsResponse.fromJson(jsonDecode(data.body));

          // print(api_url2 + 'attendance/$id');
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return GetDocumentForStatsResponse(success: false, documents: null);
        } else {
          return GetDocumentForStatsResponse(success: false, documents: null);
        }
      }).catchError((e) {
        return GetDocumentForStatsResponse(success: false, documents: null);
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return GetDocumentForStatsResponse(success: false, documents: null);
    } on HttpException {
      return GetDocumentForStatsResponse(success: false, documents: null);
    } on FormatException {
      return GetDocumentForStatsResponse(success: false, documents: null);
    }
  }

  Future<GetProgressForStatsResponse> getUserProgress(
      ProgressStatsRequest request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse(api_url2 + '/tracking/all-progress'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(request))
          .then((data) {
        if (data.statusCode == 200) {
          final response =
              GetProgressForStatsResponse.fromJson(jsonDecode(data.body));

          // print(api_url2 + 'attendance/$id');
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return GetProgressForStatsResponse(success: false, allProgress: null);
        } else {
          return GetProgressForStatsResponse(success: false, allProgress: null);
        }
      }).catchError((e) {
        return GetProgressForStatsResponse(success: false, allProgress: null);
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return GetProgressForStatsResponse(success: false, allProgress: null);
    } on HttpException {
      return GetProgressForStatsResponse(success: false, allProgress: null);
    } on FormatException {
      return GetProgressForStatsResponse(success: false, allProgress: null);
    }
  }

  Future<GetPerformanceForStatsResponse> getUserPerformance(
      StudentStatsRequest request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse(api_url2 + '/users/activity'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(request))
          .then((data) {
        if (data.statusCode == 200) {
          final response =
              GetPerformanceForStatsResponse.fromJson(jsonDecode(data.body));

          // print(api_url2 + 'attendance/$id');
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return GetPerformanceForStatsResponse(
              success: false,
              commentCount: null,
              yearOne: null,
              yearThree: null,
              yearTwo: null,
              attendance: null);
        } else {
          return GetPerformanceForStatsResponse(
              success: false,
              commentCount: null,
              yearOne: null,
              yearThree: null,
              yearTwo: null,
              attendance: null);
        }
      }).catchError((e) {
        print('error ayo' + e.toString());
        return GetPerformanceForStatsResponse(
            success: false,
            commentCount: null,
            yearOne: null,
            yearThree: null,
            yearTwo: null,
            attendance: null);
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      print("socket error ayo" + e.toString());
      return GetPerformanceForStatsResponse(
          success: false,
          commentCount: null,
          yearOne: null,
          yearThree: null,
          yearTwo: null,
          attendance: null);
    } on HttpException {
      return GetPerformanceForStatsResponse(
          success: false,
          commentCount: null,
          yearOne: null,
          yearThree: null,
          yearTwo: null,
          attendance: null);
    } on FormatException {
      return GetPerformanceForStatsResponse(
          success: false,
          commentCount: null,
          yearOne: null,
          yearThree: null,
          yearTwo: null,
          attendance: null);
    }
  }

  Future<GetSubmissionsForStatsResponse> getUsersSubmission(
      String username) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse('$api_url2/assessments/all-assessments/$username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      return GetSubmissionsForStatsResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch submissions');
    }
  }

  Future<AllUserAssignment> getAllStudentsAssignments(
      String username) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse('$api_url2/assignments/get-all-assignments/$username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      return AllUserAssignment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch submissions');
    }
  }

  Future<GetSubmissionsQuizForStatsResponse> getUsersSubmissionQuiz(
      String username) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse('$api_url2/quiz/all/quiz-stats/$username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      return GetSubmissionsQuizForStatsResponse.fromJson(
          jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch submissions for quiz');
    }
  }

  Future<GetDisciplinaryForStatsResponse> getUsersDisciplinary(
      String username) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/disciplinary-history/$username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      return GetDisciplinaryForStatsResponse.fromJson(
          jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch submissions for disciplinary');
    }
  }

  Future<Addprojectresponse> postOffence(PenalizeRequest request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .post(Uri.parse(api_url2 + '/offense-reports/add-new'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = Addprojectresponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return Addprojectresponse(
            message: 'Error',
            success: false,
          );
        }
      }).catchError((e) {
        return Addprojectresponse(
          message: 'Error',
          success: false,
        );
      });
    } on SocketException catch (e) {
      return Addprojectresponse(
        message: 'Error',
        success: false,
      );
    } on HttpException {
      return Addprojectresponse(
        message: 'Error',
        success: false,
      );
    } on FormatException {
      return Addprojectresponse(
        message: 'Error',
        success: false,
      );
    }
  }

  Future<StudentDisciplinaryActionResponse> getUserDisciplinaryActions() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    print("GET::::: $api_url2/disciplinary-actions/");
    final response = await http.get(
      Uri.parse('$api_url2/disciplinary-actions/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      return StudentDisciplinaryActionResponse.fromJson(
          jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch submissions for disciplinary');
    }
  }

  Future<DisciplinaryLevelDetailsResponse> getDisciplinaryLevelDetails(String id) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    print("GET::::: $api_url2/disciplinary-history/get-level-details/$id");
    print(token);
    final response = await http.get(
      Uri.parse('$api_url2/disciplinary-history/get-level-details/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
      print(response.body);
    if (response.statusCode == 200) {

      return DisciplinaryLevelDetailsResponse.fromJson(
          jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch submissions for disciplinary');
    }
  }

}
