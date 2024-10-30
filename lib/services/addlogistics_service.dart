import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/logistics_request.dart';
import 'package:schoolworkspro_app/response/addlogistics_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class AddLogisticService {
  Future<Addlogisticsresponse> addLogistics(LogisticsRequest map) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .post(Uri.parse('$api_url2/logisticsRequests/add'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(map.toJson()))
          .then((data) {
        // print(data.body);
        if (data.statusCode == 200) {
          final response = Addlogisticsresponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return Addlogisticsresponse(
              logistics: null,
              success: false,
              message: "Some Error Has Occured");
        }
      }).catchError((e) {
        // print(e);
        return Addlogisticsresponse(
            logistics: null, success: false, message: "Some Error Has Occured");
      });
    } on SocketException catch (e) {
      // print(e);
      return Addlogisticsresponse(
          logistics: null, success: false, message: "Some Error Has Occured");
    } on HttpException {
      return Addlogisticsresponse(
          logistics: null, success: false, message: "Some Error Has Occured");
    } on FormatException {
      return Addlogisticsresponse(
          logistics: null, success: false, message: "Some Error Has Occured");
    }
  }
}
