// import 'dart:convert';
// import 'dart:math';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:schoolworkspro_app/Screens/lecturer/attendance/all_attendance_view_model.dart';
// import 'package:schoolworkspro_app/Screens/prinicpal/staff_attendance/singlephoto_view.dart';
// import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
// import 'package:schoolworkspro_app/api/api.dart';
// import 'package:schoolworkspro_app/attendance_view_model.dart';
// import 'package:schoolworkspro_app/common_view_model.dart';
// import 'package:schoolworkspro_app/components/shimmer.dart';
// import 'package:schoolworkspro_app/constants.dart';
// import 'package:schoolworkspro_app/request/lecturer/studentattendance_request.dart';
// import 'package:schoolworkspro_app/response/lecturer/check_attendance.dart';
// import 'package:schoolworkspro_app/response/lecturer/createnew_attendanceresponse.dart';
// import 'package:schoolworkspro_app/response/lecturer/getbatch_response.dart';
// import 'package:schoolworkspro_app/response/lecturer/getstudent_batchresponse.dart';
// import 'package:schoolworkspro_app/services/lecturer/get_attendanceservice.dart';
// import 'package:schoolworkspro_app/services/lecturer/getstudent_service.dart';
// import 'package:schoolworkspro_app/services/lecturer/post_attendanceservice.dart';
// import 'package:shimmer/shimmer.dart';
//
// import '../../../config/api_response_config.dart';
//
// // class AllAttendanceScreen extends StatefulWidget {
// //   List<dynamic> modules;
// //   AllAttendanceScreen({Key? key, required this.modules}) : super(key: key);
// //
// //   @override
// //   _AllAttendanceScreenState createState() => _AllAttendanceScreenState();
// // }
// //
// // class _AllAttendanceScreenState extends State<AllAttendanceScreen> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return ChangeNotifierProvider(
// //       create: (_) => AttendanceViewModel(),
// //       child: AllAttendanceBody(modules: widget.modules),
// //     );
// //   }
// // }
//
// class AllAttendanceBody extends StatefulWidget {
//   List<dynamic> modules;
//   AllAttendanceBody({Key? key, required this.modules})
//       : super(key: key);
//
//   @override
//   _AllAttendanceBodyState createState() => _AllAttendanceBodyState();
// }
//
// class _AllAttendanceBodyState extends State<AllAttendanceBody> {
//   List<Color> _colors = [];
//   List<Color> _colors2 = [];
//   bool _value = false;
//   int val = 1;
//   String? selected_batchOneTime;
//   String? selected_module;
//   String? selected_batchSubjectWise;
//   late AttendanceViewModel _provider;
//   late CommonViewModel _provider2;
//   String? _myclass;
//   List<dynamic> _presentStudents = <dynamic>[];
//   List<dynamic> _absentStudents = <dynamic>[];
//   final TextEditingController date_controller =
//       new TextEditingController();
//   final TextEditingController present_controller =
//       new TextEditingController();
//   final TextEditingController absent_controller =
//       new TextEditingController();
//   late Future<GetStudentByBatchResponse> student_response;
//   List<dynamic> _list = <dynamic>[];
//   List<dynamic> _listForDisplay = <dynamic>[];
//
//   List<dynamic> _list2 = <dynamic>[];
//   List<dynamic> _listForDisplay2 = <dynamic>[];
//   final TextEditingController present_controller2 =
//       new TextEditingController();
//   final TextEditingController absent_controller2 =
//       new TextEditingController();
//   List<dynamic> _presentStudents2 = <dynamic>[];
//   List<dynamic> _absentStudents2 = <dynamic>[];
//
//   late GetBatchResponse Selectedbatches;
//
//   Icon cusIcon = Icon(Icons.search);
//   late Widget cusSearchBar;
//   Icon cusIcon2 = Icon(Icons.search);
//   late Widget cusSearchBar2;
//   final TextEditingController _searchController =
//       TextEditingController();
//   final TextEditingController _searchController2 =
//       TextEditingController();
//
//   late CheckAttendanceResponse check_attendance;
//   late Stream<CheckAttendanceResponse> check_attendance2;
//   @override
//   void initState() {
//     // TODO: implement initState
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       // _provider2 =
//       Provider.of<CommonViewModel>(context, listen: false)
//           .fetchBatches();
//       // _provider2.setSlug(widget.moduleSlug);
//       // _provider2.fetchBatches();
//
//       // _provider =
//       Provider.of<AttendanceViewModel>(context, listen: false)
//           .fetchclass();
//       // _provider;
//
//       // Provider.of<AllAttendanceViewModel>(context, listen: false)
//       //     .fetchAttendanceStatus(
//       //         const Duration(milliseconds: 200),
//       //         selected_module.toString(),
//       //         selected_batchSubjectWise.toString());
//
//       // Provider.of<AllAttendanceViewModel>(context, listen: false)
//       //     .fetchAttendanceStatus(
//       //     const Duration(milliseconds: 200),
//       //     'school',
//       //     _myclass.toString());
//     });
//

