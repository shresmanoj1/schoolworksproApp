import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../../../api/api_response.dart';
import '../../../api/repositories/quiz_reposiotry.dart';
import '../../../response/flagged_quiz_response.dart';
import '../../../response/quizStart._response.dart';
import '../../../response/quiz_question_ans_response.dart';
import '../../../response/quiz_response.dart';
import '../../../response/quizoverview_response.dart';

class QuizViewModel with ChangeNotifier {
  bool _timeUp = false;
  bool get timeUp => _timeUp;

  Duration _meDuration = Duration();
  Duration get meDuration => _meDuration;

  setDuration(Duration value) {
    _meDuration = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ApiResponse _quizApiResponse = ApiResponse.initial('Empty data');
  ApiResponse get quizApiResponse => _quizApiResponse;
  List<AllQuiz> _quiz = [];
  List<AllQuiz> get quiz => _quiz;

  Future<void> getQuiz(String moduleSlug) async {
    _isLoading = true;
    _quizApiResponse = ApiResponse.loading("Loading");
    notifyListeners();
    try {
      QuizResponse res = await QuizRepository().fetchQuiz(moduleSlug);
      if (res.success == true) {
        _quiz = res.allQuiz!;
        notifyListeners();
      } else {
        _quizApiResponse = ApiResponse.error(res.toString());
      }
    } catch (e) {
      _quizApiResponse = ApiResponse.error(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ApiResponse _startquizApiResponse = ApiResponse.initial('Empty Data');
  ApiResponse get startquizApiResponse => _startquizApiResponse;
  dynamic _startquiz;
  dynamic get startquiz => _startquiz;
  dynamic _pastQuiz;
  dynamic get pastQuiz => _pastQuiz;


  Future<void> getStartQuiz(String ms, String week) async {
    _startquizApiResponse = ApiResponse.loading("Loading");
    notifyListeners();
    try {
      QuizStartResponse res = await QuizRepository().startQuiz(ms, week);
      if (res.success == true) {
        _pastQuiz = res.isPastQuiz;

        _startquiz = res.quiz!;
        print("${res.quiz!}this");

        _startquizApiResponse = ApiResponse.completed(res.success.toString());
      } else {
        _startquizApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      _startquizApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }



  ApiResponse _myQuizAnswerApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get myQuizAnswerApiResponse => _myQuizAnswerApiResponse;
  QuizMyAnswerResponse _myQuizAnswer = QuizMyAnswerResponse();
  QuizMyAnswerResponse get myQuizAnswer => _myQuizAnswer;

  Future<void> fetchMyQuizAnswer(String id) async {
    _myQuizAnswerApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      QuizMyAnswerResponse res = await QuizRepository().getMyAnswer(id);
      if (res.success == true) {
        print("I am here");
        _myQuizAnswer = res;
        _myQuizAnswerApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        print("i am inside ellse");
        _myQuizAnswerApiResponse =
            ApiResponse.completed(res.success.toString());
      }
    } catch (e) {
      print(e.toString());
      _myQuizAnswerApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _flaggedQuizApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get flaggedQuizApiResponse => _flaggedQuizApiResponse;
  FlaggedQuizResponse _flaggedQuiz = FlaggedQuizResponse();
  FlaggedQuizResponse get flaggedQuiz => _flaggedQuiz;

  Future<void> getFlaggedQuiz(String quizId) async {
    _flaggedQuizApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      dynamic res = await QuizRepository().getFlagQuiz(quizId);
      if (res != null) {
        _flaggedQuiz = res;
        _flaggedQuizApiResponse = ApiResponse.completed("Success");
        notifyListeners();
      } else {
        _flaggedQuizApiResponse = ApiResponse.error("Failed");
      }
    } catch (e) {
      _flaggedQuizApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  // ApiResponse _checkCodeQuizApiResponse = ApiResponse.initial("Empty Data");
  // ApiResponse get checkCodeQuizApiResponse => _checkCodeQuizApiResponse;
  // CodeQuizCheckResponse _checkCodeQuiz = CodeQuizCheckResponse();
  // CodeQuizCheckResponse get checkCodeQuiz => _checkCodeQuiz;
  //
  // Future<void> addcheckCodeQuiz(checkquizquestionrequest request, String quizId,
  //     BuildContext context) async {
  //   _checkCodeQuizApiResponse = ApiResponse.initial("Loading");
  //   notifyListeners();
  //   try {
  //     context.loaderOverlay.show();
  //     CodeQuizCheckResponse response =
  //         (await QuizRepository().postCheckCodeQuiz(request, quizId));
  //
  //     if (response.success == true) {
  //       _checkCodeQuiz = response;
  //
  //       notifyListeners();
  //
  //       context.loaderOverlay.hide();
  //       notifyListeners();
  //     } else {
  //       context.loaderOverlay.hide();
  //       _checkCodeQuizApiResponse =
  //           ApiResponse.error(response.success.toString());
  //     }
  //   } catch (e) {
  //     _checkCodeQuizApiResponse = ApiResponse.error(e.toString());
  //   }
  //   notifyListeners();
  // }

  ApiResponse _quizServerTimeApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get quizServerTimeApiResponse => _quizServerTimeApiResponse;
  dynamic _quizserverTime;
  dynamic get quizserverTime => _quizserverTime;

  Future<void> fetchServerTimeQuiz() async {
    _quizServerTimeApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      dynamic res = await QuizRepository().getServerTimeQuiz();
      if (res != null) {
        print(res.toString());
        _quizserverTime = res;

        _quizServerTimeApiResponse = ApiResponse.completed("Success");
        notifyListeners();
      } else {
        _quizServerTimeApiResponse = ApiResponse.error("Failed");
      }
    } catch (e) {
      _quizServerTimeApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }


  ApiResponse _quizoverviewApiResponse = ApiResponse.initial('Empty Data');
  ApiResponse get quizoverviewApiResponse => _quizoverviewApiResponse;
  QuizOverviewResponse _quizoverview = QuizOverviewResponse();
  QuizOverviewResponse get quizoverview => _quizoverview;

  Future<void> fetchQuizOverview(String quizid) async {
    _quizoverviewApiResponse = ApiResponse.loading("Loading");
    notifyListeners();
    try {
      QuizOverviewResponse res = await QuizRepository().getOverview(quizid);
      if (res.success == true) {
        _quizoverview = res;
        _quizoverviewApiResponse =
            ApiResponse.completed(res.success.toString());
      } else {
        _quizoverviewApiResponse =
            ApiResponse.completed(res.success.toString());
      }
    } catch (e) {
      _quizoverviewApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}