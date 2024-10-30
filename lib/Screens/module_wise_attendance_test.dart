import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/staff_attendance/singlephoto_view.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/attendance_view_model.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/request/lecturer/studentattendance_request.dart';
import 'package:schoolworkspro_app/response/lecturer/createnew_attendanceresponse.dart';
import 'package:schoolworkspro_app/response/lecturer/student_leave_response.dart'
    hide User;
import 'package:schoolworkspro_app/services/lecturer/post_attendanceservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/custom_loader.dart';
import '../response/login_response.dart';
import 'lecturer/my-modules/attendance/attendance_lecturer_view_model.dart';

class ModuleWiseAttendanceTest extends StatefulWidget {
  List<dynamic> modules;
  ModuleWiseAttendanceTest({Key? key, required this.modules}) : super(key: key);

  @override
  _ModuleWiseAttendanceTestState createState() =>
      _ModuleWiseAttendanceTestState();
}

class _ModuleWiseAttendanceTestState extends State<ModuleWiseAttendanceTest> {
  String? _myclass;
  String? selected_module;
  String? selected_attendance_type;
  List<Color> _colors = <Color>[];
  late CommonViewModel commonViewModel;
  List<dynamic> _list = <dynamic>[];
  List<dynamic> _listForDisplay = <dynamic>[];
  List<dynamic> _presentStudents = <dynamic>[];
  List<dynamic> _absentStudents = <dynamic>[];

  final present_controller = new TextEditingController();
  final absent_controller = new TextEditingController();
  final date_controller = new TextEditingController();
  final _searchController = new TextEditingController();
  Icon cusIcon = Icon(Icons.search);
  late Widget cusSearchBar;

  late LecturerCommonViewModel lecturerCommonViewModel;
  User? user;

  bool? optionalStudentCount;

  bool markAllValue = false;

