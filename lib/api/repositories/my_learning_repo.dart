import 'dart:convert';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/api/endpoints.dart';

import '../../../response/mylearning_response.dart';
import '../../response/new_learning_response.dart';
import '../../response/student_study_material_response.dart';
import '../../response/syllabus_batch_module_status_response.dart';

class MyLearningRepository {
  API api = API();

  Future<Mylearningresponse> getMyLearning(String params) async {
    dynamic response;
    Mylearningresponse res;
    var url;
    if(params.isEmpty){
      url = Endpoints.getMyLearnings;
    }else{
      List<String> splitList = params.split(" ");
      String joinedString = splitList.join("%20");
      url = "${Endpoints.getMyLearnings}?year=$joinedString";
    }
    try{
      response = await api.getWithToken(url);
      res = Mylearningresponse.fromJson(response);
    } catch(e){
      res = Mylearningresponse.fromJson(response);
    }
    return res;
  }

  Future<NewLearningResponse> getMyLearningNew(String params) async {
    dynamic response;
    NewLearningResponse res;
    var url;
    if(params.isEmpty){
      url = Endpoints.getMyLearningsNewApI;
    }else{
      url = "${Endpoints.getMyLearningsNewApI}?year=$params";
    }
    try{
      response = await api.getWithToken(url);
      res = NewLearningResponse.fromJson(response);
    } catch(e){
      res = NewLearningResponse.fromJson(response);
    }
    return res;
  }

  Future<StudentStudyMaterialResponse> getMyStudyMaterial(String moduleSlug) async {
    dynamic response;
    StudentStudyMaterialResponse res;
    try{
      response = await api.getWithToken("/lessons/teaching-materials/all/$moduleSlug");
      res = StudentStudyMaterialResponse.fromJson(response);
    } catch(e){
      res = StudentStudyMaterialResponse.fromJson(response);
    }
    return res;
  }

  Future<SyllabusBatchModuleStatusResponse> getSyllabusBatchModuleStatus(data) async {
    dynamic response;
    SyllabusBatchModuleStatusResponse res;
    try{
      response = await api.postDataWithToken(jsonEncode(data),"/syllabus/batch-module-status");
      res = SyllabusBatchModuleStatusResponse.fromJson(response);
    } catch(e){
      print("ERROR syllabus::${e.toString()}");
      res = SyllabusBatchModuleStatusResponse.fromJson(response);
    }
    return res;
  }
}