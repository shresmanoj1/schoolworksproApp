import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schoolworkspro_app/api/repositories/learning_repository.dart';
import 'package:schoolworkspro_app/response/attendance_progress_response.dart';
import 'package:schoolworkspro_app/response/comment_response.dart';
import 'package:schoolworkspro_app/response/lesson_progress_response.dart';
import 'package:schoolworkspro_app/response/like_response.dart' as lr;
import 'package:schoolworkspro_app/response/markascompleteresponse.dart';
import 'package:schoolworkspro_app/response/new_learning_response.dart';
import 'package:schoolworkspro_app/response/postcomment_response.dart' as pcr;
import 'package:schoolworkspro_app/response/report_response.dart' as rr;
import 'package:schoolworkspro_app/response/support_ticket_response.dart';
import '../../api/api_response.dart';
import '../../api/repositories/activity_repository.dart';
import '../../api/repositories/my_learning_repo.dart';
import '../../helper/custom_loader.dart';
import '../../request/comment_request.dart';
import '../../request/lessontrack_request.dart';
import '../../response/activity_response.dart' as ar;
import '../../response/commentreply_response.dart' as crs;
import '../../response/completed_response.dart';
import '../../response/learning_filter_response.dart';
import '../../response/lesson_response.dart';
import '../../response/lesson_week_category_response.dart';
import '../../response/lessoncontent_response.dart';
import '../../response/lessonrating_response.dart';
import '../../response/lessonstatus_response.dart';
import '../../response/mylearning_response.dart';
import '../../response/particularassessment_response.dart';
import '../../response/particularmoduleresponse.dart';
import '../../response/rating_response.dart';
import '../../response/startlesson_response.dart';
import '../../response/student_study_material_response.dart';
import '../../response/syllabus_batch_module_status_response.dart';

class LearningViewModel extends ChangeNotifier {

  bool checkShowDigitalDiary = false;
  bool get getShowDigitalDiary => checkShowDigitalDiary;

  int tabIndex = 8;
  int get getTabIndex => tabIndex;

  void setShowDigitalDiary(String value) {
    if (value == "School") {
      checkShowDigitalDiary = true;
      tabIndex = 9;
    } else {
      checkShowDigitalDiary = false;
      tabIndex = 8;
    }
    notifyListeners();
  }


  ApiResponse _myLearningResponse = ApiResponse.initial("Empty Data");
  ApiResponse get myLearningApiResponse => _myLearningResponse;
  List<ModuleLearning> _myLearning = <ModuleLearning>[];
  List<ModuleLearning> get myLearning => _myLearning;

