// import 'dart:convert';
// import 'dart:io';
// import 'package:schoolworkspro_app/api/api.dart';
// import 'package:schoolworkspro_app/request/lecturer/get_studentrequest.dart';
// import 'package:schoolworkspro_app/response/lecturer/progress_student_response.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// class ViewStudentService {
//   Future<ProgressStudentResponse> getstudentsformodule(
//       Getstudentrequest request) async {
//     final SharedPreferences sharedPreferences =
//         await SharedPreferences.getInstance();
//
//     String? token = sharedPreferences.getString('token');
//
//     try {
//       return await http
//           .post(Uri.parse(api_url2 + '/tracking/module-progress'),
//               headers: {
//                 'Authorization': 'Bearer $token',
//                 'Content-Type': 'application/json; charset=utf-8',
//               },
//               body: jsonEncode(request.toJson()))
//           .then((data) {
//         if (data.statusCode == 200) {
//           final response =
//               ProgressStudentResponse.fromJson(jsonDecode(data.body));
//
//           return response;
//         } else {
//           return ProgressStudentResponse(
//             allProgress: null,
//             success: false,
//           );
//         }
//       }).catchError((e) {
//         return ProgressStudentResponse(
//           allProgress: null,
//           success: false,
//         );
//       });
//     } on SocketException catch (e) {
//       return ProgressStudentResponse(
//         allProgress: null,
//         success: false,
//       );
//     } on HttpException {
//       return ProgressStudentResponse(
//         allProgress: null,
//         success: false,
//       );
//     } on FormatException {
//       return ProgressStudentResponse(
//         allProgress: null,
//         success: false,
//       );
//     }
//   }
// }
