import 'dart:convert';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/lesson_progress_response.dart';
import 'package:schoolworkspro_app/response/postcomment_response.dart';
import 'package:schoolworkspro_app/response/slide_response.dart';

import '../../request/comment_request.dart';
import '../../request/lessontrack_request.dart';
import '../../response/attendance_progress_response.dart';
import '../../response/comment_response.dart';
import '../../response/commentreply_response.dart';
import '../../response/completed_response.dart';
import '../../response/learning_filter_response.dart';
import '../../response/lesson_response.dart';
import '../../response/lesson_week_category_response.dart';
import '../../response/lessoncontent_response.dart';
import '../../response/lessonrating_response.dart';
import '../../response/lessonstatus_response.dart';
import '../../response/like_response.dart';
import '../../response/markascompleteresponse.dart';
import '../../response/particularassessment_response.dart';
import '../../response/particularmoduleresponse.dart';
import '../../response/rating_response.dart';
import '../../response/report_response.dart';
import '../../response/startlesson_response.dart';
import '../../response/support_ticket_response.dart';
import '../endpoints.dart';

class LearningRepository {
  API api = API();
  Future<Particularmoduleresponse> getParticularModule(
      String moduleSlug) async {
    dynamic response;
    Particularmoduleresponse res;
    try {
      response = await api.postDataWithToken(
          jsonEncode({}), Endpoints.modules + moduleSlug);

      res = Particularmoduleresponse.fromJson(response);
    } catch (e) {
      print(e.toString());

      res = Particularmoduleresponse.fromJson(response);
      print(res.toJson().toString());
    }
    return res;
  }

  Future<SupportTicketResponse> getModuleSupportTeacher(
      String moduleSlug) async {
    dynamic response;
    SupportTicketResponse res;
    try {
      response = await api.getWithToken(Endpoints.supportTeacher + moduleSlug);

      res = SupportTicketResponse.fromJson(response);
    } catch (e) {
      print(e.toString());

      res = SupportTicketResponse.fromJson(response);
      print(res.toJson().toString());
    }
    return res;
  }

  Future<LearningFilterResponse> getLearningFilters() async {
    dynamic response;
    LearningFilterResponse res;
    try {
      response = await api.getWithToken(Endpoints.filters);

      res = LearningFilterResponse.fromJson(response);
    } catch (e) {
      print(e.toString());

      res = LearningFilterResponse.fromJson(response);
      print(res.toJson().toString());
    }
    return res;
  }

  Future<AttendanceProgressResponse> getAttendanceFilter(String slug) async {
    dynamic response;
    AttendanceProgressResponse res;
    try {
      response = await api.getWithToken(Endpoints.attendanceProgress+slug);

      res = AttendanceProgressResponse.fromJson(response);
    } catch (e) {
      print(e.toString());

      res = AttendanceProgressResponse.fromJson(response);
      print(res.toJson().toString());
    }
    return res;
  }

  Future<Ratingresponse> getAverageRating(String moduleSlug) async {
    dynamic response;
    Ratingresponse res;
    try {
      response =
          await api.getWithToken(Endpoints.moduleAverageRating + moduleSlug);

      res = Ratingresponse.fromJson(response);
    } catch (e) {
      print(e.toString());

      res = Ratingresponse.fromJson(response);
      print(res.toJson().toString());
    }
    return res;
  }

  Future<Completedlessonresponse> getCompletedLesson() async {
    dynamic response;
    Completedlessonresponse res;
    try {
      response = await api.getWithToken(Endpoints.completedLessons);

      res = Completedlessonresponse.fromJson(response);
    } catch (e) {
      print(e.toString());

      res = Completedlessonresponse.fromJson(response);
      print(res.toJson().toString());
    }
    return res;
  }

  Future<Lessonresponse> getLessonsAsModules(String moduleSlug) async {
    dynamic response;
    Lessonresponse res;
    try {
      response = await api.getWithToken(
          "${Endpoints.lessonsForModules}$moduleSlug/weekly/public");

      res = Lessonresponse.fromJson(response);
    } catch (e) {
      print(e.toString());

      res = Lessonresponse.fromJson(response);
      print(res.toJson().toString());
    }
    return res;
  }

  Future<Lessoncontentresponse> getLessonContent(String lessonSlug) async {
    dynamic response;
    Lessoncontentresponse res;
    try {
      response =
          await api.getWithToken("${Endpoints.lessonsContent}$lessonSlug");

      res = Lessoncontentresponse.fromJson(response);
    } catch (e) {
      print(e.toString());

      res = Lessoncontentresponse.fromJson(response);
      print(res.toJson().toString());
    }
    return res;
  }

  Future<LessonstatusResponse> getLessonStatus(LessonTrackRequest datas) async {
    dynamic response;
    LessonstatusResponse res;
    try {
      response = await api.postDataWithToken(
          jsonEncode(datas), Endpoints.trackLessonStatus);

      res = LessonstatusResponse.fromJson(response);
    } catch (e) {
      res = LessonstatusResponse.fromJson(response);
    }
    return res;
  }

