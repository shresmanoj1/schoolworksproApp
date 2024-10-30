import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/lecturer/viewexamattendance_response.dart';
import 'package:schoolworkspro_app/services/exam_service.dart';

class ViewExamAttendanceScreen extends StatefulWidget {
  final examID;
  const ViewExamAttendanceScreen({Key? key, this.examID}) : super(key: key);

  @override
  _ViewExamAttendanceScreenState createState() =>
      _ViewExamAttendanceScreenState();
}

class _ViewExamAttendanceScreenState extends State<ViewExamAttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewExamAttendanceBody(
      examID: widget.examID,
    );
  }
}

class ViewExamAttendanceBody extends StatefulWidget {
  final examID;
  const ViewExamAttendanceBody({Key? key, this.examID}) : super(key: key);

  @override
  _ViewExamAttendanceBodyState createState() => _ViewExamAttendanceBodyState();
}

class _ViewExamAttendanceBodyState extends State<ViewExamAttendanceBody> {
  List<AllStudent> _list = <AllStudent>[];
  List<AllStudent> _listForDisplay = <AllStudent>[];
  Widget? cusSearchBar;
  TextEditingController _searchController = new TextEditingController();

  Icon cusIcon = Icon(Icons.search);

  @override
  void initState() {
    // TODO: implement initState
getData();
    super.initState();
  }

  getData() async {
    final res = await ExamService().examAttendance(widget.examID.toString());
    for (int i = 0; i < res.allStudents!.length; i++) {
      setState(() {
        _list.add(res.allStudents![i]);
        _listForDisplay = _list;
      });
    }
    cusSearchBar = Text(
      "Exam Attendance",
      style: TextStyle(color: Colors.black),
    );
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<void> refresh() async {
    _list.clear();
    _listForDisplay.clear();


    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (this.cusIcon.icon == Icons.search) {
                      this.cusIcon = Icon(
                        Icons.cancel,
                        color: Colors.grey,
                      );
                      this.cusSearchBar = TextField(
                        autofocus: true,
                        textInputAction: TextInputAction.go,
                        controller: _searchController,
                        decoration: const InputDecoration(
                            hintText: 'search ...', border: InputBorder.none),
                        onChanged: (text) {
                          setState(() {
                            _listForDisplay = _list.where((list) {
                              var itemName = list.firstname!.toLowerCase() +
                                  " " +
                                  list.lastname!.toLowerCase();
                              return itemName.contains(text);
                            }).toList();
                          });
                        },
                      );
                    } else {
                      this.cusIcon = Icon(Icons.search);
                      _listForDisplay = _list;
                      _searchController.clear();
                      this.cusSearchBar = Text(
                        "Exam Attendance",
                        style: TextStyle(color: Colors.black),
                      );
                    }
                  });
                },
                icon: cusIcon)
          ],
          title: cusSearchBar,
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          child: _listForDisplay.isEmpty
              ? const SpinKitDualRing(color: kPrimaryColor)
              : getListView(),
          onRefresh: refresh,
        ));
  }

  List<dynamic> getListElements() {
    var items = List<dynamic>.generate(
        _listForDisplay.length, (counter) => _listForDisplay[counter]);
    return items;
  }

  Widget getListView() {
    var listItems = getListElements();
    var listview = ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: listItems.length,
      itemBuilder: (context, index) {
        var data = listItems[index];
        return Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chip(label: Text(data.batch ?? "",style: const TextStyle(color: Colors.white),),backgroundColor: Colors.black,),
              ListTile(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(builder: (context) {
                      var name = listItems[index].firstname.toString() +
                          " " +
                          listItems[index].lastname.toString();
                      return RichText(
                        text: TextSpan(
                          text: 'Name: ',
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                              text: name.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      );
                    }),
                    RichText(
                      text: TextSpan(
                        text: 'Batch: ',
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                            text: data.batch.toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                trailing: data.status == null
                    ? Icon(
                        Icons.cancel,
                        color: Colors.red,
                      )
                    : Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    data.time == null
                        ? const SizedBox()
                        : ListView.builder(
                            itemCount: data.time!.length,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, i) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Builder(builder: (context) {
                                    DateTime now = DateTime.parse(
                                        data.time![i].punchIn.toString());

                                    now = now.add(
                                        const Duration(hours: 5, minutes: 45));

                                    final formattedTime =
                                        DateFormat('y-MMMM-d hh:mm a')
                                            .format(now);

                                    return RichText(
                                      text: TextSpan(
                                        text: 'In Time: ',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: formattedTime.toString(),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  data.time![i].punchOut == null
                                      ? const Text("")
                                      : Builder(builder: (context) {
                                          DateTime now = DateTime.parse(data
                                              .time![i].punchOut
                                              .toString());

                                          now = now.add(const Duration(
                                              hours: 5, minutes: 45));

                                          final formattedEnd =
                                              DateFormat('y-MMMM-d hh:mm a')
                                                  .format(now);
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Out Time: ',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: formattedEnd
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Builder(
                                                builder: (context) {
                                                  DateTime now = DateTime.parse(
                                                      data.time![i].punchOut
                                                          .toString());

                                                  DateTime innow =
                                                      DateTime.parse(data
                                                          .time![i].punchIn
                                                          .toString());
                                                  innow = innow.add(Duration(
                                                      hours: 5, minutes: 45));
                                                  now = now.add(Duration(
                                                      hours: 5, minutes: 45));

                                                  Duration diff = now
                                                      .difference(innow)
                                                      .abs();
                                                  final hours = diff.inHours;
                                                  final minutes =
                                                      diff.inMinutes % 60;
                                                  var formatted =
                                                      DateFormat('hh:mm a')
                                                          .format(now);

                                                  return Text(
                                                    "Duration: " +
                                                        hours.toString() +
                                                        " hours " +
                                                        minutes.toString() +
                                                        " minutes",
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  );
                                                },
                                              )
                                            ],
                                          );
                                        })
                                ],
                              );
                            },
                          )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    return listview;
  }
}
