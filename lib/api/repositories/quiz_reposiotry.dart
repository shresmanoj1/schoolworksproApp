import 'dart:convert';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/api/endpoints.dart';

import '../../response/code_quizcheck_response.dart';
import '../../response/flagged_quiz_response.dart';
import '../../response/mark_quiz_question_response.dart';
import '../../response/post_quiz_answer_response.dart';
import '../../response/quizEnd_response.dart';
import '../../response/quizStart._response.dart';
import '../../response/quiz_question_ans_response.dart';
import '../../response/quiz_response.dart';
import '../../response/quizcomplete_response.dart';
import '../../response/quizoverview_response.dart';
import '../../response/submitquiz_response.dart';

class QuizRepository {
  API api = API();
  Future<QuizResponse> fetchQuiz(String moduleSlug) async {
    dynamic response;
    QuizResponse res;

    try {
      response = await api.getWithToken(Endpoints.getAllQuiz + moduleSlug);
      res = QuizResponse.fromJson(response);
    } catch (e) {
      print("CATCH::::$e");
      res = QuizResponse.fromJson(response);
    }
    return res;
  }

  Future<QuizStartResponse> startQuiz(String ms, String week) async {
    dynamic response;
    QuizStartResponse res;

    try {
      response = await api.getWithToken("${Endpoints.getQuiz}$ms/$week");
      res = QuizStartResponse.fromJson(response);
    } catch (e) {
      res = QuizStartResponse.fromJson(response);
    }
    return res;
  }



  Future<QuizCompleteResponse> quizComplete(
      String moduleSlug, String week) async {
    dynamic response;
    QuizCompleteResponse res;

    try {
      response =
      await api.getWithToken("${Endpoints.getQuiz}$moduleSlug/$week");
      res = QuizCompleteResponse.fromJson(response);
    } catch (e) {
      res = QuizCompleteResponse.fromJson(response);
    }
    return res;
  }

  Future<PostQuizAnswerResponse> postQuizAnswer(String data) async {
    dynamic response;
    PostQuizAnswerResponse res;
    try {
      response = await api.postDataWithToken(data, Endpoints.postquizanswer);
      res = PostQuizAnswerResponse.fromJson(response);
    } catch (e) {
      res = PostQuizAnswerResponse.fromJson(response);
    }
    return res;
  }

  Future<QuizMyAnswerResponse> getMyAnswer(String id) async {
    dynamic response;
    QuizMyAnswerResponse res;
    try {
      response = await api.getWithToken(Endpoints.getmyanswer + id);
      res = QuizMyAnswerResponse.fromJson(response);
    } catch (e) {
      res = QuizMyAnswerResponse.fromJson(response);
    }
    return res;
  }

  Future<MarkQuizQuestionResponse> flagQuizQuestion(String data) async {
    dynamic response;
    MarkQuizQuestionResponse res;
    try {
      response = await api.postDataWithToken(data, Endpoints.addflagquestion);
      res = MarkQuizQuestionResponse.fromJson(response);
    } catch (e) {
      res = MarkQuizQuestionResponse.fromJson(response);
    }
    return res;
  }

  Future<FlaggedQuizResponse> getFlagQuiz(String quizId) async {
    dynamic response;
    FlaggedQuizResponse res;
    try {
      response = await api.getWithToken(Endpoints.getflagquestion + quizId);
      res = FlaggedQuizResponse.fromJson(response);
    } catch (e) {
      res = FlaggedQuizResponse.fromJson(response);
    }
    return res;
  }

  Future<dynamic> getServerTimeQuiz() async {
    API api = API();
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

  Future<CodeQuizCheckResponse> postCheckCodeQuiz(String quizId) async {
    dynamic response;
    CodeQuizCheckResponse res;
    try {
      response = await api.postDataWithToken(
          null, Endpoints.postCodequizcheck + quizId);
      res = CodeQuizCheckResponse.fromJson(response);
    } catch (e) {
      res = CodeQuizCheckResponse.fromJson(response);
    }
    return res;
  }

  Future<QuizCompleteResponse> updateQuizCompletion(String quizId) async {
    dynamic response;
    QuizCompleteResponse res;
    try {
      response =
      await api.putDataWithToken(null, Endpoints.completeQuiz + quizId);
      res = QuizCompleteResponse.fromJson(response);
    } catch (e) {
      res = QuizCompleteResponse.fromJson(response);
    }
    return res;
  }

  Future<QuizOverviewResponse> getOverview(String quizid) async {
    dynamic response;
    QuizOverviewResponse res;
    try {
      response = await api.getWithToken(Endpoints.overview + quizid);
      res = QuizOverviewResponse.fromJson(response);
    } catch (e) {
      res = QuizOverviewResponse.fromJson(response);
    }
    return res;
  }
}