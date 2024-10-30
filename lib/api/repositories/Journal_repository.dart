import 'dart:convert';

import 'package:schoolworkspro_app/api/api.dart';

import '../../request/comment_request.dart';
import '../../response/addjournal_response.dart';
import '../../response/addproject_response.dart';
import '../../response/common_response.dart';
import '../../response/fetchjournal_response.dart';
import '../../response/verifiedJournal_response.dart';
import '../../response/weeklydetails_response.dart';
import '../endpoints.dart';

class JournalRepository {
  API api = API();
  Future<AddJournalresponse> postJournal(data) async {
    dynamic response;
    AddJournalresponse res;

    try {
      response =
          await api.postDataWithToken(jsonEncode(data), Endpoints.addJournal);
      res = AddJournalresponse.fromJson(response);
    } catch (e) {
      res = AddJournalresponse.fromJson(response);
    }
    return res;
  }

  Future<Addprojectresponse> updateJournal(data, String slug) async {
    dynamic response;
    Addprojectresponse res;

    try {
      response = await api.putDataWithToken(
          jsonEncode(data), Endpoints.updateJournal + slug);
      print("${response}hekc");
      res = Addprojectresponse.fromJson(response);
    } catch (e) {
      res = Addprojectresponse.fromJson(response);
    }

    return res;
  }

  Future<Fetchjournalresponse> fetchmyJournal() async {
    dynamic response;
    Fetchjournalresponse res;

    try {
      response = await api.getWithToken(Endpoints.getJournal);
      res = Fetchjournalresponse.fromJson(response);
    } catch (e) {
      res = Fetchjournalresponse.fromJson(response);
    }
    return res;
  }

  Future<Addprojectresponse> deleteJournal(String slug) async {
    dynamic response;
    Addprojectresponse res;
    try {
      response = await api.deleteDataWithToken(Endpoints.deleteJournal + slug);
      res = Addprojectresponse.fromJson(response);
    } catch (e) {
      res = Addprojectresponse.fromJson(response);
    }
    return res;
  }

  Future<VerifiedJournalresponse> journalVerify() async {
    dynamic response;
    VerifiedJournalresponse res;
    try {
      response = await api.getWithToken(Endpoints.verifiedJournal);
      res = VerifiedJournalresponse.fromJson(response);
    } catch (e) {
      res = VerifiedJournalresponse.fromJson(response);
    }
    return res;
  }

  Future<WeeklyDetailsresponse> detailWeekly(String JournalSlug) async {
    dynamic response;
    WeeklyDetailsresponse res;

    try {
      print("JournalSlug: $JournalSlug");
      response = await api.getWithToken(Endpoints.weeklydetails + JournalSlug);
    } catch (e) {
      print("Error fetching weekly details: $e");
    }

    if (response != null) {
      try {
        res = WeeklyDetailsresponse.fromJson(response);
      } catch (e) {

        res = WeeklyDetailsresponse.fromJson(response);
      }
    } else {
      res = WeeklyDetailsresponse.fromJson(response);
    }

    return res;
  }

  Future<Commonresponse> putLike(String slug) async {
    dynamic response;
    Commonresponse res;
    try {
      response = await api.putDataWithToken(null, Endpoints.likeJournal+slug);
      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> postComment(Commentrequest request, String slug) async {
    dynamic response;
    Commonresponse res;
    try {
      response = await api.postDataWithToken( jsonEncode(request),Endpoints.commentJournal+slug);
      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }
}
