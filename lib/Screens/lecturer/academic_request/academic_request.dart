import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/admin/request_detail/individualrequestdetail.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/admin/adminchangestatus_request.dart';
import 'package:schoolworkspro_app/response/admin/adminchangeticketstatus_response.dart';
import 'package:schoolworkspro_app/services/admin/getassignedrequest_service.dart';
import 'package:schoolworkspro_app/services/admin/getstaff_service.dart';
import 'package:intl/intl.dart';
import 'package:schoolworkspro_app/ticket_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../constants/colors.dart';
import '../../../helper/custom_loader.dart';
import '../../../response/login_response.dart';
import '../../../utils/preference_utils.dart';

class AcademicRequestLecturer extends StatefulWidget {
  const AcademicRequestLecturer({Key? key}) : super(key: key);

  @override
  _AcademicRequestLecturerState createState() =>
      _AcademicRequestLecturerState();
}

class _AcademicRequestLecturerState extends State<AcademicRequestLecturer> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TicketViewModel>(
        create: (_) => TicketViewModel(), child: AcademicRequestBody());
  }
}

class AcademicRequestBody extends StatefulWidget {
  const AcademicRequestBody({Key? key}) : super(key: key);

  @override
  _AcademicRequestBodyState createState() => _AcademicRequestBodyState();
}

class _AcademicRequestBodyState extends State<AcademicRequestBody> {
  // late Stream<LecturerRequestResponse> request_response;
  DateTime? _startDate;
  DateTime? _endDate;
  User? user;
  final DateRangePickerController _controller = DateRangePickerController();

  String? department;
  String? staff;
  String? staff_username;
  List<dynamic> department_list = <dynamic>[];
  List<dynamic> staff_list = <dynamic>[];
  bool assignloading = false;
  bool menubarloading = false;
  late TicketViewModel _provider;

