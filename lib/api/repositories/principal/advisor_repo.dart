import 'dart:convert';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/postadvisor_request.dart';
import 'package:schoolworkspro_app/request/referral_details_request.dart';
import 'package:schoolworkspro_app/response/principal/getadvisors_response.dart';
import 'package:schoolworkspro_app/response/principal/postadvisor_response.dart';
import 'package:schoolworkspro_app/response/principal/referral_details_response.dart';

class AdvisorRepository {
  Future<GetAdvisorResponse> getAdvisor() async {
    API api = API();
    dynamic response;
    GetAdvisorResponse res;
    try {
      response = await api.getWithToken('/advisors');

      res = GetAdvisorResponse.fromJson(response);
    } catch (e) {
      res = GetAdvisorResponse.fromJson(response);
    }
    return res;
  }

  Future<PostAdvisorResponse> postAdvisor(request) async {
    API api = API();
    dynamic response;
    PostAdvisorResponse res;
    try {
      response = await api.postDataWithToken(jsonEncode(request),'/advisors/add');

      res = PostAdvisorResponse.fromJson(response);
    } catch (e) {
      print(e.toString());
      res = PostAdvisorResponse.fromJson(response);
    }
    return res;
  }

  Future<PostAdvisorResponse> admit(request,String id) async {
    API api = API();
    dynamic response;
    PostAdvisorResponse res;
    try {
      response = await api.putDataWithToken(jsonEncode(request),'/advisors/$id');

      res = PostAdvisorResponse.fromJson(response);
    } catch (e) {
      print(e.toString());
      res = PostAdvisorResponse.fromJson(response);
    }
    return res;
  }

  Future<ReferralDetailsResponse> postReferralDetails(request, id) async {
    API api = API();
    dynamic response;
    ReferralDetailsResponse res;
    try {
      response = await api.putDataWithToken(jsonEncode(request),'/advisors/$id');

      res = ReferralDetailsResponse.fromJson(response);
    } catch (e) {
      print(e.toString());
      res = ReferralDetailsResponse.fromJson(response);
    }
    return res;
  }

}