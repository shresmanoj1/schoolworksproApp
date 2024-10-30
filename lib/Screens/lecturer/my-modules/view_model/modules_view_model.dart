import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api_response.dart';
import 'package:schoolworkspro_app/response/lecturer/findbyemail_response.dart';

import '../../../../api/repositories/lecturer/modules_repository.dart';
import '../../../../request/lecturer/get_studentrequest.dart';
import '../../../../response/lecturer/progress_student_response.dart';

class ModuleViewModel with ChangeNotifier {
  ApiResponse _studentOnlyForModuleListApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get studentOnlyForModuleListApiResponse => _studentOnlyForModuleListApiResponse;
  ProgressStudentResponse _studentOnlyForModuleList = ProgressStudentResponse();
  ProgressStudentResponse get studentOnlyForModuleList => _studentOnlyForModuleList;

  Future<void> fetchStudentForModule(Getstudentrequest data) async {
    _studentOnlyForModuleListApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      ProgressStudentResponse res = await ModuleRepository().getStudentForModule(data);
      if (res.success == true) {
        _studentOnlyForModuleList = res;

        _studentOnlyForModuleListApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _studentOnlyForModuleListApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _studentOnlyForModuleListApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
