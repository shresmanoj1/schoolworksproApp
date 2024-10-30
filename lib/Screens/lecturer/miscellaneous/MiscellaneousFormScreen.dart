import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/miscellaneous/components/miscellaneous_multi_select.dart';
import 'package:schoolworkspro_app/Screens/lecturer/miscellaneous/components/single_std.dart';
import 'package:schoolworkspro_app/Screens/lecturer/miscellaneous/miscellaneous_view_model.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/miscellaneous_repo.dart';
import 'package:schoolworkspro_app/components/misc_edit_text_field.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import '../../../config/api_response_config.dart';
import '../../../constants/text_style.dart';
import '../../../helper/custom_loader.dart';
import '../../../routes/route_generator.dart';

class MiscellaneousFormScreen extends StatefulWidget {
  final batch;
  List<dynamic>? students;

  MiscellaneousFormScreen({Key? key, this.batch, this.students})
      : super(key: key);

  @override
  State<MiscellaneousFormScreen> createState() =>
      _MiscellaneousFormScreenState();
}

class _MiscellaneousFormScreenState extends State<MiscellaneousFormScreen> {
  String? selected_exam;
  String? selectedGrade;
  Map<String, TextEditingController> presentControllers = {};
  Map<String, TextEditingController> absentControllers = {};
  late MiscellaneousViewModel miscellaneousViewModel;

  Map<String, Map<String, String?>> studentDropdownValues = {};

  List<String?>? selectedVariable = [];

