// import 'dart:convert';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
// import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/activities.dart';
// import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/drafts.dart';
// import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/more.dart';
// import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/overview.dart';
// import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/resources.dart';
// import 'package:schoolworkspro_app/config/api_response_config.dart';
// import 'package:schoolworkspro_app/response/login_response.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../constants.dart';
//
// class LearningDetailLecturer extends StatefulWidget {
//   final modulSlug;
//   final title;
//   const LearningDetailLecturer({Key? key, required this.modulSlug, this.title})
//       : super(key: key);
//
//   @override
//   State<LearningDetailLecturer> createState() => _LearningDetailLecturerState();
// }
//
// class _LearningDetailLecturerState extends State<LearningDetailLecturer> {
//   PageController pagecontroller = PageController();
//   int selectedIndex = 0;
//   String title = 'Home';
//   late User user;
//   _onPageChanged(int index) {
//     // onTap
//     setState(() {
//       selectedIndex = index;
//       switch (index) {
//         case 0:
//           {
//             title = 'Overview';
//           }
//           break;
//         case 1:
//           {
//             title = 'Resources';
//           }
//           break;
//         case 2:
//           {
//             title = 'Activities';
//           }
//           break;
//         case 3:
//           {
//             title = 'More';
//           }
//           break;
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
//   void initState() {
//     // TODO: implement initState
//     //gives you the message on which user taps and it openned the app from terminated state
//
//     getData();
//
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
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       dynamic data = {
//         "lecturerEmail": user.email.toString(),
//         "moduleSlug": widget.modulSlug
//       };
//       Provider.of<LecturerCommonViewModel>(context, listen: false)
//           .fetchModuleDetails(data);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () {
//         if (selectedIndex == 0) {
//           // Navigator.of(context).pushReplacementNamed(LearningDetailLecturer.routeName);
//           Navigator.of(context).popUntil((route) => route.isFirst);
//           return Future.value(false);
//         } else {
//           _itemTapped(0);
//           return Future.value(false);
//         }
//         return Future.value(true);
//       },
//       child:
//       Consumer<LecturerCommonViewModel>(builder: (context, value, child) {
//         return Scaffold(
//           appBar: AppBar(
//               elevation: 0.0,
//               title: Text(
//                 widget.title,
//                 style: const TextStyle(color: Colors.black),
//               ),
//               iconTheme: const IconThemeData(
//                   color: Colors.black //change your color here
//               ),
//               backgroundColor: Colors.white),
//           body: PageView(
//             controller: pagecontroller,
//             onPageChanged: _onPageChanged,
//             physics: const NeverScrollableScrollPhysics(),
//             children: <Widget>[
//               isLoading(value.modulesApiResponse)
//                   ? Container(
//                 child: const Center(
//                   child: CupertinoActivityIndicator()
//                 ),
//               )
//                   : Container(),
//               // OverViewScreen(data: value.modules),
//               ResourcesScreen(
//                 data: value.modules,
//               ),
//               ActivitiesScreen(
//                 data: value.modules,
//               ),
//               DraftScreen(data: value.modules),
//               MoreScreen(
//                 data: value.modules,
//               ),
//             ],
//           ),
//           bottomNavigationBar: BottomNavigationBar(
//             backgroundColor: Colors.white,
//             currentIndex: selectedIndex,
//             onTap: _itemTapped,
//             type: BottomNavigationBarType.fixed,
//             items: [
//               BottomNavigationBarItem(
//                 icon: Image.asset(
//                   'assets/icons/file.png',
//                   height: 20,
//                   width: 20,
//                   color: selectedIndex == 0 ? kPrimaryColor : Colors.grey,
//                 ),
//                 // icon: SvgPicture.asset(
//                 //   categories,
//                 //   color: selectedIndex == 0 ? kPrimaryColor : Colors.grey,
//                 // ),
//                 // ignore: deprecated_member_use
//                 label: 'Overview',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.pages,
//                   size: 20,
//                   color: selectedIndex == 1 ? kPrimaryColor : Colors.grey,
//                 ),
//                 // icon: SvgPicture.asset(
//                 //   categories,
//                 //   color: selectedIndex == 0 ? kPrimaryColor : Colors.grey,
//                 // ),
//                 // ignore: deprecated_member_use
//                 label: 'Resources',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.assessment,
//                   size: 20,
//                   color: selectedIndex == 2 ? kPrimaryColor : Colors.grey,
//                 ),
//                 // icon: SvgPicture.asset(
//                 //   categories,
//                 //   color: selectedIndex == 0 ? kPrimaryColor : Colors.grey,
//                 // ),
//                 // ignore: deprecated_member_use
//                 label: 'Activities',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.lock_clock,
//                   size: 20,
//                   color: selectedIndex == 3 ? kPrimaryColor : Colors.grey,
//                 ),
//                 // icon: SvgPicture.asset(
//                 //   categories,
//                 //   color: selectedIndex == 0 ? kPrimaryColor : Colors.grey,
//                 // ),
//                 // ignore: deprecated_member_use
//                 label: 'Drafts',
//               ),
//               BottomNavigationBarItem(
//                 icon: Image.asset(
//                   'assets/icons/more.png',
//                   height: 20,
//                   width: 20,
//                   color: selectedIndex == 3 ? kPrimaryColor : Colors.grey,
//                 ),
//                 // icon: SvgPicture.asset(
//                 //   categories,
//                 //   color: selectedIndex == 0 ? kPrimaryColor : Colors.grey,
//                 // ),
//                 // ignore: deprecated_member_use
//                 label: 'More',
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }