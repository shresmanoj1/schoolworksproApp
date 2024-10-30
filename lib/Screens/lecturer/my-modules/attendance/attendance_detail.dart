import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/attendance_view_model.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/lecturer/studentattendance_request.dart';
import 'package:schoolworkspro_app/response/lecturer/getstudent_batchresponse.dart';
import 'package:schoolworkspro_app/services/lecturer/getstudent_service.dart';
import 'package:schoolworkspro_app/services/lecturer/post_attendanceservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/api_response_config.dart';
import '../../../../response/lecturer/student_leave_response.dart' hide User;
import '../../../../response/login_response.dart';
import '../../lecturer_common_view_model.dart';
import 'attendance_lecturer_view_model.dart';

class AttendanceDetail extends StatefulWidget {
  final batch;
  final date;
  final absent_student;
  final present_student;
  final module_slug;
  final id;
  final attendanceType;
  const AttendanceDetail(
      {Key? key,
      this.batch,
      this.id,
      this.date,
      this.module_slug,
      this.absent_student,
      this.present_student,
      required this.attendanceType})
      : super(key: key);

  @override
  _AttendanceDetailState createState() => _AttendanceDetailState();
}

class _AttendanceDetailState extends State<AttendanceDetail> {
  late Future<GetStudentByBatchResponse> student_response;
  bool _value = false;
  Icon cusIcon = Icon(Icons.search);
  late Widget cusSearchBar;
  final TextEditingController _searchController =
      TextEditingController();
  List<dynamic> _presentStudents = <dynamic>[];
  List<dynamic> _absentStudents = <dynamic>[];

  List<dynamic> _list = <dynamic>[];
  List<dynamic> _listForDisplay = <dynamic>[];

  List<bool> _isChecked = <bool>[];
  late LecturerCommonViewModel lecturerCommonViewModel;
  late AttendanceViewModel _provider;
  late User user;

  @override
  void initState() {
    // TODO: implement initState
    cusSearchBar = Text(
      widget.date,
      style: TextStyle(color: Colors.black),
    );

    lecturerCommonViewModel = Provider.of<LecturerCommonViewModel>(context, listen: false);
    _provider = Provider.of<AttendanceViewModel>(context, listen: false);
    _provider.checkAttendanceEditable(widget.id);

    getData();
    getUser();
    _listForDisplay.clear();
    _list.clear();
    super.initState();
  }

  getUser() async {
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }

