import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/my_learning/components/assessment_submission_card.dart';
import 'package:schoolworkspro_app/Screens/my_learning/homework/assignment_report_view_screen.dart';
import 'package:schoolworkspro_app/Screens/my_learning/homework/assignment_view_model.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api/repositories/assignment_repo.dart';
import '../../../common_view_model.dart';
import '../../../config/api_response_config.dart';
import '../../../constants/colors.dart';
import '../../../constants/text_style.dart';
import '../../../response/authenticateduser_response.dart';
import '../../widgets/common_button_widget.dart';
import '../../widgets/snack_bar.dart';

class AssignmentSubmissionScreen extends StatefulWidget {
  final String assignmentId;
  final String moduleSlug;
  const AssignmentSubmissionScreen(
      {Key? key, required this.assignmentId, required this.moduleSlug})
      : super(key: key);
  @override
  State<AssignmentSubmissionScreen> createState() =>
      _AssignmentSubmissionScreenState();
}

class _AssignmentSubmissionScreenState
    extends State<AssignmentSubmissionScreen> {
  late AssignmentViewModel _provider;
  User? user;

  String url = "";
  double progress = 0;

  @override
  void initState() {
    refreshPage();
    super.initState();
    imageList.clear();
  }

  _launchURL(String fileName) async {
    String url = "https://api.schoolworkspro.com/uploads/files/$fileName";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _mySubmissionLaunchURL(String fileName) async {
    //https://api.schoolworkspro.com/uploads/assignments/english-1-bktscl-1667187811122/sample_1674187321286.pdf
    String url = "https://api.schoolworkspro.com/uploads/$fileName";
    print("URL:::${url}");
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<String> imageList = [];
  updateImage(images) {
    setState(() {
      imageList.add(images);
    });
  }

  Future<void> refreshPage() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<AssignmentViewModel>(context, listen: false);
      _provider.fetchAssignmentDetails(widget.assignmentId).then((_) {
        if (_provider.assignmentDetail.assignment?.submission != null) {
          _provider.fetchAssignmentPlagResult(
              _provider.assignmentDetail.assignment?.submission["submittedBy"],
              _provider.assignmentDetail.assignment?.submission["assignment"]);
        } else {
          null;
        }
      });
      getUser();
    });
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  num remainingUploading(AssignmentViewModel value) {
    var remainingUpload = 3;
    Duration difference;
    var latestSubmission;
    int hoursDifference;

    try {
      List submissionArray =
          value.assignmentDetail.assignment?.submission["submissionDate"] ?? [];

      if (submissionArray.length >= 3) {
        latestSubmission = submissionArray[submissionArray.length - 1];

        difference =
            DateTime.parse(latestSubmission).difference(DateTime.now());

        hoursDifference = difference.inHours;

        if (hoursDifference < 24) {
          remainingUpload = 0;
        } else {
          remainingUpload = 1;
        }
      } else {
        remainingUpload -= submissionArray.length;
      }
    } catch (e) {
      remainingUpload = 3;
    }

    return remainingUpload;
  }

  getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AssignmentViewModel, CommonViewModel>(
        builder: (context, value, common, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          title: const Text("Assignment Submission",
              style: TextStyle(fontSize: 16, color: white)),
        ),
        body: isLoading(value.assignmentDetailApiResponse)
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : isError(value.assignmentDetailApiResponse)
                ? const Center(
                    child: Text(
                    "Something went wrong. Please check your internet connection",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ))
                : SafeArea(
                    child: RefreshIndicator(
                    onRefresh: () => refreshPage(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: ListView(
                        // physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        // shrinkWrap: true,
                        children: [
                          value.assignmentDetail.assignment == null
                              ? Container()
                              : Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        value.assignmentDetail.assignment
                                                    ?.plagarismEnabled ==
                                                true
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.red.shade100,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: const Text(
                                                        "Please note: You can only upload your assignment upto three times. After three times, you will have to wait 24 hours to re-upload again.")),
                                              )
                                            : const SizedBox(),
                                        Text(
                                          value.assignmentDetail.assignment!
                                                      .assignmentTitle ==
                                                  null
                                              ? "N/A"
                                              : value.assignmentDetail
                                                  .assignment!.assignmentTitle
                                                  .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        AssessmentSubmissionCard(
                                            color: grey_200,
                                            label: "File",
                                            valueColor: Colors.blue.shade200,
                                            onTap: () {
                                              var linkUrl = value
                                                  .assignmentDetail
                                                  .assignment!
                                                  .filename
                                                  .toString()
                                                  .replaceAll(" ", "%20");
                                              _launchURL(linkUrl);
                                            },
                                            value: value.assignmentDetail
                                                .assignment!.filename
                                                .toString()),
                                        AssessmentSubmissionCard(
                                            color: white,
                                            label: "Due at",
                                            value: value.assignmentDetail
                                                        .assignment!.dueDate ==
                                                    null
                                                ? ""
                                                : "${DateFormat.yMMMEd().format(value.assignmentDetail.assignment!.dueDate!.toLocal())} ${DateFormat.jm().format(value.assignmentDetail.assignment!.dueDate!.toLocal())}"),
                                        value.assignmentDetail.assignment
                                                        ?.plagarismEnabled ==
                                                    true &&
                                                value
                                                        .assignmentDetail
                                                        .assignment
                                                        ?.submission !=
                                                    null
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AssessmentSubmissionCard(
                                                      color: grey_200,
                                                      valueColor: value
                                                                  .assignmentDetail
                                                                  .assignment!
                                                                  .submission ==
                                                              null
                                                          ? Colors.red.shade200
                                                          : greenLight,
                                                      label:
                                                          "Submission status",
                                                      value: value
                                                                  .assignmentDetail
                                                                  .assignment!
                                                                  .submission ==
                                                              null
                                                          ? "Not Submitted"
                                                          : "Submitted"),
                                                  Builder(builder: (context) {
                                                    String submittedDate = value
                                                            .assignmentDetail
                                                            .assignment!
                                                            .submission[
                                                        'updatedAt'];
                                                    return AssessmentSubmissionCard(
                                                        color: white,
                                                        value: value
                                                                        .assignmentDetail
                                                                        .assignment!
                                                                        .submission ==
                                                                    null ||
                                                                value
                                                                    .assignmentDetail
                                                                    .assignment!
                                                                    .submission
                                                                    .isEmpty
                                                            ? "n/a"
                                                            : DateFormat(
                                                                    "d MMM, yyy HH:mm a, EEEE")
                                                                .format(DateTime
                                                                        .parse(
                                                                            submittedDate)
                                                                    .add(Duration(
                                                                        hours:
                                                                            5,
                                                                        minutes:
                                                                            45))),
                                                        label:
                                                            "Submitted Date");
                                                  }),
                                                  isLoading(value
                                                          .assignmentPlagResultApiResponse)
                                                      ? Container()
                                                      : AssessmentSubmissionCard(
                                                          color: grey_200,
                                                          label: "Similarity",
                                                          valueColor: value
                                                                          .assignmentDetail
                                                                          .assignment
                                                                          ?.submission[
                                                                      "reportLoading"] ==
                                                                  "SUCCESS"
                                                              ? value
                                                                          .assignmentResult
                                                                          .details
                                                                          ?.totalPercentage
                                                                          ?.toInt() ==
                                                                      null
                                                                  ? white
                                                                  : (value.assignmentResult.details
                                                                              ?.totalPercentage
                                                                              ?.toInt())! <
                                                                          20
                                                                      ? Colors
                                                                          .lightGreen
                                                                      : solidRed
                                                              : Colors.white,
                                                          value: value
                                                                      .assignmentDetail
                                                                      .assignment
                                                                      ?.submission["reportLoading"] ==
                                                                  "SUCCESS"
                                                              ? "${value.assignmentResult.details?.totalPercentage == null ? 0 : value.assignmentResult.details?.totalPercentage.toString()} %"
                                                              : value.assignmentDetail.assignment?.submission["reportLoading"] == "FAILURE"
                                                                  ? "FAILED"
                                                                  : "Pending... "),
                                                  value.assignmentDetail.assignment
                                                                      ?.submission[
                                                                  "contents"] ==
                                                              null ||
                                                          value
                                                                  .assignmentDetail
                                                                  .assignment
                                                                  ?.submission[
                                                                      "contents"]
                                                                  .isEmpty ==
                                                              true
                                                      ? Container()
                                                      : AssessmentSubmissionCard(
                                                          color: white,
                                                          label:
                                                              "Your Submission",
                                                          valueColor: white,
                                                          onTap: () {
                                                            var fileName = value
                                                                .assignmentDetail
                                                                .assignment
                                                                ?.folderToUpload
                                                                .toString();
                                                            var linkUrl = value
                                                                .assignmentDetail
                                                                .assignment
                                                                ?.submission[
                                                                    "contents"]
                                                                .toString()
                                                                .replaceAll(
                                                                    " ", "%20");

                                                            var fullLinkUrl =
                                                                "$fileName/$linkUrl";
                                                            print(
                                                                "LINK::$fullLinkUrl");
                                                            _mySubmissionLaunchURL(
                                                                fullLinkUrl
                                                                    .toString());
                                                          },
                                                          value: "Open"),
                                                  value
                                                              .assignmentDetail
                                                              .assignment
                                                              ?.plagarismEnabled ==
                                                          true
                                                      ? AssessmentSubmissionCard(
                                                          color: grey_200,
                                                          value:
                                                              remainingUploading(
                                                                      value)
                                                                  .toString(),
                                                          label:
                                                              "Remaining Uploads Left")
                                                      : Container(),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                ],
                                              )
                                            : value.assignmentDetail.assignment
                                                            ?.submission !=
                                                        null &&
                                                    value
                                                            .assignmentDetail
                                                            .assignment
                                                            ?.plagarismEnabled ==
                                                        false
                                                ? Column(
                                                    children: [
                                                      AssessmentSubmissionCard(
                                                          color: grey_200,
                                                          valueColor: value
                                                                      .assignmentDetail
                                                                      .assignment!
                                                                      .submission ==
                                                                  null
                                                              ? Colors
                                                                  .red.shade200
                                                              : greenLight,
                                                          label:
                                                              "Submission status",
                                                          value: value
                                                                      .assignmentDetail
                                                                      .assignment!
                                                                      .submission ==
                                                                  null
                                                              ? "Not Submitted"
                                                              : "Submitted"),
                                                      Builder(
                                                          builder: (context) {
                                                        String submittedDate = value
                                                                .assignmentDetail
                                                                .assignment!
                                                                .submission[
                                                            'updatedAt'];
                                                        return AssessmentSubmissionCard(
                                                            color: white,
                                                            value: value.assignmentDetail.assignment!
                                                                            .submission ==
                                                                        null ||
                                                                    value
                                                                        .assignmentDetail
                                                                        .assignment!
                                                                        .submission
                                                                        .isEmpty
                                                                ? "n/a"
                                                                : DateFormat("d MMM, yyy HH:mm a, EEEE").format(DateTime
                                                                        .parse(
                                                                            submittedDate)
                                                                    .add(const Duration(
                                                                        hours:
                                                                            5,
                                                                        minutes:
                                                                            45))),
                                                            label:
                                                                "Submitted Date");
                                                      }),
                                                    ],
                                                  )
                                                : Container(),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        value.assignmentDetail.assignment!
                                                        .submission ==
                                                    null ||
                                                value
                                                            .assignmentDetail
                                                            .assignment!
                                                            .submission[
                                                        "feedback"] ==
                                                    null
                                            ? Container()
                                            : Text("Feedback",
                                                style: p14.copyWith(
                                                    fontWeight:
                                                        FontWeight.w800)),
                                        Text(
                                            value.assignmentDetail.assignment!
                                                            .submission ==
                                                        null ||
                                                    value
                                                                .assignmentDetail
                                                                .assignment!
                                                                .submission[
                                                            "feedback"] ==
                                                        null
                                                ? ""
                                                : value
                                                    .assignmentDetail
                                                    .assignment!
                                                    .submission["feedback"]
                                                        ["feedback"]
                                                    .toString(),
                                            style: p14),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        value.assignmentDetail.assignment?.submission == null &&
                                                value
                                                        .assignmentDetail
                                                        .assignment
                                                        ?.isDisabled ==
                                                    true
                                            ? Container(
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 5, horizontal: 5),
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xfff33066),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      "Assignment Submission Disabled",
                                                      style: TextStyle(
                                                          color: white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "You are ineligible to submit the assignment. Contact concerned authority for more information.",
                                                      style: TextStyle(
                                                          color: white,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ))
                                            : value.assignmentDetail.assignment?.submission != null &&
                                                    value
                                                            .assignmentDetail
                                                            .assignment
                                                            ?.isDisabled ==
                                                        false
                                                ? Row(
                                                    children: [
                                                      value
                                                                  .assignmentDetail
                                                                  .assignment
                                                                  ?.plagarismEnabled ==
                                                              false
                                                          ? Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child:
                                                                  CommonButton(
                                                                text:
                                                                    "My Submission",
                                                                fontSize: 14,
                                                                color: black,
                                                                textColor:
                                                                    white,
                                                                onTap:
                                                                    () async {
                                                                  String file =
                                                                      "${value.assignmentDetail.assignment!.folderToUpload}/${value.assignmentDetail.assignment!.submission["contents"]}";
                                                                  //https://api.schoolworkspro.com/uploads/assignments/english-1-bktscl-1667187811122/sample_1674187321286.pdf
                                                                  _mySubmissionLaunchURL(
                                                                      file);
                                                                },
                                                              ))
                                                          : value.assignmentDetail.assignment
                                                                          ?.submission[
                                                                      "reportLoading"] ==
                                                                  "SUCCESS"
                                                              ? Container()
                                                              : CommonButton(
                                                                  text: value
                                                                              .assignmentDetail
                                                                              .assignment
                                                                              ?.submission["reportLoading"] ==
                                                                          "SUCCESS"
                                                                      ? "View Report"
                                                                      : "Generating Report..",
                                                                  onTap: () {
                                                                    Map<String,
                                                                            String>
                                                                        request =
                                                                        {
                                                                      "username": user!
                                                                          .username
                                                                          .toString(),
                                                                      "assignmentId":
                                                                          widget
                                                                              .assignmentId,
                                                                      "name":
                                                                          "${user!.firstname}[SEP]${user!.lastname}",
                                                                    };

                                                                    value.assignmentDetail.assignment?.submission["reportLoading"] ==
                                                                            "SUCCESS"
                                                                        ? () {}
                                                                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>AssignmentViewReportWebView(data: request)))
                                                                        : null;
                                                                  },
                                                                  fontSize: 12,
                                                                  color: value.assignmentDetail.assignment?.submission[
                                                                              "reportLoading"] ==
                                                                          "SUCCESS"
                                                                      ? Colors
                                                                          .lightGreen
                                                                      : grey_400,
                                                                  textColor:
                                                                      white,
                                                                ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      CommonButton(
                                                        text: "Update Paper",
                                                        onTap: remainingUploading(
                                                                        value) ==
                                                                    0 &&
                                                                value
                                                                        .assignmentDetail
                                                                        .assignment
                                                                        ?.plagarismEnabled ==
                                                                    true
                                                            ? () {
                                                                snackThis(
                                                                    context:
                                                                        context,
                                                                    color: Colors
                                                                        .red,
                                                                    duration: 2,
                                                                    content:
                                                                        const Text(
                                                                            "Upload limit exceeded"));
                                                              }
                                                            : value
                                                                        .assignmentDetail
                                                                        .assignment
                                                                        ?.isDisabled ==
                                                                    true
                                                                ? () {}
                                                                : () async {
                                                                    if (value
                                                                            .assignmentDetail
                                                                            .assignment
                                                                            ?.isDisabled ==
                                                                        true) {
                                                                      snackThis(
                                                                          context:
                                                                              context,
                                                                          color: Colors
                                                                              .red,
                                                                          duration:
                                                                              2,
                                                                          content:
                                                                              const Text("Assignment is past due date"));
                                                                    } else {
                                                                      FilePickerResult?
                                                                          result =
                                                                          await FilePicker.platform.pickFiles(
                                                                              type: FileType.custom,
                                                                              allowedExtensions: [
                                                                            'doc',
                                                                            'pdf'
                                                                          ]);
                                                                      if (result !=
                                                                          null) {
                                                                        File file = File(result
                                                                            .files
                                                                            .single
                                                                            .path!);
                                                                        try {
                                                                          common
                                                                              .setLoading(true);
                                                                          updateImage(
                                                                              file.path);
                                                                          final res =
                                                                              await AssignmentRepository().assignmentSubmission({
                                                                            "folderToUpload":
                                                                                value.assignmentDetail.assignment!.folderToUpload.toString(),
                                                                            "moduleSlug":
                                                                                widget.moduleSlug.toString(),
                                                                            "assignment":
                                                                                widget.assignmentId.toString()
                                                                          }, imageList);
                                                                          imageList
                                                                              .clear();

                                                                          if (res.success ==
                                                                              true) {
                                                                            // Navigator.pop(context);
                                                                            value.fetchAssignmentDetails(widget.assignmentId);
                                                                            refreshPage();
                                                                            snackThis(
                                                                                context: context,
                                                                                color: Colors.green,
                                                                                duration: 2,
                                                                                content: Text(res.message.toString()));
                                                                          } else {
                                                                            snackThis(
                                                                                context: context,
                                                                                color: Colors.red,
                                                                                duration: 2,
                                                                                content: Text(res.message.toString()));
                                                                          }
                                                                          common
                                                                              .setLoading(false);
                                                                        } on Exception catch (e) {
                                                                          common
                                                                              .setLoading(true);
                                                                          snackThis(
                                                                              context: context,
                                                                              color: Colors.red,
                                                                              duration: 2,
                                                                              content: Text(e.toString()));
                                                                          common
                                                                              .setLoading(false);
                                                                        }
                                                                      } else {
                                                                        print(
                                                                            "No file selected");
                                                                      }
                                                                    }
                                                                  },
                                                        fontSize: 12,
                                                        color: value
                                                                    .assignmentDetail
                                                                    .assignment
                                                                    ?.isDisabled ==
                                                                true
                                                            ? lightBlue
                                                            : lightTabBlue,
                                                        textColor: white,
                                                      )
                                                    ],
                                                  )
                                                : value
                                                                .assignmentDetail
                                                                .assignment
                                                                ?.plagarismEnabled ==
                                                            false &&
                                                        value
                                                                .assignmentDetail
                                                                .assignment
                                                                ?.submission !=
                                                            null
                                                    ? Align(
                                                        alignment: Alignment.centerRight,
                                                        child: CommonButton(
                                                          text: "My Submission",
                                                          fontSize: 14,
                                                          color: black,
                                                          textColor: white,
                                                          onTap: () async {
                                                            String file =
                                                                "${value.assignmentDetail.assignment!.folderToUpload}/${value.assignmentDetail.assignment!.submission["contents"]}";
                                                            //https://api.schoolworkspro.com/uploads/assignments/english-1-bktscl-1667187811122/sample_1674187321286.pdf
                                                            _mySubmissionLaunchURL(
                                                                file);
                                                          },
                                                        ))
                                                    : value.assignmentDetail.assignment?.submission != null
                                                        ? Container()
                                                        : Align(
                                                            alignment: Alignment.centerRight,
                                                            child: CommonButton(
                                                              text:
                                                                  "Submit Paper",
                                                              fontSize: 14,
                                                              color: value
                                                                          .assignmentDetail
                                                                          .assignment
                                                                          ?.isDisabled ==
                                                                      true
                                                                  ? lightBlue
                                                                  : lightTabBlue,
                                                              textColor: white,
                                                              onTap: () async {
                                                                if (value
                                                                        .assignmentDetail
                                                                        .assignment
                                                                        ?.isDisabled ==
                                                                    true) {
                                                                  snackThis(
                                                                      context:
                                                                          context,
                                                                      color: Colors
                                                                          .red,
                                                                      duration:
                                                                          2,
                                                                      content:
                                                                          const Text(
                                                                              "Assignment is past due date"));
                                                                } else {
                                                                  FilePickerResult?
                                                                      result =
                                                                      await FilePicker
                                                                          .platform
                                                                          .pickFiles(
                                                                              type: FileType.custom,
                                                                              allowedExtensions: [
                                                                        'doc',
                                                                        'pdf'
                                                                      ]);
                                                                  if (result !=
                                                                      null) {
                                                                    File file = File(result
                                                                        .files
                                                                        .single
                                                                        .path!);

                                                                    print(
                                                                        "THIS IS FILE :::: ${file.path}");

                                                                    try {
                                                                      common.setLoading(
                                                                          true);

                                                                      updateImage(
                                                                          file.path);

                                                                      final res =
                                                                          await AssignmentRepository()
                                                                              .assignmentSubmission({
                                                                        "folderToUpload": value
                                                                            .assignmentDetail
                                                                            .assignment!
                                                                            .folderToUpload
                                                                            .toString(),
                                                                        "moduleSlug": widget
                                                                            .moduleSlug
                                                                            .toString(),
                                                                        "assignment": widget
                                                                            .assignmentId
                                                                            .toString()
                                                                      }, imageList);
                                                                      imageList
                                                                          .clear();

                                                                      if (res.success ==
                                                                          true) {
                                                                        // _provider.fetchAssignmentDetails(
                                                                        //     widget
                                                                        //         .assignmentId);
                                                                        refreshPage();
                                                                        snackThis(
                                                                            context:
                                                                                context,
                                                                            color: Colors
                                                                                .green,
                                                                            duration:
                                                                                2,
                                                                            content:
                                                                                Text(res.message.toString()));
                                                                      } else {
                                                                        snackThis(
                                                                            context:
                                                                                context,
                                                                            color: Colors
                                                                                .red,
                                                                            duration:
                                                                                2,
                                                                            content:
                                                                                Text(res.message.toString()));
                                                                      }
                                                                      common.setLoading(
                                                                          false);
                                                                    } on Exception catch (e) {
                                                                      common.setLoading(
                                                                          true);
                                                                      snackThis(
                                                                          context:
                                                                              context,
                                                                          color: Colors
                                                                              .red,
                                                                          duration:
                                                                              2,
                                                                          content:
                                                                              Text(e.toString()));
                                                                      common.setLoading(
                                                                          false);
                                                                    }
                                                                  } else {
                                                                    print(
                                                                        "No file selected");
                                                                  }
                                                                }
                                                              },
                                                            )),
                                        value.assignmentDetail.assignment
                                                        ?.submission ==
                                                    null ||
                                                value
                                                            .assignmentDetail
                                                            .assignment
                                                            ?.submission[
                                                        "reportLoading"] ==
                                                    null
                                            ? const SizedBox()
                                            : value.assignmentDetail.assignment
                                                            ?.submission[
                                                        "reportLoading"] ==
                                                    "FAILURE"
                                                ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: const [
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "Similarity report not generated! Please try uploading again.",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .redAccent),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text("Please note:",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                          "1. Similarity report is generated only for pdf and doc files."),
                                                      Text(
                                                          "2. If all the file content are images, similarity report won't be generated."),
                                                      Text(
                                                          "3. Make sure that your filename doesn't contain special characters (\$ # . , ; : /). You can include underscores."),
                                                      Text(
                                                          "4. If the problem persists, please contact your concerned support with details including your id and module.")
                                                    ],
                                                  )
                                                : const SizedBox()
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  )),
      );
    });
  }
}
