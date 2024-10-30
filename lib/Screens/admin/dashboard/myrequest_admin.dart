import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/services/admin/getmyrequestadmin_service.dart';

import '../../request/requestdetail.dart';
import '../navigation/drawer.dart';

class AdminMyRequestScreen extends StatefulWidget {
  const AdminMyRequestScreen({Key? key}) : super(key: key);

  @override
  _AdminMyRequestScreenState createState() => _AdminMyRequestScreenState();
}

class _AdminMyRequestScreenState extends State<AdminMyRequestScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "My Request",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        // elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: Container(
          //     height: 70,
          //     color: Colors.pinkAccent,
          //     width: double.infinity,
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             'Pending',
          //             style: TextStyle(
          //                 color: Colors.white, fontWeight: FontWeight.bold),
          //           ),
          //           Text("0")
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: Container(
          //     height: 70,
          //     color: kPrimaryColor,
          //     width: double.infinity,
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             'Approved',
          //             style: TextStyle(
          //                 color: Colors.white, fontWeight: FontWeight.bold),
          //           ),
          //           Text("0")
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: Container(
          //     height: 70,
          //     color: Colors.green,
          //     width: double.infinity,
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             'Resolved',
          //             style: TextStyle(
          //                 color: Colors.white, fontWeight: FontWeight.bold),
          //           ),
          //           Text("0")
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 10,
          // ),

          ChangeNotifierProvider<MyRequestAdminService>(
              create: (context) => MyRequestAdminService(),
              child: Consumer<MyRequestAdminService>(
                  builder: (context, provider, child) {
                provider.myticketsAdmin(context);
                if (provider.data?.requests == null) {
                  provider.myticketsAdmin(context);
                  return const Center(
                      child: SpinKitDualRing(
                    color: kPrimaryColor,
                  ));
                }

                return provider.data!.requests!.isEmpty
                    ? Column(children: <Widget>[
                        Image.asset("assets/images/no_content.PNG"),
                      ])
                    : Column(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: provider.data!.requests!.length,
                              itemBuilder: (context, index) {
                                var ticket = provider.data!.requests![index];

                                DateTime now = DateTime.parse(
                                    ticket['createdAt'].toString());

                                now = now
                                    .add(const Duration(hours: 5, minutes: 45));

                                var formattedTime =
                                    DateFormat('yMMMMd').format(now);

                                // var ticketResponseLength = ticket.ticketResponse.length;

                                return Card(
                                  clipBehavior: Clip.antiAlias,
                                  margin: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 250,
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 15),
                                                decoration: BoxDecoration(
                                                    color: ticket['status'] ==
                                                                "Pending" ||
                                                            ticket['status'] ==
                                                                "Backlog"
                                                        ? Colors.orange
                                                        : ticket['status'] ==
                                                                "Approved"
                                                            ? kPrimaryColor
                                                            : Colors.green,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                30.0))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Text(ticket['status'],
                                                      style: const TextStyle(
                                                          fontSize: 9,
                                                          color: Colors.white)),
                                                ),
                                              ),
                                            ),
                                            ListTile(
                                              title: Text(ticket['topic']),
                                              subtitle: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.map,
                                                        size: 15,
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                      ),
                                                      Text(ticket['ticketId']),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.timer,
                                                        size: 15,
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                      ),
                                                      Text(formattedTime),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.thermostat,
                                                        size: 15,
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                      ),
                                                      Text(ticket['severity']),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Text(
                                                  ticket['request'],
                                                  overflow: TextOverflow.fade,
                                                  style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ButtonBar(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Requestdetail(
                                                                responseid:
                                                                    ticket[
                                                                        '_id'],
                                                              )),
                                                    );
                                                  },
                                                  child:
                                                      const Text("Details >"),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 245,
                                        width: 5,
                                        color: ticket['status'] == "Resolved"
                                            ? Colors.green
                                            : Colors.orange,
                                      )
                                    ],
                                  ),
                                );
                              }),
                        ],
                      );
              })),
        ],
      ),
    );
  }
}

class menuBarFilter {
  static const String pending = "Pending";
  static const String approved = "Approved";
  static const String resolved = "Resolved";

  static const List<String> settings = <String>[pending, approved, resolved];
}
