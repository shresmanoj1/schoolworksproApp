import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/my_learning/quiz/quiz_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants/colors.dart';

import 'overview_unreleased_screen.dart';

class QuizScoreScreen extends StatefulWidget {
  String? week;
  String? moduleSlug;

  QuizScoreScreen({
    Key? key,
    required this.week,
    required this.moduleSlug,
  }) : super(key: key);

  @override
  State<QuizScoreScreen> createState() => _QuizScoreScreenState();
}

class _QuizScoreScreenState extends State<QuizScoreScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizViewModel(),
      child: QuizScorebody(
        week: widget.week,
        moduleSlug: widget.moduleSlug,
      ),
    );
  }
}

class QuizScorebody extends StatefulWidget {
  String? week;
  String? moduleSlug;
  QuizScorebody({Key? key, required this.week, required this.moduleSlug})
      : super(key: key);

  @override
  State<QuizScorebody> createState() => _QuizScorebodyState();
}

class _QuizScorebodyState extends State<QuizScorebody> {
  late QuizViewModel _provider;

  void initState() {
    print("${"hereeee"}");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<QuizViewModel>(context, listen: false);
      _provider.getStartQuiz(widget.moduleSlug!, widget.week.toString());
      _provider.fetchServerTimeQuiz();

      print("Fetching quiz data...");
    });
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    print('QuizScorebody is being rebuilt');
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<QuizViewModel>(
        builder: (context, quiz, child) {
          if (quiz.startquiz == null) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          // else if (quiz.startquiz['isReleased'] &&
          //     quiz.startquiz['score'] != null) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Container(
                    height: 350,
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            quiz.startquiz['score'] < 60
                                ? Container()
                                : Text(
                                    'Congratulations!',
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      color: kpink,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                            const SizedBox(height: 5.0),
                            Text(
                              'You have Completed Week ${widget.week} Quiz of ${quiz.startquiz['moduleTitle']}',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700]),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20.0),
                            quiz.startquiz['isReleased'] == true &&
                                    quiz.startquiz['score'] != null
                                ? RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'You have scored\n',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[700]),
                                        ),
                                        TextSpan(
                                          text: '${quiz.startquiz['score']}%',
                                          style: const TextStyle(
                                            fontSize: 36.0,
                                            color: kBlack,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const Text(
                                    'Your Score is not Released Yet!',
                                    style: TextStyle(fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Builder(builder: (context) {

                                    DateTime endDate = DateTime.parse(_provider.quizserverTime["raw"]).add(const Duration(hours: 5, minutes: 45));

                                    if(quiz.startquiz['duration'] != null && quiz.startquiz['startDate'] != null ){
                                      int minutes =   quiz.startquiz['duration'];
                                    Duration durationObj = Duration(minutes: minutes);
                                     endDate =  DateTime.parse(quiz.startquiz['startDate']).add(const Duration(hours: 5, minutes: 45)).add(durationObj);
                                    }

                                    return
                                      quiz.pastQuiz == false
                                    && (endDate.isBefore(DateTime.parse(_provider.quizserverTime["raw"])) || endDate.isAtSameMomentAs(DateTime.parse(_provider.quizserverTime["raw"]).add(const Duration(hours: 5, minutes: 45))))
                                        ?
                                    ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                fixedSize:
                                                    const Size(100, 30),
                                                backgroundColor: kpink),
                                            onPressed: () {
                                              Navigator.push((context),
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return overviewUnreleased(
                                                  quizId:
                                                      quiz.startquiz['_id'],
                                                );
                                              }));
                                            },
                                            child: const Text(
                                              "Overview",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold),
                                            ),
                                          )
                                        : Container();
                                  }),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(100, 30),
                                        backgroundColor: logoTheme),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "Go Back",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          // }
          // else {
          //   return Padding(
          //     padding: const EdgeInsets.all(20.0),
          //     child: Container(
          //       height: 280,
          //       child: Card(
          //         elevation: 8,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10.0),
          //         ),
          //         color: Colors.white,
          //         child: Center(
          //           child: Padding(
          //             padding: const EdgeInsets.symmetric(
          //                 vertical: 40.0, horizontal: 8),
          //             child: Column(
          //               children: [
          //                 RichText(
          //                   textAlign: TextAlign.center,
          //                   text: TextSpan(
          //                     children: <TextSpan>[
          //                       const TextSpan(
          //                         text: 'You have Completed ',
          //                         style: TextStyle(
          //                             fontSize: 20.0, color: Colors.grey),
          //                       ),
          //                       TextSpan(
          //                         text:
          //                             'Week ${widget.week} Quiz of ${quiz.startquiz['moduleTitle']}',
          //                         style: const TextStyle(
          //                             fontSize: 18.0, color: Colors.grey),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 const SizedBox(
          //                   height: 20,
          //                 ),
          //                 const Text(
          //                   'Your Score is not Released Yet!',
          //                   style: TextStyle(fontSize: 18),
          //                   textAlign: TextAlign.center,
          //                 ),
          //                 const SizedBox(
          //                   height: 10,
          //                 ),
          //                 Padding(
          //                   padding:
          //                       const EdgeInsets.symmetric(horizontal: 75.0),
          //                   child: Row(
          //                     children: [
          //                       ElevatedButton(
          //                         style: ElevatedButton.styleFrom(
          //                             backgroundColor: kpink),
          //                         onPressed: () {
          //                           Navigator.push((context),
          //                               MaterialPageRoute(builder: (context) {
          //                             return overviewUnreleased(
          //                               quizId: quiz.startquiz['_id'],
          //                             );
          //                           }));
          //                         },
          //                         child: const Text(
          //                           "Overview",
          //                           style:
          //                               TextStyle(fontWeight: FontWeight.bold),
          //                         ),
          //                       ),
          //                       SizedBox(
          //                         width: 10,
          //                       ),
          //                       ElevatedButton(
          //                         style: ElevatedButton.styleFrom(
          //                             backgroundColor: logoTheme),
          //                         onPressed: () {
          //                           Navigator.of(context).pop();
          //                         },
          //                         child: Text(
          //                           "Go Back",
          //                           style:
          //                               TextStyle(fontWeight: FontWeight.bold),
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   );
          // }
        },
      ),
    );
  }
}
