import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api_response.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/homework_repository.dart';
import 'package:schoolworkspro_app/response/lecturer/add_homework_response.dart';

import '../../../../../response/lecturer/get_homework_response.dart';

class HomeworkViewModel extends ChangeNotifier {
  ApiResponse _homeworkApiResponse = ApiResponse.initial("Empty Data");

  ApiResponse get homeworkApiResponse => _homeworkApiResponse;
  GetHomeworkResponse _data = GetHomeworkResponse(task: []);

  GetHomeworkResponse get data => _data;

  Future<void> fetchHomework(moduleSlug, batch) async {
    _homeworkApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetHomeworkResponse res =
          await HomeworkRepository().viewHomework(moduleSlug, batch);
      if (res.success == true) {
        _data = res;

        _homeworkApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _homeworkApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      _homeworkApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  ApiResponse _studentHomeworkFeedbackApiResponse =
      ApiResponse.initial("Empty Data");

  ApiResponse get studentHomeworkFeedbackApiResponse =>
      _studentHomeworkFeedbackApiResponse;
  GetHomeworkResponse _studentFeedback = GetHomeworkResponse(task: []);

  GetHomeworkResponse get studentFeedback => _studentFeedback;

  Future<void> fetchStudentHomeworkStatus(moduleSlug, batch) async {
    _studentHomeworkFeedbackApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetHomeworkResponse res =
          await HomeworkRepository().viewHomework(moduleSlug, batch);
      if (res.success == true) {
        _studentFeedback = res;

        _studentHomeworkFeedbackApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _studentHomeworkFeedbackApiResponse =
            ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      _studentHomeworkFeedbackApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
