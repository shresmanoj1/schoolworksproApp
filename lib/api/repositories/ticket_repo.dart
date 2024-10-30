import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/lecturer/academicrequest_response.dart';
import 'package:schoolworkspro_app/response/lecturer/lecturerrequest_response.dart';

class TicketRepository extends ChangeNotifier {
  API api = API();

  Future<LecturerRequestResponse> getMyRequestFromProvider() async {
    // print("DATA :: " + data.toString());
    dynamic response = await api.getWithToken('/requests/my-requests');
    // print("RAW RESPONSE :: "+ response.toString());
    LecturerRequestResponse res = LecturerRequestResponse.fromJson(response);
    return res;
  }


  Future<AcademicRequestResponse> getMyAcademicRequest() async {
    // print("DATA :: " + data.toString());
    dynamic response = await api.getWithToken('/requests/lecturer/academic-requests');
    // print("RAW RESPONSE :: "+ response.toString());
    AcademicRequestResponse res = AcademicRequestResponse.fromJson(response);
    return res;
  }


}
