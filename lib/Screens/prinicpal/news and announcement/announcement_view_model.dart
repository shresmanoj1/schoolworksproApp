import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api_response.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/notice_repository.dart';
import 'package:schoolworkspro_app/api/repositories/principal/notice_repo.dart';
import 'package:schoolworkspro_app/response/admin/admin_notice_response.dart';
import 'package:schoolworkspro_app/response/principal/mynoticeprincipal_response.dart';
import 'package:schoolworkspro_app/response/principal/newsannouncement_response.dart';

class AnnouncementViewModel with ChangeNotifier {
  ApiResponse _announcementApiResponse = ApiResponse.initial('Empty data');
  ApiResponse _loadMoreApiResponse = ApiResponse.initial('Empty data');

  ApiResponse get announcementApiResponse => _announcementApiResponse;
  ApiResponse get loadMoreApiResponse => _loadMoreApiResponse;


  List<Notice> _notices = <Notice>[];
  List<Notice> get notices => _notices;

  int _page = 1;
  int _totalData = 0;
  bool _hasMore = true;
  int get page => _page;
  int _size = 10;
  int get size => _size;
  int get totalData => _totalData;
  bool get hasMore => _hasMore;

  setPage(int pagess) {
    _page = pagess;
    notifyListeners();
  }


  Future<void> loadMore() async {
    _page = _page + 1;
    _loadMoreApiResponse = ApiResponse.loading('Fetching device data');
    notifyListeners();
    try {
      NewsAnnouncementResponse data =
          await NoticePrincipalRepository().getnewsandannouncment([
        {"page": _page.toString()},
      ]);
      _notices.addAll(data.notices!);

      _loadMoreApiResponse = ApiResponse.completed(data);
      notifyListeners();
    } catch (e) {
      _loadMoreApiResponse = ApiResponse.error(e.toString());
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> fetchannouncement() async {
    _announcementApiResponse = ApiResponse.loading('Fetching device data');
    notifyListeners();
    try {
      NewsAnnouncementResponse data =
          await NoticePrincipalRepository().getnewsandannouncment([
        {"page": "1"},
      ]);

      _notices = data.notices!;

      _announcementApiResponse = ApiResponse.completed(data);
      _loadMoreApiResponse = ApiResponse.completed(data);
      // _loadMoreApiResponse = ApiResponse.completed(data);
      notifyListeners();
    } catch (e) {
      _announcementApiResponse = ApiResponse.error(e.toString());
      notifyListeners();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _page = 1;
    _size = 10;
    _totalData = 0;
    _hasMore = true;

    super.dispose();
  }

  ApiResponse _mynoticeApiResponse = ApiResponse.initial("Empty Data");
  ApiResponse get mynoticeApiResponse => _mynoticeApiResponse;
  List<dynamic> _mynotice = <dynamic>[];
  List<dynamic> get mynotice => _mynotice;

  Future<void> fetchmynotices() async {
    _mynoticeApiResponse = ApiResponse.initial("Loading");
    notifyListeners();
    try {
      Mynoticeesponse res = await NoticePrincipalRepository().getmynotices();
      if (res.success == true) {
        _mynotice = res.notices!;

        _mynoticeApiResponse = ApiResponse.completed(res.success.toString());
        notifyListeners();
      } else {
        _mynoticeApiResponse = ApiResponse.error(res.success.toString());
      }
    } catch (e) {
      print("VM CATCH ERR :: " + e.toString());
      _mynoticeApiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }


  ApiResponse _adminAllApiResponse = ApiResponse.initial('Empty data');
  ApiResponse get adminAllApiResponse => _adminAllApiResponse;

  List<dynamic> _adminNotices = <dynamic>[];
  List<dynamic> get adminNotices => _adminNotices;

  Future<void> fetchAllAdminNotice() async {

    _adminAllApiResponse = ApiResponse.loading('Fetching device data');
    notifyListeners();
    try {
      AdminNoticeResponse data =
      await NoticePrincipalRepository().fetchAllNoticeAdmin();

      _adminNotices = data.notices!;

      _adminAllApiResponse = ApiResponse.completed(data);
      notifyListeners();
    } catch (e) {
      _adminAllApiResponse = ApiResponse.error(e.toString());
      notifyListeners();
    }
    notifyListeners();
  }
}
