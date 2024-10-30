import 'dart:convert';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/exam_from_course_response.dart';
import 'package:schoolworkspro_app/response/getexam_response.dart';
import 'package:schoolworkspro_app/response/lecturer/lecturerexam_response.dart';
import 'package:schoolworkspro_app/response/lecturer/viewexamattendance_response.dart';
import 'package:schoolworkspro_app/response/overall_new_result_response.dart';
import 'package:schoolworkspro_app/response/parents/getexam_parent_response.dart';
import 'package:schoolworkspro_app/response/showexam_dropdown.dart';

import '../../request/lecturer/qrdataexam_request.dart';
import '../../response/all_exam_response.dart';
import '../../response/exam_completed_response.dart';
import '../../response/exam_detail_response.dart';
import '../../response/exam_my_answer_response.dart';
import '../../response/exam_rules_regulation_response.dart';
import '../../response/exam_score_response.dart';
import '../../response/exam_submit_answer_response.dart';
import '../../response/exam_with_question_response.dart';
import '../../response/flagged_question_response.dart';
import '../../response/mark_exam_question_respopnse.dart';
import '../../response/my_exam_generate_qr_response.dart';
import '../../response/question_answer_response.dart';

class ExamRepository {

  API api = API();

  Future<GetExamResponse> getExam() async {
    dynamic response;
    GetExamResponse res;
    try {
      response = await api.getWithToken('/exams/my-exams');
      res = GetExamResponse.fromJson(response);
    } catch (e) {
      res = GetExamResponse.fromJson(response);
    }
    return res;
  }

  Future<ShowExamsDropDownResponse> getExamforDropdown(
      String moduleSlug) async {
    dynamic response;
    ShowExamsDropDownResponse res;
    try {
      response = await api.getWithToken('/exams/by-module-slug/$moduleSlug');
      res = ShowExamsDropDownResponse.fromJson(response);
    } catch (e) {
      res = ShowExamsDropDownResponse.fromJson(response);
    }
    return res;
  }

  Future<ExamFromCourseResponse> getExamFromCourseStudents(username) async {
    dynamic response;
    ExamFromCourseResponse res;
    try {
      response = await api.getWithToken('/overall-result/my-exams/$username');
      res = ExamFromCourseResponse.fromJson(response);
    } catch (e) {
      res = ExamFromCourseResponse.fromJson(response);
    }
    return res;
  }

  Future<GetExamParentResponse> getExamFromCourseParents(
      username, institution) async {

    dynamic response;
    GetExamParentResponse res;
    try {
      response = await api.getWithToken(
          '/overall-result/my-exams/$username?institution=$institution');
      res = GetExamParentResponse.fromJson(response);
    } catch (e) {
      res = GetExamParentResponse.fromJson(response);
    }
    return res;
  }

  Future<OverallNewResultResponse> displayresultToParent(
      examSlug, username) async {

    dynamic response;
    OverallNewResultResponse res;
    try {
      response = await api.getWithToken(
          '/overall-result/for-student/$examSlug?username=$username');
      res = OverallNewResultResponse.fromJson(response);
    } catch (e) {
      res = OverallNewResultResponse.fromJson(response);
    }
    return res;
  }

  Future<OverallNewResultResponse> displayresultToStudent(examSlug) async {

    dynamic response;
    OverallNewResultResponse res;
    try {
      response =
          await api.getWithToken('/overall-result/for-student/$examSlug');
      res = OverallNewResultResponse.fromJson(response);
    } catch (e) {
      res = OverallNewResultResponse.fromJson(response);
    }
    return res;
  }

