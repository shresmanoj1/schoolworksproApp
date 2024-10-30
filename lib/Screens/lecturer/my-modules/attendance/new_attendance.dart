import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/attendance/attendance_detail.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/attendance/attendance_lecturer_view_model.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/lecturer/studentattendance_request.dart';
import 'package:schoolworkspro_app/response/lecturer/createnew_attendanceresponse.dart';
import 'package:schoolworkspro_app/response/lecturer/getstudent_batchresponse.dart';
import 'package:schoolworkspro_app/services/lecturer/getstudent_service.dart';
import 'package:schoolworkspro_app/services/lecturer/post_attendanceservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../attendance_view_model.dart';
import '../../../../config/api_response_config.dart';
import '../../../../response/login_response.dart';
import '../../attendance/all_attendance_view_model.dart';
import '../../lecturer_common_view_model.dart';

class NewAttendanceScreen extends StatefulWidget {
  final batch;
  final module_slug;
  final attendanceType;

  const NewAttendanceScreen(
      {Key? key, this.batch, this.module_slug, required this.attendanceType})
      : super(key: key);

  @override
  _NewAttendanceScreenState createState() => _NewAttendanceScreenState();
}

class _NewAttendanceScreenState extends State<NewAttendanceScreen> {
  late Future<GetStudentByBatchResponse> student_response;
  bool _value = false;
  Icon cusIcon = Icon(Icons.search);
  late Widget cusSearchBar;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _presentStudents = <dynamic>[];
  List<dynamic> _absentStudents = <dynamic>[];

  List<dynamic> _list = <dynamic>[];
  List<dynamic> _listForDisplay = <dynamic>[];

  List<bool> _isChecked = <bool>[];
  late User user;
  late LecturerCommonViewModel lecturerCommonViewModel;

  late CommonViewModel commonViewModel;
  late AttendanceViewModel allAttendanceViewModel;
  late ModuleAttendanceLecturer moduleAttendanceLecturer;
  late AttendanceViewModel _provider2;

  @override
  void initState() {
    cusSearchBar = const Text(
      "Attendance",
      style: TextStyle(color: Colors.black),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AttendanceViewModel>(context, listen: false).fetchclass();
      commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
      allAttendanceViewModel =
          Provider.of<AttendanceViewModel>(context, listen: false);
      moduleAttendanceLecturer =
          Provider.of<ModuleAttendanceLecturer>(context, listen: false);
      lecturerCommonViewModel =
          Provider.of<LecturerCommonViewModel>(context, listen: false);
      _provider2 = Provider.of<AttendanceViewModel>(context, listen: false);

      handleRefresh();
    });

