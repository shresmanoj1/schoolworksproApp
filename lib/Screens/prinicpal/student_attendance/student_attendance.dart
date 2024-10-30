import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/principal_common_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/principal/getallmodule_response.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../../../constants/colors.dart';
import '../../../response/principal/allattendanceprincipal_response.dart';
import '../../request/DateRequest.dart';

class PrincipalStudentAttendance extends StatefulWidget {
  const PrincipalStudentAttendance({Key? key}) : super(key: key);

  @override
  _PrincipalStudentAttendanceState createState() =>
      _PrincipalStudentAttendanceState();
}

class _PrincipalStudentAttendanceState
    extends State<PrincipalStudentAttendance> {
  String? mySelection;
  String? selected_batch;

  bool show = false;
  late PrinicpalCommonViewModel _provider;
  Widget cusSearchBar = const Text(
    'Student Attendance',
    style: TextStyle(color: Colors.black),
  );
  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<PrinicpalCommonViewModel>(context, listen: false);
      _provider.fetchAllModules();
      // _provider.fetchAllModules();
      _provider.fetchCourses();
    });

    super.initState();
  }

  TextEditingController _searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<PrinicpalCommonViewModel>(builder: (context, value, child) {
      return Scaffold(
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            children: [
              Container(
                color: Colors.orange.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        WidgetSpan(
                          child:
                              Icon(Icons.warning, color: Colors.red, size: 14),
                        ),
                        TextSpan(
                            text:
                                " Note: You must select a subject/module and a section/batch to view the attendance report.",
                            style: TextStyle(
                              color: Colors.black,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Modules/Subjects',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DropdownSearch<String>(
                dropdownSearchDecoration: const InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    hintText: 'Select module/subject',
                    contentPadding: EdgeInsets.zero),
                showSearchBox: true,
                maxHeight: MediaQuery.of(context).size.height / 1.2,
                items: value.modules.map((pt) {
                  return pt.moduleTitle.toString();
                }).toList(),
                mode: Mode.MENU,
                // selectedItem: mySelection,

                onChanged: (newVal) {
                  setState(() {
                    var selectedModule = value.modules
                        .firstWhere((module) => module.moduleTitle == newVal);
                    mySelection = selectedModule.moduleSlug;
                    log("SELECTION:::$mySelection");
                    selected_batch = null;
                    show = true;
                    _provider.fetchAssignedModules(mySelection.toString());
                    // print(_mySelection);
                  });
                },
              ),

              const SizedBox(
                height: 12,
              ),
              show == false
                  ? const SizedBox()
                  : value.assignedBatches.isEmpty
                      ? const Text("No batch assigned in this module")
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Batches/Sections',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DropdownButtonFormField(
                              hint: const Text('Select batch'),
                              value: selected_batch,
                              isExpanded: true,
                             decoration: const InputDecoration(
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                                hintText: 'Select batch',
                                filled: true,
                                fillColor: white,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),

                              ),
                              icon: const Icon(Icons.arrow_drop_down_outlined),
                              items: value.assignedBatches.map((pt) {
                                return DropdownMenuItem(
                                  value: pt,
                                  child: Text(
                                    pt,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                setState(() {
                                  // print(newVal);

                                  selected_batch = newVal as String?;
                                  Map<String, dynamic> request = {
                                    "moduleSlug": mySelection,
                                    "batch": selected_batch
                                  };
                                  _provider.fetchallattendance(request);
                                });
                              },
                            ),
                          ],
                        ),
              selected_batch == null
                  ? const SizedBox()
                  : isLoading(value.allAttendanceApiResponse)
                      ? const Center(
                          child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                color: kPrimaryColor,
                              )),
                        )
                      : Column(
                          children: [
                            ...List.generate(value.allAttendance.length,
                                (index) {
                              var datas = value.allAttendance[index];
                              return Container(
                                child: Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        title: RichText(
                                          text: TextSpan(
                                              text: 'Name: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                              children: [
                                                TextSpan(
                                                  text: datas.name.toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.black),
                                                ),
                                              ]),
                                        ),
                                        subtitle: datas.contact == null
                                            ? Text("contact: n/a")
                                            : RichText(
                                                text: TextSpan(
                                                    text: 'contact: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                    children: [
                                                      TextSpan(
                                                        text: datas.contact
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ]),
                                              ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: LinearPercentIndicator(
                                          // width: MediaQuery.of(context).size.width/2,
                                          lineHeight: 16.0,
                                          center: Builder(builder: (context) {
                                            var txt = datas.percentage
                                                .toString()
                                                .split(".")
                                                .first;
                                            return Text(
                                              txt + "%",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            );
                                          }),
                                          percent: datas.percentage! / 100,
                                          // header:Center(child: Text(progress['moduleTitle'],overflow: TextOverflow.ellipsis,)),
                                          backgroundColor: Colors.grey.shade100,
                                          progressColor: datas.percentage! >= 80
                                              ? Colors.green
                                              : datas.percentage! >= 50 &&
                                                      datas.percentage! <= 80
                                                  ? Colors.orange
                                                  : datas.percentage! < 50
                                                      ? Colors.red
                                                      : Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            SizedBox(height: 80)
                          ],
                        )
            ],
          ));
    });
  }
}
