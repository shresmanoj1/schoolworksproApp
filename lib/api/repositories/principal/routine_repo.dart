import 'dart:convert';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/allclassroom_response.dart';
import 'package:schoolworkspro_app/response/alllecturer_response.dart';
import 'package:schoolworkspro_app/response/principal/filter_routine_response.dart';
import 'package:schoolworkspro_app/response/routineforprincipal_response.dart';

import '../../../response/common_response.dart';
import '../../../response/principal/available_lecturer_routine_response.dart';

class RoutineRepository {
  Future<GetAllLecturerResponse> getallteacher() async {
    API api = API();
    dynamic response;
    GetAllLecturerResponse res;
    try {
      response = await api.getWithToken('/lecturers');

      res = GetAllLecturerResponse.fromJson(response);
    } catch (e) {
      res = GetAllLecturerResponse.fromJson(response);
    }
    return res;
  }

  Future<GetAllClassRoomResponse> getallclassroom(data) async {
    API api = API();
    dynamic response;
    GetAllClassRoomResponse res;
    try {
      response = await api.postDataWithToken(
          jsonEncode(data), '/routines/all-classrooms');

      res = GetAllClassRoomResponse.fromJson(response);
    } catch (e) {
      print(e.toString());
      res = GetAllClassRoomResponse.fromJson(response);
    }
    return res;
  }

  Future<RoutineForPrincipalStats> getallroutine(params) async {
    API api = API();
    dynamic response;
    RoutineForPrincipalStats res;
    try {
      response = await api.getWithToken('/routines/$params');

      res = RoutineForPrincipalStats.fromJson(response);
    } catch (e) {
      print(e.toString());
      res = RoutineForPrincipalStats.fromJson(response);
    }
    return res;
  }

  Future<FilterRoutineResponse> getFilterRoutine(String batch, String lecturer, String classroom, String institution) async {
    API api = API();
    dynamic response;
    FilterRoutineResponse res;
    try {
      response = await api.getWithToken('/routines/get-filter?institution=$institution&lecturer=$lecturer&batch=$batch&classroom=$classroom');

      res = FilterRoutineResponse.fromJson(response);

    } catch (e) {
      print(e.toString());
      res = FilterRoutineResponse.fromJson(response);
    }
    return res;
  }

  Future<AvailableLecturerRoutineResponse> getAvailableLecturerRoutine(data) async {
    API api = API();
    dynamic response;
    AvailableLecturerRoutineResponse res;
    try {
      response = await api.postDataWithToken(jsonEncode(data), '/routines/available');

      res = AvailableLecturerRoutineResponse.fromJson(response);

    } catch (e) {
      print(e.toString());
      res = AvailableLecturerRoutineResponse.fromJson(response);
    }
    return res;
  }

  Future<RoutineForPrincipalStats> getAllRoutine(String batch, String lecturer, String classroom, String institution) async {
    API api = API();
    dynamic response;
    RoutineForPrincipalStats res;
    try {
      response = await api.getWithToken('/routines/get-routine?institution=$institution&lecturer=$lecturer&batch=$batch&classroom=$classroom');

      res = RoutineForPrincipalStats.fromJson(response);

      print("RESPONSE::11:${res.routines}");
    } catch (e) {
      print(e.toString());
      res = RoutineForPrincipalStats.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> updateRoutineP(data, String id) async {
    API api = API();
    dynamic response;
    Commonresponse res;
    try {
      response = await api.putDataWithToken(
          jsonEncode(data), '/routines/$id');

      res = Commonresponse.fromJson(response);
    } catch (e) {
      print(e.toString());
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> replaceRoutineP(data, String id) async {
    API api = API();
    dynamic response;
    Commonresponse res;
    try {
      response = await api.putDataWithToken(
          jsonEncode(data), '/routines/replace/$id');

      res = Commonresponse.fromJson(response);
    } catch (e) {
      print(e.toString());
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> deleteRoutineP(String id) async {
    API api = API();
    dynamic response;
    Commonresponse res;
    try {
      response = await api.deleteDataWithToken('/routines/$id');

      res = Commonresponse.fromJson(response);
    } catch (e) {
      print(e.toString());
      res = Commonresponse.fromJson(response);
    }
    return res;
  }

  Future<Commonresponse> cancelRoutine(data, String id) async {
    API api = API();
    dynamic response;
    Commonresponse res;
    try {
      response = await api.putDataWithToken(
          jsonEncode(data), '/routines/cancel/$id');

      print("RESPONSE CANCEL ROUTINE:::${response}");

      res = Commonresponse.fromJson(response);
    } catch (e) {
      print(e.toString());
      res = Commonresponse.fromJson(response);
    }
    return res;
  }


  Future<RoutineForPrincipalStats> getallroutinefromclass(data) async {
    API api = API();
    dynamic response;
    RoutineForPrincipalStats res;
    try {
      response = await api.postDataWithToken(jsonEncode(data),'/routines/classroom');

      res = RoutineForPrincipalStats.fromJson(response);
    } catch (e) {
      print(e.toString());
      res = RoutineForPrincipalStats.fromJson(response);
    }
    return res;
  }
}
