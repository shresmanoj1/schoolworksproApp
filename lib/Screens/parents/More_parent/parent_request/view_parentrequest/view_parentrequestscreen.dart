import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/parents/More_parent/parent_request/view_parentrequest/parentrequestdetail_screen.dart';
import 'package:schoolworkspro_app/Screens/request/request_view_model.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:schoolworkspro_app/response/parents/getrequestparent_response.dart';
import 'package:schoolworkspro_app/services/parents/getparentrequest_service.dart';

class Viewparentrequestscreen extends StatefulWidget {
  String requestName;
  Viewparentrequestscreen({Key? key, required this.requestName})
      : super(key: key);

  @override
  _ViewparentrequestscreenState createState() =>
      _ViewparentrequestscreenState();
}

class _ViewparentrequestscreenState extends State<Viewparentrequestscreen> {
  Future<Getparentequestresponse>? parent_request;

  @override
  void initState() {
    // TODO: implement initState
    parent_request = Getparentrequestservice().getrequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Consumer<RequestViewModel>(
          // future: parent_request,
          builder: (context, snapshot, child) {
            // if (snapshot.hasData) {
            return isLoading(snapshot.parentRequestApiResponse)
                ? VerticalLoader()
                : snapshot.parentRequest.requests == null ||
                        snapshot.parentRequest.requests!.isEmpty
                    ? Image.asset("assets/images/no_content.PNG")
                    : ListView.builder(
                        itemCount: snapshot.parentRequest.requests!.length,
                        itemBuilder: (context, index) {
                          var ticket = snapshot.parentRequest.requests![index];

                          DateTime now =
                              DateTime.parse(ticket['createdAt'].toString());

                          now = now.add(const Duration(hours: 5, minutes: 45));

                          var formattedTime = DateFormat('yMMMMd').format(now);

                          return widget.requestName.toString() == 'Pending'
                              ? ticket['status'] ==
                                          widget.requestName.toString() ||
                                      ticket['status'] == 'Backlog'
                                  ? myRequest(ticket, formattedTime)
                                  : Container()
                              : ticket['status'] ==
                                      widget.requestName.toString()
                                  ? myRequest(ticket, formattedTime)
                                  : Container();
                        });
            // } else if (snapshot.hasError) {
            //   return Image.asset("assets/images/no_content.PNG");
            // } else {
            //   return VerticalLoader();
            // }
          },
        ),
      ),
    );
  }

  Widget myRequest(ticket, formattedTime) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           Parentrequestdetailscreen(id: ticket['_id'])),
        // );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: ticket["status"] == "Pending"
                      ? Color(0xffff9b20)
                      : ticket['status'] == "Resolved"
                          ? Colors.green
                          : logoTheme),
              top: BorderSide(
                  color: ticket["status"] == "Pending"
                      ? Color(0xffff9b20)
                      : ticket['status'] == "Resolved"
                          ? Colors.green
                          : logoTheme),
              right: BorderSide(
                  color: ticket["status"] == "Pending"
                      ? Color(0xffff9b20)
                      : ticket['status'] == "Resolved"
                          ? Colors.green
                          : logoTheme),
              left: BorderSide(
                  color: ticket["status"] == "Pending"
                      ? Color(0xffff9b20)
                      : ticket['status'] == "Resolved"
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
                      Text(ticket['topic']),
                      Container(
                        decoration: BoxDecoration(
                            color: ticket["status"] == "Pending"
                                ? Color(0xffff9b20)
                                : ticket['status'] == "Resolved"
                                    ? Colors.green
                                    : kPrimaryColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0))),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(ticket['status'],
                              style: const TextStyle(
                                  fontSize: 9, color: Colors.white)),
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
                      child: Text(ticket['ticketId'],
                          style: TextStyle(color: white, fontSize: 10)),
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
                                  .format(DateTime.parse(ticket['createdAt'])),
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
                              ticket['severity'],
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
                  ticket['request'],
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
                      backgroundColor: MaterialStateProperty.all(logoTheme),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Parentrequestdetailscreen(id: ticket['_id'], isParent: false,)),
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
      ),
    );
  }
}
