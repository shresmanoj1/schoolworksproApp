import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/student_stats/components/disciplinary_stats.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/student_stats/components/documents_stats.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/student_stats/components/issued_book_stats.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/student_stats/components/logistics_request_stats_screen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/student_stats/components/performance_stats.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/student_stats/components/progress_stats.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/student_stats/components/submission_stats.dart';
import 'package:schoolworkspro_app/Screens/parents/More_parent/resuult_parent/result_parent.dart';
import 'package:schoolworkspro_app/Screens/parents/attendance_parent/attendance_parent.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/fees/feeadmin_request.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/fees/feeadmin_service.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/fees/feesprincipal_screen.dart';
import 'package:schoolworkspro_app/Screens/result_softwarica/result_softwarica.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/lecturer/progressstats_request.dart';
import 'package:schoolworkspro_app/request/lecturer/stats_request.dart';
import 'package:schoolworkspro_app/response/addproject_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getdisciplinaryforstats_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getdocument_stats_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getperformance_stats_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getprogressstats_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getsubmissionforstats_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getsubmissionquizforstats_response.dart';
import 'package:schoolworkspro_app/services/lecturer/penalize_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/colors.dart';
import '../../../../helper/custom_loader.dart';
import '../../../../response/login_response.dart';
import '../../../../services/lecturer/studentstats_service.dart';
import '../../../prinicpal/principal_common_view_model.dart';
import '../../../prinicpal/student_stats/student_logs_screen.dart';
import 'components/disciplinary_student_remark.dart';

class StatsDetailScreen extends StatefulWidget {
  final data;
  const StatsDetailScreen({Key? key, this.data}) : super(key: key);

  @override
  _StatsDetailScreenState createState() => _StatsDetailScreenState();
}

class _StatsDetailScreenState extends State<StatsDetailScreen> {
  User? user;
  int _selectedPage = 0;
  int _subselectedPage = 0;
  late PageController _pageController;
  late PageController _subpageController;
  late PrinicpalCommonViewModel _provider;
  Future<GetDocumentForStatsResponse>? document_response;
  Future<GetProgressForStatsResponse>? progress_response;
  Future<GetPerformanceForStatsResponse>? performance_response;
  Future<GetSubmissionsForStatsResponse>? submission_response;
  Future<GetSubmissionsQuizForStatsResponse>? quiz_response;
  Future<GetDisciplinaryForStatsResponse>? disciplinary_response;

  List<Complete> submissions = <Complete>[];
  List<Complete> completed = <Complete>[];
  List<Complete> incompleted = <Complete>[];
  List<dynamic> quizData = <dynamic>[];
  List<dynamic> quizCompleted = <dynamic>[];
  List<dynamic> quizIncompleted = <dynamic>[];
  bool penalizeVisibility = false;
  PickedFile? _imageFile;
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage(ImageSource source) async {
    var selected =
        await ImagePicker().pickImage(source: source, imageQuality: 10);

    setState(() {
      if (selected != null) {
        _imageFile = PickedFile(selected.path);
      } else {
        Fluttertoast.showToast(msg: 'No image selected.');
      }
    });
  }

  bool isLoading = false;

