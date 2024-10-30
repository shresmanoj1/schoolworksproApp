import 'dart:convert';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/principal/activity_log_response.dart';
import 'package:schoolworkspro_app/response/principal/assignedrequestforstats_response.dart';
import 'package:schoolworkspro_app/response/principal/leaveforstats_principal.dart';
import 'package:schoolworkspro_app/response/principal/overtimeforstats_response.dart';
import 'package:schoolworkspro_app/response/principal/respondleave_response.dart';
import 'package:schoolworkspro_app/response/principal/supportstaff_response.dart';

import '../../../response/certificates_names_response.dart';

class StatsRepository {
  API api = API();
  Future<LeaveForStatsPrincipal> getleavestats(String username) async {
    API api = new API();
    dynamic response;
    LeaveForStatsPrincipal res;
    try {
      response = await api.getWithToken('/leaves/$username');

      res = LeaveForStatsPrincipal.fromJson(response);
    } catch (e) {
      res = LeaveForStatsPrincipal.fromJson(response);
    }
    return res;
  }

  Future<RespondToLeaveResponse> respondleave(data, String id) async {
    API api = new API();
    dynamic response;
    RespondToLeaveResponse res;
    try {
      response = await api.putDataWithToken(jsonEncode(data), '/leaves/$id');

      res = RespondToLeaveResponse.fromJson(response);
    } catch (e) {
      res = RespondToLeaveResponse.fromJson(response);
    }
    return res;
  }

  Future<AssignedRequestForStatsResponse> getassignedrequest(
      String username) async {
    API api = new API();
    dynamic response;
    AssignedRequestForStatsResponse res;
    try {
      response = await api.getWithToken('/requests/assigned/$username');

      res = AssignedRequestForStatsResponse.fromJson(response);
    } catch (e) {
      res = AssignedRequestForStatsResponse.fromJson(response);
    }
    return res;
  }

  Future<OvertimeForStatsResponse> getovertime(String username) async {
    API api = new API();
    dynamic response;
    OvertimeForStatsResponse res;
    try {
      response = await api.getWithToken('/overtime/$username');

      res = OvertimeForStatsResponse.fromJson(response);
    } catch (e) {
      res = OvertimeForStatsResponse.fromJson(response);
    }
    return res;
  }

  Future<ActivityLogsResponse> getlogs(data, String username) async {
    API api = new API();
    dynamic response;
    ActivityLogsResponse res;
    try {
      response = await api.postDataWithToken(
          jsonEncode(data), '/staffAttendance/getMonthlyWorking/$username');

      res = ActivityLogsResponse.fromJson(response);
    } catch (e) {
      res = ActivityLogsResponse.fromJson(response);
    }
    return res;
  }

  Future<GetSupportStaffResponse> getsupportstaffs(String username) async {
    API api = new API();
    dynamic response;
    GetSupportStaffResponse res;
    try {
      response =
          await api.getWithToken('/supportStaff/get-support-batches/$username');

      res = GetSupportStaffResponse.fromJson(response);
    } catch (e) {
      res = GetSupportStaffResponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> resetPassword(data) async {
    API api = new API();
    dynamic response;
    Commonresponse res;
    try {
      response = await api.putDataWithToken(
          jsonEncode(data), '/passwords/reset-password-admin');

      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> assignbatch(data) async {
    API api = new API();
    dynamic response;
    Commonresponse res;
    try {
      response =
          await api.postDataWithToken(jsonEncode(data), '/supportStaff/add');

      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<CertificateNamesResponse> getCertificateNames() async {
    API api = new API();
    dynamic response;
    CertificateNamesResponse res;
    try {
      response = await api.getWithToken('/builder/get-certificate-names');

      res = CertificateNamesResponse.fromJson(response);
    } catch (e) {
      res = CertificateNamesResponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> addRequestLetter(data) async {
    API api = new API();
    dynamic response;
    Commonresponse res;
    try {
      response = await api.postDataWithToken(data, '/letter/add');

      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }
}
