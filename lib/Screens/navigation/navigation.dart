import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:schoolworkspro_app/Screens/dashboard/dasboard.dart';
import 'package:schoolworkspro_app/Screens/events/event.dart';
import 'package:schoolworkspro_app/Screens/more/more.dart';
import 'package:schoolworkspro_app/Screens/my_learning/my_learning.dart';
import 'package:schoolworkspro_app/Screens/notice/notice.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:schoolworkspro_app/request/fcm_request.dart';
import 'package:schoolworkspro_app/services/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/repositories/lecturer/attendance_repository.dart';
import '../../api/repositories/principal/event_repo.dart';
import '../../constants/text_style.dart';
import '../../flavor_config_provider.dart';
import '../../helper/app_version.dart';
import '../../response/login_response.dart';
import '../../services/notification_navigate_service.dart';
import '../achievements/achievement_view_model.dart';
import '../lecturer/ID-lecturer/idcard_view_model.dart';
import '../lecturer/events/events_lecturer.dart';
import '../lecturer/my-modules/components/group_result/group_result_view_model.dart';
import '../my_learning/learning_view_model.dart';
import '../physical_library/library_view_model.dart';
import '../prinicpal/stats_common_view_model.dart';

class Navigation extends StatefulWidget {
  final int currentIndex;

  const Navigation({Key? key, required this.currentIndex}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation>
    with SingleTickerProviderStateMixin {
  GlobalKey _one = GlobalKey();
  int _currentindex = 0;
  final _inactiveColor = Colors.grey;

  int notificationCount = 0;
  int oldnotificationCount = 0;
  User? user;
  String _scanBarcode = 'Unknown';

  // PageController pagecontroller = PageController();
  int selectedIndex = 0;
  String title = 'Home';

  late CommonViewModel commonViewModel;
  late LearningViewModel learningViewModel;
  late AchievementViewModel _provider;
  late LibraryViewModel _libraryViewModel;
  late IDCardLecturerViewModel _idCardLecturer;
  late GroupResultViewModel _provider3;
  late StatsCommonViewModel _provider4;

  @override
  void initState() {
    // TODO: implement initState
    // checkversion();
    // checkbar();setSt

    postFCM();
    // getNotifications();
    Future.delayed(Duration.zero, () {
      VersionChecker.checkVersion(context);
    });
    commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<AchievementViewModel>(context, listen: false);
      learningViewModel =
          Provider.of<LearningViewModel>(context, listen: false);
      _libraryViewModel = Provider.of<LibraryViewModel>(context, listen: false);
      _idCardLecturer =
          Provider.of<IDCardLecturerViewModel>(context, listen: false);
      _provider3 = Provider.of<GroupResultViewModel>(context, listen: false);
      _provider4 = Provider.of<StatsCommonViewModel>(context, listen: false);

      commonViewModel.getAuthenticatedUser();
      commonViewModel.fetchoffenses();
      commonViewModel.fetchNotice();
      learningViewModel =
          Provider.of<LearningViewModel>(context, listen: false);
      learningViewModel.fetchLearningFilters();
      learningViewModel.fetchMyLearning("");
      learningViewModel.fetchMyNewLearning("");
      commonViewModel.fetchExamRulesRegulations();
      commonViewModel.fetchStudentBus();

      NotificationRoute.NavigationNavigateService(context);
    });
    setState(() {
      _currentindex = widget.currentIndex;
    });

    super.initState();
  }

