import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/response/lecturer/getsubmissionquizforstats_response.dart';
import 'package:schoolworkspro_app/services/lecturer/studentstats_service.dart';

import '../../../../../constants/colors.dart';
import '../../../../../response/admin/allUserAssignemntResponse.dart';
import '../../../../../response/lecturer/getsubmissionforstats_response.dart';
import '../tab_barlecturer.dart';

class SubmissionStats extends StatefulWidget {
  final data;
  const SubmissionStats({Key? key, this.data}) : super(key: key);

  @override
  _SubmissionStatsState createState() => _SubmissionStatsState();
}

class _SubmissionStatsState extends State<SubmissionStats> {
  int _subselectedPage = 0;
  late PageController _subpageController;

  void _changesubPage(int pageNum) {
    setState(() {
      _subselectedPage = pageNum;
      _subpageController.animateToPage(
        pageNum,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }

  List<Complete> submissions = <Complete>[];
  List<Complete> taskCompleted = <Complete>[];

  // List<Complete> taskInCompleted = <Complete>[];
  List<dynamic> quizData = <dynamic>[];
  List<dynamic> quizCompleted = <dynamic>[];
  List<dynamic> quizIncompleted = <dynamic>[];
  List<AllAssignment> allAssignmentData = <AllAssignment>[];
  Future<GetSubmissionsQuizForStatsResponse>? quiz_response;

  @override
  void initState() {
    // TODO: implement initState

    _subpageController = PageController();
    getData();
    super.initState();
  }


  getData() async {
    final submisson_data = await StudentStatsLecturerService()
        .getUsersSubmission(widget.data['username']);

    final assignmentData = await StudentStatsLecturerService()
        .getAllStudentsAssignments(widget.data['username']);

    quiz_response = StudentStatsLecturerService()
        .getUsersSubmissionQuiz(widget.data['username']);

    final quiz_data = await StudentStatsLecturerService()
        .getUsersSubmissionQuiz(widget.data['username']);

    for (int i = 0; i < quiz_data.allQuiz!.length; i++) {
      for (int j = 0; j < quiz_data.allQuiz![i]['complete'].length; j++) {
        setState(() {
          quizCompleted.add(quiz_data.allQuiz![i]['complete'][j]);
        });
      }
    }

    for (int i = 0; i < quiz_data.allQuiz!.length; i++) {
      for (int j = 0; j < quiz_data.allQuiz![i]['incomplete'].length; j++) {
        setState(() {
          quizCompleted.add(quiz_data.allQuiz![i]['incomplete'][j]);
        });
      }
    }

    for (int i = 0; i < submisson_data.complete!.length; i++) {
      setState(() {
        submissions.add(submisson_data.complete![i]);
        // taskCompleted.add(submisson_data.complete![i]);
      });
    }

    for (int j = 0; j < submisson_data.incomplete!.length; j++) {
      setState(() {
        submissions.add(submisson_data.incomplete![j]);
        // taskInCompleted.add(submisson_data.incomplete![j]);
      });
    }

    allAssignmentData.clear();
    if (assignmentData.allAssignments != null) {
    for (int j = 0; j < assignmentData.allAssignments!.length; j++) {
      setState(() {
        allAssignmentData.add(assignmentData.allAssignments![j]);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: const IconThemeData(color: white),
          // backgroundColor: Colors.white,
          title: const Text("Submissions",
            style: TextStyle(color: white),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    TabButtonLecturer(
                      text: "Tasks",
                      pageNumber: 0,
                      selectedPage: _subselectedPage,
                      onPressed: () {
                        _changesubPage(0);
                      },
                    ),
                    TabButtonLecturer(
                      text: "Quiz",
                      pageNumber: 1,
                      selectedPage: _subselectedPage,
                      onPressed: () {
                        _changesubPage(1);
                      },
                    ),
                    TabButtonLecturer(
                      text: "Assignment",
                      pageNumber: 2,
                      selectedPage: _subselectedPage,
                      onPressed: () {
                        _changesubPage(2);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: PageView(
                    onPageChanged: (int page) {
                      setState(() {
                        _subselectedPage = page;
                      });
                    },
                    controller: _subpageController,
                    children: [
                      studentTaskWidget(),
                      studentQuizWidget(),
                      studentAssignmentWidget()
                    ],
                  ))
            ],
          ),
        )
    );
  }

  Widget studentTaskWidget() {
    return SingleChildScrollView(
      child: submissions.isEmpty ? const VerticalLoader() :
      SizedBox(
        width: double.infinity,
        child: GroupedListView<Complete, String>(
          elements: submissions,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          groupBy: (element) =>
          element.module!.moduleTitle!,
          groupComparator: (value1, value2) =>
              value2.compareTo(value1),
          itemComparator: (item1, item2) =>
              item1
                  .lesson!.lessonTitle!
                  .compareTo(item2.lesson!.lessonTitle!),
          order: GroupedListOrder.DESC,
          useStickyGroupSeparators: true,
          groupSeparatorBuilder: (String value) =>
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
          itemBuilder: (c, element) {
            return ListTile(
              trailing: taskCompleted.contains(element)
                  ? const Icon(
                Icons.check_circle,
                color: Colors.green,
              )
                  : Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red),
                child: const Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              title: Text(element.lesson!.lessonTitle!),
            );
          },
        ),
      ),
    );
  }

  Widget studentQuizWidget() {
    return FutureBuilder<
        GetSubmissionsQuizForStatsResponse>(
      future: quiz_response,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.allQuiz!.length,
            itemBuilder: (context, index) {
              var datas =
              snapshot.data?.allQuiz?[index];
              return datas['complete'].isEmpty &&
                  datas['incomplete'].isEmpty
                  ? SizedBox()
                  : ExpansionTile(
                  trailing: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  title: Text(
                    datas['moduleTitle'],
                    style: const TextStyle(
                        color: Colors.black),
                  ),
                  children: [
                    ...List.generate(
                        datas['complete'].length,
                            (i) =>
                            ListTile(
                                subtitle: Row(
                                  children: [
                                    datas['complete'][
                                    i]
                                    [
                                    'score'] >=
                                        80
                                        ? const Text(
                                      'Pass',
                                      style: TextStyle(
                                          color:
                                          Colors.green),
                                    )
                                        : const Text(
                                      'Fail',
                                      style: TextStyle(
                                          color:
                                          Colors.red),
                                    ),
                                    Text(
                                      " - " +
                                          datas['complete'][i]
                                          [
                                          'score']
                                              .toString(),
                                      style: TextStyle(
                                          color: datas['complete'][i]['score'] >=
                                              80
                                              ? Colors
                                              .green
                                              : Colors
                                              .red),
                                    ),
                                  ],
                                ),
                                trailing: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                title: Text(datas[
                                'complete'][i]
                                [
                                'lessonTitle']))),
                    ...List.generate(
                        datas['incomplete']
                            .length,
                            (j) =>
                            ListTile(
                                subtitle: const Text(
                                  "Not Completed",
                                  style: TextStyle(
                                      color:
                                      Colors.red),
                                ),
                                trailing: Container(
                                  height: 20,
                                  width: 20,
                                  decoration:
                                  const BoxDecoration(
                                      shape: BoxShape
                                          .circle,
                                      color: Colors
                                          .red),
                                  child: const Icon(
                                    Icons.clear,
                                    color:
                                    Colors.white,
                                    size: 20,
                                  ),
                                ),
                                title: Text(datas[
                                'incomplete'][j]
                                [
                                'lessonTitle']))),
                  ]);
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return VerticalLoader();
        }
      },
    );
  }

  Widget studentAssignmentWidget() {
    return SingleChildScrollView(
      child: allAssignmentData.isEmpty ? const VerticalLoader() :
      SizedBox(
        width: double.infinity,
        child: GroupedListView<AllAssignment, String>(
          elements: allAssignmentData,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          groupBy: (element) =>
          element.moduleData?.moduleTitle ?? "",
          groupComparator: (value1, value2) =>
              value2.compareTo(value1),
          itemComparator: (item1, item2) =>
              item1.assignmentTitle!
                  .compareTo(item2.assignmentTitle!),
          order: GroupedListOrder.DESC,
          useStickyGroupSeparators: true,
          groupSeparatorBuilder: (String value) =>
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
          itemBuilder: (c, element) {
            return ListTile(
              trailing: element.submission == null || element.submission == {}
              ?  Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red),
                child: const Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 20,
                ),
              )
                  :const Icon(
                Icons.check_circle,
                color: Colors.green,
              )
              ,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              title: Text(element.assignmentTitle ?? "N/A"),
            );
          },
        ),
      ),
    );
  }
}
