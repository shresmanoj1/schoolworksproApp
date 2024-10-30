import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/my_learning/quiz/quiz_view_model.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

class overviewUnreleased extends StatefulWidget {
  String? quizId;
  overviewUnreleased({Key? key, required this.quizId}) : super(key: key);

  @override
  State<overviewUnreleased> createState() => _overviewUnreleasedState();
}

class _overviewUnreleasedState extends State<overviewUnreleased> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizViewModel(),
      child: overviewUnreleasedbody(
        quizId: widget.quizId,
      ),
    );
  }
}

class overviewUnreleasedbody extends StatefulWidget {
  String? quizId;
  overviewUnreleasedbody({Key? key, required this.quizId}) : super(key: key);

  @override
  State<overviewUnreleasedbody> createState() => _overviewUnreleasedbodyState();
}

class _overviewUnreleasedbodyState extends State<overviewUnreleasedbody> {
  late QuizViewModel _provider;

  @override
  void initState() {
    print("${widget.quizId.toString()}heree");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<QuizViewModel>(context, listen: false);
      _provider.fetchQuizOverview(widget.quizId.toString());
      _provider.fetchServerTimeQuiz();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          title: const Text("Overview", style: TextStyle(color: kWhite)),
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: kWhite,
          ),
          backgroundColor: logoTheme),
      body: Consumer<QuizViewModel>(

        builder: (context, quiz, child) {
          return quiz.quizoverview.result == null
              ? const Center(child: CupertinoActivityIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 130,
                          child: Card(
                            elevation: 4,
                            color: const Color(0xFFADD8E6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: Colors.grey, width: 0.2),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Attempted Questions',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            '${quiz.quizoverview.result!.attemptedQuestions}/${quiz.quizoverview.result!.totalQuestions}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                            )),
                                        Text(
                                            '${quiz.quizoverview.result!.attemptedQuestions} out of ${quiz.quizoverview.result!.totalQuestions} questions ',
                                            style: const TextStyle(
                                              fontSize: 16,
                                            )),
                                      ],
                                    ),
                                  ),
                                  // SizedBox(width: 10.0),
                                  CircularPercentIndicator(
                                      radius: 40,
                                      progressColor: logoTheme,
                                      percent: quiz.quizoverview.result!
                                                  .attemptedPercent ==
                                              null
                                          ? 0.0
                                          : double.parse(quiz.quizoverview
                                                  .result!.attemptedPercent!) /
                                              100.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                            height: 130,
                            child: Card(
                                elevation: 4,
                                color: const Color(0xff89CFF0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: const BorderSide(
                                      color: Colors.grey, width: 0.2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Quiz Score',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            if (quiz.quizoverview.result
                                                    ?.quizScore?.isReleased ==
                                                true)
                                              Text(
                                                "${(quiz.quizoverview.result?.quizScore?.score)}",
                                                style: const TextStyle(
                                                    fontSize: 22),
                                              )
                                            else
                                              const Text(
                                                "Waiting For Results...",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                      // SizedBox(width: 10.0),
                                      if (quiz.quizoverview.result?.quizScore
                                              ?.isReleased ==
                                          true)
                                        CircularPercentIndicator(
                                          radius: 40,
                                          progressColor: logoTheme,
                                          percent: quiz.quizoverview.result
                                                      ?.quizScore?.score ==
                                                  null
                                              ? 0
                                              : (quiz.quizoverview.result
                                                      ?.quizScore?.score)! /
                                                  100.0,
                                        ),
                                    ],
                                  ),
                                ))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.grey[100],
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Summary",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kBlack,
                                        fontSize: 20),
                                  ),
                                ),
                                Divider(
                                  height: 2,
                                  color: kpink,
                                  thickness: 3.0,
                                  endIndent: 250.0,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemCount: quiz
                                        .quizoverview.result?.answers?.length,
                                    itemBuilder: (context, index) {
                                      final overview = quiz
                                          .quizoverview.result?.answers?[index];

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Q ${index + 1}.',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: logoTheme,
                                                  ),
                                                ),

                                                if (quiz.quizoverview.result?.quizScore?.isReleased == false &&
                                                    overview?.question?.questionType ==
                                                        'subjective')
                                                  const Text("Score : Pending")
                                                else if (quiz.quizoverview.result?.quizScore?.isReleased == true &&
                                                    overview?.question?.questionType ==
                                                        'objective' &&
                                                    overview?.question?.questionType ==
                                                        'subjective' &&
                                                    (quiz.quizoverview.result?.answers?[index].objectiveAnswers == null ||
                                                        quiz.quizoverview.result?.answers?[index].objectiveAnswers?.isEmpty ==
                                                            true))
                                                  Text(
                                                      "Score: ${overview?.score}/${overview?.question?.questionWeightage}")
                                                else if ((quiz
                                                            .quizoverview
                                                            .result
                                                            ?.answers?[index]
                                                            .isSubjective ==
                                                        false) ||
                                                    (quiz.quizoverview.result?.answers?[index].objectiveAnswers == null ||
                                                        quiz
                                                                .quizoverview
                                                                .result
                                                                ?.answers?[index]
                                                                .objectiveAnswers
                                                                ?.isEmpty ==
                                                            true))
                                                  Text("Score: ${overview?.score}/1")
                                                // else(
                                                //     Text('Score:')
                                                //     )
                                              ],
                                            ),
                                          ),
                                          // Html(
                                          //   data:
                                          //       overview?.question?.question ??
                                          //           '',
                                          //   style: {
                                          //     'p': Style(
                                          //         fontSize: const FontSize(18)),
                                          //   },
                                          // ),
                                          Html(
                                            style: {
                                              "ol": Style(
                                                  margin:
                                                  const EdgeInsets.all(5))
                                            },
                                            shrinkWrap: true,
                                            customRender: {
                                              "table": (context, child) {
                                                return SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: (context.tree as TableLayoutElement).toWidget(context),
                                                );
                                              }
                                            },
                                            data:  overview?.question?.question.toString(),
                                            onLinkTap: (String? url,
                                                RenderContext context,
                                                Map<String, String> attributes,
                                                dom.Element? element) {
                                              var linkUrl = url!.replaceAll(" ", "%20");
                                              launch(linkUrl);
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
                                          if (quiz
                                                      .quizoverview
                                                      .result
                                                      ?.answers?[index]
                                                      .question
                                                      ?.questionType ==
                                                  'single' ||
                                              quiz
                                                      .quizoverview
                                                      .result
                                                      ?.answers?[index]
                                                      .question
                                                      ?.questionType ==
                                                  'multiple' ||
                                              quiz
                                                      .quizoverview
                                                      .result
                                                      ?.answers?[index]
                                                      .question
                                                      ?.questionType ==
                                                  'true/false')
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.blue),
                                                  onPressed: () {
                                                    final correctAnswers = quiz.quizoverview.result?.answers?[index].question?.correctAnswers;
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: const Text("Correct Answers"),
                                                          content: SizedBox(
                                                            height: 150,
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    const Icon(Icons.arrow_circle_right, color: Colors.green),
                                                                    const SizedBox(width: 8),
                                                                    Text(correctAnswers?.join(", ") ?? "No correct answers found."),
                                                                  ],
                                                                ),

                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },

                                                  child: const Text(
                                                      "Correct Answer")),
                                            ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              'Your Answer:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: kpink,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          // Html(
                                          //   data: overview?.answer ?? '',
                                          //   style: {
                                          //     'p': Style(
                                          //         fontSize: const FontSize(18)),
                                          //   },
                                          // ),
                                          Html(
                                            data: overview?.answer,
                                            customRender: {
                                              "table": (context, child) {
                                                return SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: (context.tree as TableLayoutElement).toWidget(context),
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
                                          const Divider(
                                            height: 5,
                                            thickness: 1.0,
                                            color: logoTheme,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      );
                                    })
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }
}
