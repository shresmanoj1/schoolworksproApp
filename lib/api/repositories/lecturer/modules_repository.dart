import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/api/endpoints.dart';
import 'package:schoolworkspro_app/config/hive.conf.dart';
import 'package:schoolworkspro_app/response/lecturer/findbyemail_response.dart';
import 'package:schoolworkspro_app/response/lecturer/lecturermoduledetail_response.dart';

import '../../../request/lecturer/get_studentrequest.dart';
import '../../../response/lecturer/lecturer_all_task_response.dart';
import '../../../response/lecturer/progress_student_response.dart';

class ModuleRepository {
  API api = API();
  Future<Findbyemailresponse> getModules(data) async {
    API api = new API();
    Box box = HiveUtils.box;
    dynamic response;
    Findbyemailresponse res;
    try {
      response =
          await api.postDataWithToken(data, Endpoints.lecturergetmodules);

      res = Findbyemailresponse.fromJson(response);
      await box.put(Endpoints.lecturergetmodules, res.toJson());
    } catch (e) {
      print(e.toString());
      response = await box.get(Endpoints.lecturergetmodules);
      // print("asas"+response.toString());
      res = Findbyemailresponse.fromJson(response);
      print(res.toJson().toString());
    }
    return res;
  }

  Future<LecturerModuleDetailResponse> getModuleDetails(data) async {
    API api = new API();
    // Box box = HiveUtils.box;
    dynamic response;
    LecturerModuleDetailResponse res;
    try {
      response = await api.postDataWithToken(jsonEncode(data), Endpoints.moduleDetails);

      res = LecturerModuleDetailResponse.fromJson(response);
    } catch (e) {
      res = LecturerModuleDetailResponse.fromJson(response);
    }
    return res;
  }

  Future<ProgressStudentResponse> getStudentForModule(Getstudentrequest request) async {
    API api = new API();
    dynamic response;
    ProgressStudentResponse res;
    try {
      response = await api.postDataWithToken(jsonEncode(request.toJson()), '/tracking/module-progress');

      res = ProgressStudentResponse.fromJson(response);
    } catch (e) {
      res = ProgressStudentResponse.fromJson(response);
    }
    return res;
  }

  Future<LecturerAllTaskResponse> getLecturerAllTask() async {
    API api = new API();
    // Box box = HiveUtils.box;
    dynamic response;
    LecturerAllTaskResponse res;
    try {
      response = await api.getWithToken("/assessments/lecturer/task");

      res = LecturerAllTaskResponse.fromJson(response);
    } catch (e) {
      res = LecturerAllTaskResponse.fromJson(response);
    }
    return res;
  }
}
