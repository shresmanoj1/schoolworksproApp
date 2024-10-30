import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/stats_common_view_model.dart';
import 'package:intl/intl.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';

class OvertimeBody extends StatefulWidget {
  final data;

  const OvertimeBody({Key? key, this.data}) : super(key: key);

  @override
  _OvertimeBodyState createState() => _OvertimeBodyState();
}

class _OvertimeBodyState extends State<OvertimeBody> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<StatsCommonViewModel>(context, listen: false)
          .fetchovertime(widget.data["username"]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StatsCommonViewModel>(builder: (context, value, child) {
      return isLoading(value.overtimestatsApiResponse)
          ? Center(
              child: SpinKitDualRing(color: kPrimaryColor),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                              height: 50,
                              color: Colors.blueGrey,
                              child: Center(
                                  child: Column(
                                children: [
                                  Text(
                                    "Pending",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    value.pendingCount.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )))),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Container(
                              height: 50,
                              color: Colors.green.shade700,
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "Approved",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      value.approvedCount.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ))),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Container(
                              height: 50,
                              color: Colors.red.shade500,
                              child: Center(
                                  child: Column(
                                children: [
                                  Text(
                                    "Denied",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    value.deniedCount.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )))),
                    ],
                  ),
                ),
                value.overtime.isEmpty
                    ? Column(
                        children: [Image.asset("assets/images/no_content.PNG")],
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: value.overtime.length,
                        itemBuilder: (context, index) {
                          var ticket = value.overtime[index];

                          DateTime start =
                              DateTime.parse(ticket['startDate'].toString());

                          start =
                              start.add(const Duration(hours: 5, minutes: 45));

                          var formattedStart =
                              DateFormat('yMMMMd').format(start);

                          DateTime end =
                              DateTime.parse(ticket['endDate'].toString());

                          end = end.add(const Duration(hours: 5, minutes: 45));

                          var formattedend = DateFormat('yMMMMd').format(end);
                          return Card(
                            clipBehavior: Clip.antiAlias,
                            margin: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Container(
                                  height: 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 15),
                                          decoration: BoxDecoration(
                                              color: ticket['status'] ==
                                                      "Approved"
                                                  ? Colors.green
                                                  : ticket['status'] == "Denied"
                                                      ? Colors.red
                                                      : Colors.orange,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(30.0))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Text(
                                                ticket['status'].toString(),
                                                style: const TextStyle(
                                                    fontSize: 9,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      ListTile(
                                        subtitle: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("From: " +
                                                formattedStart.toString()),
                                            Text("To: " +
                                                formattedend.toString()),
                                            Text("purpose"),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 150,
                                  width: 5,
                                  color: ticket['status'] == "Approved"
                                      ? Colors.green
                                      : ticket['status'] == "Denied"
                                          ? Colors.red
                                          : Colors.orange,
                                )
                              ],
                            ),
                          );
                        },
                      )
              ],
            );
    });
  }
}
