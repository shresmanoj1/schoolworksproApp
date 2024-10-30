// import 'dart:convert';
// import 'dart:io';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:getwidget/components/list_tile/gf_list_tile.dart';
// import 'package:grouped_list/grouped_list.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:percent_indicator/percent_indicator.dart';
// import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/student_stats/tab_barlecturer.dart';
// import 'package:schoolworkspro_app/Screens/my_learning/tab_button.dart';
// import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
// import 'package:schoolworkspro_app/api/api.dart';
// import 'package:schoolworkspro_app/constants.dart';
// import 'package:schoolworkspro_app/request/lecturer/penalize_request.dart';
// import 'package:schoolworkspro_app/request/lecturer/progressstats_request.dart';
// import 'package:schoolworkspro_app/request/lecturer/stats_request.dart';
// import 'package:schoolworkspro_app/response/addproject_response.dart';
// import 'package:schoolworkspro_app/response/lecturer/getdisciplinaryforstats_response.dart';
// import 'package:schoolworkspro_app/response/lecturer/getdocument_stats_response.dart';
// import 'package:schoolworkspro_app/response/lecturer/getperformance_stats_response.dart';
// import 'package:schoolworkspro_app/response/lecturer/getprogressstats_response.dart';
// import 'package:schoolworkspro_app/response/lecturer/getsubmissionforstats_response.dart';
// import 'package:schoolworkspro_app/response/lecturer/getsubmissionquizforstats_response.dart';
// import 'package:schoolworkspro_app/services/lecturer/penalize_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../../../response/login_response.dart';
// import '../../../../services/lecturer/studentstats_service.dart';
//
// class StudentStatsPrincipalScreen extends StatefulWidget {
//   final data;
//   const StudentStatsPrincipalScreen({Key? key, this.data}) : super(key: key);
//
//   @override
//   _StudentStatsPrincipalScreenState createState() =>
//       _StudentStatsPrincipalScreenState();
// }
//
// class _StudentStatsPrincipalScreenState
//     extends State<StudentStatsPrincipalScreen> {
//   User? user;
//   int _selectedPage = 0;
//   int _subselectedPage = 0;
//   late PageController _pageController;
//   late PageController _subpageController;
//   Future<GetDocumentForStatsResponse>? document_response;
//   Future<GetProgressForStatsResponse>? progress_response;
//   Future<GetPerformanceForStatsResponse>? performance_response;
//   Future<GetSubmissionsForStatsResponse>? submission_response;
//   Future<GetSubmissionsQuizForStatsResponse>? quiz_response;
//   Future<GetDisciplinaryForStatsResponse>? disciplinary_response;
//
//   List<Complete> submissions = <Complete>[];
//   List<Complete> completed = <Complete>[];
//   List<Complete> incompleted = <Complete>[];
//   List<dynamic> quizData = <dynamic>[];
//   List<dynamic> quizCompleted = <dynamic>[];
//   List<dynamic> quizIncompleted = <dynamic>[];
//   bool penalizeVisibility = false;
//   PickedFile? _imageFile;
//   final _formKey = GlobalKey<FormState>();
//
//   final ImagePicker _picker = ImagePicker();
//   Future<void> _pickImage(ImageSource source) async {
//     var selected =
//         await ImagePicker().pickImage(source: source, imageQuality: 10);
//
//     setState(() {
//       if (selected != null) {
//         _imageFile = PickedFile(selected.path);
//       } else {
//         Fluttertoast.showToast(msg: 'No image selected.');
//       }
//     });
//   }
//
//   bool isLoading = false;
//
//   Widget bottomSheet(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
//       height: 100.0,
//       width: MediaQuery.of(context).size.width,
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       child: Column(
//         children: <Widget>[
//           const Text(
//             "choose photo",
//             style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               TextButton.icon(
//                 icon: const Icon(Icons.camera, color: Colors.red),
//                 onPressed: () async {
//                   _pickImage(ImageSource.camera);
//                   Navigator.of(context, rootNavigator: true).pop();
//                 },
//                 label: const Text("Camera"),
//               ),
//               TextButton.icon(
//                 icon: const Icon(Icons.image, color: Colors.green),
//                 onPressed: () {
//                   _pickImage(ImageSource.gallery);
//                   Navigator.of(context, rootNavigator: true).pop();
//                 },
//                 label: const Text("Gallery"),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   final TextEditingController _remarksController = new TextEditingController();
//
//   void _changePage(int pageNum) {
//     setState(() {
//       _selectedPage = pageNum;
//       _pageController.animateToPage(
//         pageNum,
//         duration: const Duration(milliseconds: 1000),
//         curve: Curves.fastLinearToSlowEaseIn,
//       );
//     });
//   }
//
//   void _changesubPage(int pageNum) {
//     setState(() {
//       _subselectedPage = pageNum;
//       _subpageController.animateToPage(
//         pageNum,
//         duration: const Duration(milliseconds: 1000),
//         curve: Curves.fastLinearToSlowEaseIn,
//       );
//     });
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     _subpageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     // getActivity();
//     _pageController = PageController();
//     _subpageController = PageController();
//
//     getData();
//
//     super.initState();
//   }
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   getData() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     String? userData = sharedPreferences.getString('_auth_');
//     Map<String, dynamic> userMap = json.decode(userData!);
//     User userD = User.fromJson(userMap);
//     setState(() {
//       user = userD;
//     });
//     final username = StudentStatsRequest(username: widget.data['username']);
//     final progressRequest = ProgressStatsRequest(
//         institution: widget.data['institution'], studentId: widget.data['_id']);
//     document_response =
//         StudentStatsLecturerService().getUserDocuments(username);
//
//     progress_response =
//         StudentStatsLecturerService().getUserProgress(progressRequest);
//
//     performance_response =
//         StudentStatsLecturerService().getUserPerformance(username);
//
//     // final datacheck = StudentStatsRequest(username: "210306");
//     //
//     // final test =
//     //     await StudentStatsLecturerService().getUserPerformance(datacheck);
//     //
//     //
//     //
//     // print('init test:::'+ jsonEncode(test));
//
//     final submisson_data = await StudentStatsLecturerService()
//         .getUsersSubmission(widget.data['username']);
//
//     quiz_response = StudentStatsLecturerService()
//         .getUsersSubmissionQuiz(widget.data['username']);
//
//     final quiz_data = await StudentStatsLecturerService()
//         .getUsersSubmissionQuiz(widget.data['username']);
//
//     for (int i = 0; i < quiz_data.allQuiz!.length; i++) {
//       for (int j = 0; j < quiz_data.allQuiz![i]['complete'].length; j++) {
//         setState(() {
//           quizCompleted.add(quiz_data.allQuiz![i]['complete'][j]);
//         });
//       }
//     }
//
//     for (int i = 0; i < quiz_data.allQuiz!.length; i++) {
//       for (int j = 0; j < quiz_data.allQuiz![i]['incomplete'].length; j++) {
//         setState(() {
//           quizCompleted.add(quiz_data.allQuiz![i]['incomplete'][j]);
//         });
//       }
//     }
//
//     for (int i = 0; i < submisson_data.complete!.length; i++) {
//       setState(() {
//         submissions.add(submisson_data.complete![i]);
//         completed.add(submisson_data.complete![i]);
//       });
//     }
//
//     for (int j = 0; j < submisson_data.incomplete!.length; j++) {
//       setState(() {
//         submissions.add(submisson_data.incomplete![j]);
//         incompleted.add(submisson_data.incomplete![j]);
//       });
//     }
//
//     disciplinary_response = StudentStatsLecturerService()
//         .getUsersDisciplinary(widget.data['username']);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading == true) {
//       context.loaderOverlay.show();
//     } else {
//       context.loaderOverlay.hide();
//     }
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//           title: Text(
//             widget.data['firstname'] + " " + widget.data['lastname'],
//             style: TextStyle(color: Colors.black),
//           ),
//           elevation: 0.0,
//           iconTheme: const IconThemeData(
//             color: Colors.black, //change your color here
//           ),
//           backgroundColor: Colors.white),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   TabButtonLecturer(
//                     text: "Info",
//                     pageNumber: 0,
//                     selectedPage: _selectedPage,
//                     onPressed: () {
//                       _changePage(0);
//                     },
//                   ),
//                   TabButtonLecturer(
//                     text: "Documents",
//                     pageNumber: 1,
//                     selectedPage: _selectedPage,
//                     onPressed: () {
//                       _changePage(1);
//                     },
//                   ),
//                   TabButtonLecturer(
//                     text: "Progress",
//                     pageNumber: 2,
//                     selectedPage: _selectedPage,
//                     onPressed: () {
//                       _changePage(2);
//                     },
//                   ),
//                   TabButtonLecturer(
//                     text: "Performance",
//                     pageNumber: 3,
//                     selectedPage: _selectedPage,
//                     onPressed: () {
//                       _changePage(3);
//                     },
//                   ),
//                   TabButtonLecturer(
//                     text: "Submissions",
//                     pageNumber: 4,
//                     selectedPage: _selectedPage,
//                     onPressed: () {
//                       _changePage(4);
//                     },
//                   ),
//                   TabButtonLecturer(
//                     text: "Disciplinary Act",
//                     pageNumber: 5,
//                     selectedPage: _selectedPage,
//                     onPressed: () {
//                       _changePage(5);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Divider(
//             height: 20,
//             thickness: 15,
//             indent: 3,
//             color: Colors.grey.shade100,
//           ),
//           Expanded(
//             child: PageView(
//               onPageChanged: (int page) {
//                 setState(() {
//                   _selectedPage = page;
//                 });
//               },
//               controller: _pageController,
//               children: [
//                 SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ListTile(
//                           leading: SizedBox(
//                             height: 100,
//                             width: 100,
//                             child: CircleAvatar(
//                                 radius: 20,
//                                 backgroundColor:
//                                     widget.data['userImage'] == null
//                                         ? Colors.grey
//                                         : Colors.white,
//                                 child: widget.data['userImage'] == null ||
//                                         widget.data['userImage'].isEmpty
//                                     ? Text(
//                                         widget.data['firstname'][0]
//                                                 .toUpperCase() +
//                                             "" +
//                                             widget.data['lastname'][0]
//                                                 .toUpperCase(),
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white),
//                                       )
//                                     : ClipOval(
//                                         clipBehavior: Clip.antiAlias,
//                                         child: CachedNetworkImage(
//                                           fit: BoxFit.fill,
//                                           imageUrl: api_url2 +
//                                               '/uploads/users/' +
//                                               widget.data['userImage'],
//                                           placeholder: (context, url) => Container(
//                                               child: const Center(
//                                                   child:
//                                                       CupertinoActivityIndicator())),
//                                           errorWidget: (context, url, error) =>
//                                               const Icon(Icons.error),
//                                         ),
//                                       )),
//                           ),
//                           title: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 widget.data['firstname'].toString() +
//                                     " " +
//                                     widget.data['lastname'].toString(),
//                                 style: const TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold),
//                               ),
//                               Chip(
//                                 backgroundColor: kPrimaryColor,
//                                 label: Text(
//                                   widget.data['batch'].toString(),
//                                   style: const TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Card(
//                           child: Container(
//                             width: double.infinity,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text("Joined on: " +
//                                       DateFormat('yMMMMEEEEd').format(
//                                           DateTime.parse(
//                                                   widget.data['createdAt'])
//                                               .add(const Duration(
//                                                   hours: 5, minutes: 45)))),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text("Email: " +
//                                       widget.data['email'].toString()),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text("Address: " +
//                                       widget.data['address'].toString()),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: RichText(
//                                     text: TextSpan(
//                                         text: 'Contact: ',
//                                         style: TextStyle(color: Colors.black),
//                                         children: [
//                                           WidgetSpan(
//                                             child: widget.data['contact'] ==
//                                                     null
//                                                 ? Text("")
//                                                 : InkWell(
//                                                     onTap: () {
//                                                       launch(
//                                                           'tel://${widget.data['contact']}');
//                                                     },
//                                                     child: Text(
//                                                       widget.data['contact'],
//                                                       style: TextStyle(
//                                                           color: Colors.blue),
//                                                     )),
//                                           ),
//                                         ]),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: RichText(
//                                     text: TextSpan(
//                                         text: 'Parents contact: ',
//                                         style: TextStyle(color: Colors.black),
//                                         children: [
//                                           WidgetSpan(
//                                             child:
//                                                 widget.data['parentsContact'] ==
//                                                         null
//                                                     ? Text("")
//                                                     : InkWell(
//                                                         onTap: () {
//                                                           launch(
//                                                               'tel://${widget.data['parentsContact']}');
//                                                         },
//                                                         child: Text(
//                                                           widget.data[
//                                                               'parentsContact'],
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.blue),
//                                                         )),
//                                           ),
//                                         ]),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text("Course: " +
//                                       widget.data['course'].toString()),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text("Batch: " +
//                                       widget.data['batch'].toString()),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text("Gender: " +
//                                       widget.data['gender'].toString()),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(
//                                       "Bio: " + widget.data['bio'].toString()),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: FutureBuilder<GetDocumentForStatsResponse>(
//                       future: document_response,
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           return snapshot.data!.documents!.isEmpty
//                               ? Column(children: <Widget>[
//                                   Image.asset("assets/images/no_content.PNG"),
//                                   const Text(
//                                     "No document submitted",
//                                     style: TextStyle(
//                                         color: Colors.red,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18.0),
//                                   ),
//                                 ])
//                               : ListView.builder(
//                                   itemCount: snapshot.data?.documents?.length,
//                                   shrinkWrap: true,
//                                   physics: ScrollPhysics(),
//                                   itemBuilder: (context, index) {
//                                     var datas =
//                                         snapshot.data?.documents?[index];
//                                     return Card(
//                                       clipBehavior: Clip.antiAlias,
//                                       margin: const EdgeInsets.all(8.0),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           datas['docType'] == null
//                                               ? const Text("")
//                                               : Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(8.0),
//                                                   child: Text(
//                                                     datas['docType'],
//                                                     style: (const TextStyle(
//                                                         fontSize: 20,
//                                                         fontWeight:
//                                                             FontWeight.bold)),
//                                                   ),
//                                                 ),
//                                           Image.network(api_url2 +
//                                               "/uploads/docs/" +
//                                               datas['docName']),
//                                           const SizedBox(
//                                             height: 20,
//                                           )
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 );
//                         } else if (snapshot.hasError) {
//                           return Text('${snapshot.error}');
//                         } else {
//                           return const Center(
//                             child: SpinKitDualRing(
//                               color: kPrimaryColor,
//                             ),
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//                 SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: FutureBuilder<GetProgressForStatsResponse>(
//                       future: progress_response,
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           // print('dataaaa' +
//                           //     snapshot.data!.allProgress.toString());
//                           return snapshot.data!.allProgress!.isEmpty
//                               ? Column(children: <Widget>[
//                                   Image.asset("assets/images/no_content.PNG"),
//                                   const Text(
//                                     "No Record",
//                                     style: TextStyle(
//                                         color: Colors.red,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18.0),
//                                   ),
//                                 ])
//                               : Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 8.0),
//                                   child: ListView.builder(
//                                       shrinkWrap: true,
//                                       physics: const ScrollPhysics(),
//                                       itemCount:
//                                           snapshot.data?.allProgress?.length,
//                                       itemBuilder: (context, index) {
//                                         var datas =
//                                             snapshot.data?.allProgress?[index];
//                                         return Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               datas['moduleTitle'] ?? "",
//                                               style:
//                                                   const TextStyle(fontSize: 15),
//                                               textAlign: TextAlign.start,
//                                             ),
//                                             const SizedBox(
//                                               height: 10,
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Expanded(
//                                                   flex: 8,
//                                                   child: Container(
//                                                     width: double.infinity,
//                                                     child: Padding(
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                               top: 10.0),
//                                                       child:
//                                                           LinearPercentIndicator(
//                                                         lineHeight: 4.0,
//                                                         percent: datas[
//                                                                     'progress'] ==
//                                                                 null
//                                                             ? 0 / 100
//                                                             : double.parse(datas[
//                                                                         'progress']
//                                                                     .toString()
//                                                                     .split(
//                                                                         ".")[0]) /
//                                                                 100,
//                                                         backgroundColor:
//                                                             Colors.grey,
//                                                         progressColor:
//                                                             Colors.green,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Expanded(
//                                                   flex: 1,
//                                                   child: Text(datas['progress']
//                                                           .toString() +
//                                                       "%"),
//                                                 ),
//                                                 SizedBox(
//                                                   height: 10,
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         );
//                                       }),
//                                 );
//                         } else if (snapshot.hasError) {
//                           return Text('${snapshot.error}');
//                         } else {
//                           return const Center(
//                             child: SpinKitDualRing(
//                               color: kPrimaryColor,
//                             ),
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//                 SingleChildScrollView(
//                   child: FutureBuilder<GetPerformanceForStatsResponse>(
//                     future: performance_response,
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         print('dataaaa' + snapshot.data!.attendance.toString());
//                         return Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                 width: double.infinity,
//                                 height: 80,
//                                 decoration: const BoxDecoration(
//                                     color: Colors.pinkAccent),
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 20.0),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         'Comments',
//                                         style: TextStyle(
//                                             color: Colors.white, fontSize: 16),
//                                       ),
//                                       Text(
//                                         '${snapshot.data?.commentCount.toString()}',
//                                         style: TextStyle(
//                                             color: Colors.white, fontSize: 16),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Divider(
//                               height: 20,
//                               thickness: 15,
//                               indent: 3,
//                               color: Colors.grey.shade100,
//                             ),
//                             ListView.builder(
//                                 shrinkWrap: true,
//                                 physics: const ScrollPhysics(),
//                                 itemCount: snapshot.data?.attendance?.length,
//                                 itemBuilder: (context, index) {
//                                   var datas = snapshot.data?.attendance?[index];
//                                   return Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Container(
//                                       width: double.infinity,
//                                       height: 80,
//                                       child: Card(
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Flexible(
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(8.0),
//                                                 child: Text(
//                                                   datas['moduleTitle'] ?? "",
//                                                   style: const TextStyle(
//                                                       fontSize: 15),
//                                                   textAlign: TextAlign.start,
//                                                 ),
//                                               ),
//                                             ),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: Text(
//                                                   datas['present'].toString()),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }),
//                           ],
//                         );
//                       } else if (snapshot.hasError) {
//                         return Text('${snapshot.error}');
//                       } else {
//                         return const Center(
//                           child: SpinKitDualRing(
//                             color: kPrimaryColor,
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//                 Container(
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           children: [
//                             TabButtonLecturer(
//                               text: "Activities",
//                               pageNumber: 0,
//                               selectedPage: _subselectedPage,
//                               onPressed: () {
//                                 _changesubPage(0);
//                               },
//                             ),
//                             TabButtonLecturer(
//                               text: "Quiz",
//                               pageNumber: 1,
//                               selectedPage: _subselectedPage,
//                               onPressed: () {
//                                 _changesubPage(1);
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Expanded(
//                           child: PageView(
//                         onPageChanged: (int page) {
//                           setState(() {
//                             _subselectedPage = page;
//                           });
//                         },
//                         controller: _subpageController,
//                         children: [
//                           SingleChildScrollView(
//                             child: Container(
//                               width: double.infinity,
//                               child: GroupedListView<Complete, String>(
//                                 elements: submissions,
//                                 shrinkWrap: true,
//                                 physics: ScrollPhysics(),
//                                 groupBy: (element) =>
//                                     element.module!.moduleTitle!,
//                                 groupComparator: (value1, value2) =>
//                                     value2.compareTo(value1),
//                                 itemComparator: (item1, item2) => item1
//                                     .lesson!.lessonTitle!
//                                     .compareTo(item2.lesson!.lessonTitle!),
//                                 order: GroupedListOrder.DESC,
//                                 useStickyGroupSeparators: true,
//                                 groupSeparatorBuilder: (String value) =>
//                                     Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(
//                                     value,
//                                     textAlign: TextAlign.left,
//                                     style: const TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                                 itemBuilder: (c, element) {
//                                   return ListTile(
//                                     trailing: completed.contains(element)
//                                         ? const Icon(
//                                             Icons.check_circle,
//                                             color: Colors.green,
//                                           )
//                                         : Container(
//                                             height: 20,
//                                             width: 20,
//                                             decoration: const BoxDecoration(
//                                                 shape: BoxShape.circle,
//                                                 color: Colors.red),
//                                             child: const Icon(
//                                               Icons.clear,
//                                               color: Colors.white,
//                                               size: 20,
//                                             ),
//                                           ),
//                                     // .contains() ? Text('a') : Text('b'),
//                                     contentPadding: const EdgeInsets.symmetric(
//                                       horizontal: 20.0,
//                                     ),
//                                     title: Text(element.lesson!.lessonTitle!),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                           Container(
//                             child: FutureBuilder<
//                                 GetSubmissionsQuizForStatsResponse>(
//                               future: quiz_response,
//                               builder: (context, snapshot) {
//                                 if (snapshot.hasData) {
//                                   return ListView.builder(
//                                     physics: ScrollPhysics(),
//                                     shrinkWrap: true,
//                                     itemCount: snapshot.data!.allQuiz!.length,
//                                     itemBuilder: (context, index) {
//                                       var datas =
//                                           snapshot.data?.allQuiz?[index];
//                                       return datas['complete'].isEmpty &&
//                                               datas['incomplete'].isEmpty
//                                           ? SizedBox()
//                                           : ExpansionTile(
//                                               children: [
//                                                   ...List.generate(
//                                                       datas['complete'].length,
//                                                       (i) => ListTile(
//                                                           subtitle: Row(
//                                                             children: [
//                                                               datas['complete'][
//                                                                               i]
//                                                                           [
//                                                                           'score'] >=
//                                                                       80
//                                                                   ? const Text(
//                                                                       'Pass',
//                                                                       style: TextStyle(
//                                                                           color:
//                                                                               Colors.green),
//                                                                     )
//                                                                   : const Text(
//                                                                       'Fail',
//                                                                       style: TextStyle(
//                                                                           color:
//                                                                               Colors.red),
//                                                                     ),
//                                                               Text(
//                                                                 " - " +
//                                                                     datas['complete'][i]
//                                                                             [
//                                                                             'score']
//                                                                         .toString(),
//                                                                 style: TextStyle(
//                                                                     color: datas['complete'][i]['score'] >=
//                                                                             80
//                                                                         ? Colors
//                                                                             .green
//                                                                         : Colors
//                                                                             .red),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           trailing: const Icon(
//                                                             Icons.check_circle,
//                                                             color: Colors.green,
//                                                           ),
//                                                           title: Text(datas[
//                                                                   'complete'][i]
//                                                               [
//                                                               'lessonTitle']))),
//                                                   ...List.generate(
//                                                       datas['incomplete']
//                                                           .length,
//                                                       (j) => ListTile(
//                                                           subtitle: const Text(
//                                                             "Not Completed",
//                                                             style: TextStyle(
//                                                                 color:
//                                                                     Colors.red),
//                                                           ),
//                                                           trailing: Container(
//                                                             height: 20,
//                                                             width: 20,
//                                                             decoration:
//                                                                 const BoxDecoration(
//                                                                     shape: BoxShape
//                                                                         .circle,
//                                                                     color: Colors
//                                                                         .red),
//                                                             child: const Icon(
//                                                               Icons.clear,
//                                                               color:
//                                                                   Colors.white,
//                                                               size: 20,
//                                                             ),
//                                                           ),
//                                                           title: Text(datas[
//                                                                   'incomplete'][j]
//                                                               [
//                                                               'lessonTitle']))),
//                                                 ],
//                                               trailing: const Icon(
//                                                 Icons.add,
//                                                 color: Colors.black,
//                                               ),
//                                               title: Text(
//                                                 datas['moduleTitle'],
//                                                 style: const TextStyle(
//                                                     color: Colors.black),
//                                               ));
//                                     },
//                                   );
//                                 } else if (snapshot.hasError) {
//                                   return Text('${snapshot.error}');
//                                 } else {
//                                   return Center(
//                                     child: SpinKitDualRing(
//                                       color: kPrimaryColor,
//                                     ),
//                                   );
//                                 }
//                               },
//                             ),
//                           ),
//                         ],
//                       ))
//                     ],
//                   ),
//                 ),
//                 FutureBuilder<GetDisciplinaryForStatsResponse>(
//                   future: disciplinary_response,
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       return snapshot.data!.result!.isEmpty
//                           ? Column(children: <Widget>[
//                               Image.asset("assets/images/no_content.PNG"),
//                               const Text(
//                                 "No offence committed",
//                                 style: TextStyle(
//                                     color: Colors.red,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18.0),
//                               ),
//                             ])
//                           : ListView.builder(
//                               shrinkWrap: true,
//                               physics: ScrollPhysics(),
//                               itemCount: snapshot.data?.result?.length,
//                               itemBuilder: (context, index) {
//                                 var datas = snapshot.data?.result?[index];
//                                 DateTime committed =
//                                     DateTime.parse(datas['date']);
//
//                                 committed = committed
//                                     .add(const Duration(hours: 5, minutes: 45));
//
//                                 var formattedTime =
//                                     DateFormat('yMMMMd').format(committed);
//
//                                 return Card(
//                                   child: GFListTile(
//                                     title: Text(
//                                       "Offence Type: " +
//                                           datas['level']['level'],
//                                       style: const TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     icon: Text(formattedTime.toString()),
//                                     description: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         const Text("Remarks:"),
//                                         Text(datas['remarks'])
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                     } else if (snapshot.hasError) {
//                       return Text('${snapshot.error}');
//                     } else {
//                       return Center(
//                         child: SpinKitDualRing(
//                           color: kPrimaryColor,
//                         ),
//                       );
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
