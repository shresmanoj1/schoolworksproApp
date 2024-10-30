// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
// import 'package:schoolworkspro_app/constants.dart';
// import 'package:schoolworkspro_app/request/lecturer/overtime_request.dart';
// import 'package:schoolworkspro_app/response/lecturer/addovertime_response.dart';
// import 'package:schoolworkspro_app/services/lecturer/overtime_service.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:intl/intl.dart';
//
// class OvertimeAdminScreen extends StatefulWidget {
//   const OvertimeAdminScreen({Key? key}) : super(key: key);
//
//   @override
//   _OvertimeAdminScreenState createState() => _OvertimeAdminScreenState();
// }
//
// class _OvertimeAdminScreenState extends State<OvertimeAdminScreen> {
//   final TextEditingController _fromdatecontroller = TextEditingController();
//   final TextEditingController _todatecontroller = TextEditingController();
//   final TextEditingController _descriptioncontroller = TextEditingController();
//   final DateRangePickerController _controller = DateRangePickerController();
//   final DateRangePickerController _controller2 = DateRangePickerController();
//   String? _startDate;
//   String? _endDate;
//   bool isloading = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     _startDate = "";
//     _endDate = "";
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isloading == true) {
//       context.loaderOverlay.show();
//     } else {
//       context.loaderOverlay.hide();
//     }
//     return Scaffold(
//       appBar: AppBar(
//           iconTheme: const IconThemeData(
//             color: Colors.black, //change your color here
//           ),
//           elevation: 0.0,
//           title: const Text("Request Overtime",
//               style: TextStyle(color: Colors.black)),
//           backgroundColor: Colors.white),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: InkWell(
//                       onTap: () {
//                         showDialog(
//                             context: context,
//                             builder: (context) {
//                               return CupertinoAlertDialog(
//                                 insetAnimationCurve: Curves.bounceIn,
//                                 insetAnimationDuration:
//                                     const Duration(milliseconds: 50),
//                                 title: const Text('Select Start Date'),
//                                 content: SizedBox(
//                                   height: 250,
//                                   child: SfDateRangePicker(
//
//                                     enablePastDates: false,
//                                     controller: _controller,
//                                     selectionMode:
//                                         DateRangePickerSelectionMode.single,
//                                     onSelectionChanged: selectionChanged,
//                                     allowViewNavigation: false,
//                                   ),
//                                 ),
//                                 actions: <Widget>[
//                                   ButtonBar(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           TextButton(
//                                               onPressed: () {
//                                                 Navigator.pop(context);
//                                               },
//                                               child: const Text('OK')),
//                                         ],
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               );
//                             });
//                       },
//                       child: TextFormField(
//                         enabled: false,
//                         controller: _fromdatecontroller,
//                         keyboardType: TextInputType.visiblePassword,
//                         decoration: const InputDecoration(
//                           hintText: 'DD/MM/YYYY',
//                           label: Text('From date'),
//                           filled: true,
//                           floatingLabelBehavior: FloatingLabelBehavior.always,
//                           enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: kPrimaryColor)),
//                           focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.green)),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   Expanded(
//                     child: InkWell(
//                       onTap: () {
//                         showDialog(
//                             context: context,
//                             builder: (context) {
//                               return CupertinoAlertDialog(
//                                 insetAnimationCurve: Curves.bounceIn,
//                                 insetAnimationDuration:
//                                     const Duration(milliseconds: 50),
//                                 title: const Text('select end date'),
//                                 content: SizedBox(
//                                   height: 250,
//                                   child: SfDateRangePicker(
//                                     enablePastDates: false,
//                                     controller: _controller2,
//                                     selectionMode:
//                                         DateRangePickerSelectionMode.single,
//                                     onSelectionChanged: selectionChanged2,
//                                     allowViewNavigation: false,
//                                   ),
//                                 ),
//                                 actions: <Widget>[
//                                   ButtonBar(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           TextButton(
//                                               onPressed: () {
//                                                 Navigator.pop(context);
//                                               },
//                                               child: const Text('OK')),
//                                         ],
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               );
//                             });
//                       },
//                       child: TextFormField(
//                         enabled: false,
//                         controller: _todatecontroller,
//                         keyboardType: TextInputType.visiblePassword,
//                         decoration: const InputDecoration(
//                           hintText: 'DD/MM/YYYY',
//                           label: Text('To Date'),
//                           floatingLabelBehavior: FloatingLabelBehavior.always,
//                           filled: true,
//                           enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: kPrimaryColor)),
//                           focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.green)),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 controller: _descriptioncontroller,
//                 maxLines: 5,
//                 keyboardType: TextInputType.visiblePassword,
//                 decoration: const InputDecoration(
//                   hintText: 'Reason for overtime',
//                   label: Text('Purpose'),
//                   filled: true,
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                   enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: kPrimaryColor)),
//                   focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.green)),
//                 ),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(left: 15.0, top: 15.0),
//                   child: SizedBox(
//                     height: 40,
//                     width: 95,
//                     child: ElevatedButton(
//                       style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(Colors.white),
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(18.0),
//                           ))),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Text("Cancel",
//                           style: TextStyle(fontSize: 14, color: Colors.black)),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 15.0, top: 15.0),
//                   child: SizedBox(
//                     height: 40,
//                     width: 95,
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         if (_fromdatecontroller.text.isEmpty) {
//                           Fluttertoast.showToast(msg: 'Select From Date');
//                         }
//                         else if (_todatecontroller.text.isEmpty) {
//                           Fluttertoast.showToast(msg: 'Select To Date');
//                         }
//                         else if (_descriptioncontroller.text.isEmpty) {
//                           Fluttertoast.showToast(
//                               msg: "Description can't be empty");
//                         }
//                         else {
//                           setState(() {
//                             isloading = true;
//                           });
//                           final request = OvertimeRequest(
//                             startDate: _startDate,
//                             endDate: _endDate,
//                             purpose: _descriptioncontroller.text,
//                           );
//
//                           AddOvertimeResponse res =
//                               await OvertimeService().postovertime(request);
//                           try {
//                             if (res.success == true) {
//                               setState(() {
//                                 isloading = true;
//                               });
//                               snackThis(
//                                   context: context,
//                                   content: Text(res.message.toString()),
//                                   color: Colors.green,
//                                   duration: 1,
//                                   behavior: SnackBarBehavior.floating);
//
//                               _fromdatecontroller.clear();
//                               _todatecontroller.clear();
//                               _descriptioncontroller.clear();
//                               setState(() {
//                                 isloading = false;
//                               });
//                             } else {
//                               setState(() {
//                                 isloading = true;
//                               });
//                               snackThis(
//                                   context: context,
//                                   content: Text(res.message.toString()),
//                                   color: Colors.red,
//                                   duration: 1,
//                                   behavior: SnackBarBehavior.floating);
//                               setState(() {
//                                 isloading = false;
//                               });
//                             }
//                           } catch (e) {
//                             setState(() {
//                               isloading = true;
//                             });
//                             snackThis(
//                                 context: context,
//                                 content: Text(res.message.toString()),
//                                 color: Colors.red,
//                                 duration: 1,
//                                 behavior: SnackBarBehavior.floating);
//                             setState(() {
//                               isloading = false;
//                             });
//                           }
//                         }
//                       },
//                       style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(Colors.green),
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(18.0),
//                           ))),
//                       child: const Text(
//                         "Save",
//                         style: TextStyle(fontSize: 14, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   selectionChanged(DateRangePickerSelectionChangedArgs args) {
//     setState(() {
//       _startDate = DateFormat('yyyy-MM-dd').format(args.value).toString();
//
//       _fromdatecontroller.text = _startDate.toString();
//     });
//   }
//
//   selectionChanged2(DateRangePickerSelectionChangedArgs args) {
//     setState(() {
//       _endDate = DateFormat('yyyy-MM-dd').format(args.value).toString();
//
//       _todatecontroller.text = _endDate.toString();
//     });
//   }
// }
