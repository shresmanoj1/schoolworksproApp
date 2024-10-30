import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/student/exam/exam_question_screen.dart';
import 'package:schoolworkspro_app/Screens/student/exam/exam_view_model.dart';
import 'package:intl/intl.dart';
import '../../../api/repositories/exam_repo.dart';
import '../../../config/api_response_config.dart';
import '../../../constants.dart';
import '../../../helper/custom_loader.dart';
import '../../../response/common_response.dart';
import '../../widgets/snack_bar.dart';

class ExamDetailScreen extends StatefulWidget {
  String? examId;
  ExamDetailScreen({Key? key, required this.examId}) : super(key: key);

  @override
  State<ExamDetailScreen> createState() => _ExamDetailScreenState();
}

class _ExamDetailScreenState extends State<ExamDetailScreen> {
  late ExamViewModel _provider;
  bool isloading = false;

  TextEditingController examCodeController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<ExamViewModel>(context, listen: false);
      _provider.fetchExamDetails(widget.examId.toString()).then((_) {
        _provider.fetchServerTime();
      });
    });
    super.initState();
  }

  bool startExamLoading = false;

  startExamFuc(ExamViewModel exam) async {
    if (exam.serverTime["raw"] != null) {
      DateTime convertStartToNepaliTime = exam.examDetails.exam!.startDate!
          .add(const Duration(hours: 5, minutes: 45));
      DateTime convertRawToNepaliTime = DateTime.parse(exam.serverTime["raw"])
          .add(const Duration(hours: 5, minutes: 45));
      if (convertStartToNepaliTime.difference(convertRawToNepaliTime) <
          Duration.zero) {
        try {
          setState(() {
            startExamLoading = true;
          });
          Commonresponse res = await ExamRepository()
              .examAttempt(exam.examDetails.exam!.id.toString());
          if (res.success == true) {
            try {
              exam
                  .fetchExamWithQuestion(exam.examDetails.exam!.id.toString())
                  .then((_) {
                setState(() {
                  startExamLoading = false;
                });
                if (context.mounted) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExamQuestionScreen(
                                exam: exam.examWithQuestion.exam,
                                examId: exam.examDetails.exam!.id.toString(),
                              )));
                }
              });
            } catch (e) {
              setState(() {
                startExamLoading = false;
              });
              snackThis(
                  context: context,
                  content:
                      const Text("Something went wrong!, Please try again"),
                  color: Colors.red,
                  duration: 1,
                  behavior: SnackBarBehavior.floating);
            }
          } else {
            setState(() {
              startExamLoading = false;
            });
          }
        } catch (e) {
          setState(() {
            startExamLoading = false;
          });
        }
      } else {
        snackThis(
            context: context,
            content: const Text("Please wait! The exam has not started yet!"),
            color: Colors.red,
            duration: 1,
            behavior: SnackBarBehavior.floating);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isloading == true ) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<ExamViewModel>(builder: (context, exam, child) {
        return isLoading(exam.examDetailsApiResponse)
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : exam.examDetails.exam == null
                ? Container()
                : (exam.examDetails.completed != null &&
                        exam.examDetails.completed == true)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Center(
                              child: Text(
                            "You have already attempted this exam!",
                            style: TextStyle(fontSize: 18),
                          )),
                        ],
                      )
                    : SafeArea(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    exam.examDetails.exam!.examTitle.toString(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text(
                                    DateFormat.yMMMEd().format(
                                        exam.examDetails.exam!.startDate!),
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Full Marks: ${exam.examDetails.exam!.fullMarks.toString()}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      "Pass Marks: ${exam.examDetails.exam!.passMarks.toString()}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Text(
                                    exam.examDetails.exam!.remarks.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                exam.examDetails.exam!.duration == null
                                    ? Container()
                                    : Center(
                                        child: Text(
                                          "Duration: ${exam.examDetails.exam!.duration.toString()}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                const SizedBox(
                                  height: 3,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: const Color(0xffeffdff),
                                  ),
                                  child: const Text(
                                    "When you begin the exam, you will be automatically logged out from all devices. It's important to note that you won't be able to log back in until you finish the exam. Please contact the concerned authority for further assistance.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18, color: Color(0xff08a7c1)),
                                  ),
                                ),
                                const Center(
                                  child: Text(
                                    "All the Best!",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                startExamLoading == true
                                    ? const CircularProgressIndicator()
                                    : ElevatedButton(
                                        onPressed:
                                            exam.examDetails.exam
                                                        ?.examCodeEnabled ==
                                                    false
                                                ? () async {
                                                    startExamFuc(exam);
                                                  }
                                                : () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return StatefulBuilder(
                                                            builder: (context,
                                                                setState) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                "Start Exam"),
                                                            content: SizedBox(
                                                              height: 340,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const Text(
                                                                      "Enter the exam code to start the exam. Once you start the exam you won't be able to login from other device."),
                                                                  const Padding(
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                            vertical:
                                                                                6),
                                                                    child:
                                                                        Divider(
                                                                      thickness:
                                                                          2,
                                                                      color: Colors
                                                                          .blueAccent,
                                                                    ),
                                                                  ),
                                                                  const Text(
                                                                      "Exam Code"),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  TextFormField(
                                                                    controller:
                                                                        examCodeController,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .text,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      filled:
                                                                          true,
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                              borderSide: BorderSide(color: kPrimaryColor)),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.green)),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                15.0,
                                                                            top:
                                                                                15.0),
                                                                        child:
                                                                            SizedBox(
                                                                          child:
                                                                              ElevatedButton(
                                                                            style: ButtonStyle(
                                                                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(4.0),
                                                                                ))),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                const Text("Cancel", style: TextStyle(fontSize: 14, color: Colors.black)),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                15.0,
                                                                            top:
                                                                                15.0),
                                                                        child:
                                                                            SizedBox(
                                                                          child:
                                                                              ElevatedButton(
                                                                            onPressed:
                                                                                () async {
                                                                              try {
                                                                                final request = jsonEncode({
                                                                                  "examCode": examCodeController.text
                                                                                });
                                                                                setState(() {
                                                                                  isloading = true;
                                                                                });
                                                                                Commonresponse res = await ExamRepository().checkExamCode(request, exam.examDetails.exam!.id.toString());
                                                                                if (res.success == true) {
                                                                                  Navigator.pop(context);
                                                                                  startExamFuc(exam);
                                                                                  examCodeController.clear();
                                                                                  setState(() {
                                                                                    isloading = false;
                                                                                  });
                                                                                } else {
                                                                                  snackThis(context: context, content: Text(res.message.toString()), color: Colors.red, duration: 1, behavior: SnackBarBehavior.floating);
                                                                                  setState(() {
                                                                                    isloading = false;
                                                                                  });
                                                                                  Navigator.pop(context);
                                                                                }
                                                                                setState(() {
                                                                                  isloading = false;
                                                                                });
                                                                              } catch (e) {
                                                                                snackThis(context: context, content: Text("Failed"), color: Colors.red, duration: 1, behavior: SnackBarBehavior.floating);
                                                                                setState(() {
                                                                                  isloading = false;
                                                                                });
                                                                                Navigator.pop(context);
                                                                              }
                                                                            },
                                                                            style: ButtonStyle(
                                                                                backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                                                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(4.0),
                                                                                ))),
                                                                            child:
                                                                                const Text(
                                                                              "start Exam",
                                                                              style: TextStyle(fontSize: 14, color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                      },
                                                    );
                                                  },
                                        child: const Text("Start Now")),
                              ],
                            ),
                          ),
                        ),
                      );
      }),
    );
  }
}
