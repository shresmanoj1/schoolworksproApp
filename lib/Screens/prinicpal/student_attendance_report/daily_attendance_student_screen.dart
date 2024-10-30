import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/principal_common_view_model.dart';
import 'package:schoolworkspro_app/extension/sizebox_ex.dart';

import '../../../components/shimmer.dart';
import '../../../config/api_response_config.dart';
import '../../request/DateRequest.dart';

class DailyAttendanceStudentScreen extends StatefulWidget {
  const DailyAttendanceStudentScreen({Key? key}) : super(key: key);

  @override
  State<DailyAttendanceStudentScreen> createState() =>
      _DailyAttendanceStudentScreenState();
}

class _DailyAttendanceStudentScreenState
    extends State<DailyAttendanceStudentScreen> {
  String? mySelection;
  String? selected_batch;
  String? selectedStatus = "Present";
  bool show = false;
  late PrinicpalCommonViewModel _provider;
  Widget cusSearchBar = const Text(
    'Student Attendance',
    style: TextStyle(color: Colors.black),
  );
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<PrinicpalCommonViewModel>(context, listen: false);
    });
    super.initState();
  }

  getData(PrinicpalCommonViewModel VM) async {
    final date = DateRequest(date: DateTime.now());
    VM.fetchAbsentStudentDailyAttendance(
        date.toString(), selected_batch ?? "", mySelection ?? "", "");
    // batch, course, module
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PrinicpalCommonViewModel>(builder: (context, value, child) {
      return Scaffold(
          body: RefreshIndicator(
        onRefresh: () => getData(value),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          children: [
            DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                hintText: 'Select a course',
              ),
              icon: const Icon(Icons.arrow_drop_down_outlined),
              items: value.courses.map((pt) {
                return DropdownMenuItem(
                  value: pt.courseSlug,
                  child: Text(
                    pt.courseName.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  mySelection = newVal as String?;
                  selected_batch = null;
                  show = true;
                  _provider.fetchCourseBatch(mySelection.toString());
                  final date = DateRequest(date: DateTime.now());
                  _provider.fetchAbsentStudentDailyAttendance(date.toString(),
                      selected_batch ?? "", mySelection ?? "", "");
                });
              },
              value: mySelection,
            ),
            show == false
                ? const SizedBox()
                : isLoading(value.courseBatchApiResponse)
                    ? const CustomShimmer.rectangular(
                        height: 50.0,
                        width: double.infinity,
                      )
                    : value.courseBatch.batches == null ||
                            value.courseBatch.batches!.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(Icons.error,
                                        color: Colors.red, size: 14),
                                  ),
                                  TextSpan(
                                      text: "No batch assigned in this module",
                                      style: TextStyle(
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              DropdownButtonFormField(
                                hint: const Text('Select batch'),
                                value: selected_batch,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                ),
                                icon:
                                    const Icon(Icons.arrow_drop_down_outlined),
                                items: value.courseBatch.batches!.map((pt) {
                                  return DropdownMenuItem(
                                    value: pt["batch"],
                                    child: Text(
                                      pt["batch"],
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newVal) {
                                  setState(() {
                                    selected_batch = newVal as String?;

                                    final date =
                                        DateRequest(date: DateTime.now());
                                    _provider.fetchAbsentStudentDailyAttendance(
                                        date.toString(),
                                        selected_batch ?? "",
                                        mySelection ?? "",
                                        "");
                                    ;
                                  });
                                },
                              ),
                            ],
                          ),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                hintText: 'Select a Status',
              ),
              icon: const Icon(Icons.arrow_drop_down_outlined),
              items: ["Present", "Absent"].map((pt) {
                return DropdownMenuItem(
                  value: pt,
                  child: Text(
                    pt.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  setState(() {
                    selectedStatus = newVal as String?;
                  });
                  // show = true;
                });
              },
              value: selectedStatus,
            ),
            const SizedBox(
              height: 10,
            ),
            isLoading(value.absentStudentsReportApiResponse)
                ? const VerticalLoader()
                : isError(value.absentStudentsReportApiResponse)
                    ? const Center(child: Text("No Data"))
                    : (selectedStatus == null || selectedStatus == 'Present') &&
                            value.allDailePresentStudentStudents != null &&
                            value.allDailePresentStudentStudents.isNotEmpty
                        ? Column(
                            children: [
                              ...List.generate(
                                  value.allDailePresentStudentStudents.length,
                                  (index) {
                                var data =
                                    value.allDailePresentStudentStudents[index];
                                return _bodyWidget(data, index);
                              }),
                              80.sH,
                            ],
                          )
                        : (selectedStatus == 'Absent') &&
                                value.allAbsentStudents != null &&
                                value.allAbsentStudents.isNotEmpty
                            ? Column(
                                children: [
                                  ...List.generate(
                                      value.allAbsentStudents.length, (index) {
                                    var data = value.allAbsentStudents[index];
                                    return _bodyWidget(data, index);
                                  }),
                                  80.sH,
                                ],
                              )
                            : const Center(child: Text("No Data")),
          ],
        ),
      ));
    });
  }

  Widget _bodyWidget(dynamic datas, int index) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
              minLeadingWidth: 0,
              leading: Text((index + 1).toString()),
              title: RichText(
                text: TextSpan(
                    text: 'Name: ',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                    children: [
                      TextSpan(
                        text: datas["full_name"].toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, color: Colors.black),
                      ),
                    ]),
              ),
              subtitle: Column(
                children: [
                  infoRowWidget(
                      label: "Module Title",
                      value: datas["moduleData"]["alias"] == null ||
                              datas["moduleData"]["alias"] == ""
                          ? datas["moduleData"]["moduleTitle"].toString()
                          : datas["moduleData"]["alias"].toString()),
                  infoRowWidget(
                      label: "Batch", value: datas["batch"].toString()),
                  infoRowWidget(
                      label: "Status", value: datas["status"].toString()),
                ],
              )),
        ],
      ),
    );
  }

  Widget infoRowWidget({required String label, required String value}) {
    return Row(
      children: [
        Text(
          "$label:  ",
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
