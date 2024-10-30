import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/activity_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getbatch_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BatchService {
  Future<GetBatchResponse> getallbatch(String moduleSlug) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/modules/$moduleSlug/batches'),
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
      return GetBatchResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load batches');
    }
  }


  Future<GetBatchResponse> getAttendanceBatches(String moduleSlug) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/modules/$moduleSlug/attendance-batches'),
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
      return GetBatchResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load batches');
    }
  }

  Stream<GetBatchResponse> getrefreshbatch(
      Duration refreshTime, String moduleSlug) async* {
    while (true) {
      await Future.delayed(refreshTime);
      yield await getallbatch(moduleSlug);
    }
  }
}
