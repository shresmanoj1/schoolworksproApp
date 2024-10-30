import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/request/request_view_model.dart';
import 'package:schoolworkspro_app/Screens/request/requestdetail.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/viewmyrequest_response.dart';
import 'package:schoolworkspro_app/services/viewmyrequest_service.dart';
import 'package:intl/intl.dart';

class Myrequest extends StatefulWidget {
  const Myrequest({Key? key}) : super(key: key);

  @override
  _MyrequestState createState() => _MyrequestState();
}

class _MyrequestState extends State<Myrequest> {
  Stream<Viewmyrequestresponse>? _ticketModel;
  Future<Viewmyrequestresponse>? check_data;
  final TextEditingController _responseController = TextEditingController();
  TextStyle linkStyle = const TextStyle(color: Colors.blue);
  bool connected = true;
  bool visibility = true;
  bool available = false;
  bool fileName = false;

  late RequestViewModel _provider;

  @override
  void initState() {
    _ticketModel =
        Viewmyrequestservice().getrefreshrequest(const Duration(seconds: 1));
    checknull();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<RequestViewModel>(context, listen: false);
      _provider.fetchMyRequest();
    });

    super.initState();
  }

  checknull() async {
    final data = await Viewmyrequestservice()
        .getrefreshrequest(const Duration(seconds: 1));
    if (data == null) {
      setState(() {
        available = false;
      });
    } else {
      setState(() {
        available = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RequestViewModel>(builder: (context, snapshot, child) {
      return Scaffold(
          body:
              isLoading(snapshot.myRequestApiResponse)
                  ? VerticalLoader()
                  : snapshot.myRequest.requests!.isEmpty
                      ? Column(children: <Widget>[
                          Image.asset("assets/images/no_content.PNG"),
                          const Text(
                            "No request available",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ])
                      : ListView.builder(
                          itemCount: snapshot.myRequest.requests!.length,
                          itemBuilder: (context, index) {
                            var ticket = snapshot.myRequest.requests![index];

                            DateTime now =
                                DateTime.parse(ticket['createdAt'].toString());

                            now =
                                now.add(const Duration(hours: 5, minutes: 45));

                            var formattedTime =
                                DateFormat('yMMMMd').format(now);

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
                                            margin:
                                                const EdgeInsets.only(left: 15),
                                            decoration: BoxDecoration(
                                                color: ticket['status'] ==
                                                        "Resolved"
                                                    ? Colors.green
                                                    : kPrimaryColor,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(30.0))),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
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
                                            padding: const EdgeInsets.all(16.0),
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
                                                                ticket['_id'],
                                                          )),
                                                );
                                              },
                                              child: const Text("Details >"),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
          );
    });
  }
}
