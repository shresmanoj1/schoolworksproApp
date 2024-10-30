import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/add_assessment/assessmentfeedback_screen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:intl/intl.dart';

import '../../../api/repositories/student_assessement_repo.dart';
import '../../../constants/colors.dart';
import '../../../helper/custom_loader.dart';
import '../../widgets/snack_bar.dart';

class ViewSubmissionScreen extends StatefulWidget {
  final List<String> batch;
  final id;
  const ViewSubmissionScreen({Key? key, required this.batch, this.id})
      : super(key: key);

  @override
  _ViewSubmissionScreenState createState() => _ViewSubmissionScreenState();
}

class _ViewSubmissionScreenState extends State<ViewSubmissionScreen> {
  late LecturerCommonViewModel _provider;
  final TextEditingController feedbackcontroller = TextEditingController();
  List<String> selectedStudents = [];
  List<String> unSelectedStudents = [];
  String? selected_batch;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<LecturerCommonViewModel>(context, listen: false);
    });
    super.initState();
  }

  bool checkStudent = false;
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    if (isloading == true) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          "Submissions",
          style: TextStyle(color: white),
        ),
        // iconTheme: const IconThemeData(color: Colors.black),
        // backgroundColor: Colors.white,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Batch/Section",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButtonFormField(
              hint: const Text('Select batch/Section'),
              value: selected_batch,
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
              ),
              icon: const Icon(Icons.arrow_drop_down_outlined),
              items: widget.batch.map((pt) {
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
                  selected_batch = newVal as String?;

                  _provider.fetchsubmissionstats(
                      widget.id, selected_batch.toString());
                  _provider.fetchSubmissionCheck(
                      widget.id, selected_batch.toString());
                });
              },
            ),
          ),
          SizedBox(height: 20,),
          selected_batch == null
              ? Container()
              : Consumer<LecturerCommonViewModel>(
                  builder: (context, value, child) {
                  return isLoading(value.submissionStatsApiResponse) ||
                          isLoading(value.submissionCheckApiResponse)
                      ? const Center(
                          child:
                              Center(child: CupertinoActivityIndicator()),
                        )
                      : value.submission.isEmpty
                          ? Container()
                          : ListView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: [
                    Container(
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
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Checkbox(
                                value: checkStudent,
                                // activeColor: Colors.green,
                                onChanged: (value2) {
                                  setState(() {
                                    checkStudent = value2!;

                                    setState(() {
                                      if (checkStudent) {
                                        selectedStudents.addAll(
                                            value.submission
                                                .map((e) =>
                                            e.username!)
                                                .toList());
                                        checkStudent = true;
                                      } else {
                                        selectedStudents.clear();
                                        checkStudent = false;
                                      }
                                    });

                                    // setState(() {
                                    //   if (value2!) {
                                    //     for (int i = 0;
                                    //     i < _listForDisplay.length;
                                    //     i++) {
                                    //       setState(() {
                                    //         _presentStudents.add(
                                    //             _listForDisplay[i]
                                    //             ['username']);
                                    //         _value = true;
                                    //       });
                                    //     }
                                    //   } else {
                                    //     _value = false;
                                    //     setState(() {
                                    //       _presentStudents.clear();
                                    //     });
                                    //   }
                                    // });
                                  });
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(right: 25.0),
                            child: ElevatedButton(
                                style: const ButtonStyle(),
                                onPressed: () async {
                                  setState(() {
                                    isloading = true;
                                  });
                                  try {
                                    String datas = jsonEncode({
                                      "assessment": widget.id,
                                      "batch": selected_batch,
                                      "submitted_students":
                                      selectedStudents,
                                      "unsubmitted_students":
                                      unSelectedStudents
                                    });
                                    final res =
                                    await StudentAssessmentRepository()
                                        .addAssessmentSubmission(
                                        datas);
                                    if (res.success == true) {
                                      setState(() {
                                        isloading = false;
                                      });
                                      Navigator.of(context).pop();
                                      snackThis(
                                          context: context,
                                          color: Colors.green,
                                          duration: 2,
                                          content: Text(res.message
                                              .toString()));
                                    } else {
                                      setState(() {
                                        isloading = false;
                                      });
                                      snackThis(
                                          context: context,
                                          color: Colors.red,
                                          duration: 2,
                                          content: Text(res.message
                                              .toString()));
                                    }
                                  } on Exception catch (e) {
                                    setState(() {
                                      isloading = false;
                                    });
                                    snackThis(
                                        context: context,
                                        color: Colors.red,
                                        duration: 2,
                                        content:
                                        Text(e.toString()));
                                  }
                                },
                                child: const Text("Save")),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: value.submission.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: ListTile(
                                minLeadingWidth: 0,
                                contentPadding: const EdgeInsets.all(0),
                                leading: Text((index + 1).toString()),
                                title: RichText(
                                  text: TextSpan(
                                    text: "Name: ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                        "${value.submission[index].firstname} ${value.submission[index].lastname}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: "Student Id: ",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: value.submission[index].username
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: "Batch: ",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: value.submission[index].batch
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    value.submission[index].submission == null
                                        ? const Text(
                                      "Not Submitted",
                                      style: TextStyle(color: Colors.red),
                                    )
                                        : RichText(
                                      text: TextSpan(
                                        text: "Submitted on: ",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: DateFormat(
                                                'EEEE, dd MMM, yyyy hh:mm a')
                                                .format(value.submission[index]
                                                .submission!.updatedAt!),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: value.submission[index].submission ==
                                            null
                                            ? const IconButton(
                                            onPressed: null,
                                            icon: Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                            ))
                                            : IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SubmissionFeedbackScreen(
                                                            data: value
                                                                .submission[index]
                                                                .submission
                                                                ?.contents
                                                                .toString(),
                                                            feedback: value
                                                                .submission[index]
                                                                .submission
                                                                ?.feedback
                                                                .toString(),
                                                            id: value
                                                                .submission[index]
                                                                .submission
                                                                ?.id
                                                                .toString()),
                                                  ));
                                            },
                                            icon: const Icon(
                                              Icons.visibility,
                                              color: Colors.grey,
                                            )),
                                      ),
                                      WidgetSpan(child: Builder(builder: (context) {
                                        try {
                                          bool isChecked = false;

                                          selectedStudents =
                                          value.submissionCheck.students!;

                                          // value.submission.map((submission) =>({
                                          //   isChecked: selectedStudents.contains(submission.username)
                                          // }) );
                                        } catch (e) {
                                          print(e);
                                        }
                                        return Checkbox(
                                          value: selectedStudents.contains(
                                              value.submission[index].username),
                                          onChanged: (bool? value3) {
                                            setState(() {
                                              if (value3!) {
                                                selectedStudents.add(value
                                                    .submission[index].username
                                                    .toString());
                                                unSelectedStudents.removeWhere(
                                                        (element) =>
                                                    element ==
                                                        value.submission[index]
                                                            .username
                                                            .toString());
                                                print(
                                                    "SELECTED STUDENT::::${selectedStudents.length}");
                                              } else {
                                                unSelectedStudents.add(value
                                                    .submission[index].username
                                                    .toString());
                                                selectedStudents.remove(value
                                                    .submission[index].username
                                                    .toString());
                                                print(
                                                    "UNNNNNSELECTED STUDENT::::${selectedStudents.length}");
                                              }
                                            });
                                          },
                                        );
                                      })),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],);
                }),
        ],
      ),
    );
  }
}
