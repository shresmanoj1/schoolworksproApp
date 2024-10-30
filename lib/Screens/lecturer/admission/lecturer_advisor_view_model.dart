import 'package:flutter/material.dart';import 'package:schoolworkspro_app/api/api_response.dart';import 'package:schoolworkspro_app/response/lecturer/advisor_assigned_response.dart';import '../../../api/repositories/lecturer/advisor_assigned_repo.dart';class LecturerAdvisorViewModel extends ChangeNotifier{  ApiResponse _advisorAssignedReponse = ApiResponse.initial("Empty Data");  ApiResponse get advisorAssignedReponse => _advisorAssignedReponse;  List<dynamic> _admissionData = <dynamic>[];  List<dynamic> get admissionData => _admissionData;  Future<void> fetchAssigned() async {    _advisorAssignedReponse = ApiResponse.initial("Loading");    notifyListeners();    try {      AdivsorAssignedLecturerResponse res =      await AdvisorAssignedRepository().getAssigned();      if (res.success == true) {        print("this is true");        print(res.assigned);        _admissionData = res.assigned!;        print(_admissionData);        _advisorAssignedReponse = ApiResponse.completed(res.success.toString());        notifyListeners();      } else {        _advisorAssignedReponse = ApiResponse.error(res.success.toString());      }    } catch (e) {      print("VM CATCH ERR :: " + e.toString());      _advisorAssignedReponse = ApiResponse.error(e.toString());    }    notifyListeners();  }}