import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/parent/progress_request.dart';
import 'package:schoolworkspro_app/response/parents/allprogress_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  Future<AllProgressResponse> getallprogress(Addprogressheader request) async {
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
              body: json.encode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = AllProgressResponse.fromJson(jsonDecode(data.body));
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return AllProgressResponse(success: false, allProgress: null);
        } else {
          return AllProgressResponse(success: false, allProgress: null);
        }
      }).catchError((e) {
        return AllProgressResponse(success: false, allProgress: null);
      });
    } on SocketException catch (e) {
      return AllProgressResponse(success: false, allProgress: null);
    } on HttpException {
      return AllProgressResponse(success: false, allProgress: null);
    } on FormatException {
      return AllProgressResponse(success: false, allProgress: null);
    }
  }
}
