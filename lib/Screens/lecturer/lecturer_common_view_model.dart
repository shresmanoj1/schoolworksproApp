import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api_response.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/assessment_repository.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/lesson_repository.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/markcomplete_repository.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/modules_repository.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/report_repo.dart';
import 'package:schoolworkspro_app/response/lecturer/draftlessoncontent_response.dart';
import 'package:schoolworkspro_app/response/lecturer/insideactivity_response.dart';
import 'package:schoolworkspro_app/response/lecturer/lecturercheckprogress_response.dart';
import 'package:schoolworkspro_app/response/lecturer/lecturermoduledetail_response.dart';
import 'package:schoolworkspro_app/response/lecturer/lecturerstudentreport_response.dart';
import 'package:schoolworkspro_app/response/lecturer/submissionstats_response.dart';
import 'package:schoolworkspro_app/response/lesson_progress_response.dart';
import 'package:schoolworkspro_app/response/lesson_response.dart';
import 'package:schoolworkspro_app/response/lessoncontent_response.dart';

import '../../response/lecturer/assessmentstats_response.dart';
import '../../response/lecturer/batch_lesson_progress_response.dart';
import '../../response/lecturer/lecturer_course_with_module_response.dart';
import '../../response/routine_preference_response.dart';
import '../../response/submission_check_respose.dart';

class LecturerCommonViewModel extends ChangeNotifier {
  ApiResponse _modulesApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get modulesApiResponse => _modulesApiResponse;
  dynamic _modules;
  dynamic get modules => _modules;