  @override
  void initState() {
    getData();

    // TODO: implement initState

    getStaff();
    super.initState();
  }

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<TicketViewModel>(context, listen: false);
      _provider.fetchAcademicRequest().then((value) {
        int outputacademic = _provider.backlogAcademic +
            _provider.pendingAcademic +
            _provider.approvedAcademic +
            _provider.resolvedAcademic;
        sharedPreferences.setInt('insideacademic', outputacademic);
      });
    });
  }

  getStaff() async {
    final dropdown = await StaffService().getStaff();
    for (int i = 0; i < dropdown.users!.length; i++) {
      setState(() {
        department_list.add(dropdown.users![i]['type']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (menubarloading == true) {
      customLoadStart();
    } else if (menubarloading == false) {
      customLoadStop();
    } else if (assignloading == true) {
      customLoadStart();
    } else if (assignloading == false) {
      customLoadStop();
    }

    return Consumer<TicketViewModel>(builder: (context, value, child) {
      return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBar(
              backgroundColor: white,
              automaticallyImplyLeading: false,
                // actions: [
                //   IconButton(
                //       onPressed: () async {
                //         showDialog(
                //             context: context,
                //             builder: (context) {
                //               return CupertinoAlertDialog(
                //                 insetAnimationCurve: Curves.bounceIn,
                //                 insetAnimationDuration:
                //                     const Duration(milliseconds: 50),
                //                 title: const Text('Drag to select'),
                //                 content: SizedBox(
                //                   height: 250,
                //                   child: SfDateRangePicker(
                //                     controller: _controller,
                //                     selectionMode:
                //                         DateRangePickerSelectionMode.range,
                //                     onSelectionChanged: selectionChanged,
                //                     allowViewNavigation: false,
                //                   ),
                //                 ),
                //                 actions: <Widget>[
                //                   ButtonBar(
                //                     children: [
                //                       Row(
                //                         children: [
                //                           TextButton(
                //                               onPressed: () {
                //                                 Navigator.pop(context);
                //                               },
                //                               child: const Text('OK')),
                //                         ],
                //                       ),
                //                     ],
                //                   )
                //                 ],
                //               );
                //             });
                //       },
                //       icon: Icon(Icons.filter_alt_outlined))
                // ],
                // iconTheme: const IconThemeData(
                //   color: Colors.black, //change your color here
                // ),
                elevation: 0.0,
                bottom: TabBar(
                  indicatorColor: kPrimaryColor,
                  labelColor: Colors.black,
                  tabs: [
                    Builder(builder: (context) {
                      return isLoading(value.academicApiResponse)
                          ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                      )
                          : Tab(
                              text:
                                  "Backlog \n ${value.backlogAcademic.toString()}",
                            );
                    }),
                    Builder(builder: (context) {
                      return isLoading(value.academicApiResponse)
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: kPrimaryColor,
                              ),
                            )
                          : Tab(
                              text: "Todo \n${value.pendingAcademic.toString()}",
                            );
                    }),
                    Builder(builder: (context) {
                      return isLoading(value.academicApiResponse)
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: kPrimaryColor,
                              ),
                            )
                          : Tab(
                              text:
                                  "Progress \n ${value.approvedAcademic.toString()}",
                            );
                    }),
                    Builder(builder: (context) {
                      return isLoading(value.academicApiResponse)
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: kPrimaryColor,
                              ),
                            )
                          : Tab(
                              text:
                                  "Done \n ${value.resolvedAcademic.toString()}",
                            );
                    }),
                  ],
                ),
                // title: const Text("Academic Request",
                //     style: TextStyle(color: Colors.black)),
                // backgroundColor: Colors.white
      ),
          ),
          body: isLoading(value.academicApiResponse) ?  Center(child: CupertinoActivityIndicator()) : TabBarView(
            children: [
              // ListView(
              //   shrinkWrap: true,
              //   physics: const ScrollPhysics(),
              //   children: [
              //     ListView.builder(
              //         shrinkWrap: true,
              //         physics: const ScrollPhysics(),
              //         itemCount: value.academicRequest.length,
              //         itemBuilder: (context, index) {
              //           var ticket = value.academicRequest[index];
              //
              //           DateTime now =
              //               DateTime.parse(ticket['assignedDate'].toString());
              //
              //           now = now.add(const Duration(hours: 5, minutes: 45));
              //
              //           var formattedTime = DateFormat('yMMMMd').format(now);
              //
              //           // var ticketResponseLength = ticket.ticketResponse.length;
              //
              //           if (ticket['status'] == "Backlog") {
              //             return InkWell(
              //               onTap: () {
              //                 // Navigator.push(
              //                 //     context,
              //                 //     MaterialPageRoute(
              //                 //       builder: (context) =>
              //                 //           IndividualRequestDetail(
              //                 //               id: ticket['_id']),
              //                 //     ));
              //               },
              //               child: Card(
              //                 clipBehavior: Clip.antiAlias,
              //                 margin: const EdgeInsets.all(8.0),
              //                 child: Stack(
              //                   children: [
              //                     Container(
              //                       height: 250,
              //                       child: Column(
              //                         children: [
              //                           Align(
              //                             alignment: Alignment.topLeft,
              //                             child: Container(
              //                               margin:
              //                                   const EdgeInsets.only(left: 15),
              //                               decoration: BoxDecoration(
              //                                   color: Colors.orange,
              //                                   borderRadius:
              //                                       const BorderRadius.all(
              //                                           Radius.circular(30.0))),
              //                               child: Padding(
              //                                 padding: const EdgeInsets.all(5),
              //                                 child: Text(
              //                                     ticket['status'].toString(),
              //                                     style: const TextStyle(
              //                                         fontSize: 9,
              //                                         color: Colors.white)),
              //                               ),
              //                             ),
              //                           ),
              //                           ListTile(
              //                             title:
              //                                 Text(ticket['topic'].toString()),
              //                             subtitle: Column(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.start,
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.start,
              //                               children: <Widget>[
              //                                 Row(
              //                                   children: <Widget>[
              //                                     Icon(
              //                                       Icons.map,
              //                                       size: 15,
              //                                       color: Colors.grey
              //                                           .withOpacity(0.5),
              //                                     ),
              //                                     Text(ticket['ticketId']
              //                                         .toString()),
              //                                   ],
              //                                 ),
              //                                 Row(
              //                                   children: <Widget>[
              //                                     Icon(
              //                                       Icons.timer,
              //                                       size: 15,
              //                                       color: Colors.grey
              //                                           .withOpacity(0.5),
              //                                     ),
              //                                     Text(formattedTime),
              //                                   ],
              //                                 ),
              //                                 Row(
              //                                   children: <Widget>[
              //                                     Icon(
              //                                       Icons.thermostat,
              //                                       size: 15,
              //                                       color: Colors.grey
              //                                           .withOpacity(0.5),
              //                                     ),
              //                                     Text(ticket['severity']
              //                                         .toString()),
              //                                   ],
              //                                 ),
              //                               ],
              //                             ),
              //                           ),
              //                           Flexible(
              //                             child: Padding(
              //                               padding: const EdgeInsets.all(16.0),
              //                               child: Text(
              //                                 ticket['request'].toString(),
              //                                 overflow: TextOverflow.fade,
              //                                 style: TextStyle(
              //                                   color: Colors.black
              //                                       .withOpacity(0.6),
              //                                 ),
              //                               ),
              //                             ),
              //                           ),
              //                           Padding(
              //                             padding: const EdgeInsets.symmetric(
              //                                 horizontal: 15.0),
              //                             child: Row(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.end,
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.end,
              //                               children: [
              //                                 Text("Requested by: " +
              //                                     ticket['postedBy']
              //                                         ['firstname'] +
              //                                     " " +
              //                                     ticket['postedBy']
              //                                         ['lastname'])
              //                               ],
              //                             ),
              //                           ),
              //                           Padding(
              //                             padding: const EdgeInsets.symmetric(
              //                                 horizontal: 8.0),
              //                             child: Row(
              //                               children: [
              //                                 TextButton(
              //                                   child:
              //                                       const Text('Change Status'),
              //                                   onPressed: () {
              //                                     showModalBottomSheet(
              //                                       context: context,
              //                                       builder: ((builder) =>
              //                                           bottomSheet(context,
              //                                               ticket, value)),
              //                                     );
              //                                   },
              //                                 ),
              //                               ],
              //                             ),
              //                           )
              //                         ],
              //                       ),
              //                     ),
              //                     Container(
              //                       height: 250,
              //                       width: 5,
              //                       color: Colors.orange,
              //                     )
              //                   ],
              //                 ),
              //               ),
              //             );
              //           }
              //           return SizedBox();
              //         }),
              //   ],
              // ),
              // ListView(
              //   shrinkWrap: true,
              //   physics: const ScrollPhysics(),
              //   children: [
              //     ListView.builder(
              //         shrinkWrap: true,
              //         physics: const ScrollPhysics(),
              //         itemCount: value.academicRequest.length,
              //         itemBuilder: (context, index) {
              //           var ticket = value.academicRequest[index];
              //
              //           DateTime now =
              //               DateTime.parse(ticket['assignedDate'].toString());
              //
              //           now = now.add(const Duration(hours: 5, minutes: 45));
              //
              //           var formattedTime = DateFormat('yMMMMd').format(now);
              //
              //           // var ticketResponseLength = ticket.ticketResponse.length;
              //
              //           if (ticket['status'] == "Pending") {
              //             return InkWell(
              //               onTap: () {
              //                 Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                       builder: (context) =>
              //                           IndividualRequestDetail(
              //                               id: ticket['_id']),
              //                     ));
              //               },
              //               child: Card(
              //                 clipBehavior: Clip.antiAlias,
              //                 margin: const EdgeInsets.all(8.0),
              //                 child: Stack(
              //                   children: [
              //                     Container(
              //                       height: 250,
              //                       child: Column(
              //                         children: [
              //                           Align(
              //                             alignment: Alignment.topLeft,
              //                             child: Container(
              //                               margin:
              //                                   const EdgeInsets.only(left: 15),
              //                               decoration: BoxDecoration(
              //                                   color: Colors.orange,
              //                                   borderRadius:
              //                                       const BorderRadius.all(
              //                                           Radius.circular(30.0))),
              //                               child: Padding(
              //                                 padding: const EdgeInsets.all(5),
              //                                 child: Text(
              //                                     ticket['status'].toString(),
              //                                     style: const TextStyle(
              //                                         fontSize: 9,
              //                                         color: Colors.white)),
              //                               ),
              //                             ),
              //                           ),
              //                           ListTile(
              //                             title:
              //                                 Text(ticket['topic'].toString()),
              //                             subtitle: Column(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.start,
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.start,
              //                               children: <Widget>[
              //                                 Row(
              //                                   children: <Widget>[
              //                                     Icon(
              //                                       Icons.map,
              //                                       size: 15,
              //                                       color: Colors.grey
              //                                           .withOpacity(0.5),
              //                                     ),
              //                                     Text(ticket['ticketId']
              //                                         .toString()),
              //                                   ],
              //                                 ),
              //                                 Row(
              //                                   children: <Widget>[
              //                                     Icon(
              //                                       Icons.timer,
              //                                       size: 15,
              //                                       color: Colors.grey
              //                                           .withOpacity(0.5),
              //                                     ),
              //                                     Text(formattedTime),
              //                                   ],
              //                                 ),
              //                                 Row(
              //                                   children: <Widget>[
              //                                     Icon(
              //                                       Icons.thermostat,
              //                                       size: 15,
              //                                       color: Colors.grey
              //                                           .withOpacity(0.5),
              //                                     ),
              //                                     Text(ticket['severity']
              //                                         .toString()),
              //                                   ],
              //                                 ),
              //                               ],
              //                             ),
              //                           ),
              //                           Flexible(
              //                             child: Padding(
              //                               padding: const EdgeInsets.all(16.0),
              //                               child: Text(
              //                                 ticket['request'].toString(),
              //                                 overflow: TextOverflow.fade,
              //                                 style: TextStyle(
              //                                   color: Colors.black
              //                                       .withOpacity(0.6),
              //                                 ),
              //                               ),
              //                             ),
              //                           ),
              //                           Padding(
              //                             padding: const EdgeInsets.symmetric(
              //                                 horizontal: 15.0),
              //                             child: Row(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.end,
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.end,
              //                               children: [
              //                                 Text("Requested by: " +
              //                                     ticket['postedBy']
              //                                         ['firstname'] +
              //                                     " " +
              //                                     ticket['postedBy']
              //                                         ['lastname'])
              //                               ],
              //                             ),
              //                           ),
              //                           Padding(
              //                             padding: const EdgeInsets.symmetric(
              //                                 horizontal: 8.0),
              //                             child: Row(
              //                               children: [
              //                                 TextButton(
              //                                   child:
              //                                       const Text('Change Status'),
              //                                   onPressed: () {
              //                                     showModalBottomSheet(
              //                                       context: context,
              //                                       builder: ((builder) =>
              //                                           bottomSheet(context,
              //                                               ticket, value)),
              //                                     );
              //                                   },
              //                                 ),
              //                               ],
              //                             ),
              //                           )
              //                         ],
              //                       ),
              //                     ),
              //                     Container(
              //                       height: 250,
              //                       width: 5,
              //                       color: Colors.orange,
              //                     )
              //                   ],
              //                 ),
              //               ),
              //             );
              //           }
              //           return SizedBox();
              //         }),
              //   ],
              // ),
              // ListView(
              //   shrinkWrap: true,
              //   physics: const ScrollPhysics(),
              //   children: [
              //     ListView.builder(
              //         shrinkWrap: true,
              //         physics: const ScrollPhysics(),
              //         itemCount: value.academicRequest.length,
              //         itemBuilder: (context, index) {
              //           var ticket = value.academicRequest[index];
              //
              //           DateTime now =
              //               DateTime.parse(ticket['assignedDate'].toString());
              //
              //           now = now.add(const Duration(hours: 5, minutes: 45));
              //
              //           var formattedTime = DateFormat('yMMMMd').format(now);
              //
              //           // var ticketResponseLength = ticket.ticketResponse.length;
              //
              //           if (ticket['status'] == "Approved") {
              //             return InkWell(
              //               onTap: () {
              //                 Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                       builder: (context) =>
              //                           IndividualRequestDetail(
              //                               id: ticket['_id']),
              //                     ));
              //               },
              //               child: Card(
              //                 clipBehavior: Clip.antiAlias,
              //                 margin: const EdgeInsets.all(8.0),
              //                 child: Stack(
              //                   children: [
              //                     Container(
              //                       height: 250,
              //                       child: Column(
              //                         children: [
              //                           Align(
              //                             alignment: Alignment.topLeft,
              //                             child: Container(
              //                               margin:
              //                                   const EdgeInsets.only(left: 15),
              //                               decoration: BoxDecoration(
              //                                   color: kPrimaryColor,
              //                                   borderRadius:
              //                                       const BorderRadius.all(
              //                                           Radius.circular(30.0))),
              //                               child: Padding(
              //                                 padding: const EdgeInsets.all(5),
              //                                 child: Text(
              //                                     ticket['status'].toString(),
              //                                     style: const TextStyle(
              //                                         fontSize: 9,
              //                                         color: Colors.white)),
              //                               ),
              //                             ),
              //                           ),
              //                           ListTile(
              //                             title:
              //                                 Text(ticket['topic'].toString()),
              //                             subtitle: Column(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.start,
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.start,
              //                               children: <Widget>[
              //                                 Row(
              //                                   children: <Widget>[
              //                                     Icon(
              //                                       Icons.map,
              //                                       size: 15,
              //                                       color: Colors.grey
              //                                           .withOpacity(0.5),
              //                                     ),
              //                                     Text(ticket['ticketId']
              //                                         .toString()),
              //                                   ],
              //                                 ),
              //                                 Row(
              //                                   children: <Widget>[
              //                                     Icon(
              //                                       Icons.timer,
              //                                       size: 15,
              //                                       color: Colors.grey
              //                                           .withOpacity(0.5),
              //                                     ),
              //                                     Text(formattedTime),
              //                                   ],
              //                                 ),
              //                                 Row(
              //                                   children: <Widget>[
              //                                     Icon(
              //                                       Icons.thermostat,
              //                                       size: 15,
              //                                       color: Colors.grey
              //                                           .withOpacity(0.5),
              //                                     ),
              //                                     Text(ticket['severity']
              //                                         .toString()),
              //                                   ],
              //                                 ),
              //                               ],
              //                             ),
              //                           ),
              //                           Flexible(
              //                             child: Padding(
              //                               padding: const EdgeInsets.all(16.0),
              //                               child: Text(
              //                                 ticket['request'].toString(),
              //                                 overflow: TextOverflow.fade,
              //                                 style: TextStyle(
              //                                   color: Colors.black
              //                                       .withOpacity(0.6),
              //                                 ),
              //                               ),
              //                             ),
              //                           ),
              //                           Padding(
              //                             padding: const EdgeInsets.symmetric(
              //                                 horizontal: 15.0),
              //                             child: Row(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.end,
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.end,
              //                               children: [
              //                                 Text("Requested by: " +
              //                                     ticket['postedBy']
              //                                         ['firstname'] +
              //                                     " " +
              //                                     ticket['postedBy']
              //                                         ['lastname'])
              //                               ],
              //                             ),
              //                           ),
              //                           Padding(
              //                             padding: const EdgeInsets.symmetric(
              //                                 horizontal: 8.0),
              //                             child: Row(
              //                               children: [
              //                                 TextButton(
              //                                   child:
              //                                       const Text('Change Status'),
              //                                   onPressed: () {
              //                                     showModalBottomSheet(
              //                                       context: context,
              //                                       builder: ((builder) =>
              //                                           bottomSheet(context,
              //                                               ticket, value)),
              //                                     );
              //                                   },
              //                                 ),
              //                               ],
              //                             ),
              //                           )
              //                         ],
              //                       ),
              //                     ),
              //                     Container(
              //                       height: 250,
              //                       width: 5,
              //                       color: kPrimaryColor,
              //                     )
              //                   ],
              //                 ),
              //               ),
              //             );
              //           }
              //           return SizedBox();
              //         }),
              //   ],
              // ),
              // ListView(
              //   shrinkWrap: true,
              //   physics: const ScrollPhysics(),
              //   children: [
              //     ListView.builder(
              //         shrinkWrap: true,
              //         physics: const ScrollPhysics(),
              //         itemCount: value.academicRequest.length,
              //         itemBuilder: (context, index) {
              //           var ticket = value.academicRequest[index];
              //
              //           DateTime now =
              //               DateTime.parse(ticket['assignedDate'].toString());
              //
              //           now = now.add(const Duration(hours: 5, minutes: 45));
              //
              //           var formattedTime = DateFormat('yMMMMd').format(now);
              //
              //           // var ticketResponseLength = ticket.ticketResponse.length;
              //
              //           if (ticket['status'] == "Resolved") {
              //             return InkWell(
              //               onTap: () {
              //                 Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                       builder: (context) =>
              //                           IndividualRequestDetail(
              //                               id: ticket['_id']),
              //                     ));
              //               },
              //               child: Card(
              //                 clipBehavior: Clip.antiAlias,
              //                 margin: const EdgeInsets.all(8.0),
              //                 child: Stack(
              //                   children: [
              //                     Container(
              //                       height: 250,
              //                       child: Column(
              //                         children: [
              //                           Align(
              //                             alignment: Alignment.topLeft,
              //                             child: Container(
              //                               margin:
              //                                   const EdgeInsets.only(left: 15),
              //                               decoration: const BoxDecoration(
              //                                   color: Colors.green,
              //                                   borderRadius: BorderRadius.all(
              //                                       Radius.circular(30.0))),
              //                               child: Padding(
              //                                 padding: const EdgeInsets.all(5),
              //                                 child: Text(
              //                                     ticket['status'].toString(),
              //                                     style: const TextStyle(
              //                                         fontSize: 9,
              //                                         color: Colors.white)),
              //                               ),
              //                             ),
              //                           ),
              //                           ListTile(
              //                             title:
              //                                 Text(ticket['topic'].toString()),
              //                             subtitle: Column(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.start,
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.start,
              //                               children: <Widget>[
              //                                 Row(
              //                                   children: <Widget>[
              //                                     Icon(
              //                                       Icons.map,
              //                                       size: 15,
              //                                       color: Colors.grey
              //                                           .withOpacity(0.5),
              //                                     ),
              //                                     Text(ticket['ticketId']
              //                                         .toString()),
              //                                   ],
              //                                 ),
              //                                 Row(
              //                                   children: <Widget>[
              //                                     Icon(
              //                                       Icons.timer,
              //                                       size: 15,
              //                                       color: Colors.grey
              //                                           .withOpacity(0.5),
              //                                     ),
              //                                     Text(formattedTime),
              //                                   ],
              //                                 ),
              //                                 Row(
              //                                   children: <Widget>[
              //                                     Icon(
              //                                       Icons.thermostat,
              //                                       size: 15,
              //                                       color: Colors.grey
              //                                           .withOpacity(0.5),
              //                                     ),
              //                                     Text(ticket['severity']
              //                                         .toString()),
              //                                   ],
              //                                 ),
              //                               ],
              //                             ),
              //                           ),
              //                           Flexible(
              //                             child: Padding(
              //                               padding: const EdgeInsets.all(16.0),
              //                               child: Text(
              //                                 ticket['request'].toString(),
              //                                 overflow: TextOverflow.fade,
              //                                 style: TextStyle(
              //                                   color: Colors.black
              //                                       .withOpacity(0.6),
              //                                 ),
              //                               ),
              //                             ),
              //                           ),
              //                           Padding(
              //                             padding: const EdgeInsets.symmetric(
              //                                 horizontal: 15.0),
              //                             child: Row(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.end,
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.end,
              //                               children: [
              //                                 Text("Requested by: " +
              //                                     ticket['postedBy']
              //                                         ['firstname'] +
              //                                     " " +
              //                                     ticket['postedBy']
              //                                         ['lastname'])
              //                               ],
              //                             ),
              //                           )
              //                         ],
              //                       ),
              //                     ),
              //                     Container(
              //                       height: 250,
              //                       width: 5,
              //                       color: Colors.green,
              //                     )
              //                   ],
              //                 ),
              //               ),
              //             );
              //           }
              //           return SizedBox();
              //         }),
              //   ],
              // ),

              myRequest(value, "Backlog"),
              myRequest(value, "Pending"),
              myRequest(value, "Approved"),
              myRequest(value, "Resolved"),
            ],
          ),
        ),
      );
    });
  }

  Widget bottomSheet(
      BuildContext context, dynamic ticket, TicketViewModel _model) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      height: 300.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text(
            "Change status",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            onTap: () async {
              try {
                setState(() {
                  menubarloading = true;
                });
                final data = AdminChangeTicketStatusRequest(status: "Backlog");

                AdminChangeTicketStatusResponse response =
                    await AssignedRequestService()
                        .updateStatus(data, ticket['_id']);

                if (response.success == true) {
                  setState(() {
                    menubarloading = true;
                  });
                  Navigator.pop(context);
                  _model.resetVal(0);
                  _model.fetchAcademicRequest();
                  Fluttertoast.showToast(msg: 'Status changed successfully');
                  setState(() {
                    menubarloading = false;
                  });
                } else {
                  setState(() {
                    menubarloading = true;
                  });
                  _model.resetVal(0);
                  _model.fetchAcademicRequest();
                  Fluttertoast.showToast(msg: 'Error while changing status');

                  setState(() {
                    menubarloading = false;
                  });
                }
              } on Exception catch (e) {
                setState(() {
                  menubarloading = true;
                });
                Fluttertoast.showToast(msg: e.toString());
                setState(() {
                  menubarloading = false;
                });
                // TODO
              }
            },
            title: Text("Backlog"),
            trailing:
                ticket['status'] == "Backlog" ? Icon(Icons.check) : SizedBox(),
          ),
          ListTile(
            onTap: () async {
              try {
                setState(() {
                  menubarloading = true;
                });
                final data = AdminChangeTicketStatusRequest(status: "Pending");

                AdminChangeTicketStatusResponse response =
                    await AssignedRequestService()
                        .updateStatus(data, ticket['_id']);

                if (response.success == true) {
                  setState(() {
                    menubarloading = true;
                  });
                  Navigator.pop(context);
                  _model.resetVal(0);
                  _model.fetchAcademicRequest();
                  Fluttertoast.showToast(msg: 'Status changed successfully');
                  setState(() {
                    menubarloading = false;
                  });
                } else {
                  setState(() {
                    menubarloading = true;
                  });
                  Fluttertoast.showToast(msg: "Error while changing status");
                  setState(() {
                    menubarloading = false;
                  });
                }
              } on Exception catch (e) {
                setState(() {
                  menubarloading = true;
                });
                Fluttertoast.showToast(msg: e.toString());
                setState(() {
                  menubarloading = false;
                });
                // TODO
              }
            },
            title: Text("To-Do"),
            trailing:
                ticket['status'] == "Pending" ? Icon(Icons.check) : SizedBox(),
          ),
          ListTile(
            onTap: () async {
              try {
                setState(() {
                  menubarloading = true;
                });
                final data = AdminChangeTicketStatusRequest(status: "Approved");

                AdminChangeTicketStatusResponse response =
                    await AssignedRequestService()
                        .updateStatus(data, ticket['_id']);

                if (response.success == true) {
                  setState(() {
                    menubarloading = true;
                  });

                  Navigator.pop(context);
                  _model.resetVal(0);
                  _model.fetchAcademicRequest();
                  Fluttertoast.showToast(msg: 'Status changed successfully');

                  setState(() {
                    menubarloading = false;
                  });
                } else {
                  setState(() {
                    menubarloading = true;
                  });
                  _model.fetchAcademicRequest();
                  Fluttertoast.showToast(msg: 'Error while changing status');

                  setState(() {
                    menubarloading = false;
                  });
                }
              } on Exception catch (e) {
                setState(() {
                  menubarloading = true;
                });
                Fluttertoast.showToast(msg: e.toString());
                setState(() {
                  menubarloading = false;
                });
                // TODO
              }
            },
            title: Text("In Progress"),
            trailing:
                ticket['status'] == "Approved" ? Icon(Icons.check) : SizedBox(),
          ),
          ListTile(
            onTap: () async {
              try {
                setState(() {
                  menubarloading = true;
                });
                final data = AdminChangeTicketStatusRequest(status: "Resolved");

                AdminChangeTicketStatusResponse response =
                    await AssignedRequestService()
                        .updateStatus(data, ticket['_id']);

                if (response.success == true) {
                  setState(() {
                    menubarloading = true;
                  });
                  Navigator.pop(context);

                  _model.resetVal(0);
                  _model.fetchAcademicRequest();
                  Fluttertoast.showToast(msg: 'Status changed successfully');

                  setState(() {
                    menubarloading = false;
                  });
                } else {
                  setState(() {
                    menubarloading = true;
                  });
                  Fluttertoast.showToast(msg: 'Error while changing status');
                  setState(() {
                    menubarloading = false;
                  });
                }
              } on Exception catch (e) {
                setState(() {
                  menubarloading = true;
                });
                // _model.fetchassignedrequest(user!.username.toString());
                Fluttertoast.showToast(msg: e.toString());

                setState(() {
                  menubarloading = false;
                });
                // TODO
              }
            },
            title: const Text("Done"),
            trailing:
                ticket['status'] == "Resolved" ? Icon(Icons.check) : SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget myRequest(TicketViewModel value, String requestType){
    return ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: value.academicRequest.length,
        itemBuilder: (context, index) {
          var ticket = value.academicRequest[index];

          DateTime now =
          DateTime.parse(ticket['assignedDate'].toString());

          now = now.add(const Duration(hours: 5, minutes: 45));

          var formattedTime = DateFormat('yMMMMd').format(now);

          // var ticketResponseLength = ticket.ticketResponse.length;

          return ticket['status'] == requestType  ?
          Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: ticket['status'] == "Pending"
                          ? Color(0xffDCAC04)
                          : ticket['status'] == "Resolved"
                          ? Colors.green
                          : ticket["status"] == "Backlog" ? Color(0xffE80000) :  logoTheme),
                  top: BorderSide(
                      color: ticket['status'] == "Pending"
                          ? Color(0xffDCAC04)
                          : ticket['status'] == "Resolved"
                          ? Colors.green
                          : ticket["status"] == "Backlog" ? Color(0xffE80000): logoTheme),
                  right: BorderSide(
                      color: ticket['status'] == "Pending"
                          ? Color(0xffDCAC04)
                          : ticket['status'] == "Resolved"
                          ? Colors.green
                          : ticket["status"] == "Backlog" ? Color(0xffE80000) : logoTheme),
                  left: BorderSide(
                      color: ticket['status'] == "Pending"
                          ? Color(0xffDCAC04)
                          : ticket['status'] == "Resolved"
                          ? Colors.green
                          : ticket["status"] == "Backlog" ? Color(0xffE80000): logoTheme,
                      width: 8),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(ticket['topic'].toString(), style: TextStyle(color: black, fontWeight: FontWeight.bold),)),
                          Container(
                            decoration: BoxDecoration(
                                color: ticket['status'] == "Pending"
                                    ? Color(0xffDCAC04)
                                    : ticket['status'] == "Resolved"
                                    ? Colors.green
                                    : ticket["status"] == "Backlog" ? Color(0xffE80000) : kPrimaryColor,
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5.0))),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(ticket['status'].toString(),
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: black,
                          ),
                          child: Text(ticket['ticketId'].toString(),
                              style: TextStyle(color: white, fontSize: 12)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.event,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                                Text(
                                  formattedTime,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.timelapse,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                                Text(
                                  DateFormat.jm()
                                      .format(DateTime.parse(ticket['assignedDate'].toString())),
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.thermostat,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                                Text(
                                  ticket['severity'].toString(),
                                  style: TextStyle(color: solidRed, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      ticket['request'].toString(),
                      style: TextStyle(
                        color: black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0),
                    child: Container(
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          const Text(
                            'Requested By:', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(ticket['postedBy']
                          ['firstname'] +
                              " " +
                              ticket['postedBy']
                              ['lastname'], style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          child:
                          const Text('Change Status'),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: ((builder) =>
                                  bottomSheet(context,
                                      ticket, value)),
                            );
                          },
                        ),

                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 5)),
                          backgroundColor: MaterialStateProperty.all(logoTheme),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    IndividualRequestDetail(
                                        id: ticket['_id']),
                              ));
                        },
                        child: Row(
                          children: const [
                            Center(
                                child: const Text(
                                  "Details",
                                  style: TextStyle(fontSize: 12),
                                )),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 15,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),

                ],
              ),
            ),
          ) : SizedBox();
        });
  }
}
