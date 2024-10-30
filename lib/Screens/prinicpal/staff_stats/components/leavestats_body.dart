import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/stats_common_view_model.dart';
import 'package:schoolworkspro_app/api/repositories/principal/stats_repo.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../response/login_response.dart';

class LeavestatsBody extends StatefulWidget {
  final data;
  const LeavestatsBody({Key? key, this.data}) : super(key: key);

  @override
  _LeavestatsBodyState createState() => _LeavestatsBodyState();
}

class _LeavestatsBodyState extends State<LeavestatsBody> {
  late User user;
  bool calender = true;
  final remarksContoller = TextEditingController();

  List<String> status = ["Approved", "Denied"];
  String? selected_status;
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<StatsCommonViewModel>(context, listen: false)
          .fetchleavereport(widget.data["username"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<StatsCommonViewModel, CommonViewModel>(
        builder: (context, value, common, child) {
      return isLoading(value.leavestatsApiResponse) ? Center(
        child: SpinKitDualRing(color: kPrimaryColor,),
      ) : ListView(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Ticket view",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Switch(
                  value: calender,
                  onChanged: (value) {
                    setState(() {
                      calender = value;
                    });
                  }),
              Text(
                "Calendar view",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          calender == false
              ? value.leavestats.isEmpty ?
          Column(
            children: [Image.asset("assets/images/no_content.PNG")],
          )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: value.leavestats.length,
                  itemBuilder: (context, index) {
                    var ticket = value.leavestats[index];

                    DateTime start =
                        DateTime.parse(ticket.startDate.toString());

                    start = start.add(const Duration(hours: 5, minutes: 45));

                    var formattedStart = DateFormat('yMMMMd').format(start);

                    DateTime end = DateTime.parse(ticket.endDate.toString());

                    end = end.add(const Duration(hours: 5, minutes: 45));

                    var formattedend = DateFormat('yMMMMd').format(end);

                    // var ticketResponseLength = ticket.ticketResponse.length;

                    return Card(
                      clipBehavior: Clip.antiAlias,
                      margin: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                        color: ticket.status == "Approved"
                                            ? Colors.green
                                            : ticket.status == "Denied"
                                                ? Colors.red
                                                : Colors.orange,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(30.0))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(ticket.status.toString(),
                                          style: const TextStyle(
                                              fontSize: 9,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "From: " + formattedStart.toString()),
                                      Text("To: " + formattedend.toString()),
                                      Text("leave type: " +
                                          ticket.leaveType.toString()),
                                      Text(
                                        "Leave description: " +
                                            ticket.content.toString(),
                                        overflow: TextOverflow.fade,
                                      ),
                                      ButtonBar(
                                        children: [
                                          OutlinedButton(
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            "Respond"),
                                                        content: SizedBox(
                                                          height: 320,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                  "Status"),
                                                              DropdownButtonFormField(
                                                                isExpanded:
                                                                    true,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  filled: true,
                                                                  hintText:
                                                                      'Select leave type',
                                                                ),
                                                                icon: const Icon(
                                                                    Icons
                                                                        .arrow_drop_down_outlined),
                                                                items: status
                                                                    .map((pt) {
                                                                  return DropdownMenuItem(
                                                                    value: pt,
                                                                    child: Text(
                                                                      pt,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                                onChanged:
                                                                    (newVal) {
                                                                  setState(() {
                                                                    selected_status =
                                                                        newVal
                                                                            as String?;
                                                                    // print(_mySelection);
                                                                  });
                                                                },
                                                                value:
                                                                    selected_status,
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Text("Remarks"),
                                                              TextFormField(
                                                                controller:
                                                                    remarksContoller,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .visiblePassword,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  hintText:
                                                                      'Enter description',
                                                                  filled: true,
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(color: kPrimaryColor)),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(color: Colors.green)),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15.0,
                                                                        top:
                                                                            15.0),
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          40,
                                                                      width: 95,
                                                                      child:
                                                                          ElevatedButton(
                                                                        style: ButtonStyle(
                                                                            backgroundColor: MaterialStateProperty.all(Colors.white),
                                                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(18.0),
                                                                            ))),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: const Text(
                                                                            "Cancel",
                                                                            style:
                                                                                TextStyle(fontSize: 14, color: Colors.black)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15.0,
                                                                        top:
                                                                            15.0),
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          40,
                                                                      width: 95,
                                                                      child:
                                                                          ElevatedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          try {
                                                                            common.setLoading(true);
                                                                            final data =
                                                                                {
                                                                              "status": selected_status,
                                                                              "remarks": remarksContoller.text
                                                                            };

                                                                            final res =
                                                                                await StatsRepository().respondleave(data, ticket.id.toString());
                                                                            if (res.success ==
                                                                                true) {
                                                                              Navigator.of(context).pop();
                                                                              value.fetchleavereport(widget.data['username']);
                                                                              Fluttertoast.showToast(msg: "Leave updated successfully");
                                                                            } else {
                                                                              Fluttertoast.showToast(msg: "Failed to update Leave");
                                                                            }
                                                                            common.setLoading(false);
                                                                          } on Exception catch (e) {
                                                                            common.setLoading(true);
                                                                            Fluttertoast.showToast(msg: e.toString());
                                                                            common.setLoading(false);
                                                                            // TODO
                                                                          }
                                                                        },
                                                                        style: ButtonStyle(
                                                                            backgroundColor: MaterialStateProperty.all(Colors.green),
                                                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(18.0),
                                                                            ))),
                                                                        child:
                                                                            const Text(
                                                                          "Save",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                                  },
                                                );
                                              },
                                              child: Text('Respond'))
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 200,
                            width: 5,
                            color: ticket.status == "Approved"
                                ? Colors.green
                                : ticket.status == "Denied"
                                    ? Colors.red
                                    : Colors.orange,
                          )
                        ],
                      ),
                    );
                  },
                )
              : Builder(
                  builder: (context) {
                    // return ListView.builder(itemBuilder: (context, index) {
                    var showData = value.leavestats;

                    List<Event> collection = [];

                    for (int i = 0; i < showData.length; i++) {
                      DateTime start =
                          DateTime.parse(showData[i].startDate.toString());

                      start = start.add(const Duration(hours: 5, minutes: 45));

                      var formattedTime = DateFormat('MM/DD/YY').format(start);
                      collection.add(Event(
                          eventName: showData[i].leaveType,
                          isAllDay: false,
                          from: DateTime.parse(showData[i].startDate.toString())
                              .add(const Duration(hours: 5, minutes: 45)),
                          to: DateTime.parse(showData[i].endDate.toString())
                              .add(const Duration(hours: 5, minutes: 45)),
                          background: Colors.green));
                    }
                    return SizedBox(
                      height: 600,
                      child: SfCalendar(
                        view: CalendarView.month,
                        showNavigationArrow: true,
                        todayHighlightColor: kPrimaryColor,
                        selectionDecoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.red, width: 2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          shape: BoxShape.rectangle,
                        ),
                        timeSlotViewSettings: const TimeSlotViewSettings(
                            startHour: 9,
                            nonWorkingDays: <int>[DateTime.saturday],
                            endHour: 16),
                        dataSource: MeetingDataSource(collection),
                        monthViewSettings: MonthViewSettings(showAgenda: true),
                        initialSelectedDate: DateTime.now(),
                      ),
                    );
                  },
                )
        ],
      );
    });
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}

class Event {
  Event(
      {this.eventName,
      this.from,
      this.to,
      this.background,
      this.isAllDay = false});

  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;
}
