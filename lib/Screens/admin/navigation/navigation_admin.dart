import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/admin/dashboard/dashboardadminscreen.dart';
import 'package:schoolworkspro_app/Screens/admin/navigation/drawer.dart';
import 'package:schoolworkspro_app/Screens/admin/notice/notice_admin.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/QrView.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/services/lecturer/punch_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/app_version.dart';
import '../../../request/fcm_request.dart';
import '../../../response/login_response.dart';
import '../../../services/login_service.dart';
import '../../lecturer/lecturer_common_view_model.dart';

class NavigationAdmin extends StatefulWidget {
  NavigationAdmin({
    Key? key,
  }) : super(key: key);

  @override
  _NavigationAdminState createState() => _NavigationAdminState();
}

class _NavigationAdminState extends State<NavigationAdmin> {
  String _title = 'Home';

  String _scanBarcode = 'Unknown';
  PageController _pageController = PageController();
  // List<Widget> _screens = [StudentDashboard(), Result(), Attendance()];
  int _selectedIndex = 0;
  bool connected = false;
  User? user;
  late LecturerCommonViewModel _provider;

  @override
  void initState() {
    // TODO: implement initState

    // getCompletedLesson();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<LecturerCommonViewModel>(context, listen: false);
      _provider.fetchRoutinePreference();
    });

    Future.delayed(Duration.zero, () {
      VersionChecker.checkVersion(context);
    });
    getData();
    super.initState();
  }

  getData() async {
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
        print("fcm: " + token.toString());
        final data = FcmTokenRequest(
            username: user?.username.toString(),
            batch: user?.batch.toString(),
            type: user?.type.toString(),
            institution: user?.institution.toString(),
            token: token.toString());
        final res = await LoginService().postFCM(data);
        if (res.success == true) {
          print("FCM token registered");
        } else {
          print("Error registering FCM token");
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
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<LecturerCommonViewModel>(
      builder: (context, lecturerVm, child) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              'Dashboard',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NoticeAdminScreen(),
                      ));
                },
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
              ),
              IconButton(
                  onPressed: () => scanQR(lecturerVm),
                  icon: const Icon(
                    Icons.qr_code_scanner,
                    color: Colors.black,
                  )),
            ],
            backgroundColor: Colors.white,
            elevation: 0.0,
          ),
          drawer: const Drawersection(),
          body: const DashboardAdminscreen(),
        );
      }
    );
  }

  // Future<void> scanQR(LecturerCommonViewModel lectureVM) async {
  //   String barcodeScanRes;
  //   DateTime now = DateTime.now();
  //
  //   // var formattedtime = DateFormat('yyyyMMddmm').format(now);
  //   // try {
  //   //   barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //   //       '#ff6666', 'Cancel', true, ScanMode.QR);
  //   //   if (barcodeScanRes.toString() ==
  //   //       "https://api.schoolworkspro.com/staffAttendance/institution=${user?.institution.toString()}?${formattedtime}") {
  //   //     hitAttendance();
  //   //   }
  //   var formattedTime = DateFormat('yyyy-MM-ddTHH:mm:ss').format(now);
  //
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //         '#ff6666', 'Cancel', true, ScanMode.QR);
  //     var extractDate = barcodeScanRes.toString().split("?");
  //
  //     String dateString = extractDate[1];
  //
  //     DateTime date1 = DateTime.parse(DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.parse(dateString)));
  //     DateTime date2 = DateTime.parse(formattedTime);
  //
  //     int staffAttendanceQRScanRefresh = lectureVM.routinePreference.refreshTime ?? 60;
  //
  //     bool isAfterDate = date2.isAfter(date1);
  //     bool isBeforeDate = date2.isBefore(date1.add(Duration(seconds: staffAttendanceQRScanRefresh)));
  //     bool isSameDate = date2.isAtSameMomentAs(date1) || date2.isAtSameMomentAs(date1.add(Duration(seconds: staffAttendanceQRScanRefresh)));
  //
  //     if((isAfterDate && isBeforeDate) || isSameDate) {
  //       hitAttendance().then((_) {
  //         // _punchService.checkPunchStatus(context);
  //       });
  //     }
  //     else {
  //       Fluttertoast.showToast(msg: "Invalid QR");
  //     }
  //   } on PlatformException {
  //     barcodeScanRes = 'Failed to get platform version.';
  //   }
  //   if (!mounted) return;
  //
  //   setState(() {
  //     _scanBarcode = barcodeScanRes;
  //   });
  // }

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
      var extractDate = barcodeScanRes.toString().split("?");

      String dateString = extractDate[1];

      DateTime date1 = DateTime.parse(DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.parse(dateString)));
      DateTime date2 = DateTime.parse(formattedTime);

      int staffAttendanceQRScanRefresh = lectureVM.routinePreference.refreshTime ?? 60;

      bool isAfterDate = date2.isAfter(date1);
      bool isBeforeDate = date2.isBefore(date1.add(Duration(seconds: staffAttendanceQRScanRefresh)));
      bool isSameDate = date2.isAtSameMomentAs(date1) || date2.isAtSameMomentAs(date1.add(Duration(seconds: staffAttendanceQRScanRefresh)));

      if((isAfterDate && isBeforeDate) || isSameDate) {
        hitAttendance().then((_) {
          // _punchService.checkPunchStatus(context);
        });
      }
      else {
        Fluttertoast.showToast(msg: "Invalid QR");
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
            msg: res.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.green,
            textColor: Colors.white);
      } else {
        Fluttertoast.showToast(
            msg: res.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.green,
            textColor: Colors.white);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
  }
}
