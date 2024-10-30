import 'package:hive/hive.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/getmessage_response.dart';
import 'package:schoolworkspro_app/response/notification_response.dart';

class MessageRepository {
  Future<GetMessageResponse> getmessageunseen() async {
    API api = new API();

    dynamic response;
    GetMessageResponse res;
    try {
      response = await api.getWithToken('/quick-message/unseen');

      res = GetMessageResponse.fromJson(response);
    } catch (e) {
      print(e.toString());

      // print("asas"+response.toString());
      res = GetMessageResponse.fromJson(response);
      print(res.toJson().toString());
    }
    return res;
  }
}
