import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:schoolworkspro_app/components/internetcheck.dart';
import 'package:schoolworkspro_app/components/nointernet_widget.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:schoolworkspro_app/request/lecturer/attendancereport_request.dart';
import 'package:schoolworkspro_app/request/lecturer/get_modulerequest.dart';
import 'package:schoolworkspro_app/response/lecturer/attendancereport_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getbatchforattendance_response.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:schoolworkspro_app/services/lecturer/getmodule_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helper/custom_loader.dart';
import '../../../../services/lecturer/attendancereport_service.dart';

class AttendanceReportLecturer extends StatefulWidget {
  const AttendanceReportLecturer({Key? key}) : super(key: key);

  @override
  _AttendanceReportLecturerState createState() =>
      _AttendanceReportLecturerState();
}

class _AttendanceReportLecturerState extends State<AttendanceReportLecturer> {
  String? selected_module;
  String? selected_batch;
  List<dynamic> modules = <dynamic>[];
  List<String> batches = <String>[];
  User? user;
  bool isloading = false;

  Future<AttendanceReportResponse>? attendance_response;
  Future<GetBatchForAttendanceResponse>? batch_response;

  List<AllAttendance> _list = <AllAttendance>[];
  List<AllAttendance> _listForDisplay = <AllAttendance>[];

  final TextEditingController _searchController = TextEditingController();

  Icon cusIcon = const Icon(Icons.search);
  Widget cusSearchBar = const Text(
    'Attendance Report',
    style: TextStyle(color: white),
  );

  bool connected = false;
  @override
  void initState() {
    // TODO: implement initState
    getuserData();
    checkInternet();
    super.initState();
  }

  checkInternet() async {
    internetCheck().then((value) {
      if (value) {
        setState(() {
          connected = true;
        });
      } else {
        setState(() {
          connected = false;
        });
        // snackThis(context: context,content: const Text("No Internet Connection"),duration: 10,color: Colors.red.shade500);
        // Fluttertoast.showToast(msg: "No Internet connection");
      }
    });
  }

  getuserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
    final data = Getmodulerequest(email: user!.email.toString());
    final res = await ModuleServiceLecturer().getmodules(data);
    for (int index = 0; index < res.lecturer!.modules!.length; index++) {
      setState(() {
        modules.add(res.lecturer?.modules?[index]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isloading == true) {
      customLoadStart();
    } else {
      customLoadStop();
    }
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
                          style: TextStyle(
                            color: white,
                          ),
                          decoration: const InputDecoration(
                              hintText: 'Search student name...',
                              hintStyle: TextStyle(color: white),
                              border: InputBorder.none),
                          onChanged: (text) {
                            setState(() {
                              _listForDisplay = _list.where((list) {
                                var itemName = list.name!.toLowerCase();
                                return itemName.contains(text);
                              }).toList();
                            });
                          },
                        );
                      } else {
                        this.cusIcon = Icon(Icons.search);

                        this.cusSearchBar = Text(
                          'Attendance Report',
                          style: TextStyle(color: white),
                        );
                      }
                    });
                  },
                  icon: cusIcon)
            ],
            elevation: 0.0,
            centerTitle: false,
            title: cusSearchBar,
            // backgroundColor: Colors.white
        ),
        body: connected == false
            ? const NoInternetWidget()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return index == 0 ? _searchBar() : _listItem(index - 1);
                      },
                      itemCount: _listForDisplay.length + 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
        );
  }

  getData() async {
    setState(() {
      isloading = true;
    });
    final request = AttendanceReportRequest(
        moduleSlug: selected_module, batch: selected_batch);
    final data = await AttendanceReportService().getAttendanceReport(request);
    for (int i = 0; i < data.allAttendance!.length; i++) {
      setState(() {
        isloading = true;
        _list.add(data.allAttendance![i]);
        _listForDisplay = _list;
        isloading = false;
      });
    }

    setState(() {
      isloading = false;
    });
    // final res2 =
    //     await AttendanceReportService().getallbatch(selected.toString());
    // for (int index2 = 0; index2 < res2.batcharr!.length; index2++) {
    //   setState(() {
    //     batches.add(res2.batcharr![index2]);
    //   });
    // }
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Module",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          DropdownSearch<String>(
            dropdownSearchDecoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black38)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black38)),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              filled: true,
              hintText: 'Select a module',
            ),
            showSearchBox: true,
            maxHeight: MediaQuery.of(context).size.height / 1.2,
            items: modules.map<String>((pt) {
              return pt['moduleTitle'];
            }).toList(),
            mode: Mode.BOTTOM_SHEET,

            onChanged: (newVal) {
              setState(() {
                isloading = true;
                var selectedModule = modules.firstWhere((module) => module['moduleTitle'] == newVal);
                selected_module = selectedModule["moduleSlug"];
                print("MODULE SLUG:::${selected_module}");
                selected_batch = null;
                isloading = false;

                print(selected_module);
              });
              setState(() {
                _listForDisplay.clear();
                _list.clear();
                isloading = true;
                batch_response = AttendanceReportService()
                    .getallbatch(selected_module.toString());
                isloading = false;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder<GetBatchForAttendanceResponse>(
            future: batch_response,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.batcharr!.isEmpty
                    ? Center(
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.orangeAccent.shade100),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.notifications,
                                  color: Colors.deepOrange,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  child: Text(
                                    'No Batch available for this module....',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(color: Colors.deepOrange),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "Batch",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),

                          DropdownSearch<String>(
                            dropdownSearchDecoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black38)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black38)),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              filled: true,
                              hintText: 'Select batch',
                            ),
                            showSearchBox: true,
                            maxHeight: MediaQuery.of(context).size.height / 1.2,
                            items: snapshot.data?.batcharr?.map<String>((pt) {
                              return pt;
                            }).toList(),
                            mode: Mode.BOTTOM_SHEET,

                            onChanged: (newVal) {
                              setState(() {
                                // print(newVal);

                                selected_batch = newVal as String?;
                                _listForDisplay.clear();
                                _list.clear();

                                print(selected_batch);

                                getData();
                              });
                            },
                          ),


                          // DropdownButtonFormField(
                          //   hint: const Text('Select batch'),
                          //   value: selected_batch,
                          //   isExpanded: true,
                          //   decoration: const InputDecoration(
                          //     contentPadding:
                          //     EdgeInsets.symmetric(horizontal: 10),
                          //     hintText: 'Select batch',
                          //     filled: true,
                          //     enabledBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(color: Colors.grey)),
                          //     focusedBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(color: Colors.grey)),
                          //     floatingLabelBehavior: FloatingLabelBehavior.always,
                          //   ),
                          //   icon: const Icon(Icons.arrow_drop_down_outlined),
                          //   items: snapshot.data?.batcharr?.map((pt) {
                          //     return DropdownMenuItem(
                          //       value: pt,
                          //       child: Text(
                          //         pt,
                          //         softWrap: true,
                          //         overflow: TextOverflow.ellipsis,
                          //       ),
                          //     );
                          //   }).toList(),
                          //   onChanged: (newVal) {
                          //     setState(() {
                          //       // print(newVal);
                          //
                          //       selected_batch = newVal as String?;
                          //       _listForDisplay.clear();
                          //       _list.clear();
                          //
                          //       print(selected_batch);
                          //
                          //       getData();
                          //     });
                          //   },
                          // ),
                        ],
                      );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.orangeAccent.shade100),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.notifications,
                            color: Colors.deepOrange,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              'Note: You must select a module and a batch to view the attendance report....',
                              textAlign: TextAlign.justify,
                              style: TextStyle(color: Colors.deepOrange),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  _listItem(index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text("Student Name : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)),
                Text(
                  _listForDisplay[index].name.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Text("Student ID : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)),
                Text(
                  _listForDisplay[index].username.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Text("Contact : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0)),
                Text(
                  _listForDisplay[index].contact.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Sessions: " +
                        _listForDisplay[index].totalDays.toString(), style:TextStyle(fontSize: 15)),
                    Text("Present Days: " +
                        _listForDisplay[index].presentDays.toString(), style:TextStyle(fontSize: 15)),
                    Text("Absent Days: " +
                        _listForDisplay[index].absentDays.toString(),style:TextStyle(fontSize: 15)),
                  ],
                ),
                CircularPercentIndicator(
                  radius: 35.0,
                  lineWidth: 6.0,
                  percent:
                  (_listForDisplay[index].percentage!.toDouble() / 100),
                  center: Text(
                    _listForDisplay[index]
                        .percentage!
                        .toString()
                        .split('.')[0] +
                        "%",
                    style: TextStyle(fontSize: 12),
                  ),
                  progressColor: _listForDisplay[index].percentage! >= 80
                      ? Colors.green
                      : _listForDisplay[index].percentage! >= 70 &&
                      _listForDisplay[index].percentage! < 80
                      ? Colors.yellow
                      : Colors.red,
                  animationDuration: 100,
                  animateFromLastPercent: true,
                  // arcType: ArcType.FULL,
                  // arcBackgroundColor: Colors.black12,
                  backgroundColor: grey_200,
                  animation: true,
                  circularStrokeCap: CircularStrokeCap.butt,
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}
