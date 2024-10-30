import 'dart:convert';
import 'dart:developer';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/lecturer/studentgrading_request.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getgradesheading_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getstudentformarking_response.dart';
import 'package:schoolworkspro_app/response/lecturer/updategrade_response.dart';
import 'package:schoolworkspro_app/response/lecturer/view_grades_response.dart';

class GradeRepository {
  API api = API();
  Future<Commonresponse> addHeadings(data) async {
    API api = new API();
    dynamic response;
    Commonresponse res;
    try {
      response = await api.postDataWithToken(jsonEncode(data), '/marksHeading');

      res = Commonresponse.fromJson(response);
    } catch (e) {
      print("REPO CATCH ERR :: " + e.toString());

      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<GetGradesHeadingResponse> getHeadings(moduleSlug) async {
    API api = new API();
    dynamic response;
    GetGradesHeadingResponse res;
    try {
      response = await api.getWithToken('/marksHeading/active/$moduleSlug');

      res = GetGradesHeadingResponse.fromJson(response);
    } catch (e) {
      res = GetGradesHeadingResponse.fromJson(response);
    }
    return res;
  }

  Future<GetGradesHeadingResponse> getMarksHeadings(
      moduleSlug, batchSlug, examType, String institution) async {
    API api = new API();
    dynamic response;
    GetGradesHeadingResponse res;
    try {
      if (institution == "soft") {
        response =
            // /marksHeading/S1-s2-C34A/cyber-security-foundation
            await api.getWithToken('/marksHeading/$batchSlug/$moduleSlug');
      } else {
        response = await api.getWithToken(
            '/marksHeading/$batchSlug/$moduleSlug?exam=$examType');
      }

      res = GetGradesHeadingResponse.fromJson(response);
    } catch (e) {
      res = GetGradesHeadingResponse.fromJson(response);
    }
    return res;
  }

  Future<UpdateGradeResponse> deleteheading(id) async {
    API api = API();
    dynamic response;
    UpdateGradeResponse res;
    try {
      response = await api.deleteWithToken('/marksHeading/$id');

      res = UpdateGradeResponse.fromJson(response);
    } catch (e) {
      res = UpdateGradeResponse.fromJson(response);
    }
    return res;
  }

  Future<UpdateGradeResponse> editHeading(data, id) async {
    API api = new API();
    dynamic response;
    UpdateGradeResponse res;
    try {
      response =
          await api.putDataWithToken(jsonEncode(data), '/marksHeading/$id');

      res = UpdateGradeResponse.fromJson(response);
    } catch (e) {
      res = UpdateGradeResponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> addSecondaryMarker(data, id) async {
    API api = new API();
    dynamic response;
    Commonresponse res;
    try {
      response = await api.putDataWithToken(
          jsonEncode(data), '/marksHeading/update-secondary-marker/$id');

      res = Commonresponse.fromJson(response);
    } catch (e) {
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> addStudentGrade(StudentGradingRequest data) async {
    API api = new API();
    dynamic response;
    Commonresponse res;
    try {
      print("DATAA:::: ${jsonEncode(data)}");
      response =
          await api.postDataWithToken(jsonEncode(data), '/marks/add-new');
      res = Commonresponse.fromJson(response);

      print(
          "RESPONSE AddGRADE :::: ${Commonresponse.fromJson(response).toJson()}");
    } catch (e) {
      print("ERRROOOORRR :::: ${e.toString()}");
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> updateSoftStudentGrade(dynamic data, String id) async {
    API api = new API();
    dynamic response;
    Commonresponse res;
    try {
      print("DATAA:::: ${jsonEncode(data)}");
      response =
      await api.putDataWithToken(jsonEncode(data), '/marks/$id');
      res = Commonresponse.fromJson(response);

      print(
          "RESPONSE AddGRADE :::: ${Commonresponse.fromJson(response).toJson()}");
    } catch (e) {
      print("ERRROOOORRR :::: ${e.toString()}");
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<GetStudentForMarkingResponse> getStudentsformarking(batch) async {
    API api = API();
    dynamic response;
    GetStudentForMarkingResponse res;
    try {
      response = await api.getWithToken('/batch/$batch/student');

      res = GetStudentForMarkingResponse.fromJson(response);
    } catch (e) {
      print(e.toString());
      res = GetStudentForMarkingResponse.fromJson(response);
    }
    return res;
  }

  Future<ViewGradesResponse> getviewStudentGrade(
      moduleSlug, batch, examSlug, String institution) async {
    API api = API();
    dynamic response;
    ViewGradesResponse res;
    try {
      if (institution == "soft") {
        // m/marks/cyber-security-foundation/S1-s2-C34A
        response = await api.getWithToken('/marks/$moduleSlug/$batch');
      } else {
        response =
            await api.getWithToken('/marks/$moduleSlug/$batch/$examSlug');
      }

      print(response.toString());

      res = ViewGradesResponse.fromJson(response);
    } catch (e) {
      print(e.toString());
      res = ViewGradesResponse.fromJson(response);
    }
    return res;
  }
}
