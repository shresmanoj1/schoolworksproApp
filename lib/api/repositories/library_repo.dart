import 'dart:convert';

import 'package:schoolworkspro_app/api/endpoints.dart';
import 'package:schoolworkspro_app/response/common_response.dart';

import '../../response/add_bookmark_response.dart';
import '../../response/digital_book_mark_response.dart';
import '../../response/digital_book_response.dart';
import '../../response/physicalbook_response.dart';
import '../api.dart';

class LibraryRepository {
  API api = API();

  Future<Physicalbookresponse> getAllBooks(String num) async {
    dynamic response;
    Physicalbookresponse res;
    try {
      response = await api.getWithToken("/library/physical/all/$num");
      // print("RESPONSE LIBRARY ${response.toString()}");
      res = Physicalbookresponse.fromJson(response);
    } catch (e) {
      print("CATCH :::::${e.toString()}");
      res = Physicalbookresponse.fromJson(response);
    }
    return res;
  }

  Future<Physicalbookresponse> getSearchBook(
      String name, String params, String page) async {
    dynamic response;
    Physicalbookresponse res;
    String data =
        jsonEncode({"category": name, "name": name, "toSearch": "BOTH"});
    // print(data.toString());
    try {
      response = await api.postDataWithToken(data,
          "/library/$params/search/$page"); // print("RESPONSE LIBRARY ${response.toString()}");
      res = Physicalbookresponse.fromJson(response);
    } catch (e) {
      res = Physicalbookresponse.fromJson(response);
    }
    return res;
  }

  Future<Physicalbookresponse> getDigitalBooks(String page) async {
    dynamic response;
    Physicalbookresponse res;
    try {
      response = await api.getWithToken(Endpoints.getDigitalBooks +
          page); // print("RESPONSE LIBRARY ${response.toString()}");
      res = Physicalbookresponse.fromJson(response);
    } catch (e) {
      res = Physicalbookresponse.fromJson(response);
    }
    return res;
  }

  Future<AddBookMarkResponse> addBookMarks(Map<String, dynamic> datas) async {
    dynamic response;
    AddBookMarkResponse res;
    try {
      response = await api.postDataWithToken(
          jsonEncode(datas),
          Endpoints
              .addBookmarks); // print("RESPONSE LIBRARY ${response.toString()}");
      res = AddBookMarkResponse.fromJson(response);
    } catch (e) {
      res = AddBookMarkResponse.fromJson(response);
    }
    return res;
  }

  Future<DigitalBookMarkedResponse> getDigitalBookMarkedBooks() async {
    dynamic response;
    DigitalBookMarkedResponse res;
    try {
      response = await api.getWithToken(Endpoints.getDigitalBookMarkedBooks);
      res = DigitalBookMarkedResponse.fromJson(response);
    } catch (e) {
      res = DigitalBookMarkedResponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> removeDigitalBookMark(String id) async {
    dynamic response;
    Commonresponse res;
    try {
      response = await api.deleteDataWithToken("/bookmarks/$id");
      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<Map<String, dynamic>> generateToken(String id) async {
    dynamic response;
    Map<String, dynamic> res;
    try {
      response = await api.getWithToken(Endpoints.generateToken + id);
      res = response;
    } catch (e) {
      res = response;
    }
    return res;
  }
}
