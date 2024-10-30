import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/lessonratingrequest.dart';
import 'package:schoolworkspro_app/response/lessonrating_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Lessonratingservice {
  Future<LessonratingResponse> getratings(String lessonSlug) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    print("POSTTT:::::${api_url2 + '/lessonRating/my-rating/' + lessonSlug}");

    String? token = sharedPreferences.getString('token');
    print(token);
    final response = await http.get(
      Uri.parse(api_url2 + '/lessonRating/my-rating/' + lessonSlug),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(response.body);
      return LessonratingResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load ratings');
    }
  }

  Stream<LessonratingResponse> getrefreshratings(
      Duration refreshTime, String? lessonslug) async* {
    while (true) {
      await Future.delayed(refreshTime);
      yield await getratings(lessonslug!);
    }
  }

  Future<LessonratingResponse> postratings(
      Lessonraterequest raterequest) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      print("POSTTT:::::${api_url2 + '/lessonRating/rate'}");
      return await http
          .post(Uri.parse(api_url2 + '/lessonRating/rate'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(raterequest.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = LessonratingResponse.fromJson(jsonDecode(data.body));
          // print(data.body);
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return LessonratingResponse(success: false, rating: null);
        } else {
          return LessonratingResponse(success: false, rating: null);
        }
      }).catchError((e) {
        return LessonratingResponse(success: false, rating: null);
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return LessonratingResponse(success: false, rating: null);
    } on HttpException {
      return LessonratingResponse(success: false, rating: null);
    } on FormatException {
      return LessonratingResponse(success: false, rating: null);
    }
  }
}
