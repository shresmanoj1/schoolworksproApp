import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/detailupdate_request.dart';
import 'package:schoolworkspro_app/response/updatedetail_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Updatedetailservice {
  Future<UpdatedetailResponse> updateAllDetails(
      MyDetailsUpdateRequest myDetailResponse) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    // Map json = jsonDecode(sharedPreferences.getString('_auth_'));
    // String _auth_ = jsonEncode(json);
    try {
      return await http
          .put(Uri.parse(api_url2 + '/users/update-details'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(myDetailResponse.toJson()))
          .then((data) {
        // print(data.body);
        if (data.statusCode == 200) {
          final response = UpdatedetailResponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return UpdatedetailResponse(
            success: false,
            message: "Some error has occured",
          );
        }
      }).catchError((e) {
        // print(e);
        return UpdatedetailResponse(
          success: false,
          message: "Some error has occured",
        );
      });
    } on SocketException catch (e) {
      // print(e);
      return UpdatedetailResponse(
        success: false,
        message: "Some error has occured",
      );
    } on HttpException {
      return UpdatedetailResponse(
        success: false,
        message: "Some error has occured",
      );
    } on FormatException {
      return UpdatedetailResponse(
        success: false,
        message: "Some error has occured",
      );
    }
  }
}
