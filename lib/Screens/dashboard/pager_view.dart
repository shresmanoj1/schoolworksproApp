
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:schoolworkspro_app/Screens/dashboard/chat_bot_screen.dart';
// import 'package:schoolworkspro_app/api/repositories/principal/event_repo.dart';
// import 'package:schoolworkspro_app/components/menubar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:schoolworkspro_app/Screens/message/messaging.dart';
// import 'package:schoolworkspro_app/Screens/navigation/navigation.dart';
// import 'package:schoolworkspro_app/services/unread_messageservice.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:showcaseview/showcaseview.dart';
// import 'package:intl/intl.dart';
// import '../../api/repositories/lecturer/attendance_repository.dart';
// import '../../config/preference_utils.dart';
// import '../../response/authenticateduser_response.dart';
// import '../../services/login_service.dart';
// import '../login/login.dart';
// import '../widgets/snack_bar.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// class Pagerview extends StatefulWidget {
//   final initialpage;
//   const Pagerview({Key? key, this.initialpage}) : super(key: key);
//
//   @override
//   State<Pagerview> createState() => _PagerviewState();
// }
//
// class _PagerviewState extends State<Pagerview> {
//   TextEditingController chatController = TextEditingController();
//   final SharedPreferences localStorage = PreferenceUtils.instance;
//   int selectedIndex = 0;
//   int count = 0;
//   String _scanBarcode = 'Unknown';
//   User? user;
//
//   IO.Socket? socket;
//   dynamic _chatResponse = '';
//
//   @override
//   void initState() {
//     getData();
//     getuserData();
//     selectedIndex = widget.initialpage;
//     super.initState();
//   }
//
//   getuserData() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     String? userData = sharedPreferences.getString('_auth_');
//
//     Map<String, dynamic> userMap = json.decode(userData!);
//     User userD = User.fromJson(userMap);
//     setState(() {
//       user = userD;
//     });
//   }
//
//   getData() async {
//     final unreadCount = await UnreadMessageService().getunreadforcount();
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
//             content: const Text('Are you sure you want to close application'),
//             actions: <Widget>[
//               TextButton(
//                   onPressed: () {
//                     // _dismissDialog();
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('No')),
//               TextButton(
//                 onPressed: () => exit(0),
//                 child: Text('Yes'),
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
//     PageController pageController = PageController(initialPage: selectedIndex);
//     _itemTapped(int selectedIndex) {
//       pageController.jumpToPage(selectedIndex);
//       setState(() {
//         this.selectedIndex = selectedIndex;
//       });
//     }
//
//     return WillPopScope(
//       onWillPop: () {
//         if (selectedIndex == 0) {
//           _itemTapped(1);
//           return Future.value(false);
//         } else {
//           _showMaterialDialog();
//           return Future.value(false);
//         }
//       },
//       child: Scaffold(
//         // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//         // floatingActionButton: Padding(
//         //   padding: const EdgeInsets.only(bottom: 50),
//         //   child: SizedBox(
//         //     child: FloatingActionButton(
//         //       child: Icon(Icons.message),
//         //       onPressed: () {
//         //         Navigator.push(context,
//         //             MaterialPageRoute(builder: (builder) => ChatBotScreen()));
//         //       },
//         //     ),
//         //   ),
//         // ),
//         appBar: AppBar(
//             actions: [
//               InkWell(
//                 borderRadius: BorderRadius.circular(50),
//                 onTap: () {
//                   Navigator.of(context).pushNamed(
//                     '/notificationscreen',
//                   );
//                 },
//                 child: const Icon(
//                   Icons.notifications,
//                   color: Colors.black,
//                 ),
//               ),
//               // PopupMenuButton<String>(
//               //   onSelected: choiceAction,
//               //   itemBuilder: (BuildContext context) {
//               //     return menubar.settings.map((String choice) {
//               //       return PopupMenuItem<String>(
//               //         value: choice,
//               //         child: Text(choice),
//               //       );
//               //     }).toList();
//               //   },
//               //   icon: const Icon(
//               //     Icons.settings,
//               //     color: Colors.black,
//               //   ),
//               // ),
//               InkWell(
//                   borderRadius: BorderRadius.circular(50),
//                   onTap: () {
//                     Navigator.of(context).pushNamed(
//                       '/notificationscreen',
//                     );
//                   },
//                   child: Padding(
//                     padding: EdgeInsets.only(right: 15),
//                     child: IconButton(
//                       onPressed: () {
//                         scanQR();
//                       },
//                       icon: Icon(
//                         Icons.qr_code_scanner,
//                         color: Colors.black,
//                       ),
//                     ),
//                   )),
//             ],
//             // centerTitle: true,
//             leading: selectedIndex == 0
//                 ? InkWell(
//                     onTap: () {
//                       _itemTapped(1);
//                     },
//                     child: Icon(Icons.arrow_back))
//                 : null,
//             title: selectedIndex == 0
//                 ? const Text(
//                     'Quick Message',
//                     style: TextStyle(color: Colors.black),
//                   )
//                 : SizedBox(
//                     child: Image.asset(
//                     'assets/images/logo.png',
//                     width: 120,
//                   )),
//             automaticallyImplyLeading: false,
//             elevation: 0.0,
//             iconTheme: const IconThemeData(
//               color: Colors.black, //change your color here
//             ),
//             backgroundColor: Colors.white),
//         body: ShowCaseWidget(
//           onStart: (index, key) {},
//           onComplete: (index, key) {
//             if (index == 4) {
//               SystemChrome.setSystemUIOverlayStyle(
//                 SystemUiOverlayStyle.light.copyWith(
//                   statusBarIconBrightness: Brightness.dark,
//                   statusBarColor: Colors.white,
//                 ),
//               );
//             }
//           },
//           blurValue: 1,
//           builder: Builder(
//             builder: (context) => PageView(
//               scrollDirection: Axis.horizontal,
//               controller: pageController,
//               onPageChanged: (value) {
//                 setState(() {
//                   selectedIndex = value;
//                 });
//               },
//               children: const <Widget>[
//                 MessageScreen(),
//                 Navigation(currentIndex: 0),
//               ],
//             ),
//           ),
//           autoPlayDelay: const Duration(seconds: 3),
//         ),
//       ),
//     );
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
//         Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (context) => const LoginScreen()));
//       } else {
//         snackThis(
//             context: context,
//             content: Text(res.success.toString()),
//             color: Colors.red,
//             duration: 1);
//       }
//     }
//   }
//
//   Future<void> scanQR() async {
//     String barcodeScanRes;
//     try {
//       barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
//           '#ff6666', 'Cancel', true, ScanMode.QR);
//       // print("TESTING::::${barcodeScanRes}");
//
//       final Map jsonConvert = jsonDecode(barcodeScanRes);
//
//       print("OBJECT:TEST::${jsonConvert}");
//       print("OBJECT11111:::${jsonConvert["type"]}");
//
//       if (jsonConvert.containsKey("token") &&
//           jsonConvert["token"] != null &&
//           jsonConvert["token"] != "null" &&
//           jsonConvert["token"] != "" && !jsonConvert.containsKey("type")) {
//         // if(jsonConvert["date"] == formattedtime){
//         //   if(jsonConvert.containsKey("batch")){
//         studentAttendance(
//             jsonConvert,
//             user == null ? "" : user!.username.toString(),
//             user == null ? "" : user!.institution.toString());
//         // }
//         // }
//       }
//       else if (jsonConvert.containsKey("qrType") && jsonConvert["qrType"] == "static") {
//         studentAttendance(
//             jsonConvert,
//             user == null ? "" : user!.username.toString(),
//             user == null ? "" : user!.institution.toString());
//       }
//       else if( jsonConvert.containsKey("type") && jsonConvert["type"] == "StudentQr"){
//         print("QR STUDENT:::::");
//         studentAllDayAttendance(jsonConvert,
//             user == null ? "" : user!.username.toString(),
//             user == null ? "" : user!.institution.toString());
//       }
//       else if (jsonConvert.containsKey("id")) {
//         eventAttendance(jsonConvert["id"]);
//       }
//     } on PlatformException {
//       barcodeScanRes = 'Failed to get platform version.';
//     }
//     if (!mounted) return;
//
//     setState(() {
//       _scanBarcode = barcodeScanRes;
//     });
//   }
//
//   eventAttendance(String id) async {
//     try {
//       final res = await EventRepository().postEventAttendance(id);
//       if (res.success == true) {
//         Fluttertoast.showToast(
//             msg: res.message.toString(),
//             backgroundColor: Colors.green,
//             textColor: Colors.white);
//       } else {
//         Fluttertoast.showToast(
//             msg: res.message.toString(),
//             backgroundColor: Colors.red,
//             textColor: Colors.white);
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//           msg: "Failed", backgroundColor: Colors.red, textColor: Colors.white);
//     }
//   }
//
//   studentAttendance(final Map data, String username, String institution) async {
//     try {
//       final request = {
//         "username": username,
//         "batch": data["batch"],
//         "moduleSlug": data["moduleSlug"],
//         "attendanceType": data["classType"],
//         "attendanceBy": data["attendanceBy"],
//         "institution": data["institution"],
//         "token": data["token"] ?? null,
//       };
//       if ((data.containsKey("qrType") && data["qrType"] == "static")) {
//         request["qrType"] = "static";
//       }
//       // print("REQUEST::::${jsonEncode(request)}");
//       final res =
//           await AttendanceRepository().postQrAttendance(jsonEncode(request));
//       if (res.success == true) {
//         Fluttertoast.showToast(
//             msg: res.message.toString(),
//             backgroundColor: Colors.green,
//             textColor: Colors.white);
//       } else {
//         Fluttertoast.showToast(
//             msg: res.message.toString(),
//             backgroundColor: Colors.red,
//             textColor: Colors.white);
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//           msg: "Failed", backgroundColor: Colors.red, textColor: Colors.white);
//     }
//   }
//
//   studentAllDayAttendance(final Map data, String username, String institution) async {
//     try {
//       print("ATTENDANCE FOR ALL DAY:::");
//       final request = {
//         "username": username,
//         "batch": data["batch"],
//         "institution": data["institution"],
//         "token": data["token"] ?? null,
//       };
//       final res = await AttendanceRepository().postAllDayStudentQrAttendance(jsonEncode(request));
//       if (res.success == true) {
//         Fluttertoast.showToast(
//             msg: res.message.toString(),
//             backgroundColor: Colors.green,
//             textColor: Colors.white);
//       } else {
//         Fluttertoast.showToast(
//             msg: res.message.toString(),
//             backgroundColor: Colors.red,
//             textColor: Colors.white);
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//           msg: "Failed", backgroundColor: Colors.red, textColor: Colors.white);
//     }
//   }
//
//   // dynamic dialoger(BuildContext context, dynamic _chatResponse) {
//   //   showDialog(
//   //       context: context,
//   //       builder: (_) {
//   //         print("VALUE:::${_chatResponse}");
//   //         // chatController.text == null || chatController.text == "" ? Container() :
//   //         getSenderView(
//   //                 CustomClipper clipper, BuildContext context) =>
//   //             ChatBubble(
//   //               clipper: clipper,
//   //               alignment: Alignment.topRight,
//   //               margin: EdgeInsets.only(top: 20),
//   //               backGroundColor: Colors.blue,
//   //               child: Container(
//   //                 constraints: BoxConstraints(
//   //                   maxWidth: MediaQuery.of(context).size.width * 0.7,
//   //                 ),
//   //                 child: Text(
//   //                     chatController.text,
//   //                   style: TextStyle(color: Colors.white),
//   //                 ),
//   //               ),
//   //             );
//   //
//   //         getReceiverView(
//   //                 CustomClipper clipper, BuildContext context) =>
//   //             ChatBubble(
//   //               clipper: clipper,
//   //               backGroundColor: Color(0xffE7E7ED),
//   //               margin: EdgeInsets.only(top: 20),
//   //               child: Container(
//   //                 constraints: BoxConstraints(
//   //                   maxWidth: MediaQuery.of(context).size.width * 0.7,
//   //                 ),
//   //                 child: Text(
//   //                   _chatResponse['text'],
//   //                   style: TextStyle(color: Colors.black),
//   //                 ),
//   //               ),
//   //             );
//   //         return StatefulBuilder(
//   //           builder: (context, setState) {
//   //             return Dialog(
//   //               insetPadding: EdgeInsets.symmetric(horizontal: 10),
//   //               child: Stack(
//   //                 children: [
//   //                   Container(
//   //                     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//   //                     height: MediaQuery.of(context).size.height/1.2,
//   //                     width: double.maxFinite,
//   //                     child: Stack(
//   //                       children: [
//   //                         ListView(
//   //                           padding: EdgeInsets.symmetric(vertical: 10),
//   //                           shrinkWrap: true,
//   //                           children: [
//   //                             getSenderView(
//   //                                 ChatBubbleClipper1(
//   //                                     type: BubbleType.sendBubble),
//   //                                 context),
//   //                             getReceiverView(
//   //                                 ChatBubbleClipper1(
//   //                                     type: BubbleType.receiverBubble),
//   //                                 context),
//   //
//   //                             SizedBox(height: 100,),
//   //
//   //                           ],
//   //                         ),
//   //                         Container(
//   //                           width: double.infinity,
//   //                           color: Colors.white,
//   //                           child: Text(
//   //                             "Chatbot-Beta",
//   //                             style: TextStyle(
//   //                               color: Colors.black,
//   //                               fontSize: 20,
//   //                             ),
//   //                           ),
//   //                         ),
//   //                         Positioned(
//   //                           bottom: 4,
//   //                           child: Container(
//   //                             child: Row(
//   //                               children: [
//   //                                 Container(
//   //                                   color: Colors.white,
//   //                                   width: MediaQuery.of(context).size.width/1.2,
//   //                                   child: TextFormField(
//   //                                     controller: chatController,
//   //                                     decoration: const InputDecoration(
//   //                                       contentPadding: EdgeInsets.symmetric(horizontal: 10),
//   //                                       hintText: 'Write something',
//   //                                       filled: true,
//   //                                       enabledBorder: OutlineInputBorder(
//   //                                           borderSide:
//   //                                           BorderSide(color: Colors.grey)),
//   //                                       focusedBorder: OutlineInputBorder(
//   //                                           borderSide:
//   //                                           BorderSide(color: Colors.green)),
//   //                                       floatingLabelBehavior:
//   //                                       FloatingLabelBehavior.always,
//   //                                     ),
//   //                                   ),
//   //                                 ),
//   //                                 IconButton( onPressed: chatFire,icon: Icon(Icons.send))
//   //                               ],
//   //                             ),
//   //                           ),
//   //                         ),
//   //                       ],
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //             );
//   //           }
//   //         );
//   //       });
//   // }
// }