  Future<Startlessonresponse> startLesson(LessonTrackRequest datas) async {
    dynamic response;
    Startlessonresponse res;
    try {
      response =
          await api.postDataWithToken(jsonEncode(datas), Endpoints.startLesson);

      res = Startlessonresponse.fromJson(response);
    } catch (e) {
      res = Startlessonresponse.fromJson(response);
    }
    return res;
  }

  Future<Particularassessmentresponse> getParticularAssessment(
      String slug) async {
    dynamic response;
    Particularassessmentresponse res;
    try {
      response = await api.getWithToken(Endpoints.assessmentOfLesson + slug);

      res = Particularassessmentresponse.fromJson(response);
    } catch (e) {
      res = Particularassessmentresponse.fromJson(response);
    }
    return res;
  }

  Future<Commentresponse> getComment(String slug, String page) async {
    dynamic response;
    Commentresponse res;
    try {
      response =
          await api.getWithToken("${Endpoints.comments}$slug/comments/$page");

      res = Commentresponse.fromJson(response);
    } catch (e) {
      res = Commentresponse.fromJson(response);
    }
    return res;
  }

  Future<Likereponse> putLike(String commentId) async {
    dynamic response;
    Likereponse res;
    try {
      response = await api.putWithToken("${Endpoints.comments}$commentId/like");

      res = Likereponse.fromJson(response);
    } catch (e) {
      res = Likereponse.fromJson(response);
    }
    return res;
  }

  Future<Reportreponse> putReport(String commentId) async {
    dynamic response;
    Reportreponse res;
    try {
      response =
          await api.putWithToken("${Endpoints.comments}$commentId/report");

      res = Reportreponse.fromJson(response);
    } catch (e) {
      res = Reportreponse.fromJson(response);
    }
    return res;
  }

  Future<Commentreplyresponse> reply(
      Commentrequest datas, String commentId) async {
    dynamic response;
    Commentreplyresponse res;
    try {
      response = await api.postDataWithToken(
          jsonEncode(datas), "${Endpoints.comments}$commentId/reply");

      res = Commentreplyresponse.fromJson(response);
    } catch (e) {
      res = Commentreplyresponse.fromJson(response);
    }
    return res;
  }

  Future<Postcommentresponse> comment(
      String lessonSlug, Commentrequest datas) async {
    dynamic response;
    Postcommentresponse res;
    try {
      response = await api.postDataWithToken(
          jsonEncode(datas), "${Endpoints.comments}$lessonSlug/comment");

      res = Postcommentresponse.fromJson(response);
    } catch (e) {
      res = Postcommentresponse.fromJson(response);
    }
    return res;
  }

  Future<LessonratingResponse> getRating(String lessonSlug) async {
    dynamic response;
    LessonratingResponse res;
    try {
      response = await api.getWithToken("/lessonRating/my-rating/$lessonSlug");

      res = LessonratingResponse.fromJson(response);
    } catch (e) {
      res = LessonratingResponse.fromJson(response);
    }
    return res;
  }

  Future<Markascompleteresponse> markComplete(
      LessonTrackRequest lessonrequest) async {
    dynamic response;
    Markascompleteresponse res;
    try {
      response = await api.postDataWithToken(
          jsonEncode(lessonrequest), "/tracking/mark-as-complete");

      res = Markascompleteresponse.fromJson(response);
    } catch (e) {
      res = Markascompleteresponse.fromJson(response);
    }
    return res;
  }

  Future<SlideResponse> getSlides(String slug) async {
    dynamic response;
    SlideResponse res;
    try {
      response = await api.getWithToken(Endpoints.getSlides + slug);

      res = SlideResponse.fromJson(response);
    } catch (e) {
      res = SlideResponse.fromJson(response);
    }
    return res;
  }

  Future<LessonProgressResponse> getWeeklyProgress(String slug) async {
    dynamic response;
    LessonProgressResponse res;
    try {
      response = await api.getWithToken(Endpoints.lessonProgress +slug);

      res = LessonProgressResponse.fromJson(response);
    } catch (e) {
      print(e.toString());

      res = LessonProgressResponse.fromJson(response);
      print(res.toJson().toString());
    }
    return res;
  }

  Future<LessonWeekCategoryResponse> getLessonWeekCategory(String moduleSlug) async {
    dynamic response;
    LessonWeekCategoryResponse res;
    try {
      response = await api.getWithToken("/weeks/$moduleSlug");

      res = LessonWeekCategoryResponse.fromJson(response);
    } catch (e) {
      print(e.toString());

      res = LessonWeekCategoryResponse.fromJson(response);
      print(res.toJson().toString());
    }
    return res;
  }
}
