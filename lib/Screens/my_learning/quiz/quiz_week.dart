import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/my_learning/quiz/quiz_landing.dart';
import 'package:schoolworkspro_app/Screens/my_learning/quiz/quiz_score_screen.dart';
import 'package:schoolworkspro_app/Screens/my_learning/quiz/quiz_view_model.dart';
import 'package:schoolworkspro_app/api/repositories/quiz_reposiotry.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/constants/colors.dart';

import '../../../config/api_response_config.dart';
import '../../../request/checkcodequiz_request.dart';
import '../../../response/code_quizcheck_response.dart';
import '../../../response/quizStart._response.dart';

class QuizWeekScreen extends StatefulWidget {
  String? moduleSlug;
  QuizWeekScreen({Key? key, this.moduleSlug}) : super(key: key);

  @override
  State<QuizWeekScreen> createState() => _QuizWeekScreenState();
}

class _QuizWeekScreenState extends State<QuizWeekScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizViewModel(),
      child: QuizWeekBody(
        moduleSlug: widget.moduleSlug,
      ),
    );
  }
}

class QuizWeekBody extends StatefulWidget {
  String? moduleSlug;
  QuizWeekBody({Key? key, required this.moduleSlug}) : super(key: key);

  @override
  State<QuizWeekBody> createState() => _QuizWeekBodyState();
}

class _QuizWeekBodyState extends State<QuizWeekBody> {
  late QuizViewModel _provider;

  @override
  void initState() {
    print("I am here:::");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<QuizViewModel>(context, listen: false);
      _provider.getQuiz(widget.moduleSlug!);
      // _provider.getStartQuiz(widget.moduleSlug!, widget.week.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizViewModel>(builder: (context, quiz, child) {
      // print('${quiz.startquiz?["hasCodeAnswer"]}there');
      return quiz.isLoading
          ? const Center(
              child: SpinKitDualRing(
                color: Colors.blue,
                size: 50.0,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Quiz',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kBlack,
                          fontSize: 20),
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: quiz.quiz.length,
                      itemBuilder: (context, index) {
                        final quizweek = quiz.quiz[index];

                        print("LENGTH::: QUIZ::::$quizweek");

                        String status = "";
                        Color? color;
                        if (quizweek.completed != null &&
                            quizweek.score != null) {
                          if (quizweek.completed! &&
                              quizweek.score! < quizweek.passMarks!) {
                            status = "Fail";
                            color = Colors.red;
                          } else if (quizweek.completed! &&
                              quizweek.score! >= quizweek.passMarks!) {
                            status = "Passed";
                            color = Colors.green;
                          } else {
                            status = "Available";
                            color = logoTheme;
                          }
                        }

                        return Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                final response = await QuizRepository()
                                    .startQuiz(widget.moduleSlug.toString(),
                                        quizweek.week.toString());
                                print("${response.toJson()}check");
                                if (response.success == true) {
                                  CodeQuizCheckResponse res =
                                      await QuizRepository().postCheckCodeQuiz(
                                          response.quiz['_id']);

                                  if (res.success == true &&
                                      res.hasCodeAnswer == true &&
                                      quizweek.completed! == false) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Coding Questions Ahead!!',
                                            style: TextStyle(
                                                // decoration: TextDecoration.underline,
                                                fontWeight: FontWeight.bold,
                                                color: kRed,
                                                fontSize: 20),
                                          ),
                                          content: const Text(
                                            'This Quiz contains coding questions, please proceed from the Web',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: const Text(
                                                'OK',
                                                style: TextStyle(
                                                    color: logoTheme,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else if (quizweek.completed!) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return QuizScoreScreen(
                                        moduleSlug: widget.moduleSlug,
                                        week: quizweek.week.toString(),
                                      );
                                    }));
                                  } else if (quizweek.completed == false) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return QuizLandingScreen(
                                        moduleSlug: widget.moduleSlug,
                                        week: quizweek.week.toString(),
                                      );
                                    }));
                                  }
                                }
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: ListTile(
                                      title: Text(
                                        'Week ${quizweek.week ?? ""}',
                                        style: const TextStyle(
                                            color: kBlack,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Status: ',
                                              style: TextStyle(
                                                  color: kBlack, fontSize: 14),
                                            ),
                                            TextSpan(
                                              text: status,
                                              style: TextStyle(
                                                  color: color,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Column(children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CircularPercentIndicator(
                                      backgroundColor: grey_300,
                                      progressColor: quizweek.score != null
                                          ? (quizweek.score! >=
                                                  quizweek.passMarks!
                                              ? Colors.green
                                              : Colors.red)
                                          : logoTheme,
                                      center: Text(
                                        "${quizweek.score?.toStringAsFixed(0) ?? "0"}%",
                                        style: const TextStyle(color: kBlack),
                                      ),
                                      radius: 30,
                                      lineWidth: 6,
                                      percent: quizweek.score == null
                                          ? 0
                                          : quizweek.score! / 100,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ]))
                                ],
                              ),
                            ),
                            // if (index != quiz.quiz.length - 1)
                            const Divider(
                              color: Colors.grey,
                              thickness: 1.3,
                              indent: 15,
                              endIndent: 15,
                            ),
                          ],
                        );
                      }),
                ],
              ),
            );
    });
  }
}
