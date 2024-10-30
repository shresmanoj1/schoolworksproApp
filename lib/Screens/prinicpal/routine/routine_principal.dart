// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:grouped_list/grouped_list.dart';
// import 'package:provider/provider.dart';
// import 'package:schoolworkspro_app/Screens/prinicpal/principal_common_view_model.dart';
// import 'package:schoolworkspro_app/Screens/prinicpal/routine/update_routine.dart';
// import 'package:schoolworkspro_app/Screens/prinicpal/stats_common_view_model.dart';
// import 'package:schoolworkspro_app/config/api_response_config.dart';
// import 'package:schoolworkspro_app/constants.dart';
//
// class RoutinePrincipal extends StatefulWidget {
//   const RoutinePrincipal({Key? key}) : super(key: key);
//
//   @override
//   _RoutinePrincipalState createState() => _RoutinePrincipalState();
// }
//
// class _RoutinePrincipalState extends State<RoutinePrincipal> {
//   late PrinicpalCommonViewModel _provider;
//   late StatsCommonViewModel _provider2;
//   String? selected_teacher;
//   String? selected_class;
//   String? selected_batch;
//   @override
//   void initState() {
//     // TODO: implement initState
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _provider = Provider.of<PrinicpalCommonViewModel>(context, listen: false);
//       _provider2 = Provider.of<StatsCommonViewModel>(context, listen: false);
//       _provider.fetchallteacher();
//       Map<String, dynamic> datas = {};
//       _provider.fetchallclass(datas);
//       _provider2.fetchAllBatch();
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer2<PrinicpalCommonViewModel, StatsCommonViewModel>(
//         builder: (context, value, stats, child) {
//       return Scaffold(
//           appBar: AppBar(
//             elevation: 0.0,
//             iconTheme: const IconThemeData(color: Colors.black),
//             backgroundColor: Colors.white,
//             title: const Text(
//               "Routines",
//               style: TextStyle(color: Colors.black),
//             ),
//           ),
//           body: ListView(
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             children: [
//               DropdownButtonFormField(
//                 isExpanded: true,
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   filled: true,
//                   hintText: 'Select Lecturer/Teacher',
//                 ),
//                 icon: const Icon(Icons.arrow_drop_down_outlined),
//                 items: value.allteacher.map((pt) {
//                   return DropdownMenuItem(
//                     value: pt.email,
//                     child: Text(
//                       pt.firstname.toString() + " " + pt.lastname.toString(),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (newVal) {
//                   setState(() {
//                     selected_teacher = newVal as String?;
//                     _provider2.fetchAllRoutines(
//                         "lecturers/${selected_teacher.toString()}");
//                     selected_class = null;
//                     selected_batch = null;
//                   });
//                 },
//                 value: selected_teacher,
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               DropdownButtonFormField(
//                 isExpanded: true,
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   filled: true,
//                   hintText: 'Select Classroom',
//                 ),
//                 icon: const Icon(Icons.arrow_drop_down_outlined),
//                 items: value.allroom.map((pt) {
//                   return DropdownMenuItem(
//                     value: pt,
//                     child: Text(
//                       pt,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (newVal) {
//                   setState(() {
//                     selected_class = newVal as String?;
//                     Map<String, dynamic> datas = {
//                       "classroom": selected_class.toString()
//                     };
//
//                     _provider2.fetchAllRoutinesfromclass(datas);
//                     selected_teacher = null;
//                     selected_batch = null;
//                   });
//                 },
//                 value: selected_class,
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               DropdownButtonFormField(
//                 isExpanded: true,
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   filled: true,
//                   hintText: 'Select all Batch',
//                 ),
//                 icon: const Icon(Icons.arrow_drop_down_outlined),
//                 items: stats.allbatches.map((pt) {
//                   return DropdownMenuItem(
//                     value: pt.batch.toString(),
//                     child: Text(
//                       pt.batch.toString(),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (newVal) {
//                   setState(() {
//                     selected_batch = newVal as String?;
//                     _provider2.fetchAllRoutines(selected_batch.toString());
//                     selected_class = null;
//                     selected_teacher = null;
//                   });
//                 },
//                 value: selected_batch,
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               selected_class == null ? SizedBox()  : isLoading(stats.allroutinefromclassApiResponse) ?
//               Center(child: SpinKitDualRing(color: kPrimaryColor,),) :
//               stats.routines.isEmpty
//                   ? Column(
//                 children: [
//                   Image.asset("assets/images/no_content.PNG")
//                 ],
//               ) :
//               GroupedListView<dynamic, String>(
//                 elements: stats.routines,
//                 shrinkWrap: true,
//                 sort: true,
//                 physics: const ScrollPhysics(),
//                 groupBy: (element) => getWeekString(
//                     DateFormat('EEEE').format(
//                         DateTime.parse(element['start'])))
//                     .toString(),
//                 groupComparator: (value1, value2) =>
//                     value2.compareTo(value1),
//                 itemComparator: (item1, item2) =>
//                     DateFormat('EEEE')
//                         .format(DateTime.parse(item1['start']))
//                         .compareTo(DateFormat('EEEE').format(
//                         DateTime.parse(item2['start']))),
//                 order: GroupedListOrder.DESC,
//                 useStickyGroupSeparators: true,
//                 groupSeparatorBuilder: (String value) => Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Builder(builder: (context) {
//                     return Text(
//                       value.toString() == "1"
//                           ? "Sunday"
//                           : value.toString() == "2"
//                           ? "Monday"
//                           : value.toString() == "3"
//                           ? "Tuesday"
//                           : value.toString() == "4"
//                           ? "Wednesday"
//                           : value.toString() == "5"
//                           ? "Thursday"
//                           : value.toString() ==
//                           "6"
//                           ? "Friday"
//                           : "Saturday",
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18),
//                     );
//                   }),
//                 ),
//                 itemBuilder: (c, element) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 10.0, vertical: 5),
//                     child: Container(
//                       decoration: const BoxDecoration(
//                           color: Colors.green,
//                           borderRadius: BorderRadius.all(
//                               Radius.circular(20))),
//                       child: ListTile(
//                         onTap: () {},
//                         contentPadding:
//                         const EdgeInsets.symmetric(
//                           horizontal: 20.0,
//                         ),
//                         title: Text(
//                           element['title'],
//                           style: const TextStyle(
//                               color: Colors.white),
//                         ),
//                         subtitle: Row(
//                           children: [
//                             Text(
//                               DateFormat.jm()
//                                   .format(DateTime.parse(
//                                   element['start'])
//                                   .add(const Duration(
//                                   hours: 5, minutes: 45)))
//                                   .toString(),
//                               style:
//                               TextStyle(color: Colors.white),
//                             ),
//                             Text(
//                               ' - ',
//                               style:
//                               TextStyle(color: Colors.white),
//                             ),
//                             Text(
//                               DateFormat.jm()
//                                   .format(DateTime.parse(
//                                   element['end'])
//                                   .add(Duration(
//                                   hours: 5, minutes: 45)))
//                                   .toString(),
//                               style:
//                               TextStyle(color: Colors.white),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               selected_teacher == null &&
//                       selected_batch == null
//                   ? SizedBox()
//                   :
//               isLoading(stats.allroutineApiResponse)
//                       ? Center(
//                           child: SpinKitDualRing(
//                             color: kPrimaryColor,
//                           ),
//                         )
//                       : stats.routines.isEmpty
//                           ? Column(
//                               children: [
//                                 Image.asset("assets/images/no_content.PNG")
//                               ],
//                             )
//                           : GroupedListView<dynamic, String>(
//                               elements: stats.routines,
//                               shrinkWrap: true,
//                               sort: true,
//                               physics: const ScrollPhysics(),
//                               groupBy: (element) => getWeekString(
//                                       DateFormat('EEEE').format(
//                                           DateTime.parse(element['start'])))
//                                   .toString(),
//                               groupComparator: (value1, value2) =>
//                                   value2.compareTo(value1),
//                               itemComparator: (item1, item2) =>
//                                   DateFormat('EEEE')
//                                       .format(DateTime.parse(item1['start']))
//                                       .compareTo(DateFormat('EEEE').format(
//                                           DateTime.parse(item2['start']))),
//                               order: GroupedListOrder.DESC,
//                               useStickyGroupSeparators: true,
//                               groupSeparatorBuilder: (String value) => Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Builder(builder: (context) {
//                                   return Text(
//                                     value.toString() == "1"
//                                         ? "Sunday"
//                                         : value.toString() == "2"
//                                             ? "Monday"
//                                             : value.toString() == "3"
//                                                 ? "Tuesday"
//                                                 : value.toString() == "4"
//                                                     ? "Wednesday"
//                                                     : value.toString() == "5"
//                                                         ? "Thursday"
//                                                         : value.toString() ==
//                                                                 "6"
//                                                             ? "Friday"
//                                                             : "Saturday",
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18),
//                                   );
//                                 }),
//                               ),
//                               itemBuilder: (c, element) {
//                                 return Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 10.0, vertical: 5),
//                                   child: Container(
//                                     decoration: const BoxDecoration(
//                                         color: Colors.green,
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(20))),
//                                     child: ListTile(
//                                       onTap: () {
//                                         // Navigator.push(context,
//                                         //     MaterialPageRoute(
//                                         //         builder: (context) {
//                                         //           return UpdateRoutine(element: element, teacher: selected_teacher, batch: selected_batch );
//                                         //         }));
//                                       },
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                         horizontal: 20.0,
//                                       ),
//                                       title: Text(
//                                         element['title'],
//                                         style: const TextStyle(
//                                             color: Colors.white),
//                                       ),
//                                       subtitle: Row(
//                                         children: [
//                                           Text(
//                                             DateFormat.jm()
//                                                 .format(DateTime.parse(
//                                                         element['start'])
//                                                     .add(const Duration(
//                                                         hours: 5, minutes: 45)))
//                                                 .toString(),
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           ),
//                                           Text(
//                                             ' - ',
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           ),
//                                           Text(
//                                             DateFormat.jm()
//                                                 .format(DateTime.parse(
//                                                         element['end'])
//                                                     .add(Duration(
//                                                         hours: 5, minutes: 45)))
//                                                 .toString(),
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             )
//             ],
//           ));
//     });
//   }
//
//   dynamic getWeekString(dynamic data) {
//     switch (data) {
//       case "Sunday":
//         return 1;
//       case "Monday":
//         return 2;
//       case "Tuesday":
//         return 3;
//       case "Wednesday":
//         return 4;
//       case "Thursday":
//         return 5;
//       case "Friday":
//         return 6;
//       case "Saturday":
//         return 7;
//       default:
//         return 'Err';
//     }
//   }
// }
