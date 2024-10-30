import 'package:hive/hive.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/api/endpoints.dart';
import 'package:schoolworkspro_app/config/hive.conf.dart';
import 'package:schoolworkspro_app/response/institutiondetail_response.dart';
import 'package:schoolworkspro_app/response/notification_response.dart';

class NotificationRepository {
  Future<Notificationresponse> getNotifications() async {
    API api = new API();
    Box box = HiveUtils.box;
    dynamic response;
    Notificationresponse res;
    try {
      response = await api.getWithToken(Endpoints.getNotifications);

      res = Notificationresponse.fromJson(response);
      await box.put(Endpoints.getNotifications, res.toJson());
    } catch (e) {
      response = await box.get(Endpoints.getNotifications);
      res = Notificationresponse.fromJson(response);
    }
    return res;
  }
}
