import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Dashboardlecturer/dashboard_lecturer.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/more_lecturer.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/mymodule_lecturer.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/request/fcm_request.dart';
import 'package:schoolworkspro_app/services/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/api.dart';
import '../../../common_view_model.dart';
import '../../../config/preference_utils.dart';
import '../../../constants/colors.dart';
import '../../../constants/text_style.dart';
import '../../../flavor_config_provider.dart';
import '../../../response/login_response.dart';
import '../../../response/notice_response.dart' hide Notice;
import '../../../services/lecturer/punch_service.dart';
import '../../../services/notification_navigate_service.dart';
import '../../notice/notice.dart';
import '../events/events_lecturer.dart';

class NavigationLecturer extends StatefulWidget {
  const NavigationLecturer({
    Key? key,
  }) : super(key: key);

  @override
  State<NavigationLecturer> createState() => _NavigationLecturerState();
}

class _NavigationLecturerState extends State<NavigationLecturer> {
  String title = 'Home';
  User? user;
  LecturerCommonViewModel? lecturerCommonViewModel;
  late PunchService _punchService;
  late CommonViewModel _commonViewModel;
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    getData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      NotificationRoute.NavigationNavigateService(context);
      lecturerCommonViewModel =
          Provider.of<LecturerCommonViewModel>(context, listen: false);
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
            // print("FCM token registered");
          } else {
            // print("Error registering FCM token");
          }
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

      _commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
      _commonViewModel.fetchNotifications();
      _commonViewModel.getAuthenticatedUser();
      _commonViewModel.fetchNotice();
      final SharedPreferences localStorage = PreferenceUtils.instance;
      if (_commonViewModel.noticeCount == localStorage.getInt('insidecount')) {
        _commonViewModel.setDot(false);
      } else {
        _commonViewModel.setDot(true);
      }

      _punchService = Provider.of<PunchService>(context, listen: false);
      _punchService.checkPunchStatus(context);
    });
    super.initState();
  }

  _onPageChanged(int index) {
    // onTap
    setState(() {
      lecturerCommonViewModel!.setNavigationIndex(index);
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
            title = 'Module';
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

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
    if(user != null) {
      lecturerCommonViewModel?.fetchCourseWithModules(user!.email.toString());
      lecturerCommonViewModel?.fetchRoutinePreference();
    }
  }

  @override
  Widget build(BuildContext context) {
    final flavorConfigProvider = Provider.of<FlavorConfigProvider>(context);
    final config = flavorConfigProvider.config;
    return WillPopScope(
      onWillPop: () {
        if (lecturerCommonViewModel!.navigatoinIndex == 0) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          return Future.value(false);
        } else {
          lecturerCommonViewModel!.itemTapped(0);
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Consumer3< LecturerCommonViewModel, PunchService,
              CommonViewModel>(
          builder: (context, lecturerCommonViewModel, provider2, common,
              child) {
        return Scaffold(
          appBar: AppBar(
              actions: [
                Align(
                  alignment: Alignment.center,
                  child: Builder(builder: (context) {
                    return provider2.data2?.status == null
                        ? Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(5)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            child: const Text(
                              "Offline",
                            ),
                          )
                        : provider2.data2?.status == "Out"
                            ? Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 3),
                                child: const Text(
                                  "Offline",
                                ))
                            : provider2.data2?.status?['status'] == "Out"
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    child: const Text(
                                      "Offline",
                                    ))
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    child: const Text(
                                      "Online",
                                    ),
                                  );
                  }),
                ),
                Builder(builder: (context) {
                  if (common.showDot == true) {
                    return IconButton(
                      onPressed: () {
                        _commonViewModel.setDot(false);
                        Navigator.of(context).pushNamed(
                          '/notificationscreen',
                        );
                      },
                      icon: Stack(
                        children: [
                          const Icon(Icons.notifications,
                              color: Color(0xff004D96)),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                height: 10,
                                width: 10,
                                decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                              ))
                        ],
                      ),
                    );
                  } else {
                    return IconButton(
                      onPressed: () {
                        _commonViewModel.setDot(false);
                        Navigator.of(context).pushNamed(
                          '/notificationscreen',
                        );
                      },
                      icon: const Icon(Icons.notifications,
                          color: Color(0xff004D96)),
                    );
                  }
                }),
                IconButton(
                    onPressed: () => scanQR(lecturerCommonViewModel),
                    icon: const Icon(
                      Icons.qr_code_scanner,
                      color: Color(0xff004D96),
                    )),
              ],
              title:  Image.asset(
                "assets/images/logo.png",
                height: 55,
              ),
              automaticallyImplyLeading: false,
              elevation: 0.0,
              iconTheme: const IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: Colors.white),
          body: PageView(
            controller: lecturerCommonViewModel.pagecontroller,
            onPageChanged: _onPageChanged,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              // Text("Dash"),
              const Dashboardlecturer(),
              EventLecturer(),
              const Mymodulelecturer(),
              const Notice(),
              const Morelecturer(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: lecturerCommonViewModel.navigatoinIndex,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,
            unselectedLabelStyle: p13.copyWith(
                fontWeight: FontWeight.w800, color: Colors.grey.shade800),
            selectedLabelStyle: p13.copyWith(
                fontWeight: FontWeight.w800, color: Colors.grey.shade800),
            onTap: lecturerCommonViewModel.itemTapped,
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
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    width: 40,
                    child: Image.asset(
                      'assets/images/button/events.png',
                      color: logoTheme,
                    )),
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
                label: "Modules",
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
                label: "Notices",
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
                  width: 40.0,
                  height: 40.0,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12), color: white),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: logoTheme,
                            border: Border.all(
                                color: provider2.data2?.status == "Out" ||
                                        provider2.data2?.status?['status'] ==
                                            "Out"
                                    ? Colors.red
                                    : Colors.green,
                                width: 2)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            height: 35,
                            width: 35,
                            fit: BoxFit.cover,
                            imageUrl:
                                '$api_url2/uploads/users/${common.authenticatedUserDetail.userImage}',
                            placeholder: (context, url) => const Center(
                                child: CupertinoActivityIndicator()),
                            errorWidget: (context, url, error) =>
                                Image.asset("assets/images/button/user.png"),
                          ),
                        ),
                      ),
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: Material(
                            color: Colors.transparent,
                            shape: const CircleBorder(
                                side: BorderSide(color: Colors.white)),
                            child: Icon(
                              Icons.circle,
                              color: provider2.data2?.status == "Out" ||
                                      provider2.data2?.status?['status'] ==
                                          "Out"
                                  ? Colors.red
                                  : Colors.green,
                              size: 10,
                            ),
                          ))
                    ],
                  ),
                ),
                label: "Profile",
                activeIcon: Container(
                  width: 40.0,
                  height: 40.0,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: logoTheme),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: logoTheme,
                            border: Border.all(
                                color: provider2.data2?.status == "Out" ||
                                        provider2.data2?.status?['status'] ==
                                            "Out"
                                    ? Colors.red
                                    : Colors.green,
                                width: 2)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            height: 35,
                            width: 35,
                            fit: BoxFit.cover,
                            imageUrl:
                                '$api_url2/uploads/users/${common.authenticatedUserDetail.userImage}',
                            placeholder: (context, url) => const Center(
                                child: CupertinoActivityIndicator()),
                            errorWidget: (context, url, error) =>
                                Image.asset("assets/images/button/user.png"),
                          ),
                        ),
                      ),
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: Material(
                            color: Colors.transparent,
                            shape: const CircleBorder(
                                side: BorderSide(color: Colors.white)),
                            child: Icon(
                              Icons.circle,
                              color: provider2.data2?.status == "Out" ||
                                      provider2.data2?.status?['status'] ==
                                          "Out"
                                  ? Colors.red
                                  : Colors.green,
                              size: 10,
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> scanQR(LecturerCommonViewModel lectureVM) async {
    String barcodeScanRes;
    DateTime now = DateTime.now();

    DateTime checkSecond = DateTime.now();

    var affter10 =
        DateFormat('ss').format(checkSecond.add(const Duration(seconds: 10)));
    var before10 = DateFormat('ss')
        .format(checkSecond.subtract(const Duration(seconds: 10)));

    var formattedTime = DateFormat('yyyy-MM-ddTHH:mm:ss').format(now);

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);

      String institutionParameter = barcodeScanRes.split('institution=')[1];
      String institutionName = institutionParameter.split('?')[0];
      var extractDate = barcodeScanRes.toString().split("?");

      String dateString = extractDate[1];

      DateTime date1 = DateTime.parse(DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.parse(dateString)));
      DateTime date2 = DateTime.parse(formattedTime);

      int staffAttendanceQRScanRefresh = lectureVM.routinePreference.refreshTime ?? 60;

      bool isAfterDate = date2.isAfter(date1);
      bool isBeforeDate = date2.isBefore(date1.add(Duration(seconds: staffAttendanceQRScanRefresh)));
      bool isSameDate = date2.isAtSameMomentAs(date1) || date2.isAtSameMomentAs(date1.add(Duration(seconds: staffAttendanceQRScanRefresh)));

      if(institutionName == user?.institution){

      if((isAfterDate && isBeforeDate) || isSameDate) {
        hitAttendance().then((_) {
          _punchService.checkPunchStatus(context);
        });
      }
      else {
        Fluttertoast.showToast(msg: "Please scan a valid QR code.", backgroundColor: Colors.red);
      }
      }else{
        Fluttertoast.showToast(msg: "Invalid institution. Please scan a valid QR code.", backgroundColor: Colors.red);
      }

    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  hitAttendance() async {
    try {
      final res = await PunchService().punchInOut();
      if (res.success == true) {
        Fluttertoast.showToast(
            msg: res.message.toString(), backgroundColor: Colors.green);
      } else {
        Fluttertoast.showToast(
            msg: res.message.toString(), backgroundColor: Colors.red);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
    }
  }
}
