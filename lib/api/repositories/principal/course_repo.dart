import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/course_response.dart';

class CourseRepository{
  Future<CourseResponse> getCourse() async {
    API api = API();
    dynamic response;
    CourseResponse res;
    try {
      response = await api.getWithToken('/courses');

      res = CourseResponse.fromJson(response);
    } catch (e) {
      res = CourseResponse.fromJson(response);
    }
    return res;
  }
}