// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:schoolworkspro_app/Screens/login/login.dart';
// import 'package:schoolworkspro_app/Screens/my_learning/tab_button.dart';
// import 'package:schoolworkspro_app/Screens/parents/More_parent/parent_fee/parentfees_screen.dart';
// import 'package:schoolworkspro_app/Screens/parents/More_parent/parent_request/parent_requestscreen.dart';
// import 'package:schoolworkspro_app/Screens/parents/More_parent/resuult_parent/result_parent.dart';
// import 'package:schoolworkspro_app/Screens/parents/components/tab_button_parents.dart';
// import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
// import 'package:schoolworkspro_app/constants.dart';
// import 'package:schoolworkspro_app/request/parent/attendance_request.dart';
// import 'package:schoolworkspro_app/request/parent/getfeesparent_request.dart';
// import 'package:schoolworkspro_app/request/parent/progress_request.dart';
// import 'package:schoolworkspro_app/response/addproject_response.dart';
// import 'package:schoolworkspro_app/response/login_response.dart';
// import 'package:schoolworkspro_app/response/parents/allprogress_response.dart';
// import 'package:schoolworkspro_app/response/parents/childattendance_response.dart';
// import 'package:schoolworkspro_app/response/parents/getchildren_response.dart';
// import 'package:schoolworkspro_app/services/login_service.dart';
// import 'package:schoolworkspro_app/services/parents/attendance_service.dart';
// import 'package:schoolworkspro_app/services/parents/getchildren_service.dart';
// import 'package:schoolworkspro_app/services/parents/getfeesparent_service.dart';
// import 'package:schoolworkspro_app/services/parents/progress_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class Moreparent extends StatefulWidget {
//   final Getchildrenresponse data;
//   final int index;
//   const Moreparent({Key? key, required this.data, required this.index})
//       : super(key: key);
//
//   @override
//   _MoreparentState createState() => _MoreparentState();
// }
//
// class _MoreparentState extends State<Moreparent> {
//   final bodyGlobalKey = GlobalKey();
//   Future<Addprojectresponse>? start_response;
//   late User user;
//   Future<AllProgressResponse>? progress_response;
//   Future<ChildAttendanceResponse>? attendance_response;
//   Future<Getchildrenresponse>? children_response;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // financialDataStart();
//     getdata();
//   }
//
//   // financialDataStart() async {
//   //   final data = GetFeesForParentsRequest(
//   //       studentId: widget.data.children?[widget.index].username.toString(),
//   //       institution:
//   //           widget.data.children?[widget.index].institution.toString());
//   //
//   //   start_response = ParentFeeService().financialDataStart(data);
//   // }
//
//   getdata() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     String? userData = sharedPreferences.getString('_auth_');
//     Map<String, dynamic> userMap = json.decode(userData!);
//     User userD = User.fromJson(userMap);
//     setState(() {
//       user = userD;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // if (user.institution == "sunway") {
//     //   final data = GetFeesForParentsRequest(
//     //       studentId: widget.data.children?[widget.index].email.toString(),
//     //       institution:
//     //           widget.data.children?[widget.index].institution.toString());
//     //
//     //   print('hello data' + jsonEncode(data));
//     //
//     //   start_response = ParentFeeService().financialDataStart(data);
//     // } else {
//     //   final data = GetFeesForParentsRequest(
//     //       studentId: widget.data.children?[widget.index].username.toString(),
//     //       institution:
//     //           widget.data.children?[widget.index].institution.toString());
//     //
//     //   print('data aayena' + jsonEncode(data));
//     //   start_response = ParentFeeService().financialDataStart(data);
//     // }
//
//     return Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: kparentsdashboard,
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 60.0),
//                     child: SizedBox(
//                       height: 130,
//                       width: 130,
//                       child: CircleAvatar(
//                           radius: 18,
//                           backgroundColor: Colors.grey,
//                           child: Text(
//                             user.firstname![0].toUpperCase() +
//                                 "" +
//                                 user.lastname![0].toUpperCase(),
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white),
//                           )),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     children: [
//                       Text(user.firstname! + "" + user.lastname!),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding:
//                       const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
//                   child: ListView(
//                     physics: const ScrollPhysics(),
//                     shrinkWrap: true,
//                     children: <Widget>[
//                       // Card(child: ListTile(title: Text('One-line ListTile'))),
//                       Card(
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.pushNamed(
//                                 context, '/parentchangepasswordscreen');
//                           },
//                           child: const ListTile(
//                             leading: Icon(Icons.lock),
//                             title: Text('Change Password'),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Card(
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) => Parentrequestscreen(
//                                       res: widget.data,
//                                       index: widget.index,
//                                     )));
//                           },
//                           child: ListTile(
//                             leading: Icon(Icons.sticky_note_2_outlined),
//                             title: Text('Request'),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Card(
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) => ParentFeeScreen(
//                                       institution: widget.data
//                                           .children?[widget.index].institution,
//                                       studentID: widget.data
//                                           .children?[widget.index].username,
//                                     )));
//                           },
//                           child: const ListTile(
//                             leading: Icon(Icons.monetization_on_outlined),
//                             title: Text('Fees'),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Card(
//                         child: GestureDetector(
//                           onTap: () async {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ResultParent(
//                                     institution: widget.data
//                                         .children?[widget.index].institution,
//                                     studentID: widget
//                                         .data.children?[widget.index].username,
//                                   ),
//                                 ));
//                           },
//                           child: const ListTile(
//                             leading: Icon(Icons.assessment),
//                             title: Text('Results'),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Card(
//                         child: GestureDetector(
//                           onTap: () async {
//                             final res = await LoginService().logout();
//                             if (res.success == true) {
//                               print(res);
//                               SharedPreferences sharedPreferences =
//                                   await SharedPreferences.getInstance();
//                               await sharedPreferences.clear();
//
//                               Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           const LoginScreen()));
//                             } else {
//                               snackThis(
//                                   context: context,
//                                   content: Text(res.success.toString()),
//                                   color: Colors.red,
//                                   duration: 1,
//                                   behavior: SnackBarBehavior.floating);
//                             }
//                           },
//                           child: ListTile(
//                             leading: Icon(Icons.logout),
//                             title: Text('Logout'),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
// }
