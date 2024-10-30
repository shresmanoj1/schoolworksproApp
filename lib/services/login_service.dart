import 'dart:io';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/fcm_request.dart';
import 'package:schoolworkspro_app/request/login_request.dart';
import 'package:schoolworkspro_app/response/fcmtoken_response.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:schoolworkspro_app/response/logout_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginService {
  Future<LogoutResponse> logout() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      return await http.get(
        Uri.parse(api_url2 + '/verification/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=utf-8',
        },
      ).then((data) {
        if (data.statusCode == 200) {
          final response = LogoutResponse.fromJson(jsonDecode(data.body));
          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return LogoutResponse(success: false);
        } else {
          return LogoutResponse(success: false);
        }
      }).catchError((e) {
        print(e);
        return LogoutResponse(success: false);
      });
    } on SocketException catch (e) {
      print(e);
      return LogoutResponse(success: false);
    } on HttpException {
      return LogoutResponse(success: false);
    } on FormatException {
      return LogoutResponse(success: false);
    }
  }

  Future<FcmTokenResponse> postFCM(FcmTokenRequest request) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      return await http
          .post(Uri.parse(api_url2 + '/tokens/registerToken'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json; charset=utf-8',
              },
              body: jsonEncode(request.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = FcmTokenResponse.fromJson(jsonDecode(data.body));

          return response;
        } else {
          return FcmTokenResponse(success: false, message: null);
        }
      }).catchError((e) {
        print(e);
        return FcmTokenResponse(success: false, message: null);
      });
    } on SocketException catch (e) {
      print(e);
      return FcmTokenResponse(success: false, message: null);
    } on HttpException {
      return FcmTokenResponse(success: false, message: null);
    } on FormatException {
      return FcmTokenResponse(success: false, message: null);
    }
  }

  Future<LoginResponse> login(
      LoginRequest loginRequest, String username, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      return await http
          .post(Uri.parse(api_url2 + '/verification/login'),
              headers: {
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(loginRequest.toJson()))
          .then((data) {
        if (data.statusCode == 200) {
          final response = LoginResponse.fromJson(jsonDecode(data.body));

          String user = jsonEncode(response.user);

          sharedPreferences.setString('_auth_', user);

          sharedPreferences.setString('type', response.user!.type!);
          sharedPreferences.setString('token', response.token!);

          sharedPreferences.setString('username', username.toString());
          sharedPreferences.setString('password', password.toString());
          sharedPreferences.setString("domains", response.user!.domains.toString());
          sharedPreferences.setString("drole", response.user!.drole.toString());
          sharedPreferences.setString("droleName", response.user!.droleName.toString());
          // sharedPreferences.setString('userImage', response.user.userImage);

          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return LoginResponse(success: false, user: null);
        } else {
          return LoginResponse(success: false, user: null);
        }
      }).catchError((e) {
        return LoginResponse(success: false, user: null);
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return LoginResponse(success: false, user: null);
    } on HttpException {
      return LoginResponse(success: false, user: null);
    } on FormatException {
      return LoginResponse(success: false, user: null);
    }
  }

  Future<LoginResponse> loginfast(Map<String, dynamic> loginRequest) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      return await http
          .post(Uri.parse(api_url2 + '/verification/login'),
              headers: {
                'Content-Type': 'application/json',
                'accept': 'application/json',
              },
              body: json.encode(loginRequest))
          .then((data) {
        if (data.statusCode == 200) {
          final response = LoginResponse.fromJson(jsonDecode(data.body));

          String user = jsonEncode(response.user);

          sharedPreferences.setString('_auth_', user);

          sharedPreferences.setString('type', response.user!.type!);
          sharedPreferences.setString('token', response.token!);

          // sharedPreferences.setString('userImage', response.user.userImage);

          return response;
        } else if (data.statusCode == 404 || data.statusCode == 401) {
          return LoginResponse(success: false, user: null);
        } else {
          return LoginResponse(success: false, user: null);
        }
      }).catchError((e) {
        return LoginResponse(success: false, user: null);
      });
    } on SocketException catch (e) {
      // ignore: avoid_print
      // print(e);
      return LoginResponse(success: false, user: null);
    } on HttpException {
      return LoginResponse(success: false, user: null);
    } on FormatException {
      return LoginResponse(success: false, user: null);
    }
  }
}
