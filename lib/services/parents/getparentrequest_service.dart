import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/parents/getchildren_response.dart';
import 'package:schoolworkspro_app/response/parents/getparentticketdetail_response.dart';
import 'package:schoolworkspro_app/response/parents/getrequestparent_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Getparentrequestservice {
  Future<Getparentequestresponse> getrequest() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse('${api_url2}/requests/created'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    if (response.statusCode == 200) {
      return Getparentequestresponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<Getparentticketdetailresponse> getrequestdetail(String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    print('https://api.schoolworkspro.com/requests/$id');

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse('https://api.schoolworkspro.com/requests/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return Getparentticketdetailresponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<Getparentequestresponse> getAssignedToRequest() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.get(
      Uri.parse('${api_url2}/requests/parent-requests'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    if (response.statusCode == 200) {
      return Getparentequestresponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<Getparentticketdetailresponse> getrefreshticketdetail(
      String id, Duration refreshTime) async {
    while (true) {
      await Future.delayed(refreshTime);
       await getrequestdetail(id);
    }
  }
}
