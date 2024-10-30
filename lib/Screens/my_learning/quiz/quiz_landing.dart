import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/my_learning/quiz/quiz_screen.dart';
import 'package:schoolworkspro_app/Screens/my_learning/quiz/quiz_view_model.dart';
import 'package:schoolworkspro_app/constants.dart';

import '../../../config/api_response_config.dart';
import '../../../constants/colors.dart';

class QuizLandingScreen extends StatefulWidget {
  String? week;
  String? moduleSlug;

  QuizLandingScreen({Key? key, required this.week, required this.moduleSlug})
      : super(key: key);

  @override
  State<QuizLandingScreen> createState() => _QuizLandingScreenState();
}

class _QuizLandingScreenState extends State<QuizLandingScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizViewModel(),
      child: QuizLandingBody(week: widget.week, moduleSlug: widget.moduleSlug),
    );
  }
}

class QuizLandingBody extends StatefulWidget {
  String? week;
  String? moduleSlug;
  QuizLandingBody({Key? key, required this.week, required this.moduleSlug})
      : super(key: key);

  @override
  State<QuizLandingBody> createState() => _QuizLandingBodyState();
}

class _QuizLandingBodyState extends State<QuizLandingBody> {
  late QuizViewModel _quizViewModel;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
      _quizViewModel.getStartQuiz(
          widget.moduleSlug.toString(), widget.week.toString());
      _quizViewModel.fetchServerTimeQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          title: const Text("Weekly Quiz", style: TextStyle(color: white)),
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: white,
          ),
          backgroundColor: logoTheme),
      body: Consumer<QuizViewModel>(
        builder: (context, quiz, child) {
          return isLoading(quiz.startquizApiResponse)
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : Stack(
                  children: [
                    Positioned.fill(
                      top: 100,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: 320,
                          height: 250,
                          child: Card(
                            elevation: 9,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                color: grey_100c,
                                width: 1.8,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Week ${widget.week} Quiz',
                                    style: const TextStyle(
                                        color: kBlack,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.alarm,
                                        color: kpink,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'Duration: ${quiz.startquiz["duration"] ?? ""} minutes',
                                        style: TextStyle(
                                            color: kpink,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 40.0),
                                    child: Container(
                                      width: 200,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: logoTheme,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  child: QuizMainScreen(
                                                    week: widget.week,
                                                    moduleSlug:
                                                        widget.moduleSlug,
                                                    quiz: quiz.startquiz,
                                                  ),
                                                  type: PageTransitionType
                                                      .rightToLeft));
                                        },
                                        child: const Text(
                                          'Begin Quiz',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
