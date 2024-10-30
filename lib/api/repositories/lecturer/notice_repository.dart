import 'package:hive/hive.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/api/endpoints.dart';
import 'package:schoolworkspro_app/config/hive.conf.dart';
import 'package:schoolworkspro_app/response/institutiondetail_response.dart';
import 'package:schoolworkspro_app/response/notice_response.dart';


class NoticeRepository {
  Future<Noticeresponse> getNoticeLecturer() async {
    API api = new API();
    // Box box = HiveUtils.box;
    dynamic response;
    Noticeresponse res;
    try {
      response = await api.getWithToken(Endpoints.getNoticeLecturer);

      res = Noticeresponse.fromJson(response);

      // await box.put(Endpoints.getNotifications, res.toJson());
    } catch (e) {
      print(e.toString());
      // response = await box.get(Endpoints.getNotifications);
      // print("asas"+response.toString());
      res = Noticeresponse.fromJson(response);
      print(res.toJson().toString());
    }
    return res;
  }
}
