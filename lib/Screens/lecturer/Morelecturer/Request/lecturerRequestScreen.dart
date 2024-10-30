import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/Request/lectureraddrequest_screen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/Request/lecturerrequestdetail_screen.dart';
import 'package:schoolworkspro_app/Screens/request/requestdetail.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/lecturer/lecturerrequest_response.dart';
import 'package:schoolworkspro_app/services/lecturer/ticket_service.dart';
import 'package:intl/intl.dart';
import 'package:schoolworkspro_app/ticket_view_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../components/shimmer.dart';
import '../../../../constants/colors.dart';

class LecturerRequestScreen extends StatefulWidget {
  final bool isAdmin;
  LecturerRequestScreen({Key? key, required this.isAdmin}) : super(key: key);

  @override
  _LecturerRequestScreenState createState() => _LecturerRequestScreenState();
}

class _LecturerRequestScreenState extends State<LecturerRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TicketViewModel>(
        create: (_) => TicketViewModel(),
        child: LecturerRequestBody(
          isAdmin: widget.isAdmin,
        ));
  }
}

class LecturerRequestBody extends StatefulWidget {
  final bool isAdmin;
  const LecturerRequestBody({Key? key, required this.isAdmin})
      : super(key: key);

  @override
  _LecturerRequestBodyState createState() => _LecturerRequestBodyState();
}

class _LecturerRequestBodyState extends State<LecturerRequestBody> {
  // late Stream<LecturerRequestResponse> request_response;
  String? _startDate;
  String? _endDate;
  final DateRangePickerController _controller = DateRangePickerController();
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TicketViewModel>(context, listen: false)
          .fetchTicketsfromProvider();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketViewModel>(builder: (context, value, child) {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: widget.isAdmin == false
              ? PreferredSize(
                  preferredSize: Size.fromHeight(50.0),
                  child: AppBar(
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
                      iconTheme: const IconThemeData(
                        color: black,
                      ),
                      elevation: 0.0,
                      automaticallyImplyLeading: true,
                      bottom: TabBar(
                        indicatorColor: kPrimaryColor,
                        labelColor: black,
                        isScrollable: true,
                        tabs: [
                          Builder(builder: (context) {
                            return const Tab(
                              text: "Pending",
                            );
                          }),
                          Builder(builder: (context) {
                            return const Tab(
                              text: "In progress",
                            );
                          }),
                          Builder(builder: (context) {
                            return const Tab(
                              text: "Resolved",
                            );
                          }),
                        ],
                      ),
                //       title: const Text("My Request",
                //           style: TextStyle(color: black)),
                      backgroundColor: white),
                )
              : PreferredSize(
                  preferredSize:
                      Size.fromHeight(widget.isAdmin == true ? 90.0 : 50),
                  child: AppBar(
                    title: widget.isAdmin == true
                        ? const Text("My Request",
                            style: TextStyle(color: white))
                        : Container(),
                    elevation: 0.0,
                    automaticallyImplyLeading: false,
                    bottom: TabBar(
                      indicatorColor: kPrimaryColor,
                      labelColor: widget.isAdmin == true ? white : black,
                      isScrollable: true,
                      tabs: [
                        Builder(builder: (context) {
                          return const Tab(
                            text: "Pending",
                          );
                        }),
                        Builder(builder: (context) {
                          return const Tab(
                            text: "In progress",
                          );
                        }),
                        Builder(builder: (context) {
                          return const Tab(
                            text: "Resolved",
                          );
                        }),
                      ],
                    ),
                    leading: widget.isAdmin == true
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        : Container(),
                  ),
                ),
          body: isLoading(value.requestApiResponse)
              ? const VerticalLoader()
              : TabBarView(
                  children: [
                    myRequest(value, "Pending"),
                    myRequest(value, "Approved"),
                    myRequest(value, "Resolved"),
                  ],
                ),
        ),
      );
    });
  }

  selectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _startDate =
          DateFormat('yyyy-MM-dd').format(args.value.startDate).toString();
      _endDate = DateFormat('yyyy-MM-dd')
          .format(args.value.endDate ?? args.value.startDate)
          .toString();
    });
  }

  Widget myRequest(TicketViewModel value, String requestType) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: value.ticket.length,
        itemBuilder: (context, index) {
          var ticket = value.ticket[index];

          DateTime now = DateTime.parse(ticket.createdAt.toString());

          now = now.add(const Duration(hours: 5, minutes: 45));

          var formattedTime = DateFormat('yMMMMd').format(now);

          // var ticketResponseLength = ticket.ticketResponse.length;

          return ticket.status == requestType
              ? Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: ticket.status == "Pending"
                                ? Color(0xffDCAC04)
                                : ticket.status == "Resolved"
                                    ? Colors.green
                                    : logoTheme),
                        top: BorderSide(
                            color: ticket.status == "Pending"
                                ? Color(0xffDCAC04)
                                : ticket.status == "Resolved"
                                    ? Colors.green
                                    : logoTheme),
                        right: BorderSide(
                            color: ticket.status == "Pending"
                                ? Color(0xffDCAC04)
                                : ticket.status == "Resolved"
                                    ? Colors.green
                                    : logoTheme),
                        left: BorderSide(
                            color: ticket.status == "Pending"
                                ? Color(0xffDCAC04)
                                : ticket.status == "Resolved"
                                    ? Colors.green
                                    : logoTheme,
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
                                Expanded(child: Text(ticket.topic.toString())),
                                // Container(
                                //   decoration: BoxDecoration(
                                //       color: ticket.status == "Pending"
                                //           ? Color(0xffDCAC04)
                                //           : ticket.status == "Resolved"
                                //           ? Colors.green
                                //           : kPrimaryColor,
                                //       borderRadius:
                                //       const BorderRadius.all(Radius.circular(5.0))),
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(5),
                                //     child: Text(ticket.status.toString(),
                                //         style: const TextStyle(
                                //             fontSize: 9, color: Colors.white)),
                                //   ),
                                // ),
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
                                child: Text(ticket.ticketId.toString(),
                                    style:
                                        TextStyle(color: white, fontSize: 10)),
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
                                        DateFormat.jm().format(DateTime.parse(
                                            ticket.createdAt.toString())),
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
                                        ticket.severity.toString(),
                                        style: TextStyle(
                                            color: solidRed, fontSize: 12),
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
                            ticket.request.toString(),
                            style: TextStyle(
                              color: Colors.black,
                            ),
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
                                backgroundColor:
                                    MaterialStateProperty.all(logoTheme),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Requestdetail(
                                          responseid: ticket.id.toString())),
                                );
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
                        )
                      ],
                    ),
                  ),
                )
              : SizedBox();
        });
  }
}
