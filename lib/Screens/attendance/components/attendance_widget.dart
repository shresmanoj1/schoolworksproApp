// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:schoolworkspro_app/components/internetcheck.dart';
// import 'package:schoolworkspro_app/components/nointernet_widget.dart';
// import 'package:schoolworkspro_app/constants.dart';
// import 'package:schoolworkspro_app/response/attendance_response.dart';
// import 'package:schoolworkspro_app/services/attendance_service.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';
//
// class Attendancewidget extends StatefulWidget {
//   const Attendancewidget({Key? key}) : super(key: key);
//
//   @override
//   _AttendancewidgetState createState() => _AttendancewidgetState();
// }
//
// class _AttendancewidgetState extends State<Attendancewidget> {
//   Future<Attendanceresponse>? _attendance;
//   PageController pagecontroller = PageController();
//   int selectedIndex = 0;
//   String title = 'Overall Attendance';
//
//   bool connected = false;
//   @override
//   void initState() {
//     // TODO: implement initState
//     _attendance = Attendanceservice().getAttendance();
//     checkInternet();
//     super.initState();
//   }
//   checkInternet() async {
//     internetCheck().then((value) {
//       if (value) {
//         setState(() {
//           connected = true;
//         });
//       } else {
//         setState(() {
//           connected = false;
//         });
//         // snackThis(context: context,content: const Text("No Internet Connection"),duration: 10,color: Colors.red.shade500);
//         // Fluttertoast.showToast(msg: "No Internet connection");
//       }
//     });
//   }
//
//   _onPageChanged(int index) {
//     // onTap
//     setState(() {
//       selectedIndex = index;
//       switch (index) {
//         case 0:
//           {
//             title = 'Overall Attendance';
//           }
//           break;
//         case 1:
//           {
//             title = 'Absent days';
//           }
//           break;
//
//       }
//     });
//   }
//
//   _itemTapped(int selectedIndex) {
//     pagecontroller.jumpToPage(selectedIndex);
//     setState(() {
//       this.selectedIndex = selectedIndex;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return connected == false ? NoInternetWidget() : Container(
//       child:
//     );
//   }
// }
