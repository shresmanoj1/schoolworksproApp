import 'package:schoolworkspro_app/api/api.dart';import 'package:schoolworkspro_app/response/common_response.dart';import '../../response/assessment_submission_response.dart';class StudentAssessmentRepository{  API api = API();  Future<Commonresponse> addAssessment(String data, bool isUpdate) async {    API api = new API();    dynamic response;    Commonresponse res;    try {      response = await api.postDataWithToken(data, '/submissions/submit');      res = Commonresponse.fromJson(response);    } catch (e) {      res = Commonresponse.fromJson(response);    }    return res;  }  Future<Commonresponse> updateAssessment(String data) async {    API api = new API();    dynamic response;    Commonresponse res;    try {      response = await api.postDataWithToken(data, '/submissions/submit');      print(response);      res = Commonresponse.fromJson(response);    } catch (e) {      res = Commonresponse.fromJson(response);    }    return res;  }  Future<Commonresponse> addAssessmentSubmission(String data) async {    API api = new API();    dynamic response;    Commonresponse res;    try {      response = await api.postDataWithToken(data, '/submissionCheck');      print(response);      res = Commonresponse.fromJson(response);    } catch (e) {      res = Commonresponse.fromJson(response);    }    return res;  }  Future<AssessmentSubmissionResponse> getCheckSubmission(String lessonSlug) async {    API api = new API();    dynamic response;    AssessmentSubmissionResponse res;    try {      response = await api.getWithToken("/submissions/$lessonSlug");      print(response);      res = AssessmentSubmissionResponse.fromJson(response);    } catch (e) {      res = AssessmentSubmissionResponse.fromJson(response);    }    return res;  }}