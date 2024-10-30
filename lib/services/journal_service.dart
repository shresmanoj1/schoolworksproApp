import 'dart:io';

import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/journal_request.dart';
import 'package:schoolworkspro_app/response/addjournal_response.dart';
import 'package:schoolworkspro_app/response/addproject_response.dart';
import 'package:schoolworkspro_app/response/fetchjournal_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JournalService extends ChangeNotifier {
  Future<AddJournalresponse> postJournal(Journalrequest request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .post(Uri.parse('${api_url2}/journals/add'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(request.toJson()))
          .then((data) {
        if (data.statusCode == 201) {
          final response = AddJournalresponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return AddJournalresponse(
              journal: null,
              file: null,
              success: false,
              message: "Some Error Has Occured");
        }
      }).catchError((e) {
        return AddJournalresponse(
            journal: null,
            file: null,
            success: false,
            message: "Some Error Has Occured");
      });
    } on SocketException catch (e) {
      return AddJournalresponse(
          journal: null,
          file: null,
          success: false,
          message: "Some Error Has Occured");
    } on HttpException {
      return AddJournalresponse(
          journal: null,
          file: null,
          success: false,
          message: "Some Error Has Occured");
    } on FormatException {
      return AddJournalresponse(
          journal: null,
          file: null,
          success: false,
          message: "Some Error Has Occured");
    }
  }

  Future<Addprojectresponse> updateJournal(
      Journalrequest request, String slug) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .put(Uri.parse('${api_url2}/journals/update/$slug'),
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
              success: false, message: "Some Error Has Occured");
        }
      }).catchError((e) {
        return Addprojectresponse(
            success: false, message: "Some Error Has Occured");
      });
    } on SocketException catch (e) {
      return Addprojectresponse(
          success: false, message: "Some Error Has Occured");
    } on HttpException {
      return Addprojectresponse(
          success: false, message: "Some Error Has Occured");
    } on FormatException {
      return Addprojectresponse(
          success: false, message: "Some Error Has Occured");
    }
  }

  // Future<Fetchjournalresponse> getmyjournal() async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //
  //   String? token = sharedPreferences.getString('token');
  //   final response = await http.get(
  //     Uri.parse('${api_url2}journals/mine/'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json; charset=utf-8',
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     return Fetchjournalresponse.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load journals');
  //   }
  // }
  Fetchjournalresponse? data;
  Future getmyjournal(context) async {
    var client = http.Client();
    // var resultModel;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    var response = await client.get(
      Uri.parse('${api_url2}/journals/mine/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    var mJson = jsonDecode(response.body);
    // print(response.body);

    data = Fetchjournalresponse.fromJson(mJson);
    notifyListeners();
  }

  Future<Addprojectresponse> deletejournal(String slug) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.delete(
      Uri.parse('${api_url2}/journals/delete/$slug'),
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
      return Addprojectresponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to delete journal');
    }
  }
}
