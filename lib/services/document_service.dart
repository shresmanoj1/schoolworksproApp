import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/document_response.dart';
import 'package:schoolworkspro_app/response/postdocument_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class DocumentService extends ChangeNotifier {
  Documentresponse? data;

  Future getDocuments(context) async {
    var client = http.Client();
    // var resultModel;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    var response = await client.get(
      Uri.parse(api_url2 + '/users/get-documents'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Charset': 'charset=utf-8',
      },
    );
    var mJson = jsonDecode(response.body);
    // print(response.body);
    data = Documentresponse.fromJson(mJson);
    notifyListeners();
  }

  Future<Documentresponse> getMyDocuments() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http.get(
        Uri.parse(api_url2 + '/users/get-documents'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=utf-8',
        },
      ).then((data) {
        if (data.statusCode == 200) {
          final response = Documentresponse.fromJson(jsonDecode(data.body));
          // print(data.body);
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return Documentresponse(success: false, documents: null);
        } else {
          return Documentresponse(success: false, documents: null);
        }
      }).catchError((e) {
        // print(e);
        return Documentresponse(success: false, documents: null);
      });
    } on SocketException catch (e) {
      // print(e);
      return Documentresponse(success: false, documents: null);
    } on HttpException {
      return Documentresponse(success: false, documents: null);
    } on FormatException {
      return Documentresponse(success: false, documents: null);
    }
  }

  Future<PostdocumentResponse> addDocuments(
      String events, String type, PickedFile file) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    var postUri = Uri.parse('$api_url2/users/upload-my-personal-doc');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var request = http.MultipartRequest("POST", postUri)
      ..fields['event'] = events
      ..fields['type'] = type
      ..files.add(http.MultipartFile.fromBytes(
          'file', await File.fromUri(Uri.parse(file.path)).readAsBytes(),
          contentType: MediaType('image', 'jpg'), filename: 'image.jpg'))
      ..headers.addAll(headers);

    return await request.send().then((data) async {
      if (data.statusCode == 200) {
        var responseData = await data.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        final response =
            PostdocumentResponse.fromJson(jsonDecode(responseString));

        return response;
      } else {
        return PostdocumentResponse(
          success: false,
          message: "Some error has occured",
        );
      }
    }).catchError((e) {
      // print(e);
      return PostdocumentResponse(
        success: false,
        message: "Some error has occured",
      );
    });
  }
}
