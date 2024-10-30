import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:schoolworkspro_app/response/getexam_response.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:schoolworkspro_app/services/authenticateduser_service.dart';
import 'package:schoolworkspro_app/services/exam_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/repositories/exam_repo.dart';
import '../../response/my_exam_generate_qr_response.dart';
import '../student/exam/exam_view_model.dart';
import 'package:html/dom.dart' as dom;

class ExaminationScreen extends StatefulWidget {
  const ExaminationScreen({Key? key}) : super(key: key);

  @override
  _ExaminationScreenState createState() => _ExaminationScreenState();
}

class _ExaminationScreenState extends State<ExaminationScreen> {
  User? user;

  List<String> exams = <String>[];
  // Future<GetExamResponse>? _response;

  late ExamViewModel _provider;
  dynamic examQrData;

  @override
  void initState() {
    getData().then((value) {
      if (user != null) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _provider = Provider.of<ExamViewModel>(context, listen: false);
          _provider.fetchMyExam().then((_) {
            if (_provider.myExams.allExam != null &&
                _provider.myExams.allExam!.isNotEmpty) {
              for (int i = 0; i < _provider.myExams.allExam!.length; i++) {
                setState(() {
                  exams.add(_provider.myExams.allExam?[i]["_id"]);
                });
              }
              Map<String, dynamic> data = {
                "username": user?.username,
                "batch": user?.batch,
                "exams": exams,
                "firstname": user?.firstname,
                "lastname": user?.lastname,
                "institution": user?.institution,
              };

              final request = ExamRepository()
                  .examinationSlipQrGenerate(data)
                  .then((value) {
                setState(() {
                  examQrData = value.qrData;
                });
              });
            }
          });
        });
      }
    });

    super.initState();
  }

  getData() async {
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
    return Consumer2<CommonViewModel, ExamViewModel>(
        builder: (context, common, examData, child) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            backgroundColor: logoTheme,
            title: const Text("Examination Slip",
                style: TextStyle(color: white, fontWeight: FontWeight.w800)),
            elevation: 0.0,
            iconTheme: const IconThemeData(
              color: white, //change your color here
            ),
          ),
          body: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 5),
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: CircleAvatar(
                                radius: 18,
                                backgroundColor:
                                    common.authenticatedUserDetail.userImage ==
                                            null
                                        ? Colors.grey
                                        : Colors.white,
                                child: user?.userImage == null
                                    ? Text(
                                        common.authenticatedUserDetail
                                                .firstname![0]
                                                .toUpperCase() +
                                            "" +
                                            common.authenticatedUserDetail
                                                .lastname![0]
                                                .toUpperCase()
                                                .toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )
                                    : ClipOval(
                                        child: Image.network(
                                          api_url2 +
                                              '/uploads/users/' +
                                              common.authenticatedUserDetail
                                                  .userImage!,
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Chip(
                              label: Text(
                                common.authenticatedUserDetail.batch.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              backgroundColor: Colors.black,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Name: ',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: common
                                            .authenticatedUserDetail.firstname
                                            .toString() +
                                        " " +
                                        common.authenticatedUserDetail.lastname
                                            .toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Email: ',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: common.authenticatedUserDetail.email
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Institution: ',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: common
                                        .authenticatedUserDetail.institution
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            common.authenticatedUserDetail.examId == null
                                ? const SizedBox()
                                : RichText(
                                    text: TextSpan(
                                      text: 'Exam Id: ',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: common
                                              .authenticatedUserDetail.examId
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.grey.shade100,
                height: 20,
                width: double.infinity,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "This is to confirm that you have been registered to the following examination at the dates and times specified below.",
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Qualification: ',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    user == null ? "" : user!.course.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  isLoading(examData.myExamsApiResponse)
                      ? const Center(child: CupertinoActivityIndicator())
                      : isError(examData.myExamsApiResponse) &&
                              examData.myExams.allExam == null &&
                              examData.myExams.allExam!.isEmpty
                          ? Container()
                          : DataTable(
                              columns: [
                                DataColumn(label: Text('Module/Subject')),
                                DataColumn(label: Text('Date & time')),
                              ],
                              rows: examData.myExams.allExam!
                                  .map((data) => DataRow(cells: [
                                        DataCell(Text(
                                          data['moduleTitle'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        )),
                                        DataCell(Builder(builder: (context) {
                                          DateTime now = DateTime.parse(
                                              data['startDate'].toString());

                                          now = now.add(const Duration(
                                              hours: 5, minutes: 45));

                                          var formattedTime =
                                              DateFormat('yMMMMd hh mm a')
                                                  .format(now);
                                          return Text(
                                            formattedTime.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          );
                                        })),
                                      ]))
                                  .toList(),
                            ),
                  Container(
                    color: Colors.grey.shade100,
                    height: 20,
                    width: double.infinity,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  examQrData != null
                      ? Center(
                          child:
                          QrImageView(size: 250, data: jsonEncode(examQrData)),
                        )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  isLoading(common.myExamsRulesApiResponse)
                      ? const Center(child: CupertinoActivityIndicator())
                      : !isError(common.myExamsRulesApiResponse) &&
                              common.myExamsRules.rulesAndRegulations != null &&
                              common.myExamsRules.rulesAndRegulations!
                                      .examRulesAndRegulations !=
                                  null &&
                              common.myExamsRules.rulesAndRegulations!
                                      .examRulesAndRegulations!.content !=
                                  null
                          ?
                          // Html(
                          //   data: common.myExamsRules.rulesAndRegulations!.examRulesAndRegulations!.content,
                          // )
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Html(
                                style: {
                                  "ol": Style(margin: const EdgeInsets.all(5)),
                                  "p": Style(
                                      fontSize: FontSize(16),
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                },
                                shrinkWrap: true,
                                data: common.myExamsRules.rulesAndRegulations!
                                    .examRulesAndRegulations!.content,
                                customRender: {
                                  "table": (context, child) {
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child:
                                          (context.tree as TableLayoutElement)
                                              .toWidget(context),
                                    );
                                  }
                                },
                                onLinkTap: (String? url,
                                    RenderContext context,
                                    Map<String, String> attributes,
                                    dom.Element? element) {
                                  Future<void> _launchInBrowser(Uri url) async {
                                    if (await launchUrl(
                                      url,
                                      mode: LaunchMode.externalApplication,
                                    )) {
                                      throw 'Could not launch $url';
                                    }
                                  }

                                  var linkUrl = url!.replaceAll(" ", "%20");
                                  _launchInBrowser(Uri.parse(linkUrl));
                                },
                                onImageTap: (String? url,
                                    RenderContext context,
                                    Map<String, String> attributes,
                                    dom.Element? element) {
                                  // print(url!);
                                  //open image in webview, or launch image in browser, or any other logic here
                                  launch(url!);
                                },
                              ),
                            )
                          : Container(),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ],
          ));
    });
  }
}
