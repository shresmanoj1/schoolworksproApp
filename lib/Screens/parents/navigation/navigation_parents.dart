// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:schoolworkspro_app/Screens/dashboard/dasboard.dart';
// import 'package:schoolworkspro_app/Screens/events/event.dart';
// import 'package:schoolworkspro_app/Screens/more/more.dart';
// import 'package:schoolworkspro_app/Screens/my_learning/my_learning.dart';
// import 'package:schoolworkspro_app/Screens/notice/notice.dart';
// import 'package:schoolworkspro_app/Screens/parents/Dashboard_parent/dashboard_parent.dart';
// import 'package:schoolworkspro_app/Screens/parents/More_parent/more_parent.dart';
// import 'package:schoolworkspro_app/Screens/parents/Progress_parent/progress_parent.dart';
// import 'package:schoolworkspro_app/Screens/parents/Result-parent/result_parent.dart';
// import 'package:schoolworkspro_app/Screens/parents/Routine_parent/routine_parent.dart';
// import 'package:schoolworkspro_app/Screens/parents/navigation/customanimatedbuttombar.dart';
// import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
// import 'package:schoolworkspro_app/constants.dart';
// import 'package:schoolworkspro_app/request/fcm_request.dart';
// import 'package:schoolworkspro_app/response/parents/getchildren_response.dart';
// import 'package:schoolworkspro_app/services/login_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../response/login_response.dart';
//
// class Navigationparents extends StatefulWidget {
//   final int currentIndex;
//   final int ind;
//   final Getchildrenresponse data;
//   const Navigationparents(
//       {Key? key,
//       required this.currentIndex,
//       required this.data,
//       required this.ind})
//       : super(key: key);
//
//   @override
//   _NavigationparentsState createState() => _NavigationparentsState();
// }
//
// class _NavigationparentsState extends State<Navigationparents> {
//   int _currentindex = 0;
//   final _inactiveColor = Colors.grey;
//
//   User? user;
//   @override
//   void initState() {
//     // TODO: implement initState
//     // checkversion();
//     // checkbar();setSt
//     getData();
//     setState(() {
//       _currentindex = widget.currentIndex;
//     });
//     super.initState();
//   }
//
//   getData() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     String? userData = sharedPreferences.getString('_auth_');
//     Map<String, dynamic> userMap = json.decode(userData!);
//     User userD = User.fromJson(userMap);
//     setState(() {
//       user = userD;
//     });
//     try {
//       FirebaseMessaging.instance.getToken().then((value) async {
//         String? token = value;
//         print("fcm: " + token.toString());
//         final data = FcmTokenRequest(
//             username: user?.username.toString(),
//             batch: user?.batch.toString(),
//             type: user?.type.toString(),
//             institution: user?.institution.toString(),
//             token: token.toString());
//         final res = await LoginService().postFCM(data);
//         if (res.success == true) {
//           print("FCM token registered");
//         } else {
//           print("Error registering FCM token");
//         }
//       });
//     } on Exception catch (e) {
//       snackThis(
//           content: Text(e.toString()),
//           color: Colors.red,
//           behavior: SnackBarBehavior.fixed,
//           duration: 2,
//           context: context);
//       // TODO
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: getBody(), bottomNavigationBar: _buildBottomBar());
//   }
//
//   Widget _buildBottomBar() {
//     return CustomAnimatedBottomBar(
//       containerHeight: 70,
//       backgroundColor: Colors.white,
//       selectedIndex: _currentindex,
//       showElevation: true,
//       itemCornerRadius: 24,
//       curve: Curves.easeIn,
//       onItemSelected: (index) => setState(() => _currentindex = index),
//       items: <BottomNavyBarItem>[
//         BottomNavyBarItem(
//           icon: const Icon(Icons.apps),
//           title: const Text('Home'),
//           activeColor: kparentsdashboard,
//           inactiveColor: _inactiveColor,
//           textAlign: TextAlign.center,
//         ),
//         BottomNavyBarItem(
//           icon: const Icon(Icons.date_range),
//           title: const Text('Routine'),
//           activeColor: Colors.green,
//           inactiveColor: _inactiveColor,
//           textAlign: TextAlign.center,
//         ),
//         BottomNavyBarItem(
//           icon: const Icon(Icons.list),
//           title: const Text('More'),
//           activeColor: Colors.blue,
//           inactiveColor: _inactiveColor,
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }
//
//   Widget getBody() {
//     List<Widget> pages = [
//       Dashboardparent(
//         data: widget.data,
//         index: widget.ind,
//       ),
//       Routineparent(
//         index: widget.ind,
//         data: widget.data,
//       ),
//       Moreparent(
//         data: widget.data,
//         index: widget.ind,
//       ),
//     ];
//
//     return IndexedStack(
//       index: _currentindex,
//       children: pages,
//     );
//   }
// }
