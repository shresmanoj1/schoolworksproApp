// // import 'dart:convert';
// //
// // import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:provider/provider.dart';
// import 'package:schoolworkspro_app/Screens/lecturer/my-modules/attendance/attendance_detail.dart';
// import 'package:schoolworkspro_app/Screens/lecturer/my-modules/attendance/attendance_lecturer_view_model.dart';
// import 'package:schoolworkspro_app/Screens/lecturer/my-modules/attendance/new_attendance.dart';
//
// import '../../../../common_view_model.dart';
// import 'package:intl/intl.dart';
//
// import '../../../../config/api_response_config.dart';
// import '../../../../constants.dart';
//
// class Attendancelecturer extends StatefulWidget {
//   final moduleSlug;
//   final moduleTitle;
//   const Attendancelecturer(
//       {Key? key, this.moduleSlug, this.moduleTitle})
//       : super(key: key);
//
//   @override
//   State<Attendancelecturer> createState() =>
//       _AttendancelecturerState();
// }
//
// class _AttendancelecturerState extends State<Attendancelecturer> {
//   late CommonViewModel _provider;
//   late ModuleAttendanceLecturer _provider2;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//           Provider.of<ModuleAttendanceLecturer>(context, listen: false).fetchAttendanceBatches(widget.moduleSlug);
//
//       // _provider.setSlug(widget.moduleSlug);
//       // _provider.fetchBatches();
//
//       // _provider2 = Provider.of<GradeViewModel>(context, listen: false);
//       //
//       // _provider2.fetchheadings(widget.moduleSlug);
//     });
//
//     super.initState();
//   }
//
//   String? selected_batch;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.moduleTitle,
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0.0,
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: Consumer2<CommonViewModel, ModuleAttendanceLecturer>(
//           builder: (context, common, attendance, child) {
//         return ListView(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           children: [
//             DropdownButtonFormField(
//               isExpanded: true,
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 filled: true,
//                 hintText: 'select batch/section',
//               ),
//               icon: const Icon(Icons.arrow_drop_down_outlined),
//               items: attendance.heading.map((pt) {
//                 return DropdownMenuItem(
//                   value: pt,
//                   child: Text(
//                     pt,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 );
//               }).toList(),
//               onChanged: (newVal) async {
//                 setState(() {
//                   selected_batch = newVal as String?;
//                 });
//
//                 await Provider.of<ModuleAttendanceLecturer>(context,
//                         listen: false)
//                     .fetchCheckAttendance(widget.moduleSlug, newVal);
//
//                 await Provider.of<ModuleAttendanceLecturer>(context,
//                         listen: false)
//                     .fetchStudentAttendance(
//                         widget.moduleSlug, newVal);
//               },
//               value: selected_batch,
//             ),
//             selected_batch != null ?
//             isLoading(attendance.checkAttendanceApiResponse)
//                 ? const SizedBox()
//                 : attendance.checkAttendance == true
//                     ? isLoading(attendance.getAttendacenApiResponse)
//                         ? Center(
//                             child: SpinKitDualRing(
//                               color: kPrimaryColor,
//                             ),
//                           )
//                         : attendance.getStudentAttendance.isNotEmpty
//                             ? ListView.builder(
//                                 physics: const ScrollPhysics(),
//                                 shrinkWrap: true,
//                                 itemCount: attendance
//                                     .getStudentAttendance.length,
//                                 itemBuilder: (context, index) {
//                                   DateTime start = DateTime.parse(
//                                       attendance
//                                               .getStudentAttendance[
//                                           index]['createdAt']);
//                                   start = start.add(const Duration(
//                                       hours: 5, minutes: 45));
//                                   var formattedTime =
//                                       DateFormat('MMMM d yyyy')
//                                           .format(start);
//
//                                   return Row(children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.all(8.0),
//                                         child:
//                                             CircularPercentIndicator(
//                                           radius: 45.0,
//                                           lineWidth: 6.0,
//                                           percent: double.parse(attendance
//                                                   .getStudentAttendance[
//                                                       index][
//                                                       'presentPercentage']
//                                                   .split(".")[0]) /
//                                               100,
//                                           center: Text(
//                                             attendance
//                                                     .getStudentAttendance[
//                                                         index][
//                                                         'presentPercentage']
//                                                     .split(".")[0] +
//                                                 "%",
//                                             style: const TextStyle(
//                                                 fontSize: 12),
//                                           ),
//                                           progressColor: Colors.green,
//                                           animationDuration: 100,
//                                           animateFromLastPercent:
//                                               true,
//                                           arcType: ArcType.FULL,
//                                           arcBackgroundColor:
//                                               Colors.black12,
//                                           backgroundColor:
//                                               Colors.white,
//                                           animation: true,
//                                           circularStrokeCap:
//                                               CircularStrokeCap.butt,
//                                         ),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       flex: 3,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.all(8.0),
//                                         child: Column(
//                                           children: [
//                                             Text("Attendance of: "),
//                                             Text(formattedTime)
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: InkWell(
//                                         onTap: () {
//                                           Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     AttendanceDetail(
//                                                   id: attendance
//                                                           .getStudentAttendance[
//                                                       index]['_id'],
//                                                   absent_student:
//                                                       attendance.getStudentAttendance[
//                                                               index][
//                                                           'absent_students'],
//                                                   present_student:
//                                                       attendance.getStudentAttendance[
//                                                               index][
//                                                           'present_students'],
//                                                   batch: attendance
//                                                           .getStudentAttendance[
//                                                       index]['batch'],
//                                                   module_slug: widget
//                                                       .moduleSlug,
//                                                   date: formattedTime,
//                                                 ),
//                                               ));
//                                         },
//                                         child: const Padding(
//                                           padding:
//                                               EdgeInsets.all(3.0),
//                                           child: Icon(
//                                             Icons.edit_rounded,
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                   ]);
//                                 },
//                               )
//                             : Image.asset(
//                                 "assets/images/no_content.PNG")
//                     : attendance.checkAttendance == false
//                         ? Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 15.0),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.end,
//                                   children: [
//                                     ElevatedButton(
//                                         onPressed: () {
//                                           Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     NewAttendanceScreen(
//                                                         batch: selected_batch
//                                                             .toString(),
//                                                         module_slug:
//                                                             widget
//                                                                 .moduleSlug),
//                                               ));
//                                         },
//                                         child: const Text(
//                                             "New Attendance")),
//                                   ],
//                                 ),
//                               ),
//                               Image.asset(
//                                   "assets/images/no_content.PNG"),
//                             ],
//                           )
//                         : SizedBox()
//
//                 : SizedBox()
//           ],
//         );
//       }),
//     );
//   }
// }
