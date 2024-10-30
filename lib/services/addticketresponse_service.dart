import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/ticketresponse_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class Addticketservice {
  Future<Addticketresponse> addmyticketresponsewithimage(
      String id, String response, PickedFile? file) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    var putUri = Uri.parse('$api_url2/tickets/$id');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var request = http.MultipartRequest("PUT", putUri)
      ..fields['response'] = response
      ..files.add(http.MultipartFile.fromBytes(
          'file', await File.fromUri(Uri.parse(file!.path)).readAsBytes(),
          contentType: MediaType('image', 'jpg'), filename: 'image.jpg'))
      ..headers.addAll(headers);

    return await request.send().then((data) async {
      if (data.statusCode == 200) {
        var responseData = await data.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        final response = Addticketresponse.fromJson(jsonDecode(responseString));

        return response;
      } else {
        return Addticketresponse(
          ticket: null,
          success: false,
        );
      }
    }).catchError((e) {
      return Addticketresponse(
        ticket: null,
        success: false,
      );
    });
  }

  Future<Addticketresponse> addmyticketresponsewithoutimage(
      String id, String response) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    var postUri = Uri.parse('$api_url2/tickets/$id');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var request = http.MultipartRequest("PUT", postUri)
      ..fields['response'] = response
      ..headers.addAll(headers);

    return await request.send().then((data) async {
      if (data.statusCode == 200) {
        var responseData = await data.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        final response = Addticketresponse.fromJson(jsonDecode(responseString));

        return response;
      } else {
        return Addticketresponse(
          ticket: null,
          success: false,
        );
      }
    }).catchError((e) {
      return Addticketresponse(
        ticket: null,
        success: false,
      );
    });
  }
}