  final List<String> grades = ["A+", "A", "B+", "B", "C+", "C", "D+", "D", "E"];

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      miscellaneousViewModel =
          Provider.of<MiscellaneousViewModel>(context, listen: false);
      miscellaneousViewModel.fetchExamForBatch(widget.batch);
    });
    // studentDropdownValues = List<Map<String?, String?>>.generate(
    //     widget.students!.length, (index) => {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Miscellaneous Form"),
      ),
      body: Consumer<MiscellaneousViewModel>(builder: (context, value, child) {
        return isLoading(value.availableExamApiResponse) ? const Center(child: CupertinoActivityIndicator(),) : value.availableExams.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 15.0),
                child: Container(
                  width: double.infinity,
                  color: const Color(0xffffe9e9),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Exam not found",
                        style: p15.copyWith(color: red),
                        textAlign: TextAlign.center),
                  ),
                ),
              )
            : ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                children: [
                  Text(
                    "Select Exam",
                    style: p15,
                  ),
                  DropdownButtonFormField(
                    isExpanded: true,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        hintText: 'Select Exam',
                        hintStyle: p14.copyWith(color: grey_600)),
                    icon: const Icon(Icons.arrow_drop_down_outlined),
                    items: value.availableExams.map((pt) {
                      return DropdownMenuItem(
                        value: pt.examSlug,
                        child: Text(
                          pt.examTitle ?? "",
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (newVal) async {
                      setState(() {
                        selected_exam = newVal as String?;
                      });
                      customLoadStart();
                      await value.fetchVariable();
                      await value
                          .fetchSavedMiscData(selected_exam.toString())
                          .then((_) {
                        checkData(value.availableMiscData);
                      });

                      customLoadStop();
                    },
                    value: selected_exam,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: selected_exam == null ? false : true,
                    maintainState: true,
                    maintainAnimation: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Miscellaneous Information",
                          style: p15,
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text(
                                          "Choose Miscellaneous Information"),
                                      actions: [
                                        TextButton(onPressed: (){
                                          RouteGenerator.goBack();
                                        }, child: const Text("Close"))
                                      ],
                                      content: SingleChildScrollView(
                                        child: Wrap(
                                          children: value.availableVariable
                                              .map((e) => Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (selectedVariable!
                                                            .contains(e.key
                                                                .toString())) {
                                                          setState(() {
                                                            selectedVariable
                                                                ?.remove(e.key
                                                                    .toString());
                                                          });
                                                        } else {
                                                          setState(() {
                                                            selectedVariable
                                                                ?.add(e.key
                                                                    .toString());
                                                          });
                                                        }

                                                        this.setState(() {});
                                                      },
                                                      child: Chip(
                                                        backgroundColor:
                                                            selectedVariable!
                                                                    .contains(e
                                                                        .key
                                                                        .toString())
                                                                ? kPrimaryColor
                                                                : grey_200,
                                                        label: Text(
                                                          e.displayName
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: selectedVariable!
                                                                      .contains(e
                                                                          .key
                                                                          .toString())
                                                                  ? white
                                                                  : black),
                                                        ),
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(color: grey_100),
                            child: const ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: 0, vertical: -3.0),
                              title: Text(
                                "Select miscellaneous information",
                                style: TextStyle(fontSize: 15, color: grey_600),
                              ),
                              trailing: Icon(
                                Icons.arrow_drop_down,
                                color: grey_700,
                              ),
                            ),
                          ),
                        ),
                        if (selectedVariable != null)
                          Wrap(
                            children: selectedVariable!.map((e) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Chip(
                                  label: Text(e.toString()),
                                  deleteIcon: const Icon(Icons.cancel,
                                      color: Colors.white),
                                  onDeleted: () {
                                    setState(() {
                                      selectedVariable?.remove(e);
                                    });
                                  },
                                  backgroundColor: kPrimaryColor,
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                          ),

                      ],
                    ),
                  ),
                  selected_exam == null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Container(
                            color: const Color(0xffffe9e9),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "Please select an exam \nto enter miscellaneous data",
                                  style: p15.copyWith(color: red),
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: getListView(),
                        ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () async {
                        saveChanges();
                      },
                      child: Text(
                        "Save",
                        style: p14.copyWith(color: white),
                      )),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              );
      }),
    );
  }

  List<dynamic> getListElements() {
    var items = List<dynamic>.generate(
        widget.students!.length, (counter) => widget.students![counter]);
    return items;
  }

  Widget getListView() {
    var listItems = getListElements();
    var listview = ListView.builder(
      shrinkWrap: true,
      itemCount: listItems.length,
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) {
        String username = listItems[index]['username'];

        // Initialize controllers for each student if not already initialized
        if (!presentControllers.containsKey(username)) {
          presentControllers[username] = TextEditingController();
        }
        if (!absentControllers.containsKey(username)) {
          absentControllers[username] = TextEditingController();
        }

        // Ensure studentDropdownValues map is initialized for each student
        if (!studentDropdownValues.containsKey(username)) {
          studentDropdownValues[username] = {};
        }

        return Column(
          children: [
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${listItems[index]['firstname']} ${listItems[index]['lastname']}"),
                        Text(username),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(listItems[index]['course'] ?? ""),
                        Text(listItems[index]['batch'] ?? ""),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MiscEditTextField(
                          hintText: "Present Days",
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          controller: presentControllers[username]!,
                          hasBottomSpace: true,
                        ),
                        MiscEditTextField(
                          hintText: "Absent Days",
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          controller: absentControllers[username]!,
                          hasBottomSpace: true,
                        ),
                        if (selectedVariable != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var item in selectedVariable!)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: DropdownButtonFormField<String>(
                                    key: Key(username),
                                    decoration: InputDecoration(
                                      labelText: item!,
                                      labelStyle: p13.copyWith(color: grey_600),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: grey_600),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: grey_600),
                                      ),
                                    ),
                                    value: studentDropdownValues[username]?[item],
                                    onChanged: (newValue) {
                                      setState(() {
                                        studentDropdownValues[username]?[item] = newValue;
                                      });
                                    },
                                    items: grades.map((grade) {
                                      return DropdownMenuItem(
                                        value: grade,
                                        child: Text(grade),
                                      );
                                    }).toList(),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
    return listview;
  }



  void saveChanges() async {
    customLoadStart();
    try {
      List<Map<String, dynamic>> studentData = [];
      for (var student in widget.students!) {
        String username = student['username'];

        // Retrieve controllers using the username
        var presentDays = int.tryParse(presentControllers[username]?.text ?? '0') ?? 0;
        var absentDays = int.tryParse(absentControllers[username]?.text ?? '0') ?? 0;
        var additionalGrades = <String, String>{};
        var extraInfo = <String, dynamic>{
          'height': 0,
          'weight': 0,
          'presentDays': presentDays,
          'absentDays': absentDays,
        };

        // Retrieve additional grades using the username from studentDropdownValues
        if (studentDropdownValues.containsKey(username)) {
          for (var item in studentDropdownValues[username]!.keys) {
            additionalGrades[item] = studentDropdownValues[username]![item]!;
          }
        }

        // Merge additional grades into extraInfo as well
        extraInfo.addAll(additionalGrades);

        var data = {
          'username': username,
          'fullname': "${student['firstname']} ${student['lastname']}",
          'batch': student['batch'],
          'height': 0,
          'weight': 0,
          'presentDays': presentDays,
          'absentDays': absentDays,
          'extraInfo': extraInfo,
          '_extraInfo': additionalGrades,
          'examSlug': selected_exam,
        };

        studentData.add(data);
      }

      var payload = {
        'misc': studentData,
      };

      final res = await MiscellaneousRepo().saveResultMisc(payload);
      if (res.success == true) {
        customLoadStop();
        // RouteGenerator.goBack();
        Fluttertoast.showToast(msg: res.message.toString());
      } else {
        customLoadStop();
        Fluttertoast.showToast(msg: res.message.toString());
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      customLoadStop();
      // TODO
    }
    customLoadStop();
  }


  void checkData(List<dynamic> data) {
    List<String> tempSelectedVariable = [];
    for (int i = 0; i < data.length; i++) {
      String username = data[i]['username'];

      // Ensure studentDropdownValues map is initialized for each student
      if (!studentDropdownValues.containsKey(username)) {
        studentDropdownValues[username] = {};
      }

      // Update present and absent days using TextEditingController
      presentControllers[username]?.text = data[i]['extraInfo']?['presentDays'].toString() ?? '';
      absentControllers[username]?.text = data[i]['extraInfo']?['absentDays'].toString() ?? '';

      var extraInfo = data[i]["_extraInfo"];
      if (extraInfo != null) {
        var keys = extraInfo.keys.toList();
        tempSelectedVariable.addAll(keys);

        tempSelectedVariable = tempSelectedVariable.toSet().toList();
        for (var key in keys) {
          studentDropdownValues[username]?[key] = extraInfo[key];
        }
        setState(() {
          selectedVariable = tempSelectedVariable;
        });
      }
    }
    customLoadStop();
  }

}


