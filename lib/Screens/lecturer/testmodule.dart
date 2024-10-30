// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:new_version/new_version.dart';
// import 'package:schoolworkspro_app/Screens/lecturer/my-modules/aboutmodule_lecturer/aboutmodule_lecturer.dart';
// import 'package:schoolworkspro_app/Screens/lecturer/my-modules/attendance/attendance_lecturer.dart';
// import 'package:schoolworkspro_app/Screens/lecturer/my-modules/lecturer_lecturer/lecturer_lecturer.dart';
// import 'package:schoolworkspro_app/Screens/lecturer/my-modules/lessoncontent_lecturer.dart';
//
// import 'package:schoolworkspro_app/Screens/my_learning/about_module/about_module.dart';
// import 'package:schoolworkspro_app/Screens/my_learning/activity/assessment.dart';
// import 'package:schoolworkspro_app/Screens/my_learning/lecturer/lecturer.dart';
// import 'package:schoolworkspro_app/Screens/my_learning/lesson_content.dart/lesson_content.dart';
// import 'package:schoolworkspro_app/Screens/my_learning/tab_button.dart';
// import 'package:schoolworkspro_app/api/api.dart';
// import 'package:schoolworkspro_app/constants.dart';
// import 'package:schoolworkspro_app/request/lecturer/lecturer_access.dart';
//
// import 'package:schoolworkspro_app/response/lecturer/lecturermoduledetail_response.dart';
// import 'package:schoolworkspro_app/response/lesson_response.dart';
// import 'package:schoolworkspro_app/response/login_response.dart';
// import 'package:schoolworkspro_app/response/particularmoduleresponse.dart';
// import 'package:schoolworkspro_app/response/rating_response.dart';
// import 'package:schoolworkspro_app/services/lecturer/getmodule_service.dart';
// import 'package:schoolworkspro_app/services/lesson_service.dart';
//
// import 'package:schoolworkspro_app/services/particularmodule_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// class TestModule extends StatefulWidget {
//   final moduleslug;
//   final title;
//   const TestModule({Key? key, this.moduleslug,this.title}) : super(key: key);
//
//   @override
//   _TestModuleState createState() => _TestModuleState();
// }
//
// class _TestModuleState extends State<TestModule> {
//   late User user;
//   Future<LecturerModuleDetailResponse>? module_response;
//   Future<Ratingresponse>? rating_response;
//   Future<Lessonresponse>? lesson_response;
//   // Future<Completedlessonresponse>? completed_response;
//   // late Future<Lessonresponse> lesson_response;
//   // String? url;
//   double ratings = 0.0;
//
//   int _selectedPage = 0;
//   late PageController _pageController;
//
//   void _changePage(int pageNum) {
//     setState(() {
//       _selectedPage = pageNum;
//       _pageController.animateToPage(
//         pageNum,
//         duration: Duration(milliseconds: 1000),
//         curve: Curves.fastLinearToSlowEaseIn,
//       );
//     });
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     _pageController = PageController();
//     // completed_response = Completedlessonservice().getcompletedlesson();
//     getData();
//     // getParticularmodule();
//     // getcompletedlesson();
//     getRating();
//     lesson_response = Lessonservice().getLesson(widget.moduleslug);
//     // checkversion();
//     // getLessons();
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
//
//     final request = LecturerAccess(
//         moduleSlug: widget.moduleslug, lecturerEmail: user.email.toString());
//     module_response = ModuleServiceLecturer().module_detail(request);
//   }
//
//   checkversion() async {
//     final new_version = NewVersion(
//       androidId: "np.edu.digitech.schoolworkspro",
//       iOSId: "np.edu.digitech.schoolworkspro",
//     );
//
//     final status = await new_version.getVersionStatus();
//     if(Platform.isAndroid){
//       if (status!.localVersion != status.storeVersion) {
//         new_version.showUpdateDialog(
//             dialogText: "You need to update this application",
//             context: context,
//             versionStatus: status);
//       }
//     }else if(Platform.isIOS){
//       if (status!.canUpdate) {
//         new_version.showUpdateDialog(
//             dialogText: "You need to update this application",
//             context: context,
//             versionStatus: status);
//       }
//     }
//   }
//
//   // List completion = [];
//
//   // getcompletedlesson() async {
//   //   final data = await Completedlessonservice().getcompletedlesson();
//   //   for (int index = 0; index < data.completedLessons!.length; index++) {
//   //     completion.add(data.completedLessons![index].lesson);
//   //   }
//   // }
//   //
//   // getLessons() async {
//   //   lesson_response = Lessonservice().getLesson(widget.moduleslug);
//   // }
//   //
//   getRating() async {
//     rating_response = Particularmoduleservice().fetchRatings(widget.moduleslug);
//     final data =
//     await Particularmoduleservice().fetchRatings(widget.moduleslug);
//
//     setState(() {
//       ratings = data.averageRating!;
//       print(ratings);
//     });
//   }
//
//   // getParticularmodule() async {
//   //   particularmodule_response =
//   //       Particularmoduleservice().getParticularModule(widget.moduleslug);
//   //
//   //   final data =
//   //       await Particularmoduleservice().getParticularModule(widget.moduleslug);
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     // String? videoId = YoutubePlayer.convertUrlToId("$url");
//     // YoutubePlayerController _controller = YoutubePlayerController(
//     //   initialVideoId: videoId!,
//     //   flags: const YoutubePlayerFlags(
//     //     autoPlay: true,
//     //     mute: true,
//     //   ),
//     // );
//     return Scaffold(
//       appBar: AppBar(
//           elevation: 0.0,
//           iconTheme: const IconThemeData(
//             color: Colors.black, //change your color here
//           ),
//           backgroundColor: Colors.white),
//       body: SafeArea(
//         child: FutureBuilder<LecturerModuleDetailResponse>(
//           future: module_response,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               print(snapshot.data!.module['institution']);
//               var module = snapshot.data!.module;
//
//               var extension = module['imageUrl'].split(".").last;
//               // String? url = YoutubePlayer.convertUrlToId(module.embeddedUrl!);
//               // var moduleleader = module.moduleLeader!.firstname! +
//               //     " " +
//               //     module.moduleLeader!.lastname!;
//               return Container(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     extension == "svg"
//                         ? SvgPicture.network(
//                       api_url2 + '/uploads/modules/' + module['imageUrl'],
//                       height: 200,
//                       width: MediaQuery.of(context).size.width,
//                     )
//                         : Image.network(
//                       api_url2 + '/uploads/modules/' + module['imageUrl'],
//                       height: 200,
//                       width: MediaQuery.of(context).size.width,
//                     ),
//
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         module['moduleTitle'],
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 22),
//                       ),
//                     ),
//                     RatingBar.builder(
//                       initialRating: ratings,
//                       // minRating: 1,
//                       direction: Axis.horizontal,
//                       tapOnlyMode: false,
//                       allowHalfRating: true,
//                       itemCount: 5,
//                       itemSize: 30,
//                       itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
//                       itemBuilder: (context, _) => const Icon(
//                         Icons.star,
//                         color: Colors.amber,
//                       ),
//                       onRatingUpdate: (rating) {
//                         print(rating);
//                       },
//                     ),
//
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           TabButton(
//                             text: "Resources",
//                             pageNumber: 0,
//                             selectedPage: _selectedPage,
//                             onPressed: () {
//                               _changePage(0);
//                             },
//                           ),
//                           TabButton(
//                             text: "More",
//                             pageNumber: 1,
//                             selectedPage: _selectedPage,
//                             onPressed: () {
//                               _changePage(1);
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: PageView(
//                         onPageChanged: (int page) {
//                           setState(() {
//                             _selectedPage = page;
//                           });
//                         },
//                         controller: _pageController,
//                         children: [
//                           Container(
//                             child: FutureBuilder<Lessonresponse>(
//                               future: lesson_response,
//                               builder: (context, snapshot) {
//                                 if (snapshot.hasData) {
//                                   return ListView.builder(
//                                       itemCount: snapshot.data!.lessons!.length,
//                                       itemBuilder: (context, i) {
//                                         var datas = snapshot.data!.lessons![i];
//                                         return Column(
//                                           children: [
//                                             Theme(
//                                               data: ThemeData().copyWith(
//                                                   dividerColor:
//                                                   Colors.transparent),
//                                               child: ExpansionTile(
//                                                 // trailing: const Icon(Icons.add),
//                                                   title: Text(
//                                                     "Week " +
//                                                         datas.week.toString(),
//                                                     style: const TextStyle(
//                                                         fontWeight:
//                                                         FontWeight.bold,
//                                                         color: Colors.black,
//                                                         fontSize: 12),
//                                                   ),
//                                                   children: List.generate(
//                                                       datas.lessons!.length,
//                                                           (i) {
//                                                         var index = i + 1;
//                                                         return Padding(
//                                                           padding: const EdgeInsets
//                                                               .symmetric(
//                                                               horizontal: 10.0),
//                                                           child: Column(
//                                                             children: <Widget>[
//                                                               ListTile(
//                                                                 // trailing: completion
//                                                                 //         .contains(datas
//                                                                 //             .lessons![
//                                                                 //                 i]
//                                                                 //             .id)
//                                                                 //     ? const Icon(
//                                                                 //         Icons
//                                                                 //             .check_circle,
//                                                                 //         color: Colors
//                                                                 //             .green,
//                                                                 //       )
//                                                                 //     : null,
//                                                                 title: Text(
//                                                                   "Lecture $index : " +
//                                                                       datas
//                                                                           .lessons![
//                                                                       i]
//                                                                           .lessonTitle.toString(),
//                                                                   style:
//                                                                   const TextStyle(
//                                                                       fontSize:
//                                                                       14),
//                                                                 ),
//                                                                 // trailing: completion
//                                                                 //         .contains(datas
//                                                                 //             .lessons[i]
//                                                                 //             .id)
//                                                                 //     ? Icon(
//                                                                 //         Icons
//                                                                 //             .check_circle,
//                                                                 //         color: Colors
//                                                                 //             .green,
//                                                                 //       )
//                                                                 //     : null,\
//                                                                 onTap: () {
//                                                                   Navigator.push(
//                                                                     context,
//                                                                     MaterialPageRoute(
//                                                                         builder:
//                                                                             (context) =>
//                                                                             LessoncontentLecturer(
//                                                                               data: datas,
//                                                                               moduleSlug: widget.moduleslug,
//                                                                               index: i,
//                                                                             )),
//                                                                   );
//                                                                 },
//                                                                 // onTap: () async {
//                                                                 // Navigator.push(
//                                                                 //   context,
//                                                                 //   MaterialPageRoute(
//                                                                 //       builder:
//                                                                 //           (context) =>
//
//                                                                 // );
//                                                                 //   final SharedPreferences
//                                                                 //       sharedPreferences =
//                                                                 //       await SharedPreferences
//                                                                 //           .getInstance();
//                                                                 //   sharedPreferences
//                                                                 //       .setString(
//                                                                 //           'lessonId',
//                                                                 //           datas
//                                                                 //               .lessons[
//                                                                 //                   i]
//                                                                 //               .id);
//                                                                 // },
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         );
//                                                       })),
//                                             ),
//                                           ],
//                                         );
//                                       });
//                                 } else if (snapshot.hasError) {
//                                   return Text('${snapshot.error}');
//                                 } else {
//                                   return const Center(
//                                       child: SpinKitDualRing(
//                                         color: kPrimaryColor,
//                                       ));
//                                 }
//                               },
//                             ),
//                           ),
//                           // Container(
//                           //   child: Text('Resources'),
//                           // ),
//                           Container(
//                               child: ListView(
//                                 children: [
//                                   ListTile(
//                                     leading: const Icon(Icons.info),
//                                     title: const Text("About this module"),
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 AboutmoduleLecturer(
//                                                     module_response:
//                                                     snapshot.data)),
//                                       );
//                                     },
//                                   ),
//                                   ListTile(
//                                     leading: const Icon(Icons.person),
//                                     title: const Text("Lecturer"),
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => LecturerLecturer(
//                                               data: snapshot.data,
//                                             )),
//                                       );
//                                     },
//                                   ),
//                                   ListTile(
//                                     leading: const Icon(Icons.assessment),
//                                     title: const Text("Activity"),
//                                     onTap: () {
//                                       // Navigator.push(
//                                       //   context,
//                                       //   MaterialPageRoute(
//                                       //       builder: (context) => Activity(
//                                       //             data: snapshot.data!,
//                                       //           )),
//                                       // );
//                                     },
//                                   ),
//                                   ListTile(
//                                     leading: const Icon(Icons.quiz),
//                                     title: const Text("Quiz"),
//                                     onTap: () {},
//                                   ),
//                                   ListTile(
//                                     leading: const Icon(Icons.add_box),
//                                     title: const Text("Add Grades"),
//                                     onTap: () {},
//                                   ),
//                                   ListTile(
//                                     leading: const Icon(Icons.event),
//                                     title: const Text("Attendance"),
//                                     onTap: () {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (BuildContext context) =>
//                                                   Attendancelecturer(
//                                                     moduleSlug: widget.moduleslug,
//                                                     moduleTitle:
//                                                     module['moduleTitle'],
//                                                   )));
//                                     },
//                                   ),
//                                 ],
//                               ))
//                         ],
//                       ),
//                     ),
//                     // Row(
//                     //   children: [
//                     //     CircleAvatar(
//                     //         radius: 30.0,
//                     //         backgroundColor: Colors.grey,
//                     //         child: snapshot.data!.module.moduleLeader!.imageUrl ==
//                     //                     null ||
//                     //                 snapshot.data!.module.moduleLeader!.imageUrl!
//                     //                     .isEmpty
//                     //             ? Text(
//                     //                 snapshot.data!.module.moduleLeader!
//                     //                         .firstname![0]
//                     //                         .toUpperCase() +
//                     //                     "" +
//                     //                     snapshot
//                     //                         .data!.module.moduleLeader!.lastname![0]
//                     //                         .toUpperCase(),
//                     //                 style: const TextStyle(
//                     //                     fontWeight: FontWeight.bold,
//                     //                     color: Colors.white),
//                     //               )
//                     //             : ClipOval(
//                     //                 child: Image.network(
//                     //                   api_url2 +
//                     //                       'uploads/users/' +
//                     //                       snapshot
//                     //                           .data!.module.moduleLeader!.imageUrl!,
//                     //                   height: 75,
//                     //                   width: 75,
//                     //                   fit: BoxFit.cover,
//                     //                 ),
//                     //               )),
//                     //     Padding(
//                     //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     //       child: Text(moduleleader),
//                     //     ),
//                     //   ],
//                     // ),
//                     // Padding(
//                     //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     //   child: Text(module.moduleLeader!.email!),
//                     // )
//                   ],
//                 ),
//               );
//             } else {
//               return const Center(
//                   child: SpinKitDualRing(
//                     color: kPrimaryColor,
//                   ));
//             }
//           },
//         ),
//       ),
//     );
//   }
// }