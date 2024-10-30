import 'dart:convert';
import 'package:html_editor_enhanced/utils/shims/dart_ui_real.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Dashboardlecturer/lecturer_view_model.dart';
import 'package:schoolworkspro_app/Screens/login/login.dart';
import 'package:schoolworkspro_app/Screens/message/messaging.dart';
import 'package:schoolworkspro_app/Screens/navigation/navigation.dart';
import 'package:schoolworkspro_app/Screens/notification/notification.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/attendancestatsdetail_screen/absent_student.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/attendancestatsdetail_screen/cancelled_class.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/attendancestatsdetail_screen/present_students.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/attendancestatsdetail_screen/todays_class.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/message_principal/admin_messaging.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/message_principal/message_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/principal_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/request/DateRequest.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/principal/staffattendanceprincipal_response.dart';
import 'package:schoolworkspro_app/services/admin/getassignedrequest_service.dart';
import 'package:schoolworkspro_app/services/lecturer/punch_service.dart';
import 'package:schoolworkspro_app/services/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/api_response_config.dart';
import '../../../response/login_response.dart';
import '../../lecturer/lecturer_common_view_model.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  User? user;
  late PrinicpalCommonViewModel _provider;
  late CommonViewModel _provider2;
  List<AttendanceDatum> _list = <AttendanceDatum>[];
  List<AttendanceDatum> _listForDisplay = <AttendanceDatum>[];
  @override
  void initState() {
    // TODO: implement initState
    getData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PrinicpalCommonViewModel>(context, listen: false)
          .fetchdailystats();
      Provider.of<MessageViewModel>(context, listen: false)
          .fetchunseenmessage();
      _provider2 = Provider.of<CommonViewModel>(context, listen: false);
      _provider = Provider.of<PrinicpalCommonViewModel>(context, listen: false);
      final date = DateRequest(date: DateTime.now());
      _provider.fetchallattendanceforstaffs(date);
      _provider.fetchStudentDailyAttendanceCount();
      _provider.fetchAbsentStudentDailyAttendance(date.toString(),"","","");
      _provider2.fetchUser();
    });
    super.initState();
  }

  int presentCount = 0;
  int totalCount = 0;
  String _scanBarcode = 'Unknown';

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer5<PrinicpalCommonViewModel, CommonViewModel,
            AssignedRequestService, MessageViewModel, LecturerCommonViewModel>(
        builder: (context, value, common, request, message, lecturerVm, child) {
      return Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            height: 190,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: Color(0xff000099),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Builder(builder: (context) {
                          DateTime now =
                              DateTime.parse(DateTime.now().toString());

                          var formattedTime = DateFormat('aa').format(now);

                          return Text(
                              "${formattedTime == "PM" ? "Good Afternoon" : "Good Morning"},\n${user?.firstname} ${user?.lastname}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20));
                        }),
                      ),
                      Expanded(
                        flex: 0,
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: kPrimaryColor,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  '/notificationscreen',
                                );
                                // Navigation.push(context, MaterialPageRoute(builder: (context) => Notificationscreen(),));
                              },
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: kPrimaryColor,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.qr_code_scanner,
                                color: Colors.white,
                              ),
                              onPressed: () => scanQR(lecturerVm),
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
                isLoading(common.userDetailsApiResponse)
                    ? const Text("")
                    : common.user.user!.designation == null || common.user.user!.designation == ""
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Chip(
                                backgroundColor: const Color(0xff17a2b8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                labelPadding: const EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                                label: Text(
                                  common.user.user!.designation.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                )),
                          ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: -70,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.,
                          children: [
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => PresentStudents(
                                //           title: true,
                                //           data: value.studentAttendance.attendanceTaken),
                                //     ));
                              },
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Present \n students",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Builder(builder: (context) {
                                    try {
                                      var percent = (int.parse(value
                                                  .studentAttendance
                                                  .totalPresent
                                                  .toString()) /
                                              int.parse(value.studentAttendance
                                                  .totalStudents
                                                  .toString())) *
                                          100;
                                      if (percent.isNaN) {
                                        return const Text("0.0 %");
                                      } else {
                                        return Text(
                                            percent.toStringAsFixed(2) + "%");
                                      }
                                    } on Exception catch (e) {
                                      return Text('N/A');
                                      // TODO
                                    }
                                  })
                                ],
                              )),
                            )),
                            Container(
                              width: 2,
                              color: Colors.grey.shade300,
                            ),
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PresentStudents(
                                          title: false,
                                          data: value.studentAttendance
                                              .attendanceTaken),
                                    ));
                              },
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Today's\nAttendance",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(isLoading(value
                                          .studentAttendanceStatsApiResponse)
                                      ? "--"
                                      : value.studentAttendance
                                                  .totalAttendance ==
                                              null
                                          ? "0"
                                          : value
                                              .studentAttendance.totalAttendance
                                              .toString())
                                ],
                              )),
                            )),
                            Container(
                              width: 2,
                              color: Colors.grey.shade300,
                            ),
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CancelledClass(
                                          data: value.studentAttendance
                                              .attendanceNotTaken),
                                    ));
                              },
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("Remaining\nAttendance",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(isLoading(value
                                            .studentAttendanceStatsApiResponse)
                                        ? "--"
                                        : value.studentAttendance
                                                    .remainingAttendance ==
                                                null
                                            ? "0"
                                            : value.studentAttendance
                                                .remainingAttendance
                                                .toString())
                                  ],
                                ),
                              ),
                            )),
                            Container(
                              width: 2,
                              color: Colors.grey.shade300,
                            ),
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AbsentStudents(
                                            data: value.allAbsentStudents)));
                              },
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Absent \n Students",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  isLoading(
                                          value.absentStudentsReportApiResponse)
                                      ? Text("--")
                                      : Text(value.allAbsentStudents == null
                                          ? "0"
                                          : value.allAbsentStudents.length
                                              .toString()),
                                ],
                              )),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Future<void> scanQR(LecturerCommonViewModel lectureVM) async {
    String barcodeScanRes;
    DateTime now = DateTime.now();

    DateTime checkSecond = DateTime.now();

    var formattedTime = DateFormat('yyyy-MM-ddTHH:mm:ss').format(now);

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      String institutionParameter = barcodeScanRes.split('institution=')[1];
      String institutionName = institutionParameter.split('?')[0];
      var extractDate = barcodeScanRes.toString().split("?");

      if (institutionName == user?.institution) {
        String dateString = extractDate[1];

        DateTime date1 = DateTime.parse(DateFormat('yyyy-MM-ddTHH:mm:ss')
            .format(DateTime.parse(dateString)));
        DateTime date2 = DateTime.parse(formattedTime);

        int staffAttendanceQRScanRefresh =
            lectureVM.routinePreference.refreshTime ?? 60;

        bool isAfterDate = date2.isAfter(date1);
        bool isBeforeDate = date2.isBefore(
            date1.add(Duration(seconds: staffAttendanceQRScanRefresh)));
        bool isSameDate = date2.isAtSameMomentAs(date1) ||
            date2.isAtSameMomentAs(
                date1.add(Duration(seconds: staffAttendanceQRScanRefresh)));

        if ((isAfterDate && isBeforeDate) || isSameDate) {
          hitAttendance().then((_) {
            // _punchService.checkPunchStatus(context);
          });
        } else {
          Fluttertoast.showToast(msg: "Please scan a valid QR code.", backgroundColor: Colors.red);
        }
      } else{
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
            msg: res.message.toString(),
            backgroundColor: Colors.green,
            toastLength: Toast.LENGTH_SHORT,
            textColor: Colors.white);
      } else {
        Fluttertoast.showToast(
            msg: res.message.toString(),
            backgroundColor: Colors.green,
            toastLength: Toast.LENGTH_SHORT,
            textColor: Colors.white);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white);
    }
  }
}

class CircleButton extends StatelessWidget {
  final IconData icon;
  final GestureTapCallback onPressed;
  const CircleButton({Key? key, required this.icon, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: kPrimaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