  List<String> attendanceTypeList = [
    "Lab",
    "Theory",
    "Lecture",
    "Workshop",
    "Tutorial",
    "Extra"
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AttendanceViewModel>(context, listen: false).fetchclass();
      commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
      lecturerCommonViewModel =
          Provider.of<LecturerCommonViewModel>(context, listen: false);
    });
    setDate();
    getData();
    cusSearchBar = const Text(
      "Attendance",
      style: TextStyle(color: Colors.black),
    );
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
  }

  setDate() async {
    DateTime now = DateTime.parse(DateTime.now().toString());

    var formattedTime = DateFormat('yyyy/MM/dd, EEEE').format(now);

    setState(() {
      date_controller.text = formattedTime.toString();
    });
  }

  bool isLoadingButton = false;

  @override
  Widget build(BuildContext context) {
    if (isLoadingButton == true ) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: cusSearchBar,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
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
                            var name =
                                list['firstname'] + ' ' + list['lastname'];
                            var itemName = name.toLowerCase();
                            return itemName.contains(text);
                          }).toList();
                        });
                      },
                    );
                  } else {
                    this.cusIcon = Icon(Icons.search);
                    _listForDisplay = _list;
                    _searchController.clear();
                    this.cusSearchBar = const Text(
                      "Attendance",
                      style: TextStyle(color: Colors.black),
                    );
                  }
                });
              },
              icon: cusIcon)
        ],
      ),
      body: Consumer4<AttendanceViewModel, CommonViewModel,
              ModuleAttendanceLecturer, LecturerCommonViewModel>(
          builder: (context, value, common, module, lecturer, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              width: double.infinity,
              child: ListView(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38)),
                        border: OutlineInputBorder(),
                        filled: true,
                        hintText: 'Select subject',
                      ),
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      items: widget.modules.map((item) {
                        return DropdownMenuItem(
                          value: item['moduleSlug'],
                          child: Text(
                            user?.institution != null
                                ? user?.institution == "softwarica" ||
                                        user?.institution == "sunway"
                                    ? item['moduleTitle']
                                    : item['alias'] ?? item['moduleTitle']
                                : item['moduleTitle'],
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (newVal) async {
                        setState(() {
                          selected_module = newVal as String?;

                          common.fetchBatcheOneTimeAttendanceCheck(
                              selected_module.toString());

                          _myclass = null;

                          _listForDisplay.clear();
                          _presentStudents.clear();
                          _absentStudents.clear();
                          _list.clear();
                        });
                      },
                      value: selected_module,
                    ),
                  ),
                  selected_module == null
                      ? SizedBox()
                      : isLoading(value.classApiResponse)
                          ? const VerticalLoader()
                          : common.oneTimeBatch.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "No batch found",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 15),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonFormField(
                                    isExpanded: true,
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black38)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black38)),
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      hintText: 'Select batch/section',
                                    ),
                                    icon: const Icon(
                                        Icons.arrow_drop_down_outlined),
                                    items: common.oneTimeBatch.map((item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          item,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (newVal) async {
                                      setState(() {
                                        _myclass = newVal as String?;

                                        value.fetchClassType(
                                            selected_module, _myclass);

                                        module.fetchStudentAttendance(
                                            selected_module,
                                            _myclass.toString());

                                        _list.clear();
                                        _listForDisplay.clear();
                                        _presentStudents.clear();
                                        _absentStudents.clear();

                                        value
                                            .fetchStudentOnlyForAttendance(
                                                _myclass.toString())
                                            .then((_) {
                                          dynamic data = {
                                            "lecturerEmail":
                                                user?.email.toString(),
                                            "moduleSlug":
                                                selected_module.toString(),
                                          };
                                          lecturer
                                              .fetchModuleDetails(data)
                                              .then((_) {
                                            DateTime date = DateTime.now();

                                            if (lecturer
                                                .modules["isOptional"]) {
                                              optionalStudentCount = lecturer
                                                  .modules["isOptional"];
                                              for (int i = 0;
                                                  i <
                                                      value
                                                          .studentOnlyForAttendanceList
                                                          .length;
                                                  i++) {
                                                if (!lecturer
                                                        .modules["blockedUsers"]
                                                        .contains(value
                                                                .studentOnlyForAttendanceList[
                                                            i]["username"]) &&
                                                    !value
                                                        .studentOnlyForAttendanceList[
                                                            i]["blockedModules"]
                                                        .contains(
                                                            selected_module)) {
                                                  if (lecturer.modules[
                                                          "optionalStudent"]
                                                      .contains(value
                                                              .studentOnlyForAttendanceList[
                                                          i]['username'])) {
                                                    _presentStudents.add(value
                                                            .studentOnlyForAttendanceList[
                                                        i]['username']);
                                                    _list.add(value
                                                        .studentOnlyForAttendanceList[i]);
                                                    var convertToList = _list.toSet();
                                                    _listForDisplay = convertToList.toList();
                                                    // _listForDisplay = _list;
                                                    present_controller.text =
                                                        "Present: ${_presentStudents.length.toString()}";
                                                    absent_controller.text =
                                                        "Absent: ${_absentStudents.length.toString()}";
                                                  }
                                                }
                                              }
                                            }
                                            else {
                                              for (int i = 0;
                                                  i <
                                                      value
                                                          .studentOnlyForAttendanceList
                                                          .length;
                                                  i++) {
                                                if (!value
                                                        .studentOnlyForAttendanceList[
                                                            i]["blockedModules"]
                                                        .contains(
                                                            selected_module) &&
                                                    !lecturer
                                                        .modules["blockedUsers"]
                                                        .contains(value
                                                                .studentOnlyForAttendanceList[
                                                            i]["username"])) {
                                                  _list.add(value
                                                      .studentOnlyForAttendanceList[i]);
                                                  var convertToList = _list.toSet();
                                                  _listForDisplay = convertToList.toList();
                                                  // _listForDisplay = _list;
                                                  _absentStudents.add(value
                                                          .studentOnlyForAttendanceList[
                                                      i]['username']);

                                                  present_controller.text =
                                                      "Present: ${_presentStudents.length.toString()}";
                                                  absent_controller.text =
                                                      "Absent: ${_absentStudents.length.toString()}";
                                                }
                                              }
                                            }
                                          });
                                        });
                                      });
                                    },
                                    value: _myclass,
                                  ),
                                ),
                  _myclass == null
                      ? const SizedBox()
                      : isLoading(value.classTypeApiResponse)
                          ? const CustomShimmer.rectangular(
                              height: 20.0,
                              width: double.infinity,
                            )
                          : value.classType.classTypes == null ||
                                  value.classType.classTypes!.isEmpty
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonFormField(
                                    isExpanded: true,
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black38)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black38)),
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      hintText: 'Type',
                                    ),
                                    icon: const Icon(
                                        Icons.arrow_drop_down_outlined),
                                    items:
                                        value.classType.classTypes!.map((item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          item,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (newVal) async {
                                      setState(() {
                                        selected_attendance_type =
                                            newVal as String?;

                                        value.checkAttendance(
                                            selected_module,
                                            _myclass.toString(),
                                            selected_attendance_type
                                                .toString());

                                        module.fetchStudentAttendance(
                                            selected_module,
                                            _myclass.toString());

                                        _list.clear();
                                        _listForDisplay.clear();
                                        _presentStudents.clear();
                                        _absentStudents.clear();

                                        value
                                            .fetchStudentOnlyForAttendance(
                                                _myclass.toString())
                                            .then((_) {
                                          Map<String, dynamic> scannedRequest =
                                              {
                                            "attendanceType":
                                                selected_attendance_type
                                                    .toString(),
                                            "batch": _myclass.toString(),
                                            "moduleSlug":
                                                selected_module.toString(),
                                          };
                                          value
                                              .fetchScannedAttendance(
                                                  scannedRequest)
                                              .then((_) {
                                            dynamic data = {
                                              "lecturerEmail":
                                                  user?.email.toString(),
                                              "moduleSlug":
                                                  selected_module.toString(),
                                            };
                                            lecturer
                                                .fetchModuleDetails(data)
                                                .then((_) {
                                              DateTime date = DateTime.now();
                                              final request = jsonEncode({
                                                "batch": _myclass,
                                                "classType":
                                                    selected_attendance_type,
                                                "date": date.toIso8601String(),
                                                "moduleSlug": selected_module,
                                              });
                                              value.fetchStudentLeave(request);
                                              var studentLeaveObj;
                                              if (lecturer
                                                  .modules["isOptional"]) {
                                                optionalStudentCount = lecturer
                                                    .modules["isOptional"];
                                                for (int i = 0;
                                                    i <
                                                        value
                                                            .studentOnlyForAttendanceList
                                                            .length;
                                                    i++) {
                                                  if (!lecturer.modules[
                                                              "blockedUsers"]
                                                          .contains(value
                                                                  .studentOnlyForAttendanceList[
                                                              i]["username"]) &&
                                                      !value
                                                          .studentOnlyForAttendanceList[
                                                              i]
                                                              ["blockedModules"]
                                                          .contains(
                                                              selected_module)) {
                                                    if (lecturer.modules[
                                                            "optionalStudent"]
                                                        .contains(value
                                                                .studentOnlyForAttendanceList[
                                                            i]['username'])) {
                                                      _list.add(value
                                                          .studentOnlyForAttendanceList[i]);
                                                      _listForDisplay = _list;
                                                      _absentStudents.add(value
                                                              .studentOnlyForAttendanceList[
                                                          i]['username']);

                                                      //scanned attendance
                                                      if (value.scannedAttendanceList !=
                                                              null &&
                                                          value
                                                              .scannedAttendanceList
                                                              .isNotEmpty) {
                                                        if (value
                                                            .scannedAttendanceList
                                                            .contains(value
                                                                    .studentOnlyForAttendanceList[i]
                                                                ["username"])) {
                                                          _presentStudents.add(
                                                              value.studentOnlyForAttendanceList[
                                                                      i]
                                                                  ['username']);
                                                          // Remove the student from _absentStudents if present
                                                          for (int i = 0;
                                                              i <
                                                                  _absentStudents
                                                                      .length;
                                                              i++) {
                                                            if (_presentStudents
                                                                .contains(
                                                                    _absentStudents[
                                                                        i])) {
                                                              _absentStudents
                                                                  .removeAt(i);
                                                            }
                                                          }
                                                        }
                                                      }
                                                      present_controller.text =
                                                          "Present: ${_presentStudents.length.toString()}";
                                                      absent_controller.text =
                                                          "Absent: ${_absentStudents.length.toString()}";
                                                    }
                                                  }
                                                }
                                              } else {
                                                for (int i = 0;
                                                    i <
                                                        value
                                                            .studentOnlyForAttendanceList
                                                            .length;
                                                    i++) {
                                                  if (!lecturer.modules[
                                                              "blockedUsers"]
                                                          .contains(value
                                                                  .studentOnlyForAttendanceList[
                                                              i]["username"]) &&
                                                      !value
                                                          .studentOnlyForAttendanceList[
                                                              i]
                                                              ["blockedModules"]
                                                          .contains(
                                                              selected_module)) {
                                                    _list.add(value
                                                        .studentOnlyForAttendanceList[i]);
                                                    _listForDisplay = _list;
                                                    _absentStudents.add(value
                                                            .studentOnlyForAttendanceList[
                                                        i]['username']);

                                                    //scanned attendance
                                                    if (value.scannedAttendanceList !=
                                                            null &&
                                                        value
                                                            .scannedAttendanceList
                                                            .isNotEmpty) {
                                                      if (value
                                                          .scannedAttendanceList
                                                          .contains(value
                                                                  .studentOnlyForAttendanceList[
                                                              i]["username"])) {
                                                        setState(() {
                                                          _presentStudents.add(
                                                              value.studentOnlyForAttendanceList[
                                                                      i]
                                                                  ['username']);
                                                          // Remove the student from _absentStudents if present
                                                          for (int i = 0;
                                                              i <
                                                                  _absentStudents
                                                                      .length;
                                                              i++) {
                                                            if (_presentStudents
                                                                .contains(
                                                                    _absentStudents[
                                                                        i])) {
                                                              _absentStudents
                                                                  .removeAt(i);
                                                            }
                                                          }
                                                        });
                                                      }
                                                    }

                                                    present_controller.text =
                                                        "Present: ${_presentStudents.length.toString()}";
                                                    absent_controller.text =
                                                        "Absent: ${_absentStudents.length.toString()}";
                                                  }
                                                }
                                              }
                                            });
                                          });
                                        });
                                      });
                                    },
                                    value: selected_attendance_type,
                                  ),
                                ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      enabled: false,
                      controller: date_controller,
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                        hintText: "Today's Date",
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            enabled: false,
                            controller: present_controller,
                            keyboardType: TextInputType.datetime,
                            decoration: const InputDecoration(
                              hintText: "Present: 0",
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black38)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black38)),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            enabled: false,
                            controller: absent_controller,
                            keyboardType: TextInputType.datetime,
                            decoration: const InputDecoration(
                              hintText: "Absent: 0",
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black38)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black38)),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _myclass == null
                      ? const SizedBox()
                      : isLoading(value.classTypeApiResponse)
                          ? const VerticalLoader()
                          : value.classType.classTypes == null ||
                                  value.classType.classTypes!.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: Text(
                                      "Not found in today's routine",
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                )
                              : selected_attendance_type == null
                                  ? const SizedBox()
                                  : isLoading(value.checkApiResponse) ||
                                          isLoading(
                                              value.studentLeaveApiResponse)
                                      ? const VerticalLoader()
                                      : value.Status == true
                                          ? const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                              child: Text(
                                                "Today's attendance already taken",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            )
                                          : isLoading(value
                                                      .studentOnlyForAttendanceListApiResponse) &&
                                                  isLoading(value
                                                      .scannedAttendanceListApiResponse)
                                              ? const VerticalLoader()
                                              : value.studentOnlyForAttendanceList
                                                      .isEmpty
                                                  ? const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8.0,
                                                              vertical: 10.0),
                                                      child: Text(
                                                        "No student available",
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    )
                                                  : isLoading(lecturer
                                                          .modulesApiResponse)
                                                      ? const VerticalLoader()
                                                      : Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          20),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  const Text(
                                                                    'Mark All',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Transform
                                                                      .translate(
                                                                    offset:
                                                                        const Offset(
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        Checkbox(
                                                                      value:
                                                                          markAllValue,
                                                                      activeColor:
                                                                          Colors
                                                                              .green,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          if (value!) {
                                                                            for (int i = 0;
                                                                                i < _listForDisplay.length;
                                                                                i++) {
                                                                              setState(() {
                                                                                _absentStudents.clear();
                                                                                _presentStudents.add(_listForDisplay[i]['username']);
                                                                                markAllValue = true;
                                                                              });
                                                                            }
                                                                          } else {
                                                                            markAllValue =
                                                                                false;
                                                                            setState(() {
                                                                              _presentStudents.clear();
                                                                            });
                                                                          }
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            ListView.builder(
                                                              shrinkWrap: true,
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return _listItem(
                                                                    index,
                                                                    module
                                                                        .getStudentAttendance,
                                                                    value);
                                                              },
                                                              itemCount:
                                                                  _listForDisplay
                                                                      .length,
                                                            ),
                                                            _listForDisplay
                                                                        .length >
                                                                    0
                                                                ? ElevatedButton(
                                                                    onPressed:
                                                                        () async {
                                                                      try {
                                                                        final request = StudentAttendanceRequest(
                                                                            batch:
                                                                                _myclass,
                                                                            absentStudents:
                                                                                _absentStudents,
                                                                            moduleSlug: selected_module
                                                                                .toString(),
                                                                            presentStudents:
                                                                                _presentStudents,
                                                                            attendanceType:
                                                                                selected_attendance_type.toString());
                                                                        CreateNewAttendanceResponse
                                                                            response =
                                                                            await PostAttendanceService().addnewAttendance(
                                                                          request,
                                                                        );

                                                                        setState(
                                                                            () {
                                                                          isLoadingButton =
                                                                              true;
                                                                        });
                                                                        if (response.success ==
                                                                            true) {
                                                                          setState(
                                                                              () {
                                                                            isLoadingButton =
                                                                                false;
                                                                          });
                                                                          value.checkAttendance(
                                                                              selected_module.toString(),
                                                                              _myclass.toString(),
                                                                              selected_attendance_type.toString());
                                                                          snackThis(
                                                                            context:
                                                                                context,
                                                                            content:
                                                                                Text("${response.message}"),
                                                                            color:
                                                                                Colors.green,
                                                                          );
                                                                        } else {
                                                                          setState(
                                                                              () {
                                                                            isLoadingButton =
                                                                                false;
                                                                          });
                                                                          snackThis(
                                                                            context:
                                                                                context,
                                                                            content:
                                                                                Text("${response.message}"),
                                                                            color:
                                                                                Colors.green,
                                                                          );
                                                                        }
                                                                      } catch (e) {
                                                                        setState(
                                                                            () {
                                                                          isLoadingButton =
                                                                              false;
                                                                        });
                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                                e.toString());
                                                                      }
                                                                    },
                                                                    child: const Text(
                                                                        "Upload"),
                                                                  )
                                                                : const Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            8.0,
                                                                        vertical:
                                                                            10.0),
                                                                    child: Text(
                                                                      "No student available",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                  )
                                                          ],
                                                        )
                ],
              )),
        );
      }),
    );
  }

  _listItem(index, List getStudentAttendance, AttendanceViewModel value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: ListTile(
              leading: CircleAvatar(
                  radius: 25.0,
                  backgroundColor:
                      _colors.length > 0 ? _colors[index] : Colors.grey,
                  child: _listForDisplay[index]['userImage'] == null ||
                          _listForDisplay[index]['userImage'].isEmpty
                      ? Text(
                          _listForDisplay[index]['firstname']
                                  .toString()[0]
                                  .toUpperCase() +
                              "" +
                              _listForDisplay[index]['lastname']
                                  .toString()[0]
                                  .toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )
                      : ClipOval(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) {
                                        return SingleImageViewer(
                                          imageIndex: 0,
                                          imageList: _listForDisplay[index]
                                                  ['userImage']
                                              .toString(),
                                        );
                                      },
                                      fullscreenDialog: true));
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl:
                                    '$api_url2/uploads/users/${_listForDisplay[index]['userImage']}',
                                placeholder: (context, url) => Container(
                                    child: const Center(
                                        child: CupertinoActivityIndicator())),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        )),
              title: Builder(builder: (context) {
                var name = _listForDisplay[index]['firstname'] +
                    " " +
                    _listForDisplay[index]['lastname'];
                return RichText(
                  text: TextSpan(
                    text: 'Name: ',
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                        text: name.toString(),
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                );
              }),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'Student Id: ',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text: _listForDisplay[index]['username']
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Builder(builder: (context) {
                        List<Leaf>? studentLeaveObj = [];
                        try {
                          if (value.studentLeave.isNotEmpty) {
                            var studentLeaveIndex = value.studentLeave
                                .indexWhere((element) =>
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
                                child: Icon(
                                  Icons.person_remove_alt_1_outlined,
                                  color: const Color(0XFFff9b20),
                                ))
                            : const SizedBox();
                      })
                    ],
                  ),
                  Builder(builder: (context) {
                    int indexValue = getStudentAttendance.length < 5
                        ? getStudentAttendance.length
                        : 5;
                    List<dynamic> attendacenValue =
                        getStudentAttendance.sublist(0, indexValue);
                    List<Widget> outer = [];
                    for (int i = 0; i < attendacenValue.length; i++) {
                      if (attendacenValue[i]['present_students']
                          .contains(_listForDisplay[index]['username'])) {
                        outer.add(const Icon(
                          Icons.check,
                          color: Colors.green,
                        ));
                      } else {
                        outer.add(const Icon(
                          Icons.close,
                          color: Colors.red,
                        ));
                      }
                    }
                    return outer.isNotEmpty
                        ? Row(
                            children: outer.reversed.toList(),
                          )
                        : const Text("");
                  }),
                ],
              ),
              trailing: Builder(builder: (context) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    value.scannedAttendanceList
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
                          setState(() {
                            present_controller.text =
                                "Present : ${_presentStudents.length.toString()}";
                            absent_controller.text =
                                "Absent : ${_absentStudents.length.toString()}";
                          });
                        });
                      },
                    ),
                  ],
                );
              })),
        )
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
              return studentLeaveObj != null
                  ? Container(
                      height: studentLeaveObj.length > 5 ? 580 : 500,
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
                                    height:
                                        studentLeaveObj.length > 5 ? 430 : 350,
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
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
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
                                                                        fontSize:
                                                                            17,
                                                                        fontWeight:
                                                                            FontWeight.w600,
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
                                                                          .format(
                                                                              studentLeaveObj[index].startDate!)),
                                                                      Text(
                                                                          " to "),
                                                                      Text(DateFormat
                                                                              .yMMMd()
                                                                          .format(
                                                                              studentLeaveObj[index].endDate!)),
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
                                                                    onTap:
                                                                        () {},
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          24,
                                                                      width: 60,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              4),
                                                                          color: studentLeaveObj[index].status == "Pending"
                                                                              ? Colors.green
                                                                              : Colors.blueAccent),
                                                                      child: Center(
                                                                          child: Text(
                                                                        studentLeaveObj[index]
                                                                            .status
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )),
                                                                    )),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 3,
                                                        ),
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
                                                                  Text(
                                                                      "All Day")
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
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        ...List.generate(
                                                                            studentLeaveObj[index]
                                                                                .routines!
                                                                                .length,
                                                                            (innerIndex) =>
                                                                                Text("${studentLeaveObj[index].routines![innerIndex]["title"]} (${studentLeaveObj[index].routines![innerIndex]["classType"]}) | ${DateFormat.yMMMd().format(DateTime.parse(studentLeaveObj[index].routines![innerIndex]["date"]))}"))
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                        SizedBox(
                                                          height: 3,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                                "Request : "),
                                                            Expanded(
                                                              child:
                                                                  ReadMoreText(
                                                                studentLeaveObj[
                                                                        index]
                                                                    .content
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.6),
                                                                ),
                                                                trimLines: 2,
                                                                trimMode:
                                                                    TrimMode
                                                                        .Line,
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
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                                "Request At : "),
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
                    )
                  : SizedBox();
            }),
          );
        });
  }
}