//     cusSearchBar2 = const Text(
//       "Attendance",
//       style: TextStyle(color: Colors.black),
//     );
//
//     // check_attendance = GetAttendanceService()
//     //     .getRefreshCheckIfAttendance(
//     //         const Duration(milliseconds: 200),
//     //         selected_module.toString(),
//     //         selected_batchSubjectWise.toString());
//     setDate();
//     super.initState();
//   }
//

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           iconTheme: const IconThemeData(
//             color: Colors.black, //change your color here
//           ),
//           actions: [
//             val == 1
//                 ? IconButton(
//                     onPressed: () {
//                       setState(() {
//                         if (this.cusIcon.icon == Icons.search) {
//                           this.cusIcon = Icon(
//                             Icons.cancel,
//                             color: Colors.grey,
//                           );
//                           this.cusSearchBar = TextField(
//                             autofocus: true,
//                             textInputAction: TextInputAction.go,
//                             controller: _searchController,
//                             decoration: const InputDecoration(
//                                 hintStyle:
//                                     TextStyle(color: Colors.black),
//                                 border: InputBorder.none,
//                                 hintText: "Search by name..."),
//                             onChanged: (text) {
//                               setState(() {
//                                 _listForDisplay = _list.where((list) {
//                                   var name = list['firstname'] +
//                                       ' ' +
//                                       list['lastname'];
//                                   var itemName = name.toLowerCase();
//                                   return itemName.contains(text);
//                                 }).toList();
//                               });
//                             },
//                           );
//                         } else {
//                           this.cusIcon = Icon(Icons.search);
//                           _listForDisplay = _list;
//                           _searchController.clear();
//                           this.cusSearchBar = Text(
//                             "Attendance",
//                             style: TextStyle(color: Colors.black),
//                           );
//                         }
//                       });
//                     },
//                     icon: cusIcon)
//                 : IconButton(
//                     onPressed: () {
//                       setState(() {
//                         if (this.cusIcon2.icon == Icons.search) {
//                           this.cusIcon2 = Icon(
//                             Icons.cancel,
//                             color: Colors.grey,
//                           );
//                           this.cusSearchBar2 = TextField(
//                             autofocus: true,
//                             textInputAction: TextInputAction.go,
//                             controller: _searchController2,
//                             decoration: const InputDecoration(
//                                 hintStyle:
//                                     TextStyle(color: Colors.black),
//                                 border: InputBorder.none,
//                                 hintText: "Search by name..."),
//                             onChanged: (text) {
//                               setState(() {
//                                 _listForDisplay2 =
//                                     _list2.where((list) {
//                                   var name = list['firstname'] +
//                                       ' ' +
//                                       list['lastname'];
//                                   var itemName = name.toLowerCase();
//                                   return itemName.contains(text);
//                                 }).toList();
//                               });
//                             },
//                           );
//                         } else {
//                           this.cusIcon2 = Icon(Icons.search);
//                           _listForDisplay2 = _list2;
//                           _searchController2.clear();
//                           this.cusSearchBar = Text(
//                             "Attendance",
//                             style: TextStyle(color: Colors.black),
//                           );
//                         }
//                       });
//                     },
//                     icon: cusIcon2)
//           ],
//           backgroundColor: Colors.white,
//           elevation: 0.0,
//           title: val == 1 ? cusSearchBar : cusSearchBar2,
//         ),
//         body: Consumer3<CommonViewModel, AttendanceViewModel,
//                 AllAttendanceViewModel>(
//             builder: (context, common, attendance, snapshot, child) {
//           // print( common.batchArr);
//           // print(snapshot!.getAttendance.attendanceStatus );
//           return ListView(
//             physics: const ScrollPhysics(),
//             shrinkWrap: true,
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: ListTile(
//                       title: const Text("One time attendance"),
//                       leading: Radio(
//                         value: 1,
//                         groupValue: val,
//                         onChanged: (value) {
//                           setState(() {
//                             print(val);
//                             val = value as int;
//                           });
//                         },
//                         activeColor: Colors.green,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: ListTile(
//                       title: const Text("Subject wise attendance"),
//                       leading: Radio(
//                         value: 2,
//                         groupValue: val,
//                         onChanged: (value) {
//                           setState(() {
//                             print(val);
//                             val = value as int;
//                           });
//                         },
//                         activeColor: Colors.green,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               val == 1
//                   ? Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                           width: double.infinity,
//                           child: ListView(
//                             shrinkWrap: true,
//                             physics: const ScrollPhysics(),
//                             children: [
//                               attendance.classes.isEmpty
//                                   ? const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         "You need to be a class teacher to do this attendance",
//                                         style: TextStyle(
//                                             color: Colors.red,
//                                             fontSize: 15),
//                                       ),
//                                     )
//                                   : Padding(
//                                       padding:
//                                           const EdgeInsets.all(8.0),
//                                       child: DropdownButtonFormField(
//                                         isExpanded: true,
//                                         decoration:
//                                             const InputDecoration(
//                                           enabledBorder:
//                                               OutlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Colors
//                                                           .black38)),
//                                           focusedBorder:
//                                               OutlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Colors
//                                                           .black38)),
//                                           border:
//                                               OutlineInputBorder(),
//                                           filled: true,
//                                           hintText: 'Select class',
//                                         ),
//                                         icon: const Icon(Icons
//                                             .arrow_drop_down_outlined),
//                                         items: attendance.classes
//                                             .map((item) {
//                                           return DropdownMenuItem(
//                                             child: Text(
//                                               item,
//                                               overflow: TextOverflow
//                                                   .ellipsis,
//                                             ),
//                                             value: item,
//                                           );
//                                         }).toList(),
//                                         onChanged: (newVal) async {
//                                           setState(() {
//                                             _myclass =
//                                                 newVal as String?;
//                                             _listForDisplay.clear();
//                                             _presentStudents.clear();
//                                             _absentStudents.clear();
//                                             _list.clear();
//                                             // setState(() {
//
//                                             print("you are goood");
//
//                                             // Provider.of<AllAttendanceViewModel>(context, listen: false)
//                                             //     .fetchAttendanceStatus(
//                                             //     const Duration(milliseconds: 200),
//                                             //     selected_module.toString(),
//                                             //     selected_batchSubjectWise.toString());
//                                           });
//
//                                           snapshot
//                                               .fetchAttendanceStatus(
//                                                   const Duration(
//                                                       milliseconds:
//                                                           200),
//                                                   'School',
//                                                   _myclass
//                                                       .toString());
//
//                                           final data =
//                                               await StudentFetchService()
//                                                   .getAllStudent(
//                                                       _myclass
//                                                           .toString());
//
//                                           if (data.students != null) {
//                                             _colors = List.generate(
//                                                 data.students!.length,
//                                                 (index) => Color(Random()
//                                                         .nextInt(
//                                                             0xfffff400))
//                                                     .withAlpha(
//                                                         0xffff));
//
//                                             // if(data.students!.length > 0){
//                                             setState(() {
//                                               common.setHasStudent(
//                                                   true);
//                                             });
//
//                                             for (int i = 0;
//                                                 i <
//                                                     data.students!
//                                                         .length;
//                                                 i++) {
//                                               setState(() {
//                                                 _list.add(data
//                                                     .students![i]);
//                                                 _listForDisplay =
//                                                     _list;
//                                                 _presentStudents.add(
//                                                     data.students![i]
//                                                         ['username']);
//
//                                                 present_controller
//                                                         .text =
//                                                     "Present Students: ${_presentStudents.length.toString()}";
//                                                 absent_controller
//                                                         .text =
//                                                     "Absent Students: ${_absentStudents.length.toString()}";
//
//                                               });
//                                             }
//                                           } else {
//                                             setState(() {
//                                               common.setHasStudent(
//                                                   false);
//                                             });
//                                           }
//                                         },
//                                         value: _myclass,
//                                       ),
//                                     ),

//                               snapshot.getAttendance == false
//                                   ? common.hasStudent == false
//                                       ? Center(
//                                           child: Column(
//                                             children: [
//                                               Image.asset(
//                                                   'assets/images/no_content.PNG'),
//                                             ],
//                                           ),
//                                         )
//                                       :
//                                       //condition for attendance
//                                       ListView.builder(
//                                           shrinkWrap: true,
//                                           physics:
//                                               const NeverScrollableScrollPhysics(),
//                                           itemBuilder:
//                                               (context, index) {
//                                             return _listItem(index);
//                                           },
//                                           itemCount:
//                                               _listForDisplay.length,
//                                         )
//                                   : Column(
//                                       children: [
//                                         Padding(
//                                           padding:
//                                               const EdgeInsets.all(
//                                                   8.0),
//                                           child: Container(
//                                             color: Colors
//                                                 .orange.shade200,
//                                             height: 50,
//                                             child: Center(
//                                               child: Text(
//                                                 "Attendance already taken for this module",
//                                                 style: TextStyle(
//                                                     fontSize: 16,
//                                                     color:
//                                                         Colors.black,
//                                                     fontWeight:
//                                                         FontWeight
//                                                             .bold),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         ElevatedButton(
//                                             onPressed: () async {},
//                                             child: Text(
//                                                 "View Attendance"))
//                                       ],
//                                     ),
//                               snapshot.getAttendance == false
//                                   ? common.hasStudent == false
//                                       ? SizedBox()
//                                       : ElevatedButton(
//                                           onPressed: () async {
//                                             try {
//                                               final request =
//                                                   StudentAttendanceRequest(
//                                                       batch: _myclass,
//                                                       absentStudents:
//                                                           _absentStudents,
//                                                       moduleSlug: '',
//                                                       presentStudents:
//                                                           _presentStudents);
//                                               CreateNewAttendanceResponse
//                                                   response =
//                                                   await PostAttendanceService()
//                                                       .addnewAttendance(
//                                                 request,
//                                               );
//
//                                               print(jsonEncode(
//                                                   request));
//                                               if (response.success ==
//                                                   true) {
//                                                 snackThis(
//                                                   context: context,
//                                                   content: Text(
//                                                       "${response.message}"),
//                                                   color: Colors.green,
//                                                 );
//                                                 snapshot.fetchAttendanceStatus(
//                                                     const Duration(
//                                                         milliseconds:
//                                                             200),
//                                                     'School',
//                                                     _myclass
//                                                         .toString());
//                                               } else {
//                                                 snackThis(
//                                                   context: context,
//                                                   content: Text(
//                                                       "${response.message}"),
//                                                   color: Colors.green,
//                                                 );
//                                               }
//                                             } catch (e) {
//                                               print('this is error' +
//                                                   e.toString());
//                                               Fluttertoast.showToast(
//                                                   msg: e.toString());
//                                             }
//                                           },
//                                           child: Text("Submit"))
//                                   : SizedBox()
//                             ],
//                           )),
//                     )
//                   : Container(
//                       width: double.infinity,
//                       child: ListView(
//                         shrinkWrap: true,
//                         physics: const ScrollPhysics(),
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: DropdownButtonFormField(
//                               isExpanded: true,
//                               decoration: const InputDecoration(
//                                 enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Colors.black38)),
//                                 focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Colors.black38)),
//                                 border: OutlineInputBorder(),
//                                 filled: true,
//                                 hintText: 'Select class',
//                               ),
//                               icon: const Icon(
//                                   Icons.arrow_drop_down_outlined),
//                               items: widget.modules.map((item) {
//                                 return DropdownMenuItem(
//                                   child: Text(
//                                     item['moduleTitle'],
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   value: item['moduleSlug'],
//                                 );
//                               }).toList(),
//                               onChanged: (newVal) async {
//                                 setState(() {
//                                   selected_module = newVal as String?;
//
//                                   common
//                                       .fetchBatcheOneTimeAttendanceCheck(
//                                           selected_module.toString());
//
//                                   selected_batchSubjectWise = null;
//
//                                   _listForDisplay2.clear();
//                                   _presentStudents2.clear();
//                                   _absentStudents2.clear();
//                                   _list2.clear();
//                                   // _listForDisplay.clear();
//                                   // _presentStudents.clear();
//                                   // _absentStudents.clear();
//                                   // _list.clear();
//                                   // moduleSlug = newVal;
//                                 });
//
//                                 // Provider.of<AllAttendanceViewModel>(
//                                 //         context,
//                                 //         listen: false)
//                                 //     .fetchAttendanceStatus(
//                                 //         const Duration(
//                                 //             milliseconds: 200),
//                                 //         'school',
//                                 //         _myclass.toString());
//                               },
//                               value: selected_module,
//                             ),
//                           ),
//                           isLoading(common.checkIfOnTimeApiResponse)
//                               ? Shimmer.fromColors(
//                                   baseColor: Colors.grey,
//                                   highlightColor: Colors.white,
//                                   child: Container())
//                               : common.oneTimeBatch.isEmpty
//                                   ? const Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 12.0),
//                                       child: Text(
//                                         "No batch/section available for this subject",
//                                         style: TextStyle(
//                                             fontSize: 15,
//                                             color: Colors.red),
//                                       ),
//                                     )
//                                   : Padding(
//                                       padding:
//                                           const EdgeInsets.all(8.0),
//                                       child: DropdownButtonFormField(
//                                         isExpanded: true,
//                                         decoration:
//                                             const InputDecoration(
//                                           enabledBorder:
//                                               OutlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Colors
//                                                           .black38)),
//                                           focusedBorder:
//                                               OutlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Colors
//                                                           .black38)),
//                                           border:
//                                               OutlineInputBorder(),
//                                           filled: true,
//                                           hintText:
//                                               'Select batch/section',
//                                         ),
//                                         icon: const Icon(Icons
//                                             .arrow_drop_down_outlined),
//                                         items: common.oneTimeBatch
//                                             .map((item) {
//                                           return DropdownMenuItem(
//                                             child: Text(
//                                               item,
//                                               overflow: TextOverflow
//                                                   .ellipsis,
//                                             ),
//                                             value: item,
//                                           );
//                                         }).toList(),
//                                         onChanged: (newVal) async {
//                                           setState(() {
//                                             selected_batchSubjectWise =
//                                                 newVal as String?;
//                                             _listForDisplay2.clear();
//                                             _presentStudents2.clear();
//                                             _absentStudents2.clear();
//                                             _list2.clear();
//                                           });
//
//                                           Provider.of<AllAttendanceViewModel>(
//                                                   context,
//                                                   listen: false)
//                                               .fetchAttendanceStatus(
//                                                   const Duration(
//                                                       milliseconds:
//                                                           200),
//                                                   selected_module
//                                                       .toString(),
//                                                   selected_batchSubjectWise
//                                                       .toString());
//
//                                           // GetAttendanceService()
//                                           //     .getRefreshCheckIfAttendance(
//                                           //         const Duration(
//                                           //             milliseconds:
//                                           //                 200),
//                                           //         selected_module
//                                           //             .toString(),
//                                           //         selected_batchSubjectWise
//                                           //             .toString());
//
//                                           final data =
//                                               await StudentFetchService()
//                                                   .getAllStudent(
//                                                       selected_batchSubjectWise
//                                                           .toString());
//
//                                           if (data.students != null) {
//                                             _colors2 = List.generate(
//                                                 data.students!.length,
//                                                 (index) => Color(Random()
//                                                         .nextInt(
//                                                             0xfffff400))
//                                                     .withAlpha(
//                                                         0xffff));
//                                             for (int i = 0;
//                                                 i <
//                                                     data.students!
//                                                         .length;
//                                                 i++) {
//                                               setState(() {
//                                                 common.setHasStudent(
//                                                     true);
//                                                 _list2.add(data
//                                                     .students![i]);
//                                                 _listForDisplay2 =
//                                                     _list2;
//                                                 _presentStudents2.add(
//                                                     data.students![i]
//                                                         ['username']);
//
//                                                 present_controller2
//                                                         .text =
//                                                     "Present Students: ${_presentStudents2.length.toString()}";
//                                                 absent_controller2
//                                                         .text =
//                                                     "Absent Students: ${_absentStudents2.length.toString()}";
//                                               });
//                                             }
//                                           } else {
//                                             setState(() {
//                                               common.setHasStudent(
//                                                   false);
//                                             });
//                                           }
//                                         },
//                                         value:
//                                             selected_batchSubjectWise,
//                                       ),
//                                     ),
//
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: TextFormField(
//                               enabled: false,
//                               controller: date_controller,
//                               keyboardType: TextInputType.datetime,
//                               decoration: const InputDecoration(
//                                 hintText: "Today's Date",
//                                 filled: true,
//                                 enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Colors.black38)),
//                                 focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Colors.black38)),
//                                 floatingLabelBehavior:
//                                     FloatingLabelBehavior.always,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10.0),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: TextFormField(
//                                     enabled: false,
//                                     controller: present_controller2,
//                                     keyboardType:
//                                         TextInputType.datetime,
//                                     decoration: const InputDecoration(
//                                       hintText: "present students: 0",
//                                       filled: true,
//                                       enabledBorder:
//                                           OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: Colors
//                                                       .black38)),
//                                       focusedBorder:
//                                           OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: Colors
//                                                       .black38)),
//                                       floatingLabelBehavior:
//                                           FloatingLabelBehavior
//                                               .always,
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 Expanded(
//                                   child: TextFormField(
//                                     enabled: false,
//                                     controller: absent_controller2,
//                                     keyboardType:
//                                         TextInputType.datetime,
//                                     decoration: const InputDecoration(
//                                       hintText: "Absent students: 0",
//                                       filled: true,
//                                       enabledBorder:
//                                           OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: Colors
//                                                       .black38)),
//                                       focusedBorder:
//                                           OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: Colors
//                                                       .black38)),
//                                       floatingLabelBehavior:
//                                           FloatingLabelBehavior
//                                               .always,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // StreamBuilder<CheckAttendanceResponse>(
//                           //   stream: check_attendance,
//                           //   builder: (context, snapshot) {
//                           //     if (snapshot.hasData) {
//                           //       return
//                           snapshot.getAttendance == false
//                               ? common.hasStudent == false
//                                   ? Center(
//                                       child: Column(
//                                         children: [
//                                           Image.asset(
//                                               'assets/images/no_content.PNG'),
//                                         ],
//                                       ),
//                                     )
//                                   : _listForDisplay2.isEmpty
//                                       ? Column(
//                                           children: [
//                                             ...List.generate(
//                                               10,
//                                               (index) => Padding(
//                                                 padding:
//                                                     const EdgeInsets
//                                                             .symmetric(
//                                                         vertical:
//                                                             8.0),
//                                                 child: CustomShimmer
//                                                     .rectangular(
//                                                   height: 50,
//                                                   width:
//                                                       double.infinity,
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         )
//                                       : Column(
//                                           children: [
//                                             ListView.builder(
//                                               shrinkWrap: true,
//                                               physics:
//                                                   const NeverScrollableScrollPhysics(),
//                                               itemBuilder:
//                                                   (context, index) {
//                                                 return _listItem2(
//                                                     index);
//                                               },
//                                               itemCount:
//                                                   _listForDisplay2
//                                                       .length,
//                                             ),
//                                             ElevatedButton(
//                                                 style: ElevatedButton
//                                                     .styleFrom(
//                                                         primary: Colors
//                                                             .green),
//                                                 onPressed: () async {
//                                                   try {
//                                                     final request = StudentAttendanceRequest(
//                                                         batch:
//                                                             selected_batchSubjectWise,
//                                                         absentStudents:
//                                                             _absentStudents2,
//                                                         moduleSlug:
//                                                             selected_module,
//                                                         presentStudents:
//                                                             _presentStudents2);
//                                                     CreateNewAttendanceResponse
//                                                         response =
//                                                         await PostAttendanceService()
//                                                             .addnewAttendance(
//                                                       request,
//                                                     );
//                                                     if (response
//                                                             .success ==
//                                                         true) {
//                                                       snackThis(
//                                                         context:
//                                                             context,
//                                                         content: Text(
//                                                             "${response.message}"),
//                                                         color: Colors
//                                                             .green,
//                                                       );
//                                                       Provider.of<
//                                                                   AllAttendanceViewModel>(
//                                                               context,
//                                                               listen:
//                                                                   false)
//                                                           .fetchAttendanceStatus(
//                                                               const Duration(
//                                                                   milliseconds:
//                                                                       200),
//                                                               selected_module
//                                                                   .toString(),
//                                                               selected_batchSubjectWise
//                                                                   .toString());
//                                                     } else {
//                                                       snackThis(
//                                                         context:
//                                                             context,
//                                                         content: Text(
//                                                             "${response.message}"),
//                                                         color: Colors
//                                                             .green,
//                                                       );
//                                                     }
//                                                   } catch (e) {
//                                                     print('this is error' +
//                                                         e.toString());
//                                                     Fluttertoast
//                                                         .showToast(
//                                                             msg: e
//                                                                 .toString());
//                                                   }
//                                                 },
//                                                 child: Text("Submit"))
//                                           ],
//                                         )
//                               : Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Container(
//                                     color: Colors.orange.shade200,
//                                     height: 50,
//                                     child: Center(
//                                       child: Text(
//                                         "Attendance already taken for this module",
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             color: Colors.black,
//                                             fontWeight:
//                                                 FontWeight.bold),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//
//                           //   }
//                           //   else if (snapshot.hasError) {
//                           //     return Text('${snapshot.error}');
//                           //   } else {
//                           //     return const Center(
//                           //       child: SpinKitDualRing(
//                           //         color: kPrimaryColor,
//                           //       ),
//                           //     );
//                           //   }
//                           // }
//                           // ),
//                         ],
//                       ),
//                     )
//             ],
//           );
//         }));
//   }
//

//   _listItem2(index) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Card(
//           child: ListTile(
//             leading: CircleAvatar(
//                 radius: 25.0,
//                 backgroundColor: _colors2.length > 0
//                     ? _colors2[index]
//                     : Colors.grey,
//                 child: _listForDisplay2[index]['userImage'] == null ||
//                         _listForDisplay2[index]['userImage'].isEmpty
//                     ? Text(
//                         _listForDisplay2[index]['firstname']
//                                 .toString()[0]
//                                 .toUpperCase() +
//                             "" +
//                             _listForDisplay2[index]['lastname']
//                                 .toString()[0]
//                                 .toUpperCase(),
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       )
//                     : ClipOval(
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (_) {
//                                       return SingleImageViewer(
//                                         imageIndex: 0,
//                                         imageList:
//                                             _listForDisplay2[index]
//                                                     ['userImage']
//                                                 .toString(),
//                                       );
//                                     },
//                                     fullscreenDialog: true));
//                           },
//                           child: Container(
//                             height: 100,
//                             width: 100,
//                             child: CachedNetworkImage(
//                               fit: BoxFit.fill,
//                               imageUrl: api_url2 +
//                                   '/uploads/users/' +
//                                   _listForDisplay2[index]['userImage']
//                                       .toString(),
//                               placeholder: (context, url) => Container(
//                                   child: const Center(
//                                       child:
//                                           CupertinoActivityIndicator())),
//                               errorWidget: (context, url, error) =>
//                                   const Icon(Icons.error),
//                             ),
//                           ),
//                         ),
//                       )),
//             title: Builder(builder: (context) {
//               var name = _listForDisplay2[index]['firstname'] +
//                   " " +
//                   _listForDisplay2[index]['lastname'];
//               return RichText(
//                 text: TextSpan(
//                   text: 'Name: ',
//                   style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold),
//                   children: <TextSpan>[
//                     TextSpan(
//                       text: name.toString(),
//                       style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.black,
//                           fontWeight: FontWeight.normal),
//                     ),
//                   ],
//                 ),
//               );
//             }),
//             subtitle: RichText(
//               text: TextSpan(
//                 text: 'Student Id: ',
//                 style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold),
//                 children: <TextSpan>[
//                   TextSpan(
//                     text: _listForDisplay2[index]['username']
//                         .toString(),
//                     style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.black,
//                         fontWeight: FontWeight.normal),
//                   ),
//                 ],
//               ),
//             ),
//             trailing: Checkbox(
//               value: _presentStudents2
//                   .contains(_listForDisplay2[index]['username']),
//               activeColor: Colors.green,
//               onChanged: (value) {
//                 setState(() {
//                   if (value!) {
//                     _presentStudents2
//                         .add(_listForDisplay2[index]['username']);
//                     _absentStudents2.removeWhere((element) =>
//                         element ==
//                         _listForDisplay2[index]['username']);
//
//                     print(_presentStudents2);
//                   } else {
//                     print(_absentStudents2);
//
//                     _absentStudents2
//                         .add(_listForDisplay2[index]['username']);
//                     _presentStudents2
//                         .remove(_listForDisplay2[index]['username']);
//                   }
//                   setState(() {
//                     present_controller2.text =
//                         "Present Students: ${_presentStudents2.length.toString()}";
//                     absent_controller2.text =
//                         "Absent Students: ${_absentStudents2.length.toString()}";
//                   });
//                 });
//               },
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
