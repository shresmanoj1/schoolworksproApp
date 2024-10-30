import 'package:image_picker/image_picker.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/myrequest_request.dart';
import 'package:schoolworkspro_app/response/myrequest_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:io';

class Addresponseservice {
  Future<MyrequestResponse> addresponse(
      Addresponserequest request, String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .put(Uri.parse('$api_url2/requests/$id'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = MyrequestResponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return MyrequestResponse(
            response: null,
            success: false,
          );
        }
      }).catchError((e) {
        return MyrequestResponse(
          response: null,
          success: false,
        );
      });
    } on SocketException catch (e) {
      return MyrequestResponse(
        response: null,
        success: false,
      );
    } on HttpException {
      return MyrequestResponse(
        response: null,
        success: false,
      );
    } on FormatException {
      return MyrequestResponse(
        response: null,
        success: false,
      );
    }
  }

  Future<MyrequestResponse> addresponsewithimage(
      String id, String response, PickedFile? file) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    var putUri = Uri.parse('$api_url2/requests/$id');
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
        final response = MyrequestResponse.fromJson(jsonDecode(responseString));

        return response;
      } else {
        return MyrequestResponse(
          response: null,
          success: false,
        );
      }
    }).catchError((e) {
      return MyrequestResponse(
        response: null,
        success: false,
      );
    });
  }
}