  Future<LecturerGetExamResponse> getExamLecturer() async {

    dynamic response;
    LecturerGetExamResponse res;
    try {
      response = await api.getWithToken('/exams/get-exam/');
      res = LecturerGetExamResponse.fromJson(response);
    } catch (e) {
      res = LecturerGetExamResponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> postExamAttendance(data) async {

    dynamic response;
    Commonresponse res;
    try {
      response =
          await api.postDataWithToken(jsonEncode(data), '/exam-attendance/');
      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<ViewExamAttendanceResponse> getExamAttendance(id) async {

    dynamic response;
    ViewExamAttendanceResponse res;
    try {
      response = await api.getWithToken('/exam-attendance/$id');
      res = ViewExamAttendanceResponse.fromJson(response);
    } catch (e) {
      res = ViewExamAttendanceResponse.fromJson(response);
    }
    return res;
  }

  Future<QuestionAnswerResponse> getAExamQuestionAnswer(String id) async {

    dynamic response;
    QuestionAnswerResponse res;
    try {
      response = await api.getWithToken('/exams/get-exam-with-questions/$id');
      print(response.toString());
      res = QuestionAnswerResponse.fromJson(response);
    } catch (e) {
      res = QuestionAnswerResponse.fromJson(response);
    }
    return res;
  }

  Future<ExamSubmitAnswerResponse> submitAnswer(String data) async {

    dynamic response;
    ExamSubmitAnswerResponse res;
    try {
      response = await api.postDataWithToken(data, "/answers/add");
      res = ExamSubmitAnswerResponse.fromJson(response);
    } catch (e) {
      print("CATCH ERROR:::${e.toString()}");
      res = ExamSubmitAnswerResponse.fromJson(response);
    }
    return res;
  }

  Future<dynamic> getServerTime() async {

    dynamic response;
    dynamic res;
    try {
      response = api.getWithToken('/');
      res = response;

    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<ExamMyAnswerResponse> getMyAnswer(String id) async {

    dynamic response;
    ExamMyAnswerResponse res;
    try {
      response = await api.getWithToken('/answers/myAnswer/$id');
      res = ExamMyAnswerResponse.fromJson(response);
    } catch (e) {
      res = ExamMyAnswerResponse.fromJson(response);
    }
    return res;
  }

  Future<ExamCompletedResponse> examCompleted(String id) async {

    dynamic response;
    ExamCompletedResponse res;
    try {
      response = await api.putDataWithToken(null ,"/exams/completed/$id");
      res = ExamCompletedResponse.fromJson(response);
    } catch (e) {
      res = ExamCompletedResponse.fromJson(response);
    }
    return res;
  }

  Future<MarkExamQuestionResponse> flagQuestion(String data) async {

    dynamic response;
    MarkExamQuestionResponse res;
    try {
      response = await api.postDataWithToken(data ,"/question-flag/flag-examq");
      res = MarkExamQuestionResponse.fromJson(response);
    } catch (e) {
      res = MarkExamQuestionResponse.fromJson(response);
    }
    return res;
  }

  Future<FlaggedQuestionResponse> getFlagQuestion(String examId) async {

    dynamic response;
    FlaggedQuestionResponse res;
    try {
      response = await api.getWithToken("/question-flag/flagged-question-exam/$examId");
      res = FlaggedQuestionResponse.fromJson(response);
    } catch (e) {
      res = FlaggedQuestionResponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> examAttempt(String examId) async {

    dynamic response;
    Commonresponse res;
    try {
      response = await api.putDataWithToken(null, "/exams/attempt/$examId");
      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> checkExamCode(String request, String examId) async {

    dynamic response;
    Commonresponse res;
    try {
      response = await api.postDataWithToken(request, "/exams/check-code/$examId");
      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> enableUserLogin(String userid) async {

    dynamic response;
    Commonresponse res;
    try {
      response = await api.putDataWithToken(null, "/users/enable-login/$userid");
      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<GetExamResponse> getMyExams() async {

    dynamic response;
    GetExamResponse res;
    try {
      response = await api.getWithToken('/exams/my-exams');
      res = GetExamResponse.fromJson(response);
    } catch (e) {
      res = GetExamResponse.fromJson(response);
    }
    return res;
  }

  Future<AllExamResponse> getAllExams() async {

    dynamic response;
    AllExamResponse res;
    try {
      response = await api.getWithToken('/exams/current-online-exams');
      res = AllExamResponse.fromJson(response);
    } catch (e) {
      res = AllExamResponse.fromJson(response);
    }
    return res;
  }

  Future<MyExamGenerateQrResponse> examinationSlipQrGenerate(data) async {

    dynamic response;
    MyExamGenerateQrResponse res;
    try {
      response =
      await api.postDataWithToken(jsonEncode(data), '/exams/generate-qr');
      res = MyExamGenerateQrResponse.fromJson(response);

    } catch (e) {
      res = MyExamGenerateQrResponse.fromJson(response);
    }
    return res;
  }

  Future<ExamRulesRegulationsResponse> getExamRulesRegulations() async {

    dynamic response;
    ExamRulesRegulationsResponse res;
    try {
      response = await api.getWithToken('/policies/exam-rules-regulations');
      res = ExamRulesRegulationsResponse.fromJson(response);
    } catch (e) {
      res = ExamRulesRegulationsResponse.fromJson(response);
    }
    return res;
  }

  Future<ExamDetailResponse> getExamDetails(String id) async {

    dynamic response;
    ExamDetailResponse res;
    try {
      response = await api.getWithToken('/exams/exam-details-by-id/$id');

      res = ExamDetailResponse.fromJson(response);
    } catch (e) {
      res = ExamDetailResponse.fromJson(response);
    }
    return res;
  }

  Future<ExamWithQuestionResponse> getExamWithQuestion(String id) async {

    dynamic response;
    ExamWithQuestionResponse res;
    try {
      response = await api.getWithToken('/exams/get-exam-with-questions/$id');

      res = ExamWithQuestionResponse.fromJson(response);
    } catch (e) {
      res = ExamWithQuestionResponse.fromJson(response);
    }
    return res;
  }

  Future<ExamScoreResponse> getExamScore(String id) async {

    dynamic response;
    ExamScoreResponse res;
    try {
      response = await api.getWithToken('/answers/getExamScore/$id');
      res = ExamScoreResponse.fromJson(response);
    } catch (e) {
      print("ERROR::${e.toString()}");
      res = ExamScoreResponse.fromJson(response);
    }
    return res;
  }
}
