// import 'dart:convert';
// import 'dart:io';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:new_version/new_version.dart';
// import 'package:provider/provider.dart';
// import 'package:readmore/readmore.dart';
// import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/QrView.dart';
// import 'package:schoolworkspro_app/Screens/lecturer/navigation/navigation_lecturer.dart';
// import 'package:schoolworkspro_app/Screens/login/login.dart';
// import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
// import 'package:schoolworkspro_app/common_view_model.dart';
// import 'package:schoolworkspro_app/components/menubar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:schoolworkspro_app/Screens/dashboard/dasboard.dart';
// import 'package:schoolworkspro_app/Screens/message/messaging.dart';
// import 'package:schoolworkspro_app/Screens/navigation/navigation.dart';
// import 'package:schoolworkspro_app/constants.dart';
// import 'package:schoolworkspro_app/response/notification_response.dart';
// import 'package:schoolworkspro_app/services/lecturer/punch_service.dart';
// import 'package:schoolworkspro_app/services/login_service.dart';
// import 'package:schoolworkspro_app/services/notification_service.dart';
// import 'package:schoolworkspro_app/services/unread_messageservice.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:showcaseview/showcaseview.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
//
// import '../../../config/preference_utils.dart';
// import '../../../response/login_response.dart';
//
// class PagerviewLecturer extends StatefulWidget {
//   final initialpage;
//   const PagerviewLecturer({Key? key, this.initialpage})
//       : super(key: key);
//
//   @override
//   State<PagerviewLecturer> createState() => _PagerviewLecturerState();
// }
//
// class _PagerviewLecturerState extends State<PagerviewLecturer> {
//   int selectedIndex = 0;
//   int count = 0;
//   int oldCount = 0;
//   int newCount = 0;
//   String _scanBarcode = 'Unknown';
//   User? user;
//   late PageController pageController;
//   late CommonViewModel _commonViewModel;
//   late PunchService _punchService;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     selectedIndex = widget.initialpage;
//     pageController = PageController(initialPage: selectedIndex);
//
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _commonViewModel =
//           Provider.of<CommonViewModel>(context, listen: false);
//       _commonViewModel.fetchNotifications();
//       final SharedPreferences localStorage = PreferenceUtils.instance;
//       if (_commonViewModel.noticeCount ==
//           localStorage.getInt('insidecount')) {
//         _commonViewModel.setDot(false);
//       } else {
//         _commonViewModel.setDot(true);
//       }
//
//       _punchService =
//           Provider.of<PunchService>(context, listen: false);
//       _punchService.checkPunchStatus(context);
//     });
//
//     super.initState();
//     getUser();
//     getData();
//     checkversion();
//   }
//
//   getUser() async {
//     SharedPreferences sharedPreferences =
//         await SharedPreferences.getInstance();
//     String? userData = sharedPreferences.getString('_auth_');
//     Map<String, dynamic> userMap = json.decode(userData!);
//     User userD = User.fromJson(userMap);
//     setState(() {
//       user = userD;
//     });
//   }
//
//   _itemTapped(int selectedIndex) {
//     pageController.jumpToPage(selectedIndex);
//     setState(() {
//       this.selectedIndex = selectedIndex;
//     });
//   }
//
//   checkversion() async {
//     try {
//       final new_version = NewVersion(
//         androidId: "np.edu.digitech.schoolworkspro",
//         iOSId: "np.edu.digitech.schoolworkspro",
//       );
//
//       final status = await new_version.getVersionStatus();
//       print('heello world:::' + status!.storeVersion);
//       print('heello world:::' + status.localVersion);
//
//       if (Platform.isAndroid) {
//         if (status.localVersion != status.storeVersion) {
//           new_version.showUpdateDialog(
//               dialogText: "You need to update this application",
//               context: context,
//               versionStatus: status);
//         }
//       } else if (Platform.isIOS) {
//         if (status.canUpdate) {
//           new_version.showUpdateDialog(
//               dialogText: "You need to update this application",
//               context: context,
//               versionStatus: status);
//         }
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   getData() async {
//     final unreadCount =
//         await UnreadMessageService().getunreadforcount();
//     setState(() {
//       count = unreadCount.allMessages!.length;
//     });
//   }
//
//   void _showMaterialDialog() {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text('Are you sure'),
//             content: const Text(
//                 'Are you sure you want to close application'),
//             actions: <Widget>[
//               TextButton(
//                   onPressed: () {
//                     // _dismissDialog();
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('No')),
//               TextButton(
//                 onPressed: () => exit(0),
//                 child: const Text('Yes'),
//               )
//             ],
//           );
//         });
//   }
//
//   final _key2 = GlobalKey();
//   final _key3 = GlobalKey();
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () {
//         if (selectedIndex == 0) {
//           // Navigator.of(context).pushReplacementNamed(NavigationScreen.routeName);
//           _itemTapped(1);
//           return Future.value(false);
//         } else {
//           _showMaterialDialog();
//           return Future.value(false);
//         }
//       },
//       child: Consumer2<CommonViewModel, PunchService>(
//         builder: (context, value, provider2, child) {
//           return Scaffold(
//             appBar: AppBar(
//                 actions: [
//                   Align(
//                     alignment: Alignment.center,
//                     child: Builder(builder: (context) {
//                       return provider2.data2?.status == null
//                           ? Container(
//                               decoration: BoxDecoration(
//                                   color: Colors.red,
//                                   borderRadius:
//                                       BorderRadius.circular(5)),
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 5, vertical: 3),
//                               child: Text(
//                                 "Offline",
//                               ),
//                             )
//                           : provider2.data2?.status == "Out"
//                               ? Container(
//                                   decoration: BoxDecoration(
//                                       color: Colors.red,
//                                       borderRadius:
//                                           BorderRadius.circular(5)),
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 5, vertical: 3),
//                                   child: Text(
//                                     "Offline",
//                                   ))
//                               : provider2.data2?.status?['status'] ==
//                                       "Out"
//                                   ? Container(
//                                       decoration: BoxDecoration(
//                                           color: Colors.red,
//                                           borderRadius:
//                                               BorderRadius.circular(
//                                                   5)),
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 5, vertical: 3),
//                                       child: const Text(
//                                         "Offline",
//                                       ))
//                                   : Container(
//                                       decoration: BoxDecoration(
//                                           color: Colors.green,
//                                           borderRadius:
//                                               BorderRadius.circular(
//                                                   5)),
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 5, vertical: 3),
//                                       child: const Text(
//                                         "Online",
//                                       ),
//                                     );
//                     }),
//                   ),
//                   Builder(builder: (context) {
//                     if (value.showDot == true) {
//                       return IconButton(
//                         onPressed: () {
//                           _commonViewModel.setDot(false);
//                           Navigator.of(context).pushNamed(
//                             '/notificationscreen',
//                           );
//                         },
//                         icon: Stack(
//                           children: [
//                             const Icon(Icons.notifications,
//                                 color: Colors.black),
//                             Positioned(
//                                 top: 0,
//                                 right: 0,
//                                 child: Container(
//                                   height: 10,
//                                   width: 10,
//                                   decoration: const BoxDecoration(
//                                       color: Colors.red,
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(50))),
//                                 ))
//                           ],
//                         ),
//                       );
//                     } else {
//                       return IconButton(
//                         onPressed: () {
//                           _commonViewModel.setDot(false);
//                           Navigator.of(context).pushNamed(
//                             '/notificationscreen',
//                           );
//                         },
//                         icon: const Icon(Icons.notifications,
//                             color: Colors.black),
//                       );
//                     }
//                   }),
//                   // PopupMenuButton<String>(
//                   //   onSelected: choiceAction,
//                   //   itemBuilder: (BuildContext context) {
//                   //     return menubar.settings.map((String choice) {
//                   //       return PopupMenuItem<String>(
//                   //         value: choice,
//                   //         child: Text(choice),
//                   //       );
//                   //     }).toList();
//                   //   },
//                   //   icon: const Icon(
//                   //     Icons.settings,
//                   //     color: Colors.black,
//                   //   ),
//                   // ),
//                   IconButton(
//                       onPressed: () => scanQR(),
//                       icon: const Icon(
//                         Icons.qr_code_scanner,
//                         color: Colors.black,
//                       )),
//                 ],
//                 // centerTitle: true,
//                 leading: selectedIndex == 0
//                     ? InkWell(
//                         onTap: () {
//                           _itemTapped(1);
//                         },
//                         child: Icon(Icons.arrow_back))
//                     : null,
//                 title: selectedIndex == 0
//                     ? const Text(
//                         'Quick Message',
//                         style: TextStyle(color: Colors.black),
//                       )
//                     : SizedBox(
//                         child: Image.asset(
//                         'assets/images/logo.png',
//                         width: 120,
//                       )),
//                 automaticallyImplyLeading: false,
//                 elevation: 0.0,
//                 iconTheme: const IconThemeData(
//                   color: Colors.black, //change your color here
//                 ),
//                 backgroundColor: Colors.white),
//             body: Column(
//               children: [
//                 Expanded(
//                   child: ShowCaseWidget(
//                     onStart: (index, key) {},
//                     onComplete: (index, key) {
//                       if (index == 4) {
//                         SystemChrome.setSystemUIOverlayStyle(
//                           SystemUiOverlayStyle.light.copyWith(
//                             statusBarIconBrightness: Brightness.dark,
//                             statusBarColor: Colors.white,
//                           ),
//                         );
//                       }
//                     },
//                     blurValue: 1,
//                     builder: Builder(
//                       builder: (context) => PageView(
//                         scrollDirection: Axis.horizontal,
//                         controller: pageController,
//                         onPageChanged: (value) {
//                           setState(() {
//                             selectedIndex = value;
//                           });
//                         },
//                         children: const <Widget>[
//                           MessageScreen(),
//                           NavigationLecturer(),
//                         ],
//                       ),
//                     ),
//                     autoPlayDelay: const Duration(seconds: 3),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Future<void> scanQR() async {
//     String barcodeScanRes;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     DateTime now = DateTime.now();
//
//     DateTime checkSecond = DateTime.now();
//
//     var affter10 = DateFormat('ss')
//         .format(checkSecond.add(const Duration(seconds: 10)));
//     var before10 = DateFormat('ss')
//         .format(checkSecond.subtract(const Duration(seconds: 10)));
//
//     //56 => 46 - 06
//
//     var formattedtime = DateFormat('yyyyMMddmm').format(now);
//
//     // await Future.delayed(Duration(seconds: 5));
//     try {
//       barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
//           '#ff6666', 'Cancel', true, ScanMode.QR);
//       print("lol" + formattedtime);
//       if (barcodeScanRes.toString() ==
//           "https://api.schoolworkspro.com/staffAttendance/institution=${user?.institution.toString()}?${formattedtime}") {
//         hitAttendance().then((_){
//           _punchService.checkPunchStatus(context);
//         });
//       } else if (barcodeScanRes.toString() !=
//           "https://api.schoolworkspro.com/staffAttendance/institution=${user?.institution.toString()}?${formattedtime}") {
//         Fluttertoast.showToast(msg: "Invalid QR");
//       }
//       // if (barcodeScanRes ==
//       //     "https://api.schoolworkspro.com/staffAttendance/add") {
//       //   hitAttendance();
//       // }
//     } on PlatformException {
//       barcodeScanRes = 'Failed to get platform version.';
//     }
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//
//     setState(() {
//       _scanBarcode = barcodeScanRes;
//     });
//   }
//
//   hitAttendance() async {
//     try {
//       final res = await PunchService().punchInOut();
//       if (res.success == true) {
//         Fluttertoast.showToast(msg: res.message.toString(), backgroundColor: Colors.green);
//         // snackThis(
//         //     content: Text(res.message.toString()),
//         //     color: Colors.green,
//         //     behavior: SnackBarBehavior.fixed,
//         //     duration: 2,
//         //     context: context);
//       } else {
//         Fluttertoast.showToast(msg: res.message.toString(), backgroundColor: Colors.red);
//         // snackThis(
//         //     content: Text(res.message.toString()),
//         //     color: Colors.red,
//         //     behavior: SnackBarBehavior.fixed,
//         //     duration: 2,
//         //     context: context);
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
//       // snackThis(
//       //     content: Text(e.toString()),
//       //     color: Colors.red,
//       //     behavior: SnackBarBehavior.fixed,
//       //     duration: 2,
//       //     context: context);
//     }
//   }
//
//   void choiceAction(String choice) async {
//     if (choice == menubar.password) {
//       Navigator.of(context).pushNamed('/updatepasswordscreen');
//     } else if (choice == menubar.detail) {
//       Navigator.of(context).pushNamed('/updatedetailscreen');
//     } else if (choice == menubar.logout) {
//       final res = await LoginService().logout();
//       if (res.success == true) {
//         SharedPreferences sharedPreferences =
//             await SharedPreferences.getInstance();
//         await sharedPreferences.clear();
//
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => const LoginScreen()));
//       } else {
//         snackThis(
//             context: context,
//             content: Text(res.success.toString()),
//             color: Colors.red,
//             duration: 1);
//       }
//     }
//   }
// }
