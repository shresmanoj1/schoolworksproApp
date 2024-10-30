import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/my_learning/homework/assignment_submission_screen.dart';
import 'package:schoolworkspro_app/Screens/my_learning/homework/assignment_view_model.dart';
import 'package:schoolworkspro_app/Screens/my_learning/learning_view_model.dart';
import 'package:schoolworkspro_app/Screens/student/exam/exam_view_model.dart';
import 'package:schoolworkspro_app/constants/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common_view_model.dart';
import '../../../config/api_response_config.dart';
import '../../../constants/colors.dart';
import '../../../response/authenticateduser_response.dart';
import 'package:html/dom.dart' as dom;

import '../../../response/exam_score_response.dart';

class ExamScoreScreen extends StatefulWidget {
  final String? moduleSlug;
  const ExamScoreScreen({Key? key, required this.moduleSlug}) : super(key: key);
  @override
  State<ExamScoreScreen> createState() => _ExamScoreScreenState();
}

class _ExamScoreScreenState extends State<ExamScoreScreen> {
  late LearningViewModel _provider;
  late ExamViewModel _provider2;
  String? _selectedExam;

  bool _customTileExpanded = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<LearningViewModel>(context, listen: false);
      _provider2 = Provider.of<ExamViewModel>(context, listen: false);
      // refreshPage();
    });
    getUser();
    super.initState();
  }

  User? user;
  getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }

  Future<void> refreshPage() async {
    _provider.fetchParticularModule(widget.moduleSlug.toString());
    _selectedExam = null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<LearningViewModel, CommonViewModel, ExamViewModel>(
        builder: (context, learningState, common, examState, child) {
      return RefreshIndicator(
        onRefresh: () => refreshPage(),
        child: Scaffold(
          body: shouldShowDuesAlert(common)
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Dues Amount Alert",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "You have dues amount in pending. Please clear the dues amount to submit your assignment.",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                )
              : _body(learningState, common, examState),
        ),
      );
    });
  }

  Widget _body(LearningViewModel value, CommonViewModel common,
      ExamViewModel examState) {
    return isLoading(value.particularModuleResponse)
        ? const Center(
            child: CupertinoActivityIndicator(),
          )
        : isError(value.particularModuleResponse) ||
                value.particularModule["releasedExam"] == null ||
                value.particularModule["releasedExam"].isEmpty
            ? Image.asset("assets/images/no_content.PNG")
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  // height: 20,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const Text("View Exam score",
                          style: TextStyle(
                            fontSize: 16,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
                        hint: const Text('Select exam'),
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                        ),
                        icon: const Icon(Icons.arrow_drop_down_outlined),
                        items: (value.particularModule["releasedExam"]
                                as List<dynamic>)
                            .map<DropdownMenuItem<String>>((pt) {
                          return DropdownMenuItem<String>(
                            value: pt["_id"].toString(),
                            child: Text(
                              pt["examTitle"].toString(),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            _selectedExam = newVal.toString();
                            _provider2.fetchExamScoreAnswer(newVal.toString());
                          });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (_selectedExam != null)
                        isLoading(examState.examScoreApiResponse)
                            ? const Center(
                                child: CupertinoActivityIndicator(),
                              )
                            : isError(examState.examScoreApiResponse)
                                ? const Text("No data found")
                                : answerListWidget(examState),
                    ],
                  ),
                ),
              );
  }

  Widget answerListWidget(ExamViewModel examState) {
    return Column(
      children: [
        Text("Your Score: ${examState.examScore.toString()}"),
        const SizedBox(
          height: 10,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: examState.examScoreAnswer.length,
          itemBuilder: (context, index) {
            var scoreItem = examState.examScoreAnswer[index];
            return scoreItem.isSubjective == true
                ? subjectiveAnswer(scoreItem)
                : answerListTileWidget(scoreItem, index);
          },
        ),
      ],
    );
  }

  Widget subjectiveAnswer(Answers scoreItem) {
    return Column(
      children: [
        _buildHtml(answer: scoreItem.answer.toString()),
        const SizedBox(
          height: 4,
        ),
        Text(scoreItem.codeAnswer.toString())
      ],
    );
  }

  Widget answerListTileWidget(Answers scoreItem, int index) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Question: ${index + 1}",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          _buildHtml(answer: scoreItem.question.toString()),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "(${scoreItem.marks ?? "0"}/${scoreItem.fullMarks} marks)",
            style: const TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Options:",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          ...(scoreItem.incorrectAnswers?.map(
                  (answer) => _buildAnswerTile(answer, isCorrect: false)) ??
              []),
          ...(scoreItem.correctAnswers?.map(
                  (answer) => _buildAnswerTile(answer, isCorrect: true)) ??
              []),
          const SizedBox(height: 10),
          const Text(
            "Checked Option:",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          ...(scoreItem.objectiveAnswers?.map((answer) {
                return _buildCheckedOption(answer);
              }) ??
              []),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            color: Colors.black,
            height: 2.0,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckedOption(String answer) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Icon(
            Icons.arrow_forward,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 8,
          child: Text(
            answer,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerTile(String answer, {required bool isCorrect}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          // flex: 1,
          child: Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: isCorrect ? Colors.green : Colors.red,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 8,
          child: Text(
            answer,
            style: TextStyle(
                color: isCorrect ? Colors.green : Colors.red, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildHtml({required String answer}) {
    return Html(
      style: {"ol": Style(margin: const EdgeInsets.all(5))},
      shrinkWrap: true,
      data: answer.toString(),
      customRender: {
        "table": (context, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: (context.tree as TableLayoutElement).toWidget(context),
          );
        }
      },
      onLinkTap: (String? url, RenderContext context,
          Map<String, String> attributes, dom.Element? element) {
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
      onImageTap: (String? url, RenderContext context,
          Map<String, String> attributes, dom.Element? element) {
        launch(url!);
      },
    );
  }

  bool shouldShowDuesAlert(CommonViewModel common) {
    if (common.authenticatedUserDetail.institution == "softwarica" ||
        common.authenticatedUserDetail.institution == "sunway") {
      return common.authenticatedUserDetail.dues ?? false;
    }
    return false;
  }
}