  getData() async {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      try{
        String dateStr = widget.date;
        List<String> dateComponents = dateStr.split(" ");
        String monthName = dateComponents[0];
        int day = int.parse(dateComponents[1]);
        int year = int.parse(dateComponents[2]);

        DateFormat format = DateFormat("MMMM");
        DateTime dateMonth = format.parse(monthName);
        int monthNumber = dateMonth.month;

        DateTime date = DateTime(year, monthNumber, day, 15);

        final request = jsonEncode({
          "batch": widget.batch,
          "classType": widget.attendanceType,
          "date": date.toIso8601String(),
          "moduleSlug": widget.module_slug,
        });
        _provider.fetchStudentLeave(request);

      }catch(e){
        print("ERROR:::$e");
      }

      _provider.fetchStudentOnlyForAttendance(widget.batch).then((_) {
        dynamic data22 = {
          "lecturerEmail": user.email.toString(),
          "moduleSlug": widget.module_slug.toString(),
        };
        lecturerCommonViewModel.fetchModuleDetails(data22).then((_) {
          if (lecturerCommonViewModel.modules["isOptional"]) {
            for (int i = 0; i < _provider.studentOnlyForAttendanceList.length; i++) {
              if(!lecturerCommonViewModel.modules["blockedUsers"].contains(_provider.studentOnlyForAttendanceList[i]["username"]) && !_provider.studentOnlyForAttendanceList[i]["blockedModules"].contains(widget.module_slug) ){
                if (lecturerCommonViewModel.modules["optionalStudent"].contains(_provider.studentOnlyForAttendanceList[i]["username"])) {
                  setState(() {
                    _list.add(_provider.studentOnlyForAttendanceList[i]);
                    _listForDisplay = _list;
                  });
                }
              }

            }
          } else {
            for (int i = 0; i < _provider.studentOnlyForAttendanceList.length; i++) {
              if(!lecturerCommonViewModel.modules["blockedUsers"].contains(_provider.studentOnlyForAttendanceList[i]["username"]) && !_provider.studentOnlyForAttendanceList[i]["blockedModules"].contains(widget.module_slug)){
                setState(() {
                  _list.add(_provider.studentOnlyForAttendanceList[i]);
                  _listForDisplay = _list;
                });
              }
            }
          }
          _presentStudents.addAll(widget.present_student);
          _absentStudents.addAll(widget.absent_student);
        });
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
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
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            hintText: "Search by name..."),
                        onChanged: (text) {
                          setState(() {
                            _listForDisplay = _list.where((list) {
                              var name = list['firstname'] +
                                  ' ' +
                                  list['lastname'];
                              var itemName = name.toLowerCase();
                              return itemName.contains(text);
                            }).toList();
                          });
                        },
                      );
                    } else {
                      this.cusIcon = Icon(Icons.search);
                      this.cusSearchBar = Text(
                        widget.date,
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
        body: Consumer3<ModuleAttendanceLecturer,
                LecturerCommonViewModel, AttendanceViewModel>(
            builder: (context, attendance, lecturer, snapShot, child) {
          return isLoading(lecturer.modulesApiResponse) || isLoading(snapShot.studentLeaveApiResponse)
              ? const Center(
                  child: SpinKitDualRing(
                    color: kPrimaryColor,
                  ),
                )
              : _listForDisplay.length > 0
                  ? Column(
                      children: [
                        isLoading(snapShot.attendanceEditableApiResponse) ? const SizedBox() :
                       snapShot.editableAttendance.canEdit == null || snapShot.editableAttendance.canEdit == true ? Container() :
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: const Color(0xfffff5e9)),
                              child: const Text(
                                "You can no longer edit this attendance. The editable time frame for this attendance has passed. Please contact administrative if you still wish to update the attendance.",
                                style: TextStyle(color: Color(0xffff9b20)),
                              )),
                        ),
                        const SizedBox(height: 20,),
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
                                padding: const EdgeInsets.only(
                                    right: 25.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green),
                                    ),
                                    onPressed: () async {

                                      final request =
                                          StudentAttendanceRequest(
                                              batch: widget.batch,
                                              absentStudents:
                                                  _absentStudents,
                                              moduleSlug:
                                                  widget.module_slug,
                                              presentStudents:
                                                  _presentStudents,
                                              attendanceType: widget
                                                  .attendanceType);

                                      try {
                                        final response =
                                            await PostAttendanceService()
                                                .changeAttendance(
                                                    request,
                                                    widget.id);
                                        if (response.success ==
                                            true) {
                                          Provider.of<ModuleAttendanceLecturer>(
                                                  context,
                                                  listen: false)
                                              .fetchCheckAttendance(
                                                  widget.module_slug,
                                                  widget.batch);

                                          Provider.of<ModuleAttendanceLecturer>(
                                                  context,
                                                  listen: false)
                                              .fetchStudentAttendance(
                                                  widget.module_slug,
                                                  widget.batch);

                                          snackThis(
                                            context: context,
                                            content: Text(
                                                "${response.message}"),
                                            color: Colors.green,
                                          );
                                          Navigator.of(context).pop();
                                        } else {
                                          snackThis(
                                            context: context,
                                            content: Text(
                                                "${response.message}"),
                                            color: Colors.red,
                                          );
                                        }
                                      } catch (e) {
                                        Fluttertoast.showToast(
                                            msg: e.toString());
                                      }
                                    },
                                    child: const Text("Save")),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return _listItem(index, snapShot);
                              },
                              itemCount: _listForDisplay.length,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10.0),
                        child: Text(
                          "No student available",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    );
        }));
  }

  _listItem(index, AttendanceViewModel value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              trailing: Builder(builder: (context) {
                return Checkbox(
                  value: _presentStudents
                      .contains(_listForDisplay[index]['username']),
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        _presentStudents
                            .add(_listForDisplay[index]['username']);
                        _absentStudents.removeWhere((element) =>
                            element ==
                            _listForDisplay[index]['username']);
                      } else {
                        _absentStudents
                            .add(_listForDisplay[index]['username']);
                        _presentStudents.remove(
                            _listForDisplay[index]['username']);
                        // selecteditems!.remove(items);
                      }
                    });
                  },
                );
              }),
              subtitle: Text(_listForDisplay[index]['username']),
              leading: Text((index + 1).toString()),
              title: Row(
                children: [
                  Text(_listForDisplay[index]['firstname'] +
                      ' ' +
                      _listForDisplay[index]['lastname']),
                  const SizedBox(width: 5,),
                  Builder(builder: (context) {
                    List<Leaf>? studentLeaveObj = [];
                    try {
                      if (value.studentLeave.isNotEmpty) {
                        var studentLeaveIndex = value.studentLeave.indexWhere(
                                (element) =>
                            element.username ==
                                _listForDisplay[index]["username"]);
                        if (studentLeaveIndex != -1) {
                          studentLeaveObj =
                              value.studentLeave[studentLeaveIndex].leaves;
                        }
                      }
                    } catch (e) {
                      print(e);
                    }
                    return studentLeaveObj != null &&
                        studentLeaveObj.isNotEmpty
                        ? InkWell(
                        onTap: () => showStudentLeaveAlertDialog(
                            context,
                            studentLeaveObj,
                            _listForDisplay[index]["username"]),
                        child: const Icon(
                          Icons.person_remove_alt_1_outlined,
                          color: Color(0XFFff9b20),
                        ))
                        : const SizedBox();
                  })
                ],
              ),

            )),
      ],
    );
  }
  showStudentLeaveAlertDialog(BuildContext context, List<Leaf>? studentLeaveObj,
      String username) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 10),
            child: StatefulBuilder(builder: (context, StateSetter setState) {
              return studentLeaveObj != null ?
              Container(
                height: studentLeaveObj.length > 5 ? 580 : 500,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            username.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: studentLeaveObj.length > 5 ? 430 : 350,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: studentLeaveObj.length,
                                  itemBuilder: (context, index) {
                                    return Column(
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
                                                                studentLeaveObj[
                                                                index]
                                                                    .leaveTitle
                                                                    .toString(),
                                                                style:
                                                                const TextStyle(
                                                                  fontSize: 17,
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
                                                                    .format(studentLeaveObj[
                                                                index]
                                                                    .startDate!)),
                                                                Text(" to "),
                                                                Text(DateFormat
                                                                    .yMMMd()
                                                                    .format(studentLeaveObj[
                                                                index]
                                                                    .endDate!)),
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
                                                                    color: studentLeaveObj[index].status ==
                                                                        "Pending"
                                                                        ? Colors
                                                                        .green
                                                                        : Colors
                                                                        .blueAccent),
                                                                child: Center(
                                                                    child: Text(
                                                                      studentLeaveObj[
                                                                      index]
                                                                          .status
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
                                                  SizedBox(height: 3,),
                                                  studentLeaveObj[index]
                                                      .allDay ==
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
                                                                studentLeaveObj[
                                                                index]
                                                                    .routines!
                                                                    .length,
                                                                    (innerIndex) =>
                                                                    Text(
                                                                        "${studentLeaveObj[index].routines![innerIndex]["title"]} (${studentLeaveObj[index].routines![innerIndex]["classType"]}) | ${DateFormat.yMMMd().format(DateTime.parse(studentLeaveObj[index].routines![innerIndex]["date"]))}"))
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(height: 3,),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      const Text("Request : "),
                                                      Expanded(
                                                        child: ReadMoreText(
                                                          studentLeaveObj[index]
                                                              .content
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                0.6),
                                                          ),
                                                          trimLines: 2,
                                                          trimMode:
                                                          TrimMode.Line,
                                                          trimCollapsedText:
                                                          ' Read more',
                                                          trimExpandedText:
                                                          ' Less',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      const Text("Request At : "),
                                                      Text(DateFormat
                                                          .yMMMd()
                                                          .format(studentLeaveObj[
                                                      index]
                                                          .createdAt!)),
                                                    ],
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
                                    );
                                  }))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ) : SizedBox();
            }),
          );
        });
  }
}
