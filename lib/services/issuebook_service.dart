import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/issuebook_request.dart';
import 'package:schoolworkspro_app/response/addproject_response.dart';
import 'package:schoolworkspro_app/response/addrequest_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IssueBookService {
  // Future<Addrequestresponse> issuebook(
  //     String book_slug, String username) async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //
  //   String? token = sharedPreferences.getString('token');
  //   var postUri = Uri.parse(api_url2 + 'library/physical/issue/book');
  //   Map<String, String> headers = {
  //     'Authorization': 'Bearer $token',
  //     'Content-Type': 'application/json',
  //   };
  //
  //   var request = http.MultipartRequest("POST", postUri)
  //     ..fields['book_slug'] = book_slug
  //     ..fields['username'] = username
  //     ..headers.addAll(headers);
  //
  //   return await request.send().then((data) async {
  //     if (data.statusCode == 201) {
  //       var responseData = await data.stream.toBytes();
  //       var responseString = String.fromCharCodes(responseData);
  //       final response =
  //           Addrequestresponse.fromJson(jsonDecode(responseString));
  //
  //       // String userData = jsonEncode(response.authUser);
  //       // sharedPreferences.setString("user", userData);
  //
  //       return response;
  //     } else {
  //
  //       return Addrequestresponse(
  //         success: false,
  //         message: "Some error has occured",
  //       );
  //     }
  //   }).catchError((e) {
  //     return Addrequestresponse(
  //       success: false,
  //       message: "Some error has occured",
  //     );
  //   });
  // }
  Future<Addprojectresponse> issuebook(Issuebookrequest lessonrequest) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse('${api_url2}/library/physical/issue/book'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(lessonrequest))
          .then((data) {
        // print(data.body);
        if (data.statusCode == 201) {
          final response = Addprojectresponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return Addprojectresponse(success: false, message: null);
        }
      }).catchError((e) {
        return Addprojectresponse(success: false, message: null);
      });
    } on SocketException catch (e) {
      print(e.toString());
      return Addprojectresponse(success: false, message: null);
    } on HttpException {
      return Addprojectresponse(success: false, message: null);
    } on FormatException {
      return Addprojectresponse(success: false, message: null);
    }
  }

  Future<Addprojectresponse> createAlbum(
      String bookslug, String username) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    final response = await http.post(
      Uri.parse('$api_url2/library/physical/issue/book'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: jsonEncode(<String, String>{
        'book_slug': bookslug,
        'username': username,
      }),
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Addprojectresponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return Addprojectresponse(
          success: false,
          message:
              "You have already borrowed this book. Please visit library to renew it.");
    } else if (response.statusCode == 404) {
      return Addprojectresponse(
          success: false, message: "Out of stock or currently unavailable");
    } else {
      throw Exception('Failed to issue book.');
    }
  }
}
