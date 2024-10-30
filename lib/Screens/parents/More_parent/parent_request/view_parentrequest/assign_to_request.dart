import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:schoolworkspro_app/Screens/parents/More_parent/parent_request/view_parentrequest/parentrequestdetail_screen.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../constants/colors.dart';
import '../../../../../response/authenticateduser_response.dart';
import '../../../../../response/parents/getrequestparent_response.dart';
import '../../../../../services/parents/getparentrequest_service.dart';

class ParentAssignedToRequest extends StatefulWidget {
  const ParentAssignedToRequest({Key? key}) : super(key: key);

  @override
  State<ParentAssignedToRequest> createState() => _ParentAssignedToRequestState();
}

class _ParentAssignedToRequestState extends State<ParentAssignedToRequest> {
  Future<Getparentequestresponse>? parent_request;
  late User user;

  @override
  void initState() {
    // TODO: implement initState
    parent_request = Getparentrequestservice().getAssignedToRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: FutureBuilder<Getparentequestresponse>(
          future: parent_request,
          builder: (context, snapshot) {
            print("DATAAA::::${snapshot.data?.requests.toString()}");
            if (snapshot.hasData) {
              return snapshot.data!.requests!.isEmpty
                  ? Image.asset("assets/images/no_content.PNG")
                  : ListView.builder(
                      itemCount: snapshot.data!.requests!.length,
                      itemBuilder: (context, index) {
                        var ticket = snapshot.data!.requests![index];

                        DateTime now =
                            DateTime.parse(ticket['createdAt'].toString());

                        now = now.add(const Duration(hours: 5, minutes: 45));

                        var formattedTime = DateFormat('yMMMMd').format(now);

                        return InkWell(
                          onTap: () {
                          },
                          child: Card(
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
                                          : logoTheme),
                                  top: BorderSide(
                                      color: ticket.status == "Resolved"
                                          ? Colors.green
                                          : logoTheme),
                                  right: BorderSide(
                                      color: ticket.status == "Resolved"
                                          ? Colors.green
                                          : logoTheme),
                                  left: BorderSide(
                                      color: ticket.status == "Resolved"
                                          ? Colors.green
                                          : logoTheme,
                                      width: 8),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(ticket["topic"].toString()),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: ticket["status"] ==
                                                        "Resolved"
                                                    ? Colors.green
                                                    : kPrimaryColor,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5.0))),
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
                                    // Text(ticket['topic']),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                          child: Text(
                                              ticket["ticketId"].toString(),
                                              style: const TextStyle(
                                                  color: white, fontSize: 10)),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.event,
                                              size: 15,
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                            ),
                                            Text(formattedTime),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.timelapse,
                                              size: 15,
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                            ),
                                            Text(
                                              DateFormat.jm()
                                                  .format(ticket.createdAt!),
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.thermostat,
                                              size: 15,
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                            ),
                                            Text(ticket['severity'].toString()),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      ticket['request'],
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
                                                    Parentrequestdetailscreen(
                                                        id: ticket['_id'])),
                                          );
                                        },
                                        child: Row(
                                          children: const [
                                            Center(
                                                child: Text(
                                              "Detail",
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
                                ],
                              ),
                            ),
                          ),
                        );
                      });
            } else if (snapshot.hasError) {
              return Image.asset("assets/images/no_content.PNG");
            } else {
              return Image.asset("assets/images/no_content.PNG");
            }
          },
        ),
      ),
    );
  }
}
