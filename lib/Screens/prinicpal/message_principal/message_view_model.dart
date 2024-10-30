import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api_response.dart';
import 'package:schoolworkspro_app/api/repositories/message_repository.dart';
import 'package:schoolworkspro_app/response/getmessage_response.dart';

class MessageViewModel extends ChangeNotifier {
  ApiResponse _unseenmessageApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get unseenmessageApiResponse => _unseenmessageApiResponse;
  List<dynamic> _unseenmessage = <dynamic>[];
  List<dynamic> get unseenmessage => _unseenmessage;

  int _unseencount = 0;
  int get unseencount => _unseencount;

  Future<void> fetchunseenmessage() async {
    _unseenmessageApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      GetMessageResponse res = await MessageRepository().getmessageunseen();
      if (res.success == true) {
        _unseenmessage = res.allMessages!;
        _unseencount = res.allMessages!.length;

        _unseenmessageApiResponse =
            ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _unseenmessageApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _unseenmessageApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