    super.initState();
  }

  getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }

  getData() async {
    _listForDisplay.clear();
    _list.clear();
    _presentStudents.clear();
    _absentStudents.clear();
    _provider2.fetchStudentOnlyForAttendance(widget.batch).then((value) {
      dynamic data22 = {
        "lecturerEmail": user.email.toString(),
        "moduleSlug": widget.module_slug.toString(),
      };
      lecturerCommonViewModel.fetchModuleDetails(data22).then((value22) {
        if (lecturerCommonViewModel.modules["isOptional"]) {
          for (int i = 0;
              i < _provider2.studentOnlyForAttendanceList.length;
              i++) {
            if (!lecturerCommonViewModel.modules["blockedUsers"].contains(
                    _provider2.studentOnlyForAttendanceList[i]["username"]) &&
                !_provider2.studentOnlyForAttendanceList[i]["blockedModules"]
                    .contains(widget.module_slug)) {
              if (lecturerCommonViewModel.modules["optionalStudent"].contains(
                  _provider2.studentOnlyForAttendanceList[i]["username"])) {
                setState(() {
                  _list.add(_provider2.studentOnlyForAttendanceList[i]);
                  _listForDisplay =_list;

                  _absentStudents.add(
                      _provider2.studentOnlyForAttendanceList[i]['username']);

                  //scanned attendance
                  if (_provider2.scannedAttendanceList != null &&
                      _provider2.scannedAttendanceList.isNotEmpty) {
                    if (_provider2.scannedAttendanceList.contains(_provider2
                        .studentOnlyForAttendanceList[i]["username"])) {
                      setState(() {
                        _presentStudents.add(_provider2
                            .studentOnlyForAttendanceList[i]['username']);
                        // Remove the student from _absentStudents if present
                        for (int i = 0; i < _absentStudents.length; i++) {
                          if (_presentStudents.contains(_absentStudents[i])) {
                            _absentStudents.removeAt(i);
                          }
                        }
                      });
                    }
                  }
                });
              }
            }
          }
        }
        else {
          for (int i = 0;
              i < _provider2.studentOnlyForAttendanceList.length;
              i++) {
            if (!lecturerCommonViewModel.modules["blockedUsers"].contains(
                    _provider2.studentOnlyForAttendanceList[i]["username"]) &&
                !_provider2.studentOnlyForAttendanceList[i]["blockedModules"]
                    .contains(widget.module_slug)) {
              setState(() {
                _list.add(_provider2.studentOnlyForAttendanceList[i]);
                var convertToList = _list.toSet();
                _listForDisplay = convertToList.toList();
                
                _absentStudents.add(
                    _provider2.studentOnlyForAttendanceList[i]['username']);

                //scanned attendance
                if (_provider2.scannedAttendanceList != null &&
                    _provider2.scannedAttendanceList.isNotEmpty) {
                  if (_provider2.scannedAttendanceList.contains(
                      _provider2.studentOnlyForAttendanceList[i]["username"])) {
                    setState(() {
                      _presentStudents.add(_provider2
                          .studentOnlyForAttendanceList[i]['username']);
                      // Remove the student from _absentStudents if present
                      for (int i = 0; i < _absentStudents.length; i++) {
                        if (_presentStudents.contains(_absentStudents[i])) {
                          _absentStudents.removeAt(i);
                        }
                      }
                    });
                  }
                }
              });
            }
          }
        }
      });
    });
  }

  Future<void> handleRefresh() async {
    allAttendanceViewModel.checkAttendance(widget.module_slug.toString(),
        widget.batch.toString(), widget.attendanceType.toString());

    moduleAttendanceLecturer.fetchStudentAttendance(
        widget.module_slug.toString(), widget.batch.toString());

    Map<String, dynamic> scannedRequest = {
      "attendanceType": widget.attendanceType.toString(),
      "batch": widget.batch.toString(),
      "moduleSlug": widget.module_slug.toString(),
    };

    _provider2.fetchScannedAttendance(scannedRequest);

    getData();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<CommonViewModel, LecturerCommonViewModel,
            AttendanceViewModel, ModuleAttendanceLecturer>(
        builder: (context, common, lecturer, attendance, mcl, child) {
      return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (this.cusIcon.icon == Icons.search) {
                        this.cusIcon = const Icon(
                          Icons.cancel,
                          color: Colors.grey,
                        );
                        this.cusSearchBar = TextField(
                          autofocus: true,
                          textInputAction: TextInputAction.go,
                          controller: _searchController,
                          decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              hintText: "Search by name..."),
                          onChanged: (text) {
                            setState(() {
                              _listForDisplay = _list.where((list) {
                                var name =
                                    list['firstname'] + ' ' + list['lastname'];
                                var itemName = name.toLowerCase();
                                return itemName.contains(text);
                              }).toList();
                            });
                          },
                        );
                      } else {
                        this.cusIcon = const Icon(Icons.search);
                        this.cusSearchBar = const Text(
                          "New Attendance",
                          style: TextStyle(color: Colors.black),
                        );
                      }
                    });
                  },
                  icon: cusIcon)
            ],
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: cusSearchBar,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                widget.attendanceType == null
                    ? Container()
                    : isLoading(lecturer.modulesApiResponse)
                        ? const Center(
                            child: CupertinoActivityIndicator(),
                          )
                        : isLoading(attendance.classApiResponse)
                            ? const Center(
                                child: CupertinoActivityIndicator(),
                              )
                            : widget.attendanceType == null
                                ? const SizedBox()
                                : attendance.Status == true
                                    ? Column(
                                        children: [
                                          const Text(
                                            "Today's attendance has been already taken",
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ListView(
                                            shrinkWrap: true,
                                            physics: const ScrollPhysics(),
                                            children: [
                                              isLoading(mcl
                                                      .getAttendacenApiResponse)
                                                  ? const VerticalDivider()
                                                  : ListView.builder(
                                                      physics:
                                                          const ScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: mcl
                                                          .getStudentAttendance
                                                          .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        DateTime
                                                            start =
                                                            DateTime.parse(
                                                                mcl.getStudentAttendance[
                                                                        index][
                                                                    'createdAt']);
                                                        start = start.add(
                                                            const Duration(
                                                                hours: 5,
                                                                minutes: 45));
                                                        var formattedTime =
                                                            DateFormat(
                                                                    'MMMM d yyyy')
                                                                .format(start);

                                                        return Row(children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  CircularPercentIndicator(
                                                                radius: 33.0,
                                                                lineWidth: 6.0,
                                                                percent: double.parse(mcl
                                                                        .getStudentAttendance[
                                                                            index]
                                                                            [
                                                                            'presentPercentage']
                                                                        .split(
                                                                            ".")[0]) /
                                                                    100,
                                                                center: Text(
                                                                  mcl.getStudentAttendance[
                                                                              index]
                                                                              [
                                                                              'presentPercentage']
                                                                          .split(
                                                                              ".")[0] +
                                                                      "%",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                progressColor:
                                                                    Colors
                                                                        .green,
                                                                animationDuration:
                                                                    100,
                                                                animateFromLastPercent:
                                                                    true,
                                                                arcType: ArcType
                                                                    .FULL,
                                                                arcBackgroundColor:
                                                                    Colors
                                                                        .black12,
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                animation: true,
                                                                circularStrokeCap:
                                                                    CircularStrokeCap
                                                                        .butt,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 5,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Column(
                                                                children: [
                                                                  const Text(
                                                                      "Attendance of: "),
                                                                  Text(
                                                                      formattedTime)
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              AttendanceDetail(
                                                                            id: mcl.getStudentAttendance[index]['_id'],
                                                                            absent_student:
                                                                                mcl.getStudentAttendance[index]['absent_students'],
                                                                            present_student:
                                                                                mcl.getStudentAttendance[index]['present_students'],
                                                                            batch:
                                                                                mcl.getStudentAttendance[index]['batch'],
                                                                            module_slug:
                                                                                widget.module_slug.toString(),
                                                                            date:
                                                                                formattedTime,
                                                                            attendanceType:
                                                                                widget.attendanceType,
                                                                          ),
                                                                        ))
                                                                    .then(
                                                                        (value) {
                                                                  attendance.checkAttendance(
                                                                      widget
                                                                          .module_slug
                                                                          .toString(),
                                                                      widget
                                                                          .batch
                                                                          .toString(),
                                                                      widget
                                                                          .attendanceType
                                                                          .toString());

                                                                  moduleAttendanceLecturer.fetchStudentAttendance(
                                                                      widget
                                                                          .module_slug
                                                                          .toString(),
                                                                      widget
                                                                          .batch
                                                                          .toString());
                                                                });
                                                              },
                                                              child:
                                                                  const Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            3.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .edit_rounded,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ]);
                                                      },
                                                    )
                                            ],
                                          ),
                                        ],
                                      )
                                    : _listForDisplay.length > 0
                                        ? Column(
                                            children: [
                                              SizedBox(
                                                height: 50,
                                                width: double.infinity,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                          EdgeInsets.only(left: 18.0),
                                                          child: Text(
                                                            'Mark All',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight.bold),
                                                          ),
                                                        ),
                                                        Checkbox(
                                                          value: _value,
                                                          activeColor: Colors.green,
                                                          onChanged: (value) {
                                                            _presentStudents.clear();
                                                            _absentStudents.clear();
                                                            setState(() {
                                                              if (value!) {
                                                                for (int i = 0;
                                                                i <
                                                                    _listForDisplay
                                                                        .length;
                                                                i++) {
                                                                  setState(() {
                                                                    _presentStudents.add(_listForDisplay[i]['username']);
                                                                    _value = true;
                                                                  });
                                                                }
                                                              } else {
                                                                for (int i = 0; i < _listForDisplay.length; i++) {
                                                                  setState(() {
                                                                    _absentStudents.add(_listForDisplay[i]['username']);
                                                                    _value = false;
                                                                  });
                                                                }
                                                              }
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 25.0),
                                                      child: ElevatedButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .green),
                                                          ),
                                                          onPressed: () async {
                                                            try {
                                                              final request = StudentAttendanceRequest(
                                                                  batch: widget
                                                                      .batch,
                                                                  absentStudents:
                                                                      _absentStudents,
                                                                  moduleSlug: widget
                                                                      .module_slug,
                                                                  presentStudents:
                                                                      _presentStudents,
                                                                  attendanceType: widget
                                                                      .attendanceType
                                                                      .toString());
                                                              CreateNewAttendanceResponse
                                                                  response =
                                                                  await PostAttendanceService()
                                                                      .addnewAttendance(
                                                                request,
                                                              );
                                                              common.setLoading(
                                                                  true);
                                                              if (response
                                                                      .success ==
                                                                  true) {
                                                                snackThis(
                                                                  context:
                                                                      context,
                                                                  content: Text(
                                                                      "${response.message}"),
                                                                  color: Colors
                                                                      .green,
                                                                );
                                                                common
                                                                    .setLoading(
                                                                        false);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              }
                                                              else {
                                                                snackThis(
                                                                  context:
                                                                      context,
                                                                  content: Text(
                                                                      "${response.message}"),
                                                                  color: Colors
                                                                      .green,
                                                                );
                                                                common
                                                                    .setLoading(
                                                                        false);
                                                              }
                                                            } catch (e) {
                                                              common.setLoading(
                                                                  false);
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg: e
                                                                          .toString());
                                                              common.setLoading(
                                                                  false);
                                                            }
                                                          },
                                                          child: const Text(
                                                              "Save")),
                                                    ),

                                                  ],
                                                ),
                                              ),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: const ScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return _listItem(
                                                      index, attendance);
                                                },
                                                itemCount:
                                                    _listForDisplay.length,
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    right: 25.0),
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                      MaterialStateProperty
                                                          .all(Colors
                                                          .green),
                                                    ),
                                                    onPressed: () async {
                                                      try {
                                                        final request = StudentAttendanceRequest(
                                                            batch: widget
                                                                .batch,
                                                            absentStudents:
                                                            _absentStudents,
                                                            moduleSlug: widget
                                                                .module_slug,
                                                            presentStudents:
                                                            _presentStudents,
                                                            attendanceType: widget
                                                                .attendanceType
                                                                .toString());
                                                        CreateNewAttendanceResponse
                                                        response =
                                                        await PostAttendanceService()
                                                            .addnewAttendance(
                                                          request,
                                                        );
                                                        common.setLoading(
                                                            true);
                                                        if (response
                                                            .success ==
                                                            true) {
                                                          snackThis(
                                                            context:
                                                            context,
                                                            content: Text(
                                                                "${response.message}"),
                                                            color: Colors
                                                                .green,
                                                          );
                                                          common
                                                              .setLoading(
                                                              false);
                                                          Navigator.of(
                                                              context)
                                                              .pop();
                                                        }
                                                        else {
                                                          snackThis(
                                                            context:
                                                            context,
                                                            content: Text(
                                                                "${response.message}"),
                                                            color: Colors
                                                                .green,
                                                          );
                                                          common
                                                              .setLoading(
                                                              false);
                                                        }
                                                      } catch (e) {
                                                        common.setLoading(
                                                            false);
                                                        Fluttertoast
                                                            .showToast(
                                                            msg: e
                                                                .toString());
                                                        common.setLoading(
                                                            false);
                                                      }
                                                    },
                                                    child: const Text(
                                                        "Save")),
                                              ),

                                            ],
                                          )
                                        : const Center(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                  vertical: 10.0),
                                              child: Text(
                                                "No student available",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ),
              ],
            ),
          ));
    });
  }

  _listItem(index, AttendanceViewModel attendanceValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  attendanceValue.scannedAttendanceList
                          .contains(_listForDisplay[index]['username'])
                      ? const Icon(Icons.qr_code_2)
                      : const SizedBox(),
                  Checkbox(
                    value: _presentStudents
                        .contains(_listForDisplay[index]['username']),
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          _presentStudents
                              .add(_listForDisplay[index]['username']);
                          _absentStudents.removeWhere((element) =>
                              element == _listForDisplay[index]['username']);
                        } else {
                          _absentStudents
                              .add(_listForDisplay[index]['username']);
                          _presentStudents
                              .remove(_listForDisplay[index]['username']);
                        }
                      });
                    },
                  ),
                ],
              ),
              subtitle: Text(_listForDisplay[index]['username']),
              leading: Text((index + 1).toString()),
              title: Text(_listForDisplay[index]['firstname'] +
                  ' ' +
                  _listForDisplay[index]['lastname']),
            )),
      ],
    );
  }
}
