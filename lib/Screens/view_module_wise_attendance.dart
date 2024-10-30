import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/attendance/all_attendance_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/attendance/attendance_detail.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/attendance/attendance_lecturer_view_model.dart';
import 'package:schoolworkspro_app/attendance_view_model.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../response/login_response.dart';

class ViewModuleAttendance extends StatefulWidget {
  List<dynamic> modules;
  ViewModuleAttendance({Key? key, required this.modules})
      : super(key: key);

  @override
  _ViewModuleAttendanceState createState() =>
      _ViewModuleAttendanceState();
}

class _ViewModuleAttendanceState extends State<ViewModuleAttendance> {
  String? _myclass;
  String? selected_module;
  List<Color> _colors = <Color>[];

  late CommonViewModel commonViewModel;
  late AttendanceViewModel _provider;

  Icon cusIcon = Icon(Icons.search);
  late Widget cusSearchBar;
  User? user;

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
      _provider =
          Provider.of<AttendanceViewModel>(context, listen: false);
      commonViewModel =
          Provider.of<CommonViewModel>(context, listen: false);

      _provider.fetchclass();
    });

    super.initState();
  }

  getData() async {
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer3<AttendanceViewModel,
              CommonViewModel, ModuleAttendanceLecturer>(
          builder: (context, value, common, mcl, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              width: double.infinity,
              child: ListView(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                children: [
                  widget.modules.isEmpty
                      ? const Text("No module assigned")
                      :
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownSearch<String>(
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
                        hintText: 'Select subject',
                      ),
                      showSearchBox: true,
                      maxHeight: MediaQuery.of(context).size.height / 2,
                      items: widget.modules.map<String>((pt) {
                        return user?.institution != null ? user?.institution == "softwarica" || user?.institution == "sunway" ? pt['moduleTitle'] : pt['alias'] ?? pt['moduleTitle'] : pt['moduleTitle'];
                      }).toList(),

                      mode: Mode.BOTTOM_SHEET,

                      onChanged: (newVal) {
                        setState(() {
                          var selectedModule = widget.modules.firstWhere((module) => module['moduleTitle'] == newVal);
                           selected_module = selectedModule["moduleSlug"];

                          common
                              .fetchBatcheOneTimeAttendanceCheck(
                              selected_module.toString());

                          _myclass = null;
                        });
                      },
                    ),
                  ),
                  selected_module == null
                      ? SizedBox()
                      : isLoading(value.classApiResponse)
                          ? VerticalLoader()
                          : common.oneTimeBatch.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "No batch/section found",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 15),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonFormField(
                                    isExpanded: true,
                                    decoration: const InputDecoration(
                                      enabledBorder:
                                          OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors
                                                      .black38)),
                                      focusedBorder:
                                          OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors
                                                      .black38)),
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      hintText:
                                          'Select batch/section',
                                    ),
                                    icon: const Icon(Icons
                                        .arrow_drop_down_outlined),
                                    items: common.oneTimeBatch
                                        .map((item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          item,
                                          overflow:
                                              TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (newVal) async {
                                      setState(() {
                                        _myclass = newVal as String?;
                                        mcl.fetchStudentAttendance(
                                            selected_module
                                                .toString(),
                                            _myclass.toString());
                                      });
                                    },
                                    value: _myclass,
                                  ),
                                ),
                  const SizedBox(
                    height: 10,
                  ),
                  selected_module == null
                      ? SizedBox()
                      : _myclass == null
                          ? SizedBox()
                              : isLoading(mcl
                                          .getAttendacenApiResponse)
                                  ? VerticalLoader()
                                  : mcl.getStudentAttendance.isEmpty
                                      ? Image.asset(
                                          'assets/images/no_content.PNG')
                                      : ListView.builder(
                                          physics:
                                              const ScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: mcl
                                              .getStudentAttendance
                                              .length,
                                          itemBuilder:
                                              (context, index) {
                                            DateTime start =
                                                DateTime.parse(mcl
                                                    .getStudentAttendance[
                                                        index]['date']
                                                    .split('T')[0]);
                                            start = start.add(
                                                const Duration(
                                                    hours: 5,
                                                    minutes: 45));
                                            var formattedTime =
                                                DateFormat(
                                                        'MMMM d yyyy')
                                                    .format(start);

                                            return Row(
                                                children: [
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
                                                      style:
                                                          const TextStyle(
                                                              fontSize:
                                                                  12),
                                                    ),
                                                    progressColor:
                                                        Colors.green,
                                                    animationDuration:
                                                        100,
                                                    animateFromLastPercent:
                                                        true,
                                                    arcType:
                                                        ArcType.FULL,
                                                    arcBackgroundColor:
                                                        Colors
                                                            .black12,
                                                    backgroundColor:
                                                        Colors.white,
                                                    animation: true,
                                                    circularStrokeCap:
                                                        CircularStrokeCap
                                                            .butt,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 6,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets
                                                          .all(8.0),
                                                  child: Column(
                                                    children: [
                                                      const Text(
                                                          "Attendance of: "),
                                                      Text(
                                                          formattedTime),
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal : 6),
                                                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                                                          child: Text(mcl.getStudentAttendance[index]["attendanceType"]))
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
                                                          builder:
                                                              (context) =>
                                                                  AttendanceDetail(
                                                            id: mcl.getStudentAttendance[
                                                                    index]
                                                                [
                                                                '_id'],
                                                            absent_student:
                                                                mcl.getStudentAttendance[index]
                                                                    [
                                                                    'absent_students'],
                                                            present_student:
                                                                mcl.getStudentAttendance[index]
                                                                    [
                                                                    'present_students'],
                                                            batch: mcl
                                                                    .getStudentAttendance[index]
                                                                [
                                                                'batch'],
                                                            module_slug:
                                                                selected_module
                                                                    .toString(),
                                                            date:
                                                                formattedTime,
                                                                    attendanceType: mcl.getStudentAttendance[index]["attendanceType"],
                                                          ),
                                                        ));
                                                  },
                                                  child:
                                                      const Padding(
                                                    padding:
                                                        EdgeInsets
                                                            .all(3.0),
                                                    child: Icon(
                                                      Icons
                                                          .edit_rounded,
                                                      color:
                                                          Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]);
                                          },
                                        )
                ],
              )),
        );
      }),
    );
  }
}
