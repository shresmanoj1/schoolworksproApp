import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/student/exam/exam_details_screen.dart';
import 'package:schoolworkspro_app/Screens/student/exam/exam_view_model.dart';
import 'package:schoolworkspro_app/Screens/widgets/common_button_widget.dart';
import 'package:intl/intl.dart';
import '../../../config/api_response_config.dart';
import '../../../constants/colors.dart';

class ExamListScreen extends StatefulWidget {
  const ExamListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ExamListScreen> createState() => _ExamListScreenState();
}

class _ExamListScreenState extends State<ExamListScreen> {
  late ExamViewModel _provider;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<ExamViewModel>(context, listen: false);
      _provider.fetchAllExam();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExamViewModel>(builder: (context, state, child) {
      return Scaffold(
          appBar: AppBar(title: const Text("My Exams")),
          body: isLoading(state.allExamsApiResponse)
              ? const Center(child: CupertinoActivityIndicator())
              : RefreshIndicator(
                  onRefresh: () async {
                    await state.fetchAllExam();
                  },
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    children: state.allExams.isEmpty ? [const Center(child: Text("No Exam Found"))] : List.generate(state.allExams.length, (index) {
                      var exam = state.allExams[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: black),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exam.examTitle.toString(),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent),
                                  // color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  exam.moduleTitle.toString(),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueAccent),
                                ),
                              ),
                              (exam.startDate != null
                                  ? Text(
                                      "Start Time: ${DateFormat('y, MMMM d, EEEE, hh:mm a').format(exam.startDate!.toLocal())}",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500))
                                  : Container()),
                              (exam.endDate != null
                                  ? Text(
                                      "End Time: ${DateFormat('y, MMMM d, EEEE, hh:mm a').format(exam.endDate!.toLocal())}",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500))
                                  : Container()),
                              //button
                              CommonButton(
                                text: "Attempt",
                                fontSize: 15,
                                color: Colors.green,
                                textColor: white,
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ExamDetailScreen(
                                                  examId: exam.id.toString())));
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ));
    });
  }
}
