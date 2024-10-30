import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:schoolworkspro_app/Screens/driver/driver_view_model.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/services/driver/getbus_service.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:intl/intl.dart';
import '../../../config/api_response_config.dart';

class StudentListBus extends StatefulWidget {
  final String busName;
  final String id;
  final String busNumber;

  const StudentListBus(
      {Key? key,
      required this.busName,
      required this.busNumber,
      required this.id})
      : super(key: key);

  @override
  _StudentListBusState createState() => _StudentListBusState();
}

class _StudentListBusState extends State<StudentListBus> {
  late DriverViewModel _provider;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<DriverViewModel>(context, listen: false);
      _provider.fetchBusStudent(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DriverViewModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.busName,
            style: const TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.black, // Change your color here
          ),
          backgroundColor: Colors.white,
        ),
        body: isLoading(model.studentListApiResponse)
            ? const Center(child: CupertinoActivityIndicator())
            : buildStudentList(model.studentList.students),
      );
    });
  }

  Widget buildStudentList(List<dynamic>? students) {
    if (students == null || students.isEmpty) {
      return const Center(
        child: Text("No Student Found"),
      );
    }

    return RefreshIndicator(
      onRefresh: () => getData(),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: students.length,
        itemBuilder: (context, index) {
          return buildStudentItem(students[index], index);
        },
      ),
    );
  }

  Widget buildStudentItem(dynamic student, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            children: [
              Text(
                "${index + 1}. ${student["firstname"]} ${student["lastname"]}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ],
          ),
        ),
        student["record"] != null
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
                child: Row(
                  children: [
                    const Text("Status: ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(student["record"]["recordStatus"].toString(),
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color:
                                student["record"]["recordStatus"].toString() ==
                                        "In"
                                    ? Colors.green
                                    : Colors.red)),
                  ],
                ),
              )
            : Container(),
        student["leave"] != null
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
                child: Row(
                  children: [
                    const Text("Leave: ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 5),
                    InkWell(
                        onTap: () =>
                            showStudentLeaveAlertDialog(context, student),
                        child: const Icon(
                          Icons.person_remove_alt_1_outlined,
                          color: Color(0XFFff9b20),
                        )),
                  ],
                ),
              )
            : const SizedBox(),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Container(
                  child: ToggleSwitch(
                    animate: false,
                    minWidth: MediaQuery.of(context).size.width / 2.22,
                    minHeight: 45,
                    initialLabelIndex: student["status"] == "Picked"
                        ? 0
                        : student["status"] == "Dropped"
                            ? 1
                            : null,
                    activeBgColor: const [kPrimaryColor],
                    inactiveBgColor: Colors.grey.shade300,
                    labels: const ['Picked Up', 'Dropped'],
                    onToggle: (i) async {
                      if (i == 0) {
                        Map<String, dynamic> request = {
                          "busId": widget.id,
                          "status": "Picked"
                        };

                        final result = await BusService()
                            .changeStatusStudent(request, student["_id"]);
                        if (result.success == true) {
                          print("helllo print");
                          Fluttertoast.showToast(
                              msg:
                                  "${'${"Status of " + student["firstname"]} ' + student["lastname"]} changed successfully");
                        } else {
                          Fluttertoast.showToast(
                              msg: result.message.toString());
                        }
                      } else if (i == 1) {
                        try {
                          Map<String, dynamic> request = {
                            "busId": widget.id,
                            "status": "Dropped"
                          };
                          final result = await BusService()
                              .changeStatusStudent(request, student["_id"]);
                          if (result.success == true) {
                            Fluttertoast.showToast(
                                msg:
                                    "${'${"Status of " + student["firstname"]} ' + student["lastname"]} changed successfully");
                          } else {
                            Fluttertoast.showToast(
                                msg: result.message.toString());
                          }
                        } catch (e) {
                          print("CATCH $e");
                        }
                      }
                    },
                    totalSwitches: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  showStudentLeaveAlertDialog(BuildContext context, dynamic studentLeve) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 10),
            child: StatefulBuilder(builder: (context, StateSetter setState) {
              return studentLeve["leave"] != null
                  ? SizedBox(
                      height: 250,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  studentLeve["username"].toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.close),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: 150,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                studentLeve["leave"]
                                                                        [
                                                                        "leaveTitle"]
                                                                    .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                )),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(DateFormat
                                                                        .yMMMd()
                                                                    .format(DateTime.parse(studentLeve["leave"]
                                                                            [
                                                                            "startDate"]
                                                                        .toString()))),
                                                                const Text(
                                                                    " to "),
                                                                Text(DateFormat
                                                                        .yMMMd()
                                                                    .format(DateTime.parse(studentLeve["leave"]
                                                                            [
                                                                            "endDate"]
                                                                        .toString()))),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          InkWell(
                                                              onTap: () {},
                                                              child: Container(
                                                                height: 24,
                                                                width: 60,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                4),
                                                                    color: studentLeve["leave"]["status"] ==
                                                                            "Pending"
                                                                        ? Colors
                                                                            .green
                                                                        : Colors
                                                                            .blueAccent),
                                                                child: Center(
                                                                    child: Text(
                                                                  studentLeve["leave"]
                                                                          [
                                                                          "status"]
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                              )),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  studentLeve["leave"]
                                                              ["allDay"] ==
                                                          true
                                                      ? Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: const [
                                                            Text(
                                                                "Leave For : "),
                                                            Text("All Day")
                                                          ],
                                                        )
                                                      : Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                                "Leave For : "),
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  ...List.generate(
                                                                      studentLeve["leave"]
                                                                              [
                                                                              "routines"]
                                                                          .length,
                                                                      (innerIndex) =>
                                                                          Text(
                                                                              "${studentLeve["leave"]["routines"]![innerIndex]["title"]} (${studentLeve["leave"]["routines"][innerIndex]["classType"]}) | ${DateFormat.yMMMd().format(DateTime.parse(studentLeve["leave"]["routines"][innerIndex]["date"].toString()))}"))
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 5, top: 5),
                                          child: Divider(
                                            color: Colors.grey,
                                            thickness: 1,
                                          ),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox();
            }),
          );
        });
  }
}
