import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/displaypictureupdate_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class Imageservice {
  Future<UpdatedpResponse> updateImage(String event, PickedFile file) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    var postUri = Uri.parse(api_url2 + '/users/upload-display-picture');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var request = http.MultipartRequest("POST", postUri)
      ..fields['event'] = event
      ..files.add(http.MultipartFile.fromBytes(
          'picture', await File.fromUri(Uri.parse(file.path)).readAsBytes(),
          contentType: MediaType('image', 'jpg'), filename: 'image.jpg'))
      ..headers.addAll(headers);

    return await request.send().then((data) async {
      if (data.statusCode == 200) {
        var responseData = await data.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        final response = UpdatedpResponse.fromJson(jsonDecode(responseString));

        String userData = jsonEncode(response.authUser);
        sharedPreferences.setString("user", userData);

        return response;
      } else {
        return UpdatedpResponse(
          filename: null,
          success: false,
          message: "Some error has occured",
          authUser: null,
        );
      }
    }).catchError((e) {
      // print(e);
      return UpdatedpResponse(
        filename: null,
        success: false,
        message: "Some error has occured",
        authUser: null,
      );
    });
  }
}