  Future<void> fetchMyLearning(String params) async {
    _myLearningResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Mylearningresponse res =
          await MyLearningRepository().getMyLearning(params);
      print(jsonEncode(res.modules));
      if (res.success == true) {
        _myLearning = res.modules!;

        _myLearningResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _myLearningResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _myLearningResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _myNewLearningApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get myNewLearningApiResponse => _myNewLearningApiResponse;
  List<ModuleNew> _myNewLearning = <ModuleNew>[];
  List<ModuleNew> get myNewLearning => _myNewLearning;

  Future<void> fetchMyNewLearning(String params) async {
    _myNewLearningApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      NewLearningResponse res =
          await MyLearningRepository().getMyLearningNew(params);
      if (res.success == true) {
        _myNewLearning = res.modules!;

        _myNewLearningApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _myNewLearningApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _myNewLearningApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _particularModuleResponse = ApiResponse.initial("Empty Data");
  ApiResponse get particularModuleResponse => _particularModuleResponse;
  dynamic _particularModule;
  dynamic get particularModule => _particularModule;

  dynamic _moduleProgress = 0;
  dynamic get moduleProgress => _moduleProgress;

  Future<void> fetchParticularModule(String slug) async {
    _particularModuleResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Particularmoduleresponse res =
          await LearningRepository().getParticularModule(slug.toString());
      if (res.success == true) {
        _particularModule = res.module!;
        _moduleProgress = double.parse(res.progress.toString());

        _particularModuleResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _particularModuleResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _particularModuleResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _averageRatingApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get averageRatingApiResponse => _averageRatingApiResponse;

  double? _averageRating;
  double? get averageRating => _averageRating;

  Future<void> fetchAverageRating(String slug) async {
    _averageRatingApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Ratingresponse res =
          await LearningRepository().getAverageRating(slug.toString());
      if (res.success == true) {
        _averageRating = res.averageRating;

        _averageRatingApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _averageRatingApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _averageRatingApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _particularAssessmentApiResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get particularAssessmentApiResponse =>
      _particularAssessmentApiResponse;

  List<Assessment> _assessment = <Assessment>[];
  List<Assessment> get assessment => _assessment;

  Future<void> fetchParticularAssignment(String slug) async {
    _particularAssessmentApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Particularassessmentresponse res =
          await LearningRepository().getParticularAssessment(slug.toString());
      if (res.success == true) {
        _assessment = res.assessment!;

        _particularAssessmentApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _particularAssessmentApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _particularAssessmentApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _completedLessonApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get completedLessonApiResponse => _completedLessonApiResponse;

  List<String> _completedLesson = <String>[];
  List<String> get completedLesson => _completedLesson;

  Future<void> fetchCompletedLesson() async {
    _completedLesson = [];
    _completedLessonApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Completedlessonresponse res =
          await LearningRepository().getCompletedLesson();
      if (res.success == true) {
        for (int i = 0; i < res.completedLessons!.length; i++) {
          _completedLesson.add(res.completedLessons![i].lesson.toString());
        }

        _completedLessonApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _completedLessonApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _completedLessonApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _markCompleteApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get markCompleteApiResponse => _markCompleteApiResponse;

  Future<void> markAsComplete(
      BuildContext context, LessonTrackRequest lessonTrackRequest) async {
    customLoadStart();
    _markCompleteApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Markascompleteresponse res1 =
          await LearningRepository().markComplete(lessonTrackRequest);
      if (res1.success == true) {
        _lessonStatus = res1.lessonStatus;
        _completedLesson = [];
        Completedlessonresponse res =
            await LearningRepository().getCompletedLesson();

        if (res.success == true) {
          for (int i = 0; i < res.completedLessons!.length; i++) {
            _completedLesson.add(res.completedLessons![i].lesson.toString());
          }
          customLoadStop();
        }
        _markCompleteApiResponse =
            ApiResponse.completed(res1.success.toString());
        customLoadStop();
        notifyListeners();
      } else {
        _completedLesson = [];
        Completedlessonresponse res =
            await LearningRepository().getCompletedLesson();

        if (res.success == true) {
          for (int i = 0; i < res.completedLessons!.length; i++) {
            _completedLesson.add(res.completedLessons![i].lesson.toString());
          }
          customLoadStop();
        }
        customLoadStop();
        notifyListeners();
        Fluttertoast.showToast(
            msg: "Unable to mark complete start lesson again");
        _markCompleteApiResponse = ApiResponse.error(res1.success.toString());
      }
    } catch (e) {
      customLoadStop();
      print("VM CATCH ERR :: $e");
      _markCompleteApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _lessonApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get lessonApiResponse => _lessonApiResponse;

  List<LessonresponseLesson> _lessons = <LessonresponseLesson>[];
  List<LessonresponseLesson> get lessons => _lessons;

  Future<void> fetchLesson(String moduleSlug) async {
    _lessonApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Lessonresponse res =
          await LearningRepository().getLessonsAsModules(moduleSlug);
      if (res.success == true) {
        _lessons = res.lessons!;
        print(jsonEncode(_lessons));

        _lessonApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _lessonApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _lessonApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _supportTeacherApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get supportTeacherApiResponse => _supportTeacherApiResponse;
  List<Lecturer> _teacher = <Lecturer>[];
  List<Lecturer> get teacher => _teacher;

  Future<void> fetchSupportTeachers(String slug) async {
    _supportTeacherApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      SupportTicketResponse res =
          await LearningRepository().getModuleSupportTeacher(slug.toString());
      if (res.success == true) {
        _teacher = res.lecturers!;

        _supportTeacherApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _supportTeacherApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _supportTeacherApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _lessonContentApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get lessonContentApiResponse => _lessonContentApiResponse;
  Lesson _lessonContent = Lesson();
  Lesson get lessonContent => _lessonContent;

  Future<void> fetchLessonContent(String slug) async {
    _lessonContentApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Lessoncontentresponse res =
          await LearningRepository().getLessonContent(slug.toString());
      if (res.success == true) {
        _lessonContent = res.lesson!;

        _lessonContentApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _lessonContentApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _lessonContentApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _trackingApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get trackingApiResponse => _trackingApiResponse;

  bool _isComplete = false;
  bool get isComplete => _isComplete;

  dynamic _lessonStatus;
  dynamic get lessonStatus => _lessonStatus;
  Future<void> fetchLessonTrackingStatus(LessonTrackRequest datas) async {
    _trackingApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      LessonstatusResponse res =
          await LearningRepository().getLessonStatus(datas);
      if (res.success == true) {
        _lessonStatus = res.lessonStatus;
        _trackingApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _trackingApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _trackingApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _startLessonApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get startLessonApiResponse => _startLessonApiResponse;

  Future<void> startLesson(
      LessonTrackRequest datas, BuildContext context) async {
    _startLessonApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      customLoadStart();
      Startlessonresponse res = await LearningRepository().startLesson(datas);
      if (res.success == true) {
        LessonstatusResponse res2 =
            await LearningRepository().getLessonStatus(datas);

        _lessonStatus = res2.lessonStatus;
        _startLessonApiResponse = ApiResponse.completed(res.success.toString());
        customLoadStop();
        notifyListeners();
      } else {
        customLoadStop();
        _startLessonApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      customLoadStop();
      print("VM CATCH ERR :: $e");
      _startLessonApiResponse = ApiResponse.error(e.toString());
    }
    customLoadStop();

    notifyListeners();
  }

  ApiResponse _commentApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get commentApiResponse => _commentApiResponse;

  List<Comment> _comments = <Comment>[];
  List<Comment> get comments => _comments;

  int _page = 1;
  int get page => _page;

  int _totalData = 0;
  int get totalData => _totalData;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  Future<void> fetchComments(String slug) async {
    _commentApiResponse = ApiResponse.initial("Loading");
    _page = 1;
    _hasMore = true;
    notifyListeners();
    try {
      Commentresponse res =
          await LearningRepository().getComment(slug, _page.toString());
      if (res.success == true) {
        _comments = res.comments!;

        _commentApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _commentApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _commentApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _loadMoreCommentApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get loadMoreCommentApiResponse => _loadMoreCommentApiResponse;

  Future<void> loadMoreComment(String slug) async {
    if (hasMore) {
      _page += 1;
      _loadMoreCommentApiResponse = ApiResponse.initial("Loading");
      notifyListeners();
      try {
        Commentresponse res =
            await LearningRepository().getComment(slug, _page.toString());
        if (res.success == true) {
          _comments.addAll(res.comments!);
          _hasMore = res.comments!.isNotEmpty;
          _loadMoreCommentApiResponse =
              ApiResponse.completed(res.success.toString());
          notifyListeners();
        } else {
          _loadMoreCommentApiResponse =
              ApiResponse.error(res.success.toString());
        }
      } catch (e) {
        print("VM CATCH ERR :: $e");
        _loadMoreCommentApiResponse = ApiResponse.error(e.toString());
      }
      notifyListeners();
    }
  }

  ApiResponse _likeApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get likeApiResponse => _likeApiResponse;

  Future<void> like(String commentId, String slug, BuildContext context) async {
    _likeApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      customLoadStart();
      lr.Likereponse res1 = await LearningRepository().putLike(commentId);
      if (res1.success == true) {
        Commentresponse res =
            await LearningRepository().getComment(slug, _page.toString());
        _comments = res.comments!;

        _hasMore = res.comments!.isNotEmpty;
        _likeApiResponse = ApiResponse.completed(res1.success.toString());

        notifyListeners();

        customLoadStop();
        notifyListeners();
      } else {
        customLoadStop();
        _likeApiResponse = ApiResponse.error(res1.success.toString());
      }
    } catch (e) {
      customLoadStop();
      print("VM CATCH ERR :: $e");
      _likeApiResponse = ApiResponse.error(e.toString());
    }
    customLoadStop();

    notifyListeners();
  }

  ApiResponse _flagApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get flagApiResponse => _flagApiResponse;

  Future<void> flag(String commentId, String slug, BuildContext context) async {
    _flagApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      customLoadStart();
      rr.Reportreponse res1 = await LearningRepository().putReport(commentId);
      if (res1.success == true) {
        print(res1.success);
        print(jsonEncode(res1.comment));
        _flagApiResponse = ApiResponse.completed(res1.success.toString());
        Commentresponse res =
            await LearningRepository().getComment(slug, _page.toString());
        _comments = res.comments!;

        _hasMore = res.comments!.isNotEmpty;

        notifyListeners();

        customLoadStop();
        notifyListeners();
      } else {
        customLoadStop();
        _flagApiResponse = ApiResponse.error(res1.success.toString());
      }
    } catch (e) {
      customLoadStop();
      print("VM CATCH ERR :: $e");
      _flagApiResponse = ApiResponse.error(e.toString());
    }
    customLoadStop();

    notifyListeners();
  }

  ApiResponse _replyApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get replyApiResponse => _replyApiResponse;

  Future<void> reply(Commentrequest datas, String commentId, String slug,
      BuildContext context) async {
    _replyApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      customLoadStart();
      crs.Commentreplyresponse res1 =
          await LearningRepository().reply(datas, commentId);
      if (res1.success == true) {
        _replyApiResponse = ApiResponse.completed(res1.success.toString());
        Commentresponse res =
            await LearningRepository().getComment(slug, _page.toString());
        _comments = res.comments!;

        _hasMore = res.comments!.isNotEmpty;

        notifyListeners();

        customLoadStop();
        notifyListeners();
      } else {
        customLoadStop();
        _replyApiResponse = ApiResponse.error(res1.success.toString());
      }
    } catch (e) {
      customLoadStop();
      print("VM CATCH ERR :: $e");
      _replyApiResponse = ApiResponse.error(e.toString());
    }
    customLoadStop();

    notifyListeners();
  }

  ApiResponse _postCommentApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get postCommentApiResponse => _postCommentApiResponse;

  Future<void> comment(
      Commentrequest datas, String slug, BuildContext context) async {
    _postCommentApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      customLoadStart();
      pcr.Postcommentresponse res1 =
          await LearningRepository().comment(slug, datas);
      if (res1.success == true) {
        _postCommentApiResponse =
            ApiResponse.completed(res1.success.toString());
        _page = 1;
        Commentresponse res =
            await LearningRepository().getComment(slug, _page.toString());
        _comments = res.comments!;

        _hasMore = res.comments!.isNotEmpty;

        notifyListeners();

        customLoadStop();
        notifyListeners();
      } else {
        customLoadStop();
        _postCommentApiResponse = ApiResponse.error(res1.success.toString());
      }
    } catch (e) {
      customLoadStop();
      print("VM CATCH ERR :: $e");
      _postCommentApiResponse = ApiResponse.error(e.toString());
    }
    customLoadStop();

    notifyListeners();
  }

  ApiResponse _ratingApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get ratingApiResponse => _ratingApiResponse;
  dynamic _rating;
  dynamic get rating => _rating;

  Future<void> fetchRatings(
    String slug,
  ) async {
    _ratingApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      LessonratingResponse res = await LearningRepository().getRating(slug);
      print(res.rating);
      if (res.success == true) {
        if (res.rating == 0) {
          _rating = 0;
        } else {
          _rating = res.rating['rating'];
        }

        // _rating = res.
        _ratingApiResponse = ApiResponse.completed(res.success.toString());

        notifyListeners();
      } else {
        _ratingApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _ratingApiResponse = ApiResponse.error(e.toString());
    }

    notifyListeners();
  }

  ApiResponse _activityPercentApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get activityPercentApiResponse => _activityPercentApiResponse;
  List<ar.Complete> _completed = <ar.Complete>[];
  List<ar.Complete> get completed => _completed;
  List<ar.Complete> _incomplete = <ar.Complete>[];
  List<ar.Complete> get incomplete => _incomplete;

  dynamic _percentage;
  dynamic get percentage => _percentage;

  Future<void> getTaskCompletedPercentage(
      String username, String moduleSlug) async {
    _activityPercentApiResponse = ApiResponse.initial("Empty Data");

    notifyListeners();
    try {
      ar.Activityresponse res =
          await ActivityRepository().getActivity(username);
      if (res.success == true) {
        for (int i = 0; i < res.complete!.length; i++) {
          if (res.complete![i].module?.moduleSlug.toString() == moduleSlug) {
            _completed.add(res.complete![i]);
          }
        }

        for (int i = 0; i < res.incomplete!.length; i++) {
          if (res.incomplete![i].module?.moduleSlug.toString() == moduleSlug) {
            _incomplete.add(res.complete![i]);
          }
        }

        if (_completed.isEmpty && _incomplete.isEmpty) {
          _percentage = 0;
        } else {
          _percentage = (_completed.length /
              (_completed.length + _incomplete.length) *
              100);
        }

        print(username);
        print(moduleSlug);
        print(_percentage);
        _activityPercentApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _activityPercentApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      _activityPercentApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _learningFilterApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get learningFilterApiResponse => _learningFilterApiResponse;
  List<String> _filters = <String>[];
  List<String> get filters => _filters;

  Future<void> fetchLearningFilters() async {
    _learningFilterApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      LearningFilterResponse res =
          await LearningRepository().getLearningFilters();
      if (res.success == true) {
        _filters = res.years!;

        _learningFilterApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _learningFilterApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _learningFilterApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _attendanceProgressApiResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get attendanceProgressApiResponse =>
      _attendanceProgressApiResponse;
  AttendanceProgressResponse _attendanceProgress = AttendanceProgressResponse();
  AttendanceProgressResponse get attendanceProgress => _attendanceProgress;

  Future<void> fetchAttendanceProgress(String slug) async {
    _attendanceProgressApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      AttendanceProgressResponse res =
          await LearningRepository().getAttendanceFilter(slug);
      if (res.success == true) {
        _attendanceProgress = res;

        _attendanceProgressApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _attendanceProgressApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _attendanceProgressApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _myStudyMaterialResponse = ApiResponse.initial("Empty Data");
  ApiResponse get myStudyMaterialApiResponse => _myStudyMaterialResponse;
  StudentStudyMaterialResponse _myStudyMaterial =
      StudentStudyMaterialResponse();
  StudentStudyMaterialResponse get myStudyMaterial => _myStudyMaterial;

  Future<void> fetchMyStudyMaterial(String moduleSlug) async {
    _myStudyMaterialResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      StudentStudyMaterialResponse res =
          await MyLearningRepository().getMyStudyMaterial(moduleSlug);
      print(jsonEncode(res));
      if (res.success == true) {
        _myStudyMaterial = res;

        _myStudyMaterialResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _myStudyMaterialResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _myStudyMaterialResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _lessonProgressApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get lessonProgressApiResponse => _lessonProgressApiResponse;
  LessonProgressResponse _lessonProgress = LessonProgressResponse();
  LessonProgressResponse get lessonProgress => _lessonProgress;

  int _totalProgressProgress = 0;
  int get totalProgressProgress => _totalProgressProgress;

  Future<void> fetchLessonProgress(String slug) async {
    _lessonProgressApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      LessonProgressResponse res =
          await LearningRepository().getWeeklyProgress(slug);

      if (res.success == true) {
        _lessonProgress = res;

        print("ASSIGNMENT::::");

        if (_lessonProgress.progress != null &&
            _lessonProgress.progress!.isNotEmpty) {
          var totalLesson = 0;
          var totalCompletedLessonCount = 0;
          for (var i = 0; i < _lessonProgress.progress!.length; i++) {
            totalLesson += _lessonProgress.progress![i].totalLessons!.toInt();
            totalCompletedLessonCount +=
                _lessonProgress.progress![i].completedLessonCount!.toInt();
          }
          _totalProgressProgress =
              (totalCompletedLessonCount / totalLesson * 100).toInt();
        }

        _lessonProgressApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _lessonProgressApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERRe555 :: $e");
      _lessonProgressApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _weekCategoryApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get weekCategoryApiResponse => _weekCategoryApiResponse;
  List<Category> _weekCategory = <Category>[];
  List<Category> get weekCategory => _weekCategory;

  Future<void> fetchLessonWeekCategory(String moduleSlug) async {
    _weekCategoryApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      LessonWeekCategoryResponse res =
          await LearningRepository().getLessonWeekCategory(moduleSlug);
      if (res.success == true) {
        _weekCategory = res.categories!;

        _weekCategoryApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _weekCategoryApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _weekCategoryApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _syllabusBatchModuleStatusResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get syllabusBatchModuleStatusApiResponse =>
      _syllabusBatchModuleStatusResponse;
  SyllabusBatchModuleStatusResponse _syllabusBatchModuleStatus =
      SyllabusBatchModuleStatusResponse();
  SyllabusBatchModuleStatusResponse get syllabusBatchModuleStatus =>
      _syllabusBatchModuleStatus;

  Future<void> fetchSyllabusBatchModuleStatus(params) async {
    _syllabusBatchModuleStatusResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      SyllabusBatchModuleStatusResponse res =
          await MyLearningRepository().getSyllabusBatchModuleStatus(params);
      print(jsonEncode(res.syllabus));
      if (res.success == true) {
        _syllabusBatchModuleStatus = res;

        _syllabusBatchModuleStatusResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _syllabusBatchModuleStatusResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _syllabusBatchModuleStatusResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
