// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import 'package:schoolworkspro_app/common_view_model.dart';
// import '../../../config/api_response_config.dart';
// import '../../../constants/colors.dart';
// import '../../result/result_view_model.dart';
//
// class ResultSoftwaricaParentScreen extends StatefulWidget {
//   final institution;
//   final studentID;
//   final bool dues;
//   const ResultSoftwaricaParentScreen(
//       {Key? key, this.institution, this.studentID, required this.dues})
//       : super(key: key);
//
//   @override
//   _ResultSoftwaricaParentScreenState createState() =>
//       _ResultSoftwaricaParentScreenState();
// }
//
// class _ResultSoftwaricaParentScreenState
//     extends State<ResultSoftwaricaParentScreen> {
//   // Future<Resultresponse>? result_response;
//
//   late StudentResultViewModel _provider;
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _provider = Provider.of<StudentResultViewModel>(context, listen: false);
//       _provider.fetchChildrenResults(
//           widget.studentID.toString(), widget.institution.toString());
//     });
//
//     // getData();
//     super.initState();
//   }
//
//   getData() async {
//     // final institution =
//     // Parentresultheader(institution: widget.institution.toString());
//     // result_response = Parentresultservice()
//     //     .getallresults(institution, widget.studentID.toString());
//     //
//     // final abc = await Parentresultservice()
//     //     .getallresults(institution, widget.studentID.toString());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer2<StudentResultViewModel, CommonViewModel>(
//         builder: (context, snapshot, common, child) {
//       return Scaffold(
//           appBar: AppBar(
//             title: const Text('Results', style: TextStyle(color: white)),
//             elevation: 0.0,
//           ),
//           body: widget.dues == true
//               ? Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: const [
//                       Text(
//                         "Dues Amount Alert",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 18),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "You have dues amount in pending. Please clear the dues amount to access this result",
//                         textAlign: TextAlign.center,
//                       )
//                     ],
//                   ),
//                 )
//               : isLoading(snapshot.childrenResultsApiResponse)
//                   ? const Center(child: CupertinoActivityIndicator())
//                   : snapshot.childrenResults.marks == null ||
//                           snapshot.childrenResults.columns == null
//                       ? Center(
//                           child: Column(
//                             children: [
//                               Image.asset(
//                                 "assets/images/no_content.PNG",
//                               ),
//                               const Text("No result available",
//                                   textAlign: TextAlign.center),
//                             ],
//                           ),
//                         )
//                       : SingleChildScrollView(
//                           child: Column(
//                             children: [
//                               SingleChildScrollView(
//                                 scrollDirection: Axis.horizontal,
//                                 child: Column(
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Card(
//                                         elevation: 4,
//                                         child: DataTable(
//                                           showBottomBorder: true,
//                                           headingRowColor:
//                                               MaterialStateProperty.all(
//                                                   Color(0xffCF407F)),
//                                           columns: [
//                                             const DataColumn(
//                                                 label: Text(
//                                                   'Subjects',
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontSize: 17.0,
//                                                       color: Colors.white),
//                                                 ),
//                                                 tooltip: 'marks of Subjects'),
//                                             ...List.generate(
//                                                 snapshot.childrenResults
//                                                             .columns ==
//                                                         null
//                                                     ? 0
//                                                     : snapshot
//                                                         .childrenResults
//                                                         .columns!
//                                                         .length, (index) {
//                                               return DataColumn(
//                                                 label: Text(
//                                                   snapshot.childrenResults
//                                                       .columns![index],
//                                                   style: const TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontSize: 17.0,
//                                                       color: Colors.white),
//                                                 ),
//                                               );
//                                             }),
//                                             // const DataColumn(
//                                             //     label: Text(
//                                             //       'Released Date',
//                                             //       style: TextStyle(
//                                             //           fontWeight: FontWeight.bold,
//                                             //           fontSize: 17.0,
//                                             //           color: Colors.white),
//                                             //     ),
//                                             //     tooltip: 'Released Date'),
//                                           ],
//                                           rows: List.generate(
//                                               snapshot.childrenResults.marks ==
//                                                           null ||
//                                                       snapshot.childrenResults
//                                                           .marks!.isEmpty
//                                                   ? 0
//                                                   : snapshot.childrenResults
//                                                       .marks!.length, (index) {
//                                             return DataRow(cells: [
//                                               DataCell(GestureDetector(
//                                                 behavior:
//                                                     HitTestBehavior.opaque,
//                                                 onTap: () {},
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           top: 8.0),
//                                                   child: Column(
//                                                     children: [
//                                                       Builder(
//                                                           builder: (context) {
//                                                         try {
//                                                           return snapshot.childrenResults
//                                                                               .marks![
//                                                                           index]
//                                                                       [
//                                                                       "moduleTitle"] ==
//                                                                   null
//                                                               ? Text('-')
//                                                               : Text(
//                                                                   snapshot
//                                                                       .childrenResults
//                                                                       .marks![
//                                                                           index]
//                                                                           [
//                                                                           "moduleTitle"]
//                                                                       .toString(),
//                                                                   style: const TextStyle(
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold,
//                                                                       fontSize:
//                                                                           15),
//                                                                 );
//                                                         } on Exception catch (e) {
//                                                           return const Text("");
//                                                           // TODO
//                                                         }
//                                                       }),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               )),
//                                               ...List.generate(
//                                                   snapshot
//                                                       .childrenResults
//                                                       .columns!
//                                                       .length, (innerIndex) {
//                                                 return DataCell(GestureDetector(
//                                                   behavior:
//                                                       HitTestBehavior.opaque,
//                                                   onTap: () {},
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             top: 8.0),
//                                                     child: Column(
//                                                       children: [
//                                                         Builder(
//                                                             builder: (context) {
//                                                           try {
//                                                             return snapshot
//                                                                         .childrenResults
//                                                                         .marks![index][snapshot
//                                                                             .childrenResults
//                                                                             .columns![
//                                                                         innerIndex]] !=
//                                                                     null
//                                                                 ? snapshot.childrenResults.columns![innerIndex] ==
//                                                                             "Mm" &&
//                                                                         widget.institution ==
//                                                                             "softwarica"
//                                                                     ? Text("-")
//                                                                     : Text(
//                                                                         snapshot
//                                                                             .childrenResults
//                                                                             .marks![index][snapshot.childrenResults.columns![innerIndex]]
//                                                                             .toString(),
//                                                                         style: const TextStyle(
//                                                                             fontWeight:
//                                                                                 FontWeight.bold,
//                                                                             fontSize: 15),
//                                                                       )
//                                                                 : Text("-");
//                                                           } on Exception catch (e) {
//                                                             return const Text(
//                                                                 "");
//                                                             // TODO
//                                                           }
//                                                         }),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ));
//                                               }),
//                                               // DataCell(GestureDetector(
//                                               //   behavior: HitTestBehavior.opaque,
//                                               //   onTap: () {},
//                                               //   child: Padding(
//                                               //     padding:
//                                               //         const EdgeInsets.only(top: 8.0),
//                                               //     child: Column(
//                                               //       children: [
//                                               //         Builder(builder: (context) {
//                                               //           try {
//                                               //             return snapshot.childrenResults
//                                               //                             .marks![index][
//                                               //                         "releasedDate"] ==
//                                               //                     null
//                                               //                 ? snapshot.childrenResults
//                                               //                                 .marks![index]
//                                               //                             [
//                                               //                             "updatedAt"] ==
//                                               //                         null
//                                               //                     ? Text("-")
//                                               //                     : Text(DateFormat.yMMMEd().format(
//                                               //                         DateTime.parse(snapshot
//                                               //                                 .childrenResults
//                                               //                                 .marks![index]
//                                               //                             ["updatedAt"])))
//                                               //                 : Text(
//                                               //                     DateFormat.yMMMEd().format(
//                                               //                         DateTime.parse(snapshot
//                                               //                                 .childrenResults
//                                               //                                 .marks![index]
//                                               //                             [
//                                               //                             "releasedDate"])),
//                                               //                   );
//                                               //           } on Exception catch (e) {
//                                               //             return const Text("");
//                                               //             // TODO
//                                               //           }
//                                               //         }),
//                                               //       ],
//                                               //     ),
//                                               //   ),
//                                               // )),
//                                             ]);
//                                           }),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ));
//     });
//   }
// }
