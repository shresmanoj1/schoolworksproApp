import 'dart:io';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/comment_request.dart';
import 'package:schoolworkspro_app/response/commentreply_response.dart';
import 'package:schoolworkspro_app/response/postcomment_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Replycommentservice {
  Future<Commentreplyresponse> replycomment(
      String commentid, Commentrequest commentRequest) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http
          .post(Uri.parse(api_url2 + '/comments/' + commentid + '/reply'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(commentRequest.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = Commentreplyresponse.fromJson(jsonDecode(data.body));

          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return Commentreplyresponse(success: false, comment: null);
        } else {
          return Commentreplyresponse(success: false, comment: null);
        }
      }).catchError((e) {
        return Commentreplyresponse(success: false, comment: null);
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return Commentreplyresponse(success: false, comment: null);
    } on HttpException {
      return Commentreplyresponse(success: false, comment: null);
    } on FormatException {
      return Commentreplyresponse(success: false, comment: null);
    }
  }
}