  postFCM() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
    try {
      FirebaseMessaging.instance.getToken().then((value) async {
        String? token = value;
        final data = FcmTokenRequest(
            username: user?.username.toString(),
            batch: user?.batch.toString(),
            type: user?.type.toString(),
            institution: user?.institution.toString(),
            token: token.toString());
        final res = await LoginService().postFCM(data);
        if (res.success == true) {
        } else {}
      });
    } on Exception catch (e) {
      snackThis(
          content: Text(e.toString()),
          color: Colors.red,
          behavior: SnackBarBehavior.fixed,
          duration: 2,
          context: context);
      // TODO
    }
  }

  _onPageChanged(int index) {
    // onTap
    setState(() {
      commonViewModel.setNavigationIndex(index);
      // selectedIndex = index;
      switch (index) {
        case 0:
          {
            title = 'Home';
          }
          break;
        case 1:
          {
            title = 'Events';
          }
          break;
        case 2:
          {
            title = 'My learning';
          }
          break;
        case 3:
          {
            title = 'Notice';
          }
          break;
        case 4:
          {
            title = 'More';
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final flavorConfigProvider = Provider.of<FlavorConfigProvider>(context);
    final config = flavorConfigProvider.config;
    return WillPopScope(
      onWillPop: () {
        if (commonViewModel.navigatoinIndex == 0) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          return Future.value(false);
        } else {
          commonViewModel.itemTapped(0);
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
            actions: [
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/notificationscreen',
                  );
                },
                child: const Icon(
                  Icons.notifications,
                  color: Color(0xff004D96),
                ),
              ),
              InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/notificationscreen',
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: IconButton(
                      onPressed: () {
                        scanQR();
                      },
                      icon: const Icon(
                        Icons.qr_code_scanner,
                        color: Color(0xff004D96),
                      ),
                    ),
                  )),
            ],
            title: Image.asset(
              "assets/images/logo.png",
              height: 48,
            ),
            automaticallyImplyLeading: false,
            elevation: 0.0,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            backgroundColor: Colors.white),
        body: PageView(
          controller: commonViewModel.pagecontroller,
          onPageChanged: _onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const Dashboard(),
            const EventScreen(),
            const MyLearning(),
            const Notice(),
            More(),
          ],
        ),
        bottomNavigationBar:
            Consumer<CommonViewModel>(builder: (context, common, child) {
          return BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: commonViewModel.navigatoinIndex,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,
            unselectedLabelStyle: p13.copyWith(
                fontWeight: FontWeight.w800, color: Colors.grey.shade800),
            selectedLabelStyle: p13.copyWith(
                fontWeight: FontWeight.w800, color: Colors.grey.shade800),
            onTap: commonViewModel.itemTapped,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                    padding: const EdgeInsets.all(8),
                    height: 40,
                    width: 40,
                    child: Image.asset('assets/images/button/house.png',
                        color: logoTheme)),
                label: "Home",
                activeIcon: Container(
                    padding: const EdgeInsets.all(8),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: logoTheme),
                    child: Image.asset(
                      'assets/images/button/homefill.png',
                      color: white,
                    )),
              ),
              BottomNavigationBarItem(
                icon: Container(
                    padding: const EdgeInsets.all(8),
                    height: 40,
                    width: 40,
                    child: Image.asset('assets/images/button/events.png',
                        color: logoTheme)),
                label: "Events",
                activeIcon: Container(
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: logoTheme),
                    child: Image.asset(
                      'assets/images/button/eventfill.png',
                      color: white,
                    )),
              ),
              BottomNavigationBarItem(
                icon: Container(
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    width: 40,
                    child: Image.asset(
                      'assets/images/button/books.png',
                      color: logoTheme,
                    )),
                label: "Learning",
                activeIcon: Container(
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: logoTheme),
                    child: Image.asset(
                      'assets/images/button/bookfill.png',
                      color: white,
                    )),
              ),
              BottomNavigationBarItem(
                icon: Container(
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                        'assets/images/button/emailmarketing.png',
                        color: logoTheme)),
                label: "Notice",
                activeIcon: Container(
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: logoTheme),
                    child: Image.asset(
                      'assets/images/button/emailmarketingfill.png',
                      color: white,
                    )),
              ),
              BottomNavigationBarItem(
                icon: Container(
                    padding: const EdgeInsets.all(8),
                    height: 40,
                    width: 40,
                    child: Image.asset('assets/images/button/user.png',
                        color: logoTheme)),
                label: "Profile",
                activeIcon: Container(
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: logoTheme),
                    child: Image.asset(
                      'assets/images/button/userfill.png',
                      color: white,
                    )),
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);

      final Map jsonConvert = jsonDecode(barcodeScanRes);

      if (jsonConvert.containsKey("token") &&
          jsonConvert["token"] != null &&
          jsonConvert["token"] != "null" &&
          jsonConvert["token"] != "" &&
          !jsonConvert.containsKey("type")) {
        studentAttendance(
            jsonConvert,
            user == null ? "" : user!.username.toString(),
            user == null ? "" : user!.institution.toString());
      } else if (jsonConvert.containsKey("token") &&
          jsonConvert["token"] != null &&
          jsonConvert["token"] != "null" &&
          jsonConvert["token"] != "" &&
          jsonConvert.containsKey("type") &&
          jsonConvert["type"] == "StudentQr") {
        studentAllDayAttendance(
            jsonConvert,
            user == null ? "" : user!.username.toString(),
            user == null ? "" : user!.institution.toString(),
            user == null ? "" : user!.batch.toString());
      } else if (jsonConvert.containsKey("qrType") &&
          jsonConvert["qrType"] == "static") {
        studentAttendance(
            jsonConvert,
            user == null ? "" : user!.username.toString(),
            user == null ? "" : user!.institution.toString());
      } else if (jsonConvert.containsKey("id")) {
        eventAttendance(jsonConvert["id"]);
      } else {
        Fluttertoast.showToast(
            msg: "Invalid QR Code",
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  studentAllDayAttendance(
      final Map data, String username, String institution, String batch) async {
    try {
      final request = {
        "username": username,
        "batch": batch,
        "institution": institution,
        "token": data["token"] ?? null,
      };
      final res = await AttendanceRepository()
          .postAllDayStudentQrAttendance(jsonEncode(request));
      if (res.success == true) {
        Fluttertoast.showToast(
            msg: res.message.toString(),
            backgroundColor: Colors.green,
            textColor: Colors.white);
      } else {
        Fluttertoast.showToast(
            msg: res.message.toString(),
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Failed", backgroundColor: Colors.red, textColor: Colors.white);
    }
  }

  eventAttendance(String id) async {
    try {
      final res = await EventRepository().postEventAttendance(id);
      if (res.success == true) {
        Fluttertoast.showToast(
            msg: res.message.toString(),
            backgroundColor: Colors.green,
            textColor: Colors.white);
      } else {
        Fluttertoast.showToast(
            msg: res.message.toString(),
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Failed", backgroundColor: Colors.red, textColor: Colors.white);
    }
  }

  studentAttendance(final Map data, String username, String institution) async {
    try {
      final request = {
        "username": username,
        "batch": data["batch"],
        "moduleSlug": data["moduleSlug"],
        "attendanceType": data["classType"],
        "attendanceBy": data["attendanceBy"],
        "institution": data["institution"],
        "token": data["token"] ?? null,
      };
      if ((data.containsKey("qrType") && data["qrType"] == "static")) {
        request["qrType"] = "static";
      }
      final res =
          await AttendanceRepository().postQrAttendance(jsonEncode(request));
      if (res.success == true) {
        Fluttertoast.showToast(
            msg: res.message.toString(),
            backgroundColor: Colors.green,
            textColor: Colors.white);
      } else {
        Fluttertoast.showToast(
            msg: res.message.toString(),
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Failed", backgroundColor: Colors.red, textColor: Colors.white);
    }
  }
}
