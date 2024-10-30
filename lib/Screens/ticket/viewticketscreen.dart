import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/request/request_view_model.dart';
import 'package:schoolworkspro_app/Screens/ticket/ticketdetail_screen.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/viewticketresponse.dart';
import 'package:schoolworkspro_app/services/viewticket_service.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../parents/More_parent/parent_request/view_parentrequest/parentrequestdetail_screen.dart';

class Ticketscreen extends StatefulWidget {
  const Ticketscreen({Key? key}) : super(key: key);

  @override
  _TicketscreenState createState() => _TicketscreenState();
}

class _TicketscreenState extends State<Ticketscreen> {
  // Stream<Viewticketresponse>? ticketresponse;
  // @override
  // void initState() {
  //   ticketresponse =
  //       Viewticketservice().getrefreshticket(const Duration(seconds: 1));
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     title: const Text(
      //       "Tickets",
      //       style: TextStyle(color: Colors.black),
      //     ),
      //     elevation: 0.0,
      //     iconTheme: const IconThemeData(
      //       color: Colors.black, //change your color here
      //     ),
      //     backgroundColor: Colors.white),
      body: Consumer<RequestViewModel>(
        // stream: ticketresponse,
        builder: (context, snapshot, child) {
          return isLoading(snapshot.myTicketApiResponse)
              ? VerticalLoader()
              : snapshot.myTicket.tickets!.isEmpty
                  ? Column(children: <Widget>[
                      Image.asset("assets/images/no_content.PNG"),
                      const Text(
                        "No ticket available",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ])
                  : ListView.builder(
                      itemCount: snapshot.myTicket.tickets!.length,
                      itemBuilder: (context, index) {
                        var ticket = snapshot.myTicket.tickets![index];

                        DateTime now =
                            DateTime.parse(ticket.createdAt.toString());

                        now = now.add(const Duration(hours: 5, minutes: 45));

                        var formattedTime = DateFormat('yMMMMd').format(now);

                        var ticketResponseLength =
                            ticket.ticketResponse!.length;

                        return Card(
                          clipBehavior: Clip.antiAlias,
                          margin: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: ticket.status == "Resolved"
                                        ? Colors.green
                                        : ticket.status == "Pending" ? Color(0xffff9b20) :  kPrimaryColor),
                                top: BorderSide(
                                    color: ticket.status == "Resolved"
                                        ? Colors.green
                                        : ticket.status == "Pending" ? Color(0xffff9b20) :  kPrimaryColor),
                                right: BorderSide(
                                    color: ticket.status == "Resolved"
                                        ? Colors.green
                                        : ticket.status == "Pending" ? Color(0xffff9b20) :  kPrimaryColor),
                                left: BorderSide(
                                    color: ticket.status == "Resolved"
                                        ? Colors.green
                                        : ticket.status == "Pending" ? Color(0xffff9b20) :  kPrimaryColor,
                                    width: 8),
                              ),
                            ),
                            child: Column(
                              children: [
                                // Align(
                                //   alignment: Alignment.topLeft,
                                //   child: Container(
                                //     // margin: const EdgeInsets.only(left: 15),
                                //     decoration: BoxDecoration(
                                //         color: ticket.status == "Approved"
                                //             ? Colors.green
                                //             : kPrimaryColor,
                                //         borderRadius: const BorderRadius.all(
                                //             Radius.circular(30.0))),
                                //     child: Padding(
                                //       padding: const EdgeInsets.all(5),
                                //       child: Text(ticket.status!,
                                //           style: const TextStyle(
                                //               fontSize: 9,
                                //               color: Colors.white)),
                                //     ),
                                //   ),
                                // ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(ticket.topic.toString()),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: ticket.status == "Resolved"
                                                  ? Colors.green
                                                  : ticket.status == "Pending" ? Color(0xffff9b20) : kPrimaryColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5.0))
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Text(
                                                ticket.status.toString(),
                                                style: const TextStyle(
                                                    fontSize: 9,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: black,
                                        ),
                                        child: Text(ticket.ticketId.toString(),
                                            style: const TextStyle(
                                                color: white, fontSize: 10)),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              const Icon(
                                                Icons.event,
                                                size: 15,
                                                color: Colors.grey,
                                              ),
                                              Text(
                                                formattedTime,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              const Icon(
                                                Icons.timelapse,
                                                size: 15,
                                                color: Colors.grey,
                                              ),
                                              Text(
                                                DateFormat.jm()
                                                    .format(ticket.createdAt!),
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              // const Icon(
                                              //   Icons.thermostat,
                                              //   size: 15,
                                              //   color: Colors.grey,
                                              // ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: ticket.subject ==
                                                            "Absent"
                                                        ? Colors.black
                                                        : Colors.orange,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                30.0))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Text(ticket.subject!,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 9,
                                                          color: Colors.white)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    ticket.request!,
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
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
                                            MaterialStateProperty.all(
                                                logoTheme),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Ticketdetail(
                                                    index: index,
                                                  )),
                                        );
                                      },
                                      child: Row(
                                        children: const [
                                          Center(
                                              child: Text(
                                            "Ticket detail",
                                            style: TextStyle(fontSize: 12),
                                          )),
                                          Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            size: 15,
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    )
                                  ],
                                )
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [
                                //     ElevatedButton(
                                //         onPressed: () {
                                //           Navigator.push(
                                //             context,
                                //             MaterialPageRoute(
                                //                 builder: (context) =>
                                //                     Ticketdetail(
                                //                       index: index,
                                //                     )),
                                //           );
                                //         },
                                //         child: const Text("Ticket detail")),
                                //   ],
                                // )
                              ],
                            ),
                          ),
                        );
                      });
        },
      ),
    );
  }
}
