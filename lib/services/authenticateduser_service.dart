import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/authenticateduser_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Authenticateduserservice extends ChangeNotifier {
  // Future<Authenticateduserresponse> getAuthentication() async {
  //   var client = http.Client();
  //   var userdetailmodel;
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();

  //   String? token = sharedPreferences.getString('token');

  //   try {
  //     var response = await client.get(
  //       Uri.parse(api_url2 + 'users/uid'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //         'Charset': 'utf-8',
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       var jsonString = response.body;
  //       var jsonMap = jsonDecode(jsonString);

  //       print(response.body);
  //       userdetailmodel = Authenticateduserresponse.fromJson(jsonMap);
  //     }
  //   } catch (exception) {
  //     return userdetailmodel;
  //   }

  //   return userdetailmodel;
  // }

  // Stream<Authenticateduserresponse> getRefereshauthentication(
  //     Duration refreshTime) async* {
  //   while (true) {
  //     await Future.delayed(refreshTime);
  //     yield await getAuthentication();
  //   }
  // }


  Authenticateduserresponse? data;
  Future getAuthentication(context) async {
    var client = http.Client();
    // var resultModel;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    print("GET:::${api_url2 + '/users/uid'}");

    var response = await client.get(
      Uri.parse(api_url2 + '/users/uid'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    var mJson = jsonDecode(response.body);
    print(response.body);

    data = Authenticateduserresponse.fromJson(mJson);
    notifyListeners();
  }

  Future<Authenticateduserresponse> getuser() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse(api_url2 + '/users/uid'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Authenticateduserresponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
  }
}