  Widget bottomSheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text(
            "choose photo",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: const Icon(Icons.camera, color: Colors.red),
                onPressed: () async {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context, rootNavigator: true).pop();
                },
                label: const Text("Camera"),
              ),
              TextButton.icon(
                icon: const Icon(Icons.image, color: Colors.green),
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context, rootNavigator: true).pop();
                },
                label: const Text("Gallery"),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _subpageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _pageController = PageController();
    _subpageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<PrinicpalCommonViewModel>(context, listen: false);
      _provider.fetchStudentLogs(widget.data["username"]);
    });

    getData();

    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
    final username = StudentStatsRequest(username: widget.data["username"]);

    final progressRequest = ProgressStatsRequest(
        institution: widget.data['institution'], studentId: widget.data['_id']);
    document_response =
        StudentStatsLecturerService().getUserDocuments(username);

    progress_response =
        StudentStatsLecturerService().getUserProgress(progressRequest);

    performance_response =
        StudentStatsLecturerService().getUserPerformance(username);

    final submisson_data = await StudentStatsLecturerService()
        .getUsersSubmission(widget.data["username"]);

    quiz_response = StudentStatsLecturerService()
        .getUsersSubmissionQuiz(widget.data["username"]);

    final quiz_data = await StudentStatsLecturerService()
        .getUsersSubmissionQuiz(widget.data["username"]);

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
        completed.add(submisson_data.complete![i]);
      });
    }

    for (int j = 0; j < submisson_data.incomplete!.length; j++) {
      setState(() {
        submissions.add(submisson_data.incomplete![j]);
        incompleted.add(submisson_data.incomplete![j]);
      });
    }

    disciplinary_response = StudentStatsLecturerService()
        .getUsersDisciplinary(widget.data['username']);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading == true) {
      customLoadStart();
    } else {
      customLoadStop();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: white,
        ),
      ),
      body:
          Consumer<PrinicpalCommonViewModel>(builder: (context, model, child) {
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: SizedBox(
                      height: 100,
                      width: 60,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: widget.data['userImage'] == null
                            ? Colors.grey
                            : Colors.white,
                        child: widget.data['userImage'] == null ||
                                widget.data['userImage'].isEmpty
                            ? Text(
                                widget.data['firstname'][0].toUpperCase() +
                                    "" +
                                    widget.data['lastname'][0].toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            : CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                  api_url2 +
                                      '/uploads/users/' +
                                      widget.data['userImage'],
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                      ),
                    ),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.data['firstname']} ${widget.data['lastname']}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        widget.data['batch'] == null
                            ? const SizedBox()
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  widget.data['batch'].toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                              ),
                      ],
                    ),
                  ),
                  Card(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Email: ${widget.data['email']}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Address: ${widget.data['address']}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Contact: ${widget.data['contact']}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "Parents Contact: ${widget.data['contact']}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Course: ${widget.data['course']}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Batch: ${widget.data['batch']}"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  model.hasPermission(["view_student_documents"])
                      ? Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DocumentStats(data: widget.data),
                                      ));
                                },
                                child: Container(
                                  height: 100,
                                  width: 50,
                                  child: Card(
                                    color: Colors.grey.shade200,
                                    child:  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.document_scanner,
                                        ),
                                        Text(
                                          "Documents",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProgressStats(data: widget.data),
                                      ));
                                },
                                child: SizedBox(
                                  height: 100,
                                  width: 50,
                                  child: Card(
                                    color: Colors.grey.shade200,
                                    child:  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.percent,
                                        ),
                                        Text(
                                          "Progress",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PerformanceStats(data: widget.data),
                                      ));
                                },
                                child: Container(
                                  height: 100,
                                  width: 50,
                                  child: Card(
                                    color: Colors.grey.shade200,
                                    child:  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check,
                                        ),
                                        Text(
                                          "Performance",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SubmissionStats(data: widget.data),
                                ));
                          },
                          child: SizedBox(
                            height: 100,
                            width: 50,
                            child: Card(
                              color: Colors.grey.shade200,
                              child:   Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check,
                                  ),
                                  Text(
                                    "Submissions",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (widget.data['institution'] == "softwarica" ||
                                widget.data['institution'] == "sunway") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResultSoftwarica(
                                      institution: widget.data['institution'],
                                      studentID: widget.data['username'],
                                      dues: false,
                                    ),
                                  ));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResultParent(
                                      institution: widget.data['institution'],
                                      studentID: widget.data['username'],
                                    ),
                                  ));
                            }
                          },
                          child: Container(
                            height: 100,
                            width: 50,
                            child: Card(
                              color: Colors.grey.shade200,
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.grade,
                                  ),
                                  Text(
                                    "Results",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AttendanceParent(
                                      batch: widget.data['batch'],
                                      institution: widget.data['institution'],
                                      username: widget.data['username']),
                                ));
                          },
                          child: Container(
                            height: 100,
                            width: 50,
                            child: Card(
                              color: Colors.grey.shade200,
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.info,
                                  ),
                                  Text(
                                    "Attendance",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (widget.data['institution'] == "softwarica") {
                              final data = FeeAdminRequest(
                                  institution: widget.data['institution'],
                                  studentId: widget.data['username']);
                              FeeServiceAdmin().duedatastart(data);
                              FeeServiceAdmin().duedatastart(data);
                            } else {
                              final data = FeeAdminRequest(
                                  institution: widget.data['institution'],
                                  studentId: widget.data['email']);
                              FeeServiceAdmin().duedatastart(data);
                              FeeServiceAdmin().duedatastart(data);
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FeePrincipalScreen(data: widget.data),
                                ));
                          },
                          child: SizedBox(
                            height: 100,
                            // width: 55,
                            child: Card(
                              color: Colors.grey.shade200,
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.money,
                                  ),
                                  Text(
                                    "Fees",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      IssuedBookStats(data: widget.data),
                                ));
                          },
                          child: SizedBox(
                            height: 100,
                            // width: 50,
                            child: Card(
                              color: Colors.grey.shade200,
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.book_online,
                                  ),
                                  Text(
                                    "Issued Books",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                             DisciplinaryStudentRemark(username: user?.username ?? "",
                                                 currentUsername: widget.data['username']),
                                      ));
                                },
                                child: SizedBox(
                                  height: 100,
                                  width: 50,
                                  child: Card(
                                    color: Colors.grey.shade200,
                                    child:   Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                        ),
                                        Text(
                                          "Disciplinary\n Act",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // model.hasPermission(["set_student_disciplinary_act"]) == false
                  //     ? const SizedBox()
                  //     :
                  Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LogisticsScreeenStats(
                                                data: widget.data),
                                      ));
                                },
                                child: SizedBox(
                                  height: 100,
                                  width: 50,
                                  child: Card(
                                    color: Colors.grey.shade200,
                                    child:   Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.book_online,
                                        ),
                                        Text(
                                          "Logistics",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            user?.type == "Lecturer" ||
                            model.hasPermission(["manage_student_log"]) == true ?
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StudentLogScreen(
                                              username: widget.data['username'],
                                            ),
                                      ));
                                },
                                child: SizedBox(
                                  height: 100,
                                  width: 50,
                                  child: Card(
                                    color: Colors.grey.shade200,
                                    child:  Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.file_open_sharp,
                                        ),
                                        Text(
                                          "Logs",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ) : Expanded(child: Container()),
                            Expanded(child: Container()),
                          ],
                        ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }

  Widget logisticsWidget() {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LogisticsScreeenStats(data: widget.data),
              ));
        },
        child: Container(
          height: 100,
          width: 50,
          child: Card(
            color: Colors.grey.shade200,
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.book_online,
                ),
                Text(
                  "Logistics",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
