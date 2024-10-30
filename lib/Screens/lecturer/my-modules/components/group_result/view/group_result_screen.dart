import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/group_result/group_result_view_model.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/group_result_repo.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import '../../../../../../config/api_response_config.dart';
import '../../../../../../constants/colors.dart';
import '../../../../../../helper/custom_loader.dart';
import '../../../../../../response/lecturer/group_result_mark_response.dart';
import '../../../../../prinicpal/principal_common_view_model.dart';
import '../../../../../widgets/snack_bar.dart';

class GroupResultScreen extends StatefulWidget {
  final String moduleSlug;
  const GroupResultScreen({Key? key, required this.moduleSlug})
      : super(key: key);

  @override
  State<GroupResultScreen> createState() => _GroupResultScreenState();
}

class _GroupResultScreenState extends State<GroupResultScreen> {
  late PrinicpalCommonViewModel _provider;
  late CommonViewModel _provider2;

  String? resultType;
  String? resultTypeSlug;
  String? batch;
  List<String> resultBatchArr = [];
  bool isMarksUpdate = false;
  bool isAllUpdateLoading = false;

  String? overallMarks;

  FocusNode _focuNode = FocusNode();

  List<List<List<TextEditingController>>> headingController = [];

  @override
  void initState() {
    _provider = Provider.of<PrinicpalCommonViewModel>(context, listen: false);
    _provider2 = Provider.of<CommonViewModel>(context, listen: false);
    super.initState();
  }

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    if (isloading == true || isAllUpdateLoading == true) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: const IconThemeData(color: white),
        // backgroundColor: Colors.white,
        title: const Text(
          "Internal Evaluation",
          style: TextStyle(color: white),
        ),
      ),
      body: Consumer3<GroupResultViewModel, PrinicpalCommonViewModel,
              CommonViewModel>(
          builder: (context, group, attendance, common, child) {
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 10),
          children: [
            const Text(
              'Select Result Type',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                hintText: 'Select Result Type',
              ),
              icon: const Icon(Icons.arrow_drop_down_outlined),
              items: group.groupResultType.allResultType?.map((pt) {
                return DropdownMenuItem(
                  value: pt.title,
                  child: Text(
                    pt.title.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  resultType = newVal.toString();
                  resultBatchArr.clear();
                  try {
                    if (group.groupResultType.allResultType != null) {
                      for (var i = 0;
                          i < group.groupResultType.allResultType!.length;
                          i++) {
                        if (group.groupResultType.allResultType![i].title ==
                            resultType) {
                          resultTypeSlug = group
                              .groupResultType.allResultType![i].resultSlug;
                          for (var j = 0;
                              j <
                                  group.groupResultType.allResultType![i].batch!
                                      .length;
                              j++) {
                            resultBatchArr.add(group
                                .groupResultType.allResultType![i].batch![j]);
                          }
                        }
                      }
                    }
                  } catch (e) {}
                });
              },
              value: resultType,
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Select Batch',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                hintText: 'Select Batch',
              ),
              icon: const Icon(Icons.arrow_drop_down_outlined),
              items: resultBatchArr.map((pt) {
                return DropdownMenuItem(
                  value: pt,
                  child: Text(
                    pt,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  batch = newVal.toString();
                });
                overallMarks = null;
                Map<String, dynamic> request = {
                  "moduleSlug": widget.moduleSlug,
                  "batch": batch
                };
                attendance.fetchallattendance(request).then((_) {
                  common.fetchStudentformarking(batch).then((_) {
                    group.fetchGroupResultModules(widget.moduleSlug).then((_) {
                      final requestData = jsonEncode({
                        "batch": batch,
                        "moduleSlug": widget.moduleSlug.toString(),
                        "examSlugList":
                            group.groupResultModule.examSlugList ?? []
                      });
                      group.fetchGroupMarksForSlug(requestData).then((_) {
                        group
                            .fetchGroupResultMarks(
                                resultTypeSlug.toString(),
                                widget.moduleSlug,
                                batch.toString(),
                                group.groupResultModule.groupResult!.id ?? "")
                            .then((_) {
                          try {
                            headingController.clear();
                            for (var k = 0;
                                k < common.studentMarking.length;
                                k++) {
                              headingController.add([]);
                              var studentResultMarkObj;
                              MarkMark? studentResultMarkMarkObj;
                              var studentResultHeadingObj;

                              if (group.groupResultMarks.marks!.isNotEmpty) {
                                setState(() {
                                  isMarksUpdate = true;
                                });
                                if (group.groupResultMarks.marks!.isNotEmpty) {
                                  var studentResultMarkIndex = group
                                      .groupResultMarks.marks!
                                      .indexWhere((element) =>
                                          element.username ==
                                          common.studentMarking[k]["username"]);

                                  if (studentResultMarkIndex >= 0) {
                                    studentResultMarkObj = group
                                        .groupResultMarks
                                        .marks![studentResultMarkIndex];
                                  }
                                }
                              }
                              for (var i = 0;
                                  i <
                                      (group.groupResultModule.groupResult!
                                                  .groups ==
                                              null
                                          ? 0
                                          : group.groupResultModule.groupResult!
                                              .groups!.length);
                                  i++) {
                                headingController[k].add([]);

                                if (studentResultMarkObj != null) {
                                  var studentResultMarMarkIndex =
                                      studentResultMarkObj!.marks!.indexWhere(
                                          (element) =>
                                              element.title ==
                                              group.groupResultModule
                                                  .groupResult!.groups![i].title
                                                  .toString());
                                  if (studentResultMarMarkIndex >= 0) {
                                    studentResultMarkMarkObj =
                                        studentResultMarkObj
                                            .marks![studentResultMarMarkIndex];
                                  }
                                }

                                var resultMark = 0;

                                for (var j = 0;
                                    j <
                                        (group.groupResultModule.groupResult!
                                                    .groups![i].headings ==
                                                null
                                            ? 0
                                            : group
                                                .groupResultModule
                                                .groupResult!
                                                .groups![i]
                                                .headings!
                                                .length);
                                    j++) {
                                  if (studentResultMarkMarkObj != null) {
                                    if (studentResultMarkMarkObj.headings !=
                                            null &&
                                        studentResultMarkMarkObj
                                            .headings!.isNotEmpty) {
                                      var studentResultHeadingIndex =
                                          studentResultMarkMarkObj.headings!
                                              .indexWhere((element) =>
                                                  element.title ==
                                                  group
                                                      .groupResultModule
                                                      .groupResult!
                                                      .groups![i]
                                                      .headings![j]
                                                      .title
                                                      .toString());
                                      if (studentResultHeadingIndex >= 0) {
                                        studentResultHeadingObj =
                                            studentResultMarkMarkObj.headings![
                                                studentResultHeadingIndex];
                                      }else{
                                        studentResultHeadingObj = null;
                                      }
                                    }
                                  }

                                  num attendanceValue = 0;

                                  if (attendance.allAttendance.isNotEmpty) {
                                    var studentAttendanceIndex = attendance
                                        .allAttendance
                                        .indexWhere((element) =>
                                            element.username ==
                                            common.studentMarking[k]
                                                ["username"]);

                                    if (studentAttendanceIndex >= 0) {
                                      var studentAttendanceObj =
                                          attendance.allAttendance[
                                              studentAttendanceIndex];
                                      attendanceValue =
                                          (studentAttendanceObj.percentage! /
                                                  100) *
                                              group
                                                  .groupResultModule
                                                  .groupResult!
                                                  .groups![i]
                                                  .headings![j]
                                                  .weightage!;
                                    }
                                  }

                                  num totalMarks = 0;
                                  num fullMark = 0;
                                  num studentMark = 0;

                                  if (group.groupResultModule.groupResult!
                                          .groups![i].headings![j].examSlug !=
                                      null) {
                                    var studentMarkIndex = group
                                        .groupMarksForSlug.allMarks!
                                        .indexWhere((element) =>
                                            element.username ==
                                                common.studentMarking[k]
                                                    ["username"] &&
                                            element.examSlug ==
                                                group
                                                    .groupResultModule
                                                    .groupResult!
                                                    .groups![i]
                                                    .headings![j]
                                                    .examSlug);
                                    if (studentMarkIndex >= 0) {
                                      var studentMarkObj = group
                                          .groupMarksForSlug
                                          .allMarks![studentMarkIndex];
                                      for (var p = 0;
                                          p < studentMarkObj.marks!.length;
                                          p++) {
                                        num markVal =
                                            studentMarkObj.marks![p].marks ?? 0;
                                        totalMarks = totalMarks + markVal;
                                      }

                                      for (var y = 0;
                                          y <
                                              group.groupMarksForSlug
                                                  .examFullMarks!.length;
                                          y++) {
                                        if (group
                                                .groupResultModule
                                                .groupResult!
                                                .groups![i]
                                                .headings![j]
                                                .examSlug ==
                                            group.groupMarksForSlug
                                                .examFullMarks![y].examSlug) {
                                          fullMark = group.groupMarksForSlug
                                              .examFullMarks![y].fullMark!;
                                        }
                                      }
                                    }
                                  }

                                  if (fullMark > 0) {
                                    studentMark = (totalMarks / fullMark) *
                                        group.groupResultModule.groupResult!
                                            .groups![i].headings![j].weightage!;
                                  }

                                  headingController[k][i].add(group
                                              .groupResultModule
                                              .groupResult!
                                              .groups![i]
                                              .groupType ==
                                          "attendance"
                                      ? TextEditingController(
                                          text: attendanceValue == 0
                                              ? "0"
                                              : attendanceValue
                                                  .toStringAsFixed(1)
                                                  .toString())
                                      : group.groupResultModule.groupResult!
                                                  .groups![i].groupType ==
                                              "exam"
                                          ? TextEditingController(
                                              text: studentMark == 0
                                                  ? "0"
                                                  : studentMark
                                                      .toStringAsFixed(1)
                                                      .toString())
                                          : isMarksUpdate == true &&
                                                  group.groupResultMarks.marks!
                                                      .isNotEmpty
                                              ? TextEditingController(
                                                  text: studentResultHeadingObj != null &&
                                                          studentResultHeadingObj
                                                                  .marks !=
                                                              null
                                                      ? studentResultHeadingObj.marks
                                                          .toString()
                                                      : "")
                                              : TextEditingController());
                                }
                              }
                            }
                          } catch (e) {}
                        });
                      });
                    });
                  });
                });
              },
              value: batch,
            ),
            const SizedBox(
              height: 15,
            ),
            batch == null
                ? Container()
                : isLoading(common.studentMarkingApiResponse) ||
                        isLoading(group.groupResultModuleApiResponse) ||
                        isLoading(group.groupResultMarksApiResponse) ||
                        isLoading(attendance.allAttendanceApiResponse) ||
                        isLoading(group.groupMarksForSlugApiResponse)
                    ? const VerticalLoader()
                    : common.studentMarking == null ||
                            common.studentMarking.isEmpty
                        ? Container()
                        : Column(
                            children: [
                              group.groupResultMarks.marks == null ||
                                      group.groupResultMarks.marks!.isEmpty
                                  ? Align(
                                      alignment: Alignment.topRight,
                                      child: ElevatedButton(
                                          onPressed: isloading == true
                                              ? () {}
                                              : () => showAlertDialog(context,
                                                  common, group, false),
                                          child: isloading == true
                                              ? const CircularProgressIndicator()
                                              : Text("Save")),
                                    )
                                  : Align(
                                      alignment: Alignment.topLeft,
                                      child: ElevatedButton(
                                          onPressed: isAllUpdateLoading == true
                                              ? () {}
                                              : () => showAlertDialog(
                                                  context, common, group, true),
                                          child: isAllUpdateLoading == true
                                              ? const CircularProgressIndicator()
                                              : Text("Update All")),
                                    ),
                              SizedBox(height: 10),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: common.studentMarking.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text("Name: "),
                                                      Expanded(
                                                        child: Text(
                                                            common.studentMarking[
                                                                        index][
                                                                    "firstname"] +
                                                                " " +
                                                                common.studentMarking[
                                                                        index][
                                                                    "lastname"],
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text("Username: "),
                                                      Expanded(
                                                        child: Text(
                                                          common.studentMarking[
                                                                  index]
                                                              ["username"],
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text("Student Id: "),
                                                      Text(
                                                        common.studentMarking[
                                                                    index]
                                                                ["studentId"] ??
                                                            "N/A",
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  group
                                                      .groupResultMarks
                                                      .marks == null ? Container() :
                                                  Builder(builder: (context) {
                                                        var studentResultMarkObj;
                                                        if (group
                                                            .groupResultMarks
                                                            .marks!
                                                            .isNotEmpty) {
                                                          if (group
                                                              .groupResultMarks
                                                              .marks!
                                                              .isNotEmpty) {
                                                            var studentResultMarkIndex = group
                                                                .groupResultMarks
                                                                .marks!
                                                                .indexWhere((element) =>
                                                                    element
                                                                        .username ==
                                                                    common.studentMarking[index][
                                                                        "username"]);

                                                            if (studentResultMarkIndex >=
                                                                0) {
                                                              studentResultMarkObj = group
                                                                      .groupResultMarks
                                                                      .marks![
                                                                  studentResultMarkIndex];

                                                              if(studentResultMarkObj.calculatedOverall != null) {
                                                                  overallMarks = studentResultMarkObj.calculatedOverall.toString();
                                                              }
                                                            }
                                                          }
                                                        }


                                                    return overallMarks == null || overallMarks == "" ? SizedBox() : Row(
                                                      children: [
                                                        Text("Overall: "),
                                                        Text(
                                                          overallMarks ?? "N/A",
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                                ],
                                              ),
                                            ),
                                            group.groupResultMarks.marks ==
                                                        null ||
                                                    group.groupResultMarks
                                                        .marks!.isNotEmpty
                                                ? ElevatedButton(
                                                    onPressed: isloading == true
                                                        ? () {}
                                                        : () =>
                                                            updateStudentMarkFuc(
                                                                group,
                                                                common,
                                                                false,
                                                                index),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                                  Colors.green),
                                                    ),
                                                    child: Text("Update"),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        group.groupResultModule.groupResult
                                                    ?.groups ==
                                                null
                                            ? const Text("No Heading Found")
                                            : ListView.builder(
                                                shrinkWrap: true,
                                                physics: ScrollPhysics(),
                                                itemCount: group
                                                    .groupResultModule
                                                    .groupResult
                                                    ?.groups
                                                    ?.length,
                                                itemBuilder:
                                                    (context, innerIndex) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        group
                                                            .groupResultModule
                                                            .groupResult!
                                                            .groups![innerIndex]
                                                            .title!
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      ...List.generate(
                                                          group
                                                              .groupResultModule
                                                              .groupResult!
                                                              .groups![
                                                                  innerIndex]
                                                              .headings!
                                                              .length,
                                                          (innerIndex2) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  group
                                                                      .groupResultModule
                                                                      .groupResult!
                                                                      .groups![
                                                                          innerIndex]
                                                                      .headings![
                                                                          innerIndex2]
                                                                      .title
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                              Builder(builder:
                                                                  (context) {
                                                                return Expanded(
                                                                  child:
                                                                      TextFormField(
                                                                        // focusNode: _focuNode,
                                                                          readOnly: group.groupResultModule.groupResult!.groups![innerIndex].groupType == "attendance" || group.groupResultModule.groupResult!.groups![innerIndex].groupType == "exam"
                                                                              ? true
                                                                              : false,
                                                                          controller: headingController[index][innerIndex]
                                                                              [
                                                                              innerIndex2],
                                                                          keyboardType: const TextInputType.numberWithOptions(
                                                                              decimal:
                                                                                  true,
                                                                              signed:
                                                                                  true),
                                                                          decoration:
                                                                               InputDecoration(
                                                                                filled: true,
                                                                            fillColor: (group.groupResultModule.groupResult!.groups![innerIndex].groupType == "attendance" || group.groupResultModule.groupResult!.groups![innerIndex].groupType == "exam")
                                                                                ?  Color(0xffdee0df)
                                                                                : Colors.white,
                                                                            contentPadding:
                                                                                EdgeInsets.symmetric(horizontal: 6),
                                                                            floatingLabelStyle:
                                                                                TextStyle(color: Colors.black),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                                                          )),
                                                                );
                                                              }),
                                                            ],
                                                          ),
                                                        );
                                                      })
                                                    ],
                                                  );
                                                }),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Divider(
                                            color: Colors.black, thickness: 1),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  })
                            ],
                          ),
          ],
        );
      }),
    );
  }

  showAlertDialog(BuildContext context, CommonViewModel common,
      GroupResultViewModel group, bool isUpdate) {
    // Create button
    Widget okButton = ElevatedButton(
      child: Text("Confirm"),
      onPressed: (){
        if(isUpdate == true) {
          Navigator.pop(context);
          updateStudentMarkFuc(group, common, true, 0);
        } else {
          Navigator.pop(context);
          addStudentMarkFuc(group, common);
        }
      },
      // isUpdate == true
      //     ? updateStudentMarkFuc(group, common, true, 0)
      //     : addStudentMarkFuc(group, common),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
      ),
    );

    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.red),
      ),
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmation"),
      content:
          Text("Please confirm that you've entered all the marks correctly"),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void addStudentMarkFuc(
      GroupResultViewModel group, CommonViewModel common) async {
    setState(() {
      isloading = true;
    });

    try {
      List<Map<String, dynamic>> allMarksArr = [];

      for (var i = 0; i < (common.studentMarking.length); i++) {
        List<Map<String, dynamic>> marksList = [];

        for (var j = 0;
            j < group.groupResultModule.groupResult!.groups!.length;
            j++) {
          List<Map<String, dynamic>> headingsList = [];

          for (var k = 0;
              k <
                  group.groupResultModule.groupResult!.groups![j].headings!
                      .length;
              k++) {
            Map<String, dynamic> headingMap = {
              "title": group
                  .groupResultModule.groupResult!.groups![j].headings![k].title
                  .toString(),
              "marks": headingController[i][j][k].text.isEmpty ||
                      headingController[i][j][k].text == ""
                  ? "0"
                  : headingController[i][j][k].text,
              if (group.groupResultModule.groupResult!.groups![j].headings?[k]
                      .examSlug !=
                  null)
                "examSlug": group.groupResultModule.groupResult!.groups![j]
                    .headings?[k].examSlug
                    .toString()
            };
            headingsList.add(headingMap);
          }

          Map<String, dynamic> marksMap = {
            "groupType": group
                .groupResultModule.groupResult!.groups![j].groupType
                .toString(),
            "title": group.groupResultModule.groupResult!.groups![j].title
                .toString(),
            "headings": headingsList
          };
          marksList.add(marksMap);
        }

        Map<String, dynamic> allMarksMap = {
          "marks": marksList,
          "username": common.studentMarking[i]["username"]
        };
        allMarksArr.add(allMarksMap);
      }
      final request = jsonEncode({
        "batch": batch,
        "groupResult": group.groupResultModule.groupResult?.id.toString(),
        "moduleSlug": widget.moduleSlug,
        "resultType": resultTypeSlug,
        "allMarks": allMarksArr
      });
      final ress = await GroupResultRepository().addGroupResultMark(request);
      if (ress.success == true) {
        group
            .fetchGroupResultMarks(
            resultTypeSlug.toString(),
            widget.moduleSlug,
            batch.toString(),
            group.groupResultModule.groupResult!.id ?? "").then((_){
          setState(() {
            isloading = false;
          });
          snackThis(
              context: context,
              content: Text(ress.message.toString()),
              color: Colors.green,
              duration: 1,
              behavior: SnackBarBehavior.floating);

        });

        // Navigator.pop(context);
      } else {
        setState(() {
          isloading = false;
        });
        snackThis(
            context: context,
            content: Text(ress.message.toString()),
            color: Colors.red,
            duration: 2,
            behavior: SnackBarBehavior.floating);
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        isloading = false;
      });
      snackThis(
          context: context,
          content: Text("Failed to add Marks"),
          color: Colors.red,
          duration: 1,
          behavior: SnackBarBehavior.floating);
    }
  }

  void updateStudentMarkFuc(GroupResultViewModel group, CommonViewModel common,
      isAllUpdate, int studentIndex) async {
    try {
      setState(() {
        if (isAllUpdate == true) {
          isAllUpdateLoading = true;
        } else {
          isloading = true;
        }
      });

      Map<String, dynamic>? allMarksObj;
      List<Map<String, dynamic>>? allMarksArr = [];

      int studentLen = studentIndex + 1;

      for (var i = 0;
          i < (isAllUpdate == true ? common.studentMarking.length : studentLen);
          i++) {
        List<Map<String, dynamic>> marksList = [];

        for (var j = 0;
            j < group.groupResultModule.groupResult!.groups!.length;
            j++) {
          List<Map<String, dynamic>> headingsList = [];

          for (var k = 0;
              k <
                  group.groupResultModule.groupResult!.groups![j].headings!
                      .length;
              k++) {
            Map<String, dynamic> headingMap = {
              "title": group
                  .groupResultModule.groupResult!.groups![j].headings![k].title
                  .toString(),
              "marks": headingController[i][j][k].text.isEmpty ||
                      headingController[i][j][k].text == ""
                  ? "0"
                  : headingController[i][j][k].text,
              "_id": group
                  .groupResultModule.groupResult!.groups![j].headings![k].id,
              if (group.groupResultModule.groupResult!.groups![j].headings?[k]
                      .examSlug !=
                  null)
                "examSlug": group.groupResultModule.groupResult!.groups![j]
                    .headings?[k].examSlug
                    .toString()
            };
            headingsList.add(headingMap);
          }

          Map<String, dynamic> marksMap = {
            "groupType": group
                .groupResultModule.groupResult!.groups![j].groupType
                .toString(),
            "title": group.groupResultModule.groupResult!.groups![j].title
                .toString(),
            "headings": headingsList,
            "_id": group.groupResultModule.groupResult!.groups![j].id
          };
          marksList.add(marksMap);
        }

        Map<String, dynamic> allMarksMap = {
          "marks": marksList,
          "username": common.studentMarking[i]["username"]
        };
        allMarksObj = allMarksMap;
        allMarksArr.add(allMarksMap);
      }

      final request = jsonEncode({
        "batch": batch,
        "groupResult": group.groupResultModule.groupResult?.id,
        "moduleSlug": widget.moduleSlug,
        "resultType": resultTypeSlug,
        if (isAllUpdate) "allMarks": allMarksArr else "studentMark": allMarksObj
      });

      if (isAllUpdate == true) {
        final ress =
            await GroupResultRepository().updateAllStudentMark(request);
        if (ress.success == true) {
          setState(() {
            isAllUpdateLoading = false;
          });
          snackThis(
              context: context,
              content: Text(ress.message.toString()),
              color: Colors.green,
              duration: 1,
              behavior: SnackBarBehavior.floating);
        } else {
          setState(() {
            isAllUpdateLoading = false;
          });
          snackThis(
              context: context,
              content: Text(ress.message.toString()),
              color: Colors.red,
              duration: 1,
              behavior: SnackBarBehavior.floating);
        }
      }
      else {
        setState(() {
          isloading = true;
        });
        final ress =
            await GroupResultRepository().updateIndividualMark(request);
        if (ress.success == true) {
          setState(() {
            isloading = false;
          });
          snackThis(
              context: context,
              content: Text(ress.message.toString()),
              color: Colors.green,
              duration: 1,
              behavior: SnackBarBehavior.floating);
        } else {
          setState(() {
            isloading = false;
          });
          snackThis(
              context: context,
              content: Text(ress.message.toString()),
              color: Colors.red,
              duration: 1,
              behavior: SnackBarBehavior.floating);
          // Alert(
          //   context: context,
          //   type: AlertType.error,
          //   title: "Alert",
          //   desc: ress.message.toString(),
          //   buttons: [
          //     DialogButton(
          //       onPressed: () {
          //         Navigator.pop(context);
          //       },
          //       color: const Color.fromRGBO(0, 179, 134, 1.0),
          //       child: const Text(
          //         "ok",
          //         style: TextStyle(color: Colors.white, fontSize: 20),
          //       ),
          //     ),
          //   ],
          // ).show();
        }
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
      snackThis(
          context: context,
          content: Text("Failed to update marks"),
          color: Colors.red,
          duration: 1,
          behavior: SnackBarBehavior.floating);
    }
  }
}
