import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/api/endpoints.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/lecturer/draftlessoncontent_response.dart';
import 'package:schoolworkspro_app/response/lecturer/senddraft_response.dart';
import 'package:schoolworkspro_app/response/lesson_response.dart';
import 'package:schoolworkspro_app/response/lessoncontent_response.dart';

import '../../../response/lecturer/batch_lesson_progress_response.dart';
import '../../../response/lecturer/lecturer_course_with_module_response.dart';
import '../../../response/lesson_progress_response.dart';
import '../../../response/routine_preference_response.dart';

class LessonRepository {
  API api = API();
  Future<Lessonresponse> geLessons(String moduleSlug) async {
    dynamic response;
    Lessonresponse res;
    try {
      response = await api.getWithToken('/lessons/$moduleSlug/weekly/public');

      res = Lessonresponse.fromJson(response);
    } catch (e) {
      res = Lessonresponse.fromJson(response);
    }
    return res;
  }

  Future<SendDraftResponse> senddrafts(String lessonSlug, data) async {
    dynamic response;
    SendDraftResponse res;
    try {
      response =
          await api.putDataWithToken(jsonEncode(data), '/lessons/$lessonSlug');

      res = SendDraftResponse.fromJson(response);
    } catch (e) {
      res = SendDraftResponse.fromJson(response);
    }
    return res;
  }

  Future<DraftContentResponse> getdrafts(String slug) async {
    dynamic response;
    DraftContentResponse res;
    try {
      response = await api.getWithToken('/lessons/$slug/weekly/private');

      res = DraftContentResponse.fromJson(response);
    } catch (e) {
      res = DraftContentResponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> deletelesson(String slug) async {
    dynamic response;
    Commonresponse res;
    try {
      response = await api.deleteWithToken('/lessons/$slug');

      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<Lessoncontentresponse> getLessonContent(String slug) async {
    dynamic response;
    Lessoncontentresponse res;
    try {
      response = await api.getWithToken('lessons/$slug');

      res = Lessoncontentresponse.fromJson(response);
    } catch (e) {
      res = Lessoncontentresponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> lessonProgress(data) async {
    dynamic response;
    Commonresponse res;
    try {
      response = await api.postDataWithToken(
          jsonEncode(data), '/syllabus/mark-lesson-complete');

      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<BatchLessonProgress> getLessonProgress(data) async {
    dynamic response;
    BatchLessonProgress res;
    try {
      response = await api.postDataWithToken(
          jsonEncode(data), '/syllabus/batch-lesson-status');
      print(response);

      res = BatchLessonProgress.fromJson(response);
    } catch (e) {
      res = BatchLessonProgress.fromJson(response);
    }
    return res;
  }

  Future<LecturerCourseWithModuleResponse> geCourseWithModule(String email) async {
    dynamic response;
    LecturerCourseWithModuleResponse res;
    try {
      response = await api
          .postDataWithToken(jsonEncode({'email': email}), '/lecturers/module-with-course');

      res = LecturerCourseWithModuleResponse.fromJson(response);
    } catch (e) {
      res = LecturerCourseWithModuleResponse.fromJson(response);
    }
    return res;
  }

  Future<RoutinePreferenceResponse> getRoutinePreference() async {
    API api = new API();
    dynamic response;
    RoutinePreferenceResponse res;
    try {
      response = await api.getWithToken('/preference/refresh-time');

      res = RoutinePreferenceResponse.fromJson(response);
    } catch (e) {
      res = RoutinePreferenceResponse.fromJson(response);
    }
    return res;
  }
}