  Future<void> fetchModuleDetails(data) async {
    _modulesApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      LecturerModuleDetailResponse res =
          await ModuleRepository().getModuleDetails(data);
      if (res.success == true) {
        _modules = res.module;
        // _noticeCount = res.notifications!.length;
        _modulesApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _modulesApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _modulesApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _resourcesApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get resourcesApiResponse => _resourcesApiResponse;
  List<LessonresponseLesson> _lessons = <LessonresponseLesson>[];
  List<LessonresponseLesson> get lessons => _lessons;
  String _slug = "";
  String get slug => _slug;

  setSlug(String module_slug) {
    _slug = module_slug;
    notifyListeners();
  }

  Future<void> fetchlessons() async {
    _resourcesApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Lessonresponse res = await LessonRepository().geLessons(_slug);
      if (res.success == true) {
        _lessons = res.lessons!;
        _resourcesApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _modulesApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _resourcesApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _assessmentStatsApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get assessmentStatsApiResponse => _assessmentStatsApiResponse;
  List<AssessmentStatsResponseAssessment> _assessmentWeeks =
      <AssessmentStatsResponseAssessment>[];
  List<AssessmentStatsResponseAssessment> get assessmentWeeks =>
      _assessmentWeeks;

  Future<void> fetchAssessmentStats(data) async {
    _assessmentStatsApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      AssessmentStatsResponse res =
          await AssessmentStatsRepository().getassessmentStats(data);
      if (res.success == true) {
        _assessmentWeeks = res.assessments!;
        // _noticeCount = res.notifications!.length;
        _assessmentStatsApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _assessmentStatsApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _assessmentStatsApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _submissionStatsApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get submissionStatsApiResponse => _submissionStatsApiResponse;
  List<SubmissionElement> _submission = <SubmissionElement>[];
  List<SubmissionElement> get submission => _submission;

  Future<void> fetchsubmissionstats(String id, String batch) async {
    _submissionStatsApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      SubmissionStatsResponse res =
          await AssessmentStatsRepository().getSubmissionstats(id, batch);
      if (res.success == true) {
        _submission = res.submission!;
        // _noticeCount = res.notifications!.length;
        _submissionStatsApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _submissionStatsApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR SUBMISSION :: " + e.toString());
      _submissionStatsApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _submissionCheckApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get submissionCheckApiResponse => _submissionCheckApiResponse;
  SubmissionCheckResponse _submissionCheck = SubmissionCheckResponse();
  SubmissionCheckResponse get submissionCheck => _submissionCheck;

  Future<void> fetchSubmissionCheck(String id, String batch) async {
    _submissionCheckApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      SubmissionCheckResponse res = await AssessmentStatsRepository()
          .getSubmissionCheckStudent(id, batch);
      if (res.success == true) {
        _submissionCheck = res;
        _submissionCheckApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _submissionCheckApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _submissionCheckApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _checkprogressApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get checkprogressApiResponse => _checkprogressApiResponse;
  List<Progress> _progress = <Progress>[];
  List<Progress> get progress => _progress;

  List<String> _weeks = <String>[];
  List<String> get weeks => _weeks;

  Future<void> checkprogress(String moduleSlug) async {
    _checkprogressApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      LecturerCheckProgressResponse res =
          await MarkCompleteRepository().checkprogress(moduleSlug);
      if (res.success == true) {
        _progress = res.progress!;
        _weeks = res.weeks!;
        // _noticeCount = res.notifications!.length;
        _checkprogressApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _checkprogressApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _submissionStatsApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _draftContentApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get draftContentApiResponse => _draftContentApiResponse;
  List<DraftContentResponseLesson> _drafts = <DraftContentResponseLesson>[];
  List<DraftContentResponseLesson> get drafts => _drafts;

  Future<void> fetchdraftcontent() async {
    _draftContentApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      DraftContentResponse res = await LessonRepository().getdrafts(_slug);
      if (res.success == true) {
        _drafts = res.lessons!;
        // _noticeCount = res.notifications!.length;
        _draftContentApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _draftContentApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _draftContentApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _lessoncontentApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get lessoncontentApiResponse => _lessoncontentApiResponse;
  Lesson _lessoncontent = new Lesson();
  Lesson get lessoncontent => _lessoncontent;

  Future<void> fetchLessoncontent(String lesson_slug) async {
    _lessoncontentApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Lessoncontentresponse res =
          await LessonRepository().getLessonContent(lesson_slug);
      if (res.success == true) {
        _lessoncontent = res.lesson!;
        // _noticeCount = res.notifications!.length;
        _lessoncontentApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _lessoncontentApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _lessoncontentApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _insidelessonactivityApiResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get insidelessonactivityApiResponse =>
      _insidelessonactivityApiResponse;
  List<dynamic> _insideActivity = <dynamic>[];
  List<dynamic> get insideActivity => _insideActivity;

  Future<void> fetchinsideactivity(lessonSlug) async {
    _insidelessonactivityApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      InsideActivityResponse res =
          await AssessmentStatsRepository().getinsideactivity(lessonSlug);
      if (res.success == true) {
        _insideActivity = res.assessment!;
        // _noticeCount = res.notifications!.length;
        _insidelessonactivityApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _insidelessonactivityApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _insidelessonactivityApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _studentreportactivityApiResponse =
      ApiResponse.initial("Empty Data");
  ApiResponse get studentreportactivityApiResponse =>
      _studentreportactivityApiResponse;
  List<LessonStatus> _lessonStatus = <LessonStatus>[];
  List<LessonStatus> get lessonStatus => _lessonStatus;

  Future<void> fetchStudentReport(data, slug) async {
    _studentreportactivityApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      LecturerStudentReportResponse res =
          await ReportRepo().getStudentReport(data, slug);
      if (res.success == true) {
        _lessonStatus = res.lessonStatus!;
        _studentreportactivityApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _studentreportactivityApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      _studentreportactivityApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _lessonProgressApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get lessonProgressApiResponse => _lessonProgressApiResponse;
  BatchLessonProgress _lessonProgress = BatchLessonProgress();
  BatchLessonProgress get lessonProgress => _lessonProgress;

  Future<void> fetchLessonProgress(data) async {
    _lessonProgressApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      BatchLessonProgress res =
          await LessonRepository().getLessonProgress(data);
      if (res.success == true) {
        _lessonProgress = res;
        _lessonProgressApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _lessonProgress = BatchLessonProgress();
        _lessonProgressApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _lessonProgressApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  bool checkShowDigitalDiary = false;
  bool get getShowDigitalDiary => checkShowDigitalDiary;

  int tabIndex = 6;
  int get getTabIndex => tabIndex;

  String institutionName = "";
  String get getInstitutionName => institutionName;

  void setShowDigitalDiary(String value, String name) {
    if (value == "School") {
      checkShowDigitalDiary = true;
      institutionName = value;
      tabIndex = 7;
    } else {
      checkShowDigitalDiary = false;
      institutionName = name;
      tabIndex = (name.toLowerCase() == "softwarica") ? 7 : 6;
    }
    notifyListeners();
  }

  int _navigatoinIndex = 0;
  int get navigatoinIndex => _navigatoinIndex;

  PageController _pagecontroller = PageController();
  PageController get pagecontroller => _pagecontroller;
  setNavigationIndex(int index) {
    _navigatoinIndex = index;
    notifyListeners();
  }

  setInitial(int index) {
    _pagecontroller = PageController(initialPage: index);
    setNavigationIndex(index);
    notifyListeners();
  }

  itemTapped(int index) {
    setNavigationIndex(index);
    _pagecontroller.jumpToPage(index);
    notifyListeners();
  }

  ApiResponse _courseWithModuleApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get courseWithModuleApiResponse => _courseWithModuleApiResponse;
  LecturerCourseWithModuleResponse _courseWithModule =
      LecturerCourseWithModuleResponse();
  LecturerCourseWithModuleResponse get courseWithModule => _courseWithModule;

  // void setCourseWithModuleForDisplay(){
  //   listCourseWithModule.where((list) {
  //     var itemName =
  //     _listCourseWithModule..toLowerCase();
  //     return itemName.contains(text);
  //   }).toList()
  // }

  Future<void> fetchCourseWithModules(String email) async {
    _courseWithModuleApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      LecturerCourseWithModuleResponse res =
          await LessonRepository().geCourseWithModule(email);
      if (res.success == true) {
        _courseWithModule = res;
        _courseWithModuleApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _modulesApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: $e");
      _courseWithModuleApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _routinePreferenceApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get routinePreferenceApiResponse => _routinePreferenceApiResponse;
  RoutinePreferenceResponse _routinePreference = RoutinePreferenceResponse();
  RoutinePreferenceResponse get routinePreference => _routinePreference;

  Future<void> fetchRoutinePreference() async {
    _routinePreferenceApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      RoutinePreferenceResponse res = await LessonRepository().getRoutinePreference();
      if (res.success == true) {
        _routinePreference = res;

        _routinePreferenceApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _routinePreferenceApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _routinePreferenceApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
