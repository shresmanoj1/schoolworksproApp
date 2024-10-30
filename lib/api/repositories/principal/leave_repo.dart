import 'dart:convert';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/principal/addleavetypeprincipal_response.dart';
import 'package:schoolworkspro_app/response/principal/approvedleave_response.dart';
import 'package:schoolworkspro_app/response/principal/getleaveprincipal_response.dart';

class LeaveRepository {
  Future<ApprovedLeaveResponse> getApprovedleave() async {
    API api = API();
    dynamic response;
    ApprovedLeaveResponse res;
    try {
      response = await api.getWithToken('/leaves/approved-leaves-today');
      print("RESPONSE TYPE:::${response}");

      res = ApprovedLeaveResponse.fromJson(response);
    } catch (e) {
      print(e.toString());
      res = ApprovedLeaveResponse.fromJson(response);
    }
    return res;
  }

  Future<GetLeavePrincipalResponse> getleavetype() async {
    API api = API();
    dynamic response;
    GetLeavePrincipalResponse res;
    try {
      response = await api.getWithToken('/leavecategory/get-leave');

      res = GetLeavePrincipalResponse.fromJson(response);
    } catch (e) {
      res = GetLeavePrincipalResponse.fromJson(response);
    }
    return res;
  }

  Future<AddLeaveTypePrincipalResponse> postleave(data) async {
    API api = API();
    dynamic response;
    AddLeaveTypePrincipalResponse res;
    try {
      response = await api.postDataWithToken(
          jsonEncode(data), '/leavecategory/add-leave');

      res = AddLeaveTypePrincipalResponse.fromJson(response);
    } catch (e) {
      res = AddLeaveTypePrincipalResponse.fromJson(response);
    }
    return res;
  }

  Future<AddLeaveTypePrincipalResponse> updateleave(data, String id) async {
    API api = API();
    dynamic response;
    AddLeaveTypePrincipalResponse res;
    try {
      response = await api.putDataWithToken(
          jsonEncode(data), '/leavecategory/update-leave/$id');

      res = AddLeaveTypePrincipalResponse.fromJson(response);
    } catch (e) {
      res = AddLeaveTypePrincipalResponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> deleteleave(String id) async {
    API api = API();
    dynamic response;
    Commonresponse res;
    try {
      response = await api.deleteWithToken('/leavecategory/delete-leave/$id');

      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }
}
