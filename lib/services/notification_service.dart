import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/notification_response.dart' as abc;
import 'package:shared_preferences/shared_preferences.dart';

class Notificationservice extends ChangeNotifier {
  // Future<Notificationresponse> getnotification() async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //
  //   String? token = sharedPreferences.getString('token');
  //   final response = await http.get(
  //     Uri.parse(api_url2 + 'notifications/all'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json; charset=utf-8',
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     // print(response.body);
  //     return Notificationresponse.fromJson(jsonDecode(response.body));
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load notification');
  //   }
  // }

  abc.Notificationresponse? data;
  List<abc.Notificationss> _notifications = [];
  List<abc.Notificationss> get notifications => _notifications;

  Future getnotification(context) async {
    var client = http.Client();
    // var resultModel;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    var response = await client.get(
      Uri.parse('${api_url2}/notifications/all'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    var mJson = jsonDecode(response.body);
    // print(response.body);

    data = abc.Notificationresponse.fromJson(mJson);
    _notifications = data!.notifications!;
    notifyListeners();
  }

  // Stream<Notificationresponse> getrefereshnotification(
  //     Duration refreshTime) async* {
  //   while (true) {
  //     await Future.delayed(refreshTime);
  //     yield await getnotification();
  //   }
  // }
}
