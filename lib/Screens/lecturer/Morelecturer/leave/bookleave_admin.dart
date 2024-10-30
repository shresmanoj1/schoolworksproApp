// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:provider/provider.dart';
// import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/leave/book_leave_view_model.dart';
// import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/leave/components/panel_widget.dart';
// import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
// import 'package:schoolworkspro_app/constants.dart';
// import 'package:schoolworkspro_app/request/lecturer/leave_request.dart';
// import 'package:schoolworkspro_app/response/lecturer/leave_response.dart'
//     hide User;
// import 'package:schoolworkspro_app/response/lecturer/postleave_response.dart';
// import 'package:schoolworkspro_app/services/lecturer/leave_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
// import '../../../../response/login_response.dart';
//
// class BookLeaveAdmin extends StatefulWidget {
//   const BookLeaveAdmin({Key? key}) : super(key: key);
//
//   @override
//   BookLeaveAdminState createState() => BookLeaveAdminState();
// }
//
// class BookLeaveAdminState extends State<BookLeaveAdmin> {
//   Stream<LeaveResponse>? leave_response;
//   bool connected = true;
//   User? user;
//   String? _mySelection;
//   // final double _initFabHeight = 120.0;
//   // double _fabHeight = 0;
//   // double _panelHeightOpen = 0;
//   // double _panelHeightClosed = 95.0;
//   List inst = [
//     'Personal',
//     'Annual Leave (min: 3 days: 10 days)',
//     'Maternal Leave (Female: 3.5 months, Male: 7 days)',
//     'Bereavement Leave (15 days)',
//     'Sick Leave',
//     'Half Day Leave',
//     'Others',
//   ];
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _startDatecontroller = TextEditingController();
//   String? _startDate;
//   String? _endDate;
//   final DateRangePickerController _controller = DateRangePickerController();
//   final _formKey = GlobalKey<FormState>();
//   bool isloading = false;
//   final PanelController panelController = PanelController();
//
//   late BookLeaveViewModel _provider;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     // checkversion();
//     getData();
//     // _fabHeight = _initFabHeight;
//     _startDate = "";
//     _endDate = "";
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _provider =
//           Provider.of<BookLeaveViewModel>(context, listen: false);
//       _provider.fetchBookLeave();
//     });
//
//     // context.loaderOverlay.hide();
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
//     leave_response = LeaveService().getRefreshLeave(
//         const Duration(milliseconds: 200), user!.username.toString());
//   }
//
//   // checkversion() async {
//   //   final new_version = NewVersion(
//   //     androidId: "np.edu.digitech.schoolworkspro",iOSId: "np.edu.digitech.schoolworkspro",
//   //   );
//   //
//   //   final status = await new_version.getVersionStatus();
//   //
//   //   new_version.showUpdateDialog(
//   //       dialogText: "You need to update this application",
//   //       context: context,
//   //       versionStatus: status!);
//   // }
//
//   // _noticeModel = NotificationService().getNotice();
//   @override
//   Widget build(BuildContext context) {
//     // _panelHeightOpen = MediaQuery.of(context).size.height * .80;
//     final panelHeightClosed = MediaQuery.of(context).size.height * 0.13;
//     final panelHeightOpen = MediaQuery.of(context).size.height * 0.8;
//
//     if (isloading == true) {
//       context.loaderOverlay.show();
//     } else {
//       context.loaderOverlay.hide();
//     }
//     // TODO: implement build
//     return Consumer<BookLeaveViewModel>(
//       builder: (context, leave, child) {
//         return Scaffold(
//           appBar: AppBar(
//               actions: [
//                 Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: InkWell(
//                     onTap: () {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return StatefulBuilder(builder: (context, setState) {
//                             return AlertDialog(
//                               title: const Text("Request A Leave"),
//                               content: SizedBox(
//                                 height: 320,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text("Leave Type"),
//                                     DropdownButtonFormField(
//                                       isExpanded: true,
//                                       decoration:
//                                       const InputDecoration(
//                                         border:
//                                         InputBorder
//                                             .none,
//                                         filled: true,
//                                         hintText:
//                                         'Select leave type',
//                                       ),
//                                       icon: const Icon(Icons
//                                           .arrow_drop_down_outlined),
//                                       items: leave.leave
//                                           .map((pt) {
//                                         return DropdownMenuItem(
//                                           value: pt
//                                               .leaveType,
//                                           child: Text(
//                                             pt.leaveType
//                                                 .toString(),
//                                             overflow:
//                                             TextOverflow
//                                                 .ellipsis,
//                                           ),
//                                         );
//                                       }).toList(),
//                                       onChanged:
//                                           (newVal) {
//                                         setState(() {
//                                           _mySelection =
//                                           newVal
//                                           as String?;
//                                           // print(_mySelection);
//                                         });
//                                       },
//                                       value: _mySelection,
//                                     ),
//
//
//                                     // DropdownButtonFormField(
//                                     //   isExpanded: true,
//                                     //   decoration: const InputDecoration(
//                                     //     border: InputBorder.none,
//                                     //     filled: true,
//                                     //     hintText: 'Select leave type',
//                                     //   ),
//                                     //   icon: const Icon(
//                                     //       Icons.arrow_drop_down_outlined),
//                                     //   items: inst.map((pt) {
//                                     //     return DropdownMenuItem(
//                                     //       value: pt,
//                                     //       child: Text(
//                                     //         pt,
//                                     //         overflow: TextOverflow.ellipsis,
//                                     //       ),
//                                     //     );
//                                     //   }).toList(),
//                                     //   onChanged: (newVal) {
//                                     //     setState(() {
//                                     //       _mySelection = newVal as String?;
//                                     //       // print(_mySelection);
//                                     //     });
//                                     //   },
//                                     //   value: _mySelection,
//                                     // ),
//                                     SizedBox(
//                                       height: 10,
//                                     ),
//                                     Text("Leave Description"),
//                                     TextFormField(
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Please enter leave description';
//                                         }
//                                         return null;
//                                       },
//                                       controller: _descriptionController,
//                                       keyboardType: TextInputType.visiblePassword,
//                                       decoration: const InputDecoration(
//                                         hintText: 'Enter description',
//                                         filled: true,
//                                         enabledBorder: OutlineInputBorder(
//                                             borderSide:
//                                             BorderSide(color: kPrimaryColor)),
//                                         focusedBorder: OutlineInputBorder(
//                                             borderSide:
//                                             BorderSide(color: Colors.green)),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 10,
//                                     ),
//                                     Text('Select Date'),
//                                     InkWell(
//                                       onTap: () {
//                                         showDialog(
//                                             context: context,
//                                             builder: (context) {
//                                               return CupertinoAlertDialog(
//                                                 insetAnimationCurve:
//                                                 Curves.bounceIn,
//                                                 insetAnimationDuration:
//                                                 const Duration(
//                                                     milliseconds: 50),
//                                                 title: const Text('Drag to select'),
//                                                 content: SizedBox(
//                                                   height: 250,
//                                                   child: SfDateRangePicker(
//                                                     enablePastDates: false,
//                                                     controller: _controller,
//                                                     selectionMode:
//                                                     DateRangePickerSelectionMode
//                                                         .range,
//                                                     onSelectionChanged:
//                                                     selectionChanged,
//                                                     allowViewNavigation: false,
//                                                   ),
//                                                 ),
//                                                 actions: <Widget>[
//                                                   ButtonBar(
//                                                     children: [
//                                                       Row(
//                                                         children: [
//                                                           TextButton(
//                                                               onPressed: () {
//                                                                 Navigator.pop(
//                                                                     context);
//                                                               },
//                                                               child:
//                                                               const Text('OK')),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   )
//                                                 ],
//                                               );
//                                             });
//                                       },
//                                       child: TextFormField(
//                                         controller: _startDatecontroller,
//                                         enabled: false,
//                                         validator: (value) {
//                                           if (value == null || value.isEmpty) {
//                                             return 'Please enter date';
//                                           }
//                                           return null;
//                                         },
//                                         keyboardType: TextInputType.visiblePassword,
//                                         decoration: const InputDecoration(
//                                           hintText: 'dd / mm /yyyy',
//                                           filled: true,
//                                           enabledBorder: OutlineInputBorder(
//                                               borderSide:
//                                               BorderSide(color: kPrimaryColor)),
//                                           focusedBorder: OutlineInputBorder(
//                                               borderSide:
//                                               BorderSide(color: Colors.green)),
//                                         ),
//                                       ),
//                                     ),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: <Widget>[
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 15.0, top: 15.0),
//                                           child: SizedBox(
//                                             height: 40,
//                                             width: 95,
//                                             child: ElevatedButton(
//                                               style: ButtonStyle(
//                                                   backgroundColor:
//                                                   MaterialStateProperty.all(
//                                                       Colors.white),
//                                                   shape: MaterialStateProperty.all<
//                                                       RoundedRectangleBorder>(
//                                                       RoundedRectangleBorder(
//                                                         borderRadius:
//                                                         BorderRadius.circular(18.0),
//                                                       ))),
//                                               onPressed: () {
//                                                 Navigator.pop(context);
//                                               },
//                                               child: const Text("Cancel",
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       color: Colors.black)),
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 15.0, top: 15.0),
//                                           child: SizedBox(
//                                             height: 40,
//                                             width: 95,
//                                             child: ElevatedButton(
//                                               onPressed: () async {
//                                                 try {
//                                                   setState(() {
//                                                     isloading = true;
//                                                   });
//                                                   if (_mySelection == null) {
//                                                     Fluttertoast.showToast(
//                                                         msg: 'Select leave Type');
//                                                   } else if (_descriptionController
//                                                       .text.isEmpty) {
//                                                     Fluttertoast.showToast(
//                                                         msg:
//                                                         "Description can't be empty");
//                                                   } else if (_startDate!.isEmpty &&
//                                                       _endDate!.isEmpty) {
//                                                     Fluttertoast.showToast(
//                                                         msg:
//                                                         'select date for your leave');
//                                                   }
//                                                   else {
//                                                     final data = LeaveRequest(
//                                                         content:
//                                                         _descriptionController
//                                                             .text,
//                                                         endDate: _endDate,
//                                                         leaveTitle: "",
//                                                         leaveType: _mySelection,
//                                                         startDate: _startDate);
//
//                                                     PostLeaveResponse res =
//                                                     await LeaveService()
//                                                         .postLeave(data);
//                                                     if (res.success == true) {
//                                                       setState(() {
//                                                         isloading = true;
//                                                       });
//                                                       Navigator.of(context).pop();
//                                                       _descriptionController
//                                                           .clear();
//                                                       _startDate = "";
//                                                       _endDate = "";
//
//                                                       snackThis(
//                                                           context: context,
//                                                           content: Text(res.message
//                                                               .toString()),
//                                                           color: Colors.green,
//                                                           duration: 1,
//                                                           behavior: SnackBarBehavior
//                                                               .floating);
//                                                       setState(() {
//                                                         isloading = false;
//                                                       });
//                                                     } else {
//                                                       setState(() {
//                                                         isloading = true;
//                                                       });
//                                                       snackThis(
//                                                           context: context,
//                                                           content: Text(res.message
//                                                               .toString()),
//                                                           color: Colors.red,
//                                                           duration: 1,
//                                                           behavior: SnackBarBehavior
//                                                               .floating);
//                                                       setState(() {
//                                                         isloading = false;
//                                                       });
//                                                     }
//                                                   }
//                                                 } catch (e) {
//                                                   setState(() {
//                                                     isloading = true;
//                                                   });
//                                                   snackThis(
//                                                       context: context,
//                                                       content: Text(e.toString()),
//                                                       color: Colors.red,
//                                                       duration: 1,
//                                                       behavior: SnackBarBehavior
//                                                           .floating);
//                                                   setState(() {
//                                                     isloading = false;
//                                                   });
//                                                 }
//                                               },
//                                               style: ButtonStyle(
//                                                   backgroundColor:
//                                                   MaterialStateProperty.all(
//                                                       Colors.green),
//                                                   shape: MaterialStateProperty.all<
//                                                       RoundedRectangleBorder>(
//                                                       RoundedRectangleBorder(
//                                                         borderRadius:
//                                                         BorderRadius.circular(18.0),
//                                                       ))),
//                                               child: const Text(
//                                                 "Save",
//                                                 style: TextStyle(
//                                                     fontSize: 14,
//                                                     color: Colors.white),
//                                               ),
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           });
//                         },
//                       );
//                     },
//                     child: Container(
//                         width: 50,
//                         decoration: const BoxDecoration(
//                             color: Colors.red,
//                             borderRadius: BorderRadius.all(Radius.circular(50))),
//                         child: const Icon(
//                           Icons.add,
//                           color: Colors.white,
//                         )),
//                   ),
//                 )
//               ],
//               iconTheme: const IconThemeData(
//                 color: Colors.black, //change your color here
//               ),
//               elevation: 0.0,
//               title:
//               const Text("Book Leave", style: TextStyle(color: Colors.black)),
//               backgroundColor: Colors.white),
//           body: StreamBuilder<LeaveResponse>(
//             stream: leave_response,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 // return ListView.builder(itemBuilder: (context, index) {
//                 var showData = snapshot.data!.leave!;
//
//                 List<Event> collection = [];
//
//                 for (int i = 0; i < showData.length; i++) {
//                   DateTime start = DateTime.parse(showData[i].startDate.toString());
//
//                   start = start.add(const Duration(hours: 5, minutes: 45));
//
//                   var formattedTime = DateFormat('MM/DD/YY').format(start);
//                   collection.add(Event(
//                       eventName: showData[i].leaveType,
//                       isAllDay: false,
//                       from: DateTime.parse(showData[i].startDate.toString())
//                           .add(const Duration(hours: 5, minutes: 45)),
//                       to: DateTime.parse(showData[i].endDate.toString())
//                           .add(const Duration(hours: 5, minutes: 45)),
//                       background: Colors.green));
//                 }
//                 return SlidingUpPanel(
//                   controller: panelController,
//                   minHeight: panelHeightClosed,
//                   maxHeight: panelHeightOpen,
//                   parallaxEnabled: true,
//                   parallaxOffset: .5,
//                   body: SizedBox(
//                     child: SfCalendar(
//                       view: CalendarView.month,
//                       // showNavigationArrow: true,
//
//                       // onLongPress: (CalendarLongPressDetails details) {
//                       //   DateTime date = details.date!;
//                       //   dynamic appointments = details.appointments;
//                       //   CalendarElement view = details.targetElement;
//                       //   print(view.name);
//                       //   // print(date);
//                       // },
//                       todayHighlightColor: kPrimaryColor,
//                       selectionDecoration: BoxDecoration(
//                         color: Colors.transparent,
//                         border: Border.all(color: Colors.red, width: 2),
//                         borderRadius: const BorderRadius.all(Radius.circular(4)),
//                         shape: BoxShape.rectangle,
//                       ),
//                       timeSlotViewSettings: const TimeSlotViewSettings(
//                           startHour: 9,
//                           nonWorkingDays: <int>[DateTime.saturday],
//                           endHour: 16),
//                       dataSource: MeetingDataSource(collection),
//                       monthViewSettings: const MonthViewSettings(
//                           appointmentDisplayMode:
//                           MonthAppointmentDisplayMode.appointment),
//                       initialSelectedDate: DateTime.now(),
//                     ),
//                   ),
//                   panelBuilder: (controller) => PanelWidget(
//                     data: showData.reversed.toList(),
//                     controller: controller,
//                     panelController: panelController,
//                   ),
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(18),
//                   ),
//                   onPanelSlide: (position) => setState(() {
//                     // print(position);
//                     final panelMaxScrollExtent =
//                         panelHeightOpen - panelHeightClosed;
//                   }),
//                 );
//               } else {
//                 return const Center(
//                     child: SpinKitDualRing(
//                       color: kPrimaryColor,
//                     ));
//               }
//             },
//           ),
//         );
//       }
//     );
//   }
//
//   selectionChanged(DateRangePickerSelectionChangedArgs args) {
//     setState(() {
//       _startDate =
//           DateFormat('yyyy-MM-dd').format(args.value.startDate).toString();
//       _endDate = DateFormat('yyyy-MM-dd')
//           .format(
//           args.value.endDate ?? args.value.startDate.add(Duration(days: 1)))
//           .toString();
//
//       _startDatecontroller.text =
//           _startDate.toString() + " " + _endDate.toString();
//     });
//   }
// // MeetingDataSource _getCalendarDataSource([List<Event> collection]) {
// //   List<Event> meetings = collection ?? <Event>[];
// //   return MeetingDataSource(meetings);
// // }
//
// // MettingDataSource _getCalendarDatSource([List<Event> collection])
// }
//
// class MeetingDataSource extends CalendarDataSource {
//   MeetingDataSource(List<Event> source) {
//     appointments = source;
//   }
//
//   @override
//   DateTime getStartTime(int index) {
//     return appointments![index].from;
//   }
//
//   @override
//   DateTime getEndTime(int index) {
//     return appointments![index].to;
//   }
//
//   @override
//   bool isAllDay(int index) {
//     return appointments![index].isAllDay;
//   }
//
//   @override
//   String getSubject(int index) {
//     return appointments![index].eventName;
//   }
//
//   @override
//   Color getColor(int index) {
//     return appointments![index].background;
//   }
// }
//
// class Event {
//   Event(
//       {this.eventName,
//         this.from,
//         this.to,
//         this.background,
//         this.isAllDay = false});
//
//   String? eventName;
//   DateTime? from;
//   DateTime? to;
//   Color? background;
//   bool? isAllDay;
// }
