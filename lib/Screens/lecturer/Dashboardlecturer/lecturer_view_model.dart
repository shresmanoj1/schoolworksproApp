import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api_response.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/modules_repository.dart';
import 'package:schoolworkspro_app/config/preference_utils.dart';
import 'package:schoolworkspro_app/request/lecturer/get_modulerequest.dart';
import 'package:schoolworkspro_app/response/lecturer/findbyemail_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../response/lecturer/lecturer_all_task_response.dart';

class LecturerViewModel extends ChangeNotifier {
  final SharedPreferences localStorage = PreferenceUtils.instance;

  String _institutiontype = "";
  String get institutiontype => _institutiontype;

  setType(String value){
    _institutiontype = value;
    notifyListeners();
  }

  String _email = "";

  String get emails => _email;

  void setEmail(String emailss) {
    _email = emailss;
    notifyListeners();
  }

  ApiResponse _moduleApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get moduleApiResponse => _moduleApiResponse;
  List<dynamic> _modules = <dynamic>[];
  List<dynamic> get modules => _modules;

  Future<void> fetchModules() async {
    _moduleApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      dynamic data =
          getmodulerequestToJson(Getmodulerequest(email: _email.toString()));

      Findbyemailresponse res = await ModuleRepository().getModules(data);
      if (res.success == true) {
        _modules = res.lecturer!.modules!;

        _moduleApiResponse = ApiResponse.completed(res.success.toString());
      } else {
        _moduleApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _moduleApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }


  ApiResponse _lecturerAllTaskApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get lecturerAllTaskApiResponse => _lecturerAllTaskApiResponse;
  LecturerAllTaskResponse _lecturerAllTask = LecturerAllTaskResponse();
  LecturerAllTaskResponse get lecturerAllTask => _lecturerAllTask;

  Future<void> fetchLecturerAllTask() async {
    _lecturerAllTaskApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      LecturerAllTaskResponse res = await ModuleRepository().getLecturerAllTask();
      if (res.success == true) {
        _lecturerAllTask = res;

        _lecturerAllTaskApiResponse = ApiResponse.completed(res.success.toString());
      } else {
        _lecturerAllTaskApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _lecturerAllTaskApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}

