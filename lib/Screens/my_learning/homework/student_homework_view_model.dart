import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api_response.dart';
import 'package:schoolworkspro_app/api/repositories/student_homework_repo.dart';
import 'package:schoolworkspro_app/response/lecturer/get_homework_response.dart';
import 'package:schoolworkspro_app/response/student_homework_info.dart'
    hide Task;

import '../../../response/digital_diary_response.dart' as digitalDiary;

class StudentHomeworkViewModel extends ChangeNotifier {
  ApiResponse _getStudentHomeworkAssignment = ApiResponse.initial("Empty Data");
  ApiResponse get getStudentHomeworkAssignment => _getStudentHomeworkAssignment;
  GetHomeworkResponse _data = GetHomeworkResponse(task: []);
  GetHomeworkResponse get data => _data;
  List<Task> _task = <Task>[];
  List<Task> get task => _task;
  List<dynamic> _students = <dynamic>[];
  List<dynamic> get students => _students;

  Future<void> fetchStudentHomework(moduleSlug, batch, username) async {
    _getStudentHomeworkAssignment = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetHomeworkResponse res = await StudentHomeworkRepository()
          .getStudentHomework(moduleSlug, batch);
      if (res.success == true) {
        _data = res;

        for (int i = 0; i < res.task.length; i++) {
          for (int j = 0; j < res.task[i].students!.length; j++) {
            if (res.task[i].students![j]['username'] == username) {
              _students.add(res.task[i].students![j]);
            }
          }
        }

        print("lala" + _students.toString());
        print("lala" + username.toString());

        _getStudentHomeworkAssignment =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _getStudentHomeworkAssignment =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _getStudentHomeworkAssignment = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _getStudentInformationAssignment =
      ApiResponse.initial("Empty Data");
  ApiResponse get getStudentInformationAssignment =>
      _getStudentInformationAssignment;
  StrudentHomeworkInfoResponse _studentInfo = StrudentHomeworkInfoResponse();
  StrudentHomeworkInfoResponse get studentInfo => _studentInfo;

  Future<void> fetchStudentInfo(taskSlug) async {
    _getStudentInformationAssignment = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      StrudentHomeworkInfoResponse res =
          await StudentHomeworkRepository().getStudentInfo(taskSlug);

      print("REs:::::${res}");
      if (res.success == true) {
        _studentInfo = res;

        _getStudentInformationAssignment =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _getStudentInformationAssignment =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _getStudentInformationAssignment = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }


  ApiResponse _getDigitalDiary =
  ApiResponse.initial("Empty Data");
  ApiResponse get getDigitalDiary =>
      _getDigitalDiary;
  digitalDiary.DigitalDiaryResponse _digitalDiaryData = digitalDiary.DigitalDiaryResponse();
  digitalDiary.DigitalDiaryResponse get digitalDiaryData => _digitalDiaryData;

  Future<void> fetchDigitalDiary(date) async {
    _getDigitalDiary = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      digitalDiary.DigitalDiaryResponse res =
      await StudentHomeworkRepository().getDigitalDiary(date);

      if (res.success == true) {
        _digitalDiaryData = res;

        _getDigitalDiary =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _getDigitalDiary =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _getDigitalDiary = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _studentInfo.userRecord = null;
    super.dispose();
  }
}
