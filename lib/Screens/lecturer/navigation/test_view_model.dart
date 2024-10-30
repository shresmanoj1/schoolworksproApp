// import 'package:flutter/material.dart';
// import 'package:schoolworkspro_app/api/api_response.dart';
// import 'package:schoolworkspro_app/api/repositories/notification_repository.dart';
// import 'package:schoolworkspro_app/response/notice_response.dart';
//
// class TestViewModel with ChangeNotifier {
//   ApiResponse _noticeApiResponse = ApiResponse.initial('Empty data');
//
//   ApiResponse get noticeApiResponse => _noticeApiResponse;
//
//   List<Notice> _notice = [];
//   List<Notice> get notice => _notice;
//
//   // int _totalNotices = 0;
//   // int get totalNotices => _totalNotices;
//   //
//   // int _unreadCount = 0;
//   // int get unreadCount => _unreadCount;
//
//   Future<void> fetchNotice() async {
//     _noticeApiResponse = ApiResponse.loading('Fetching device data');
//     notifyListeners();
//     try {
//       Noticeresponse data = await NoticeRepository().getNotice();
//
//       _notice = data.notices!;
//       // _totalNotices = data.totalNotices!;
//       // _unreadCount = data.unreadCount!;
//       _noticeApiResponse = ApiResponse.completed('success');
//
//       print("data::" + _notice.toString());
//       // _loadMoreApiResponse = ApiResponse.completed(data);
//       notifyListeners();
//     } catch (e) {
//       _noticeApiResponse = ApiResponse.error(e.toString());
//       notifyListeners();
//     }
//     notifyListeners();
//   }
// }
