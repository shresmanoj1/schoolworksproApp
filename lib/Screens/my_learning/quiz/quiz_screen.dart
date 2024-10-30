import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/my_learning/quiz/quiz_view_model.dart';
import 'package:schoolworkspro_app/api/repositories/quiz_reposiotry.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;

import '../../../api/repositories/lecturer/homework_repository.dart';
import '../../../common_view_model.dart';
import '../../../config/api_response_config.dart';
import '../../../constants/colors.dart';
import '../../../helper/custom_loader.dart';
import '../../../response/file_upload_response.dart';
import '../../../response/post_quiz_answer_response.dart';
import '../../../response/quizcomplete_response.dart';

class QuizMainScreen extends StatefulWidget {
  dynamic quiz;
  String? week;
  String? moduleSlug;
  QuizMainScreen(
      {Key? key,
        required this.week,
        required this.moduleSlug,
        required this.quiz})
      : super(key: key);

  @override
  State<QuizMainScreen> createState() => _QuizMainScreenState();
}

class _QuizMainScreenState extends State<QuizMainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizViewModel(),
      child: QuizMainBody(
        week: widget.week,
        moduleSlug: widget.moduleSlug,
        quiz: widget.quiz,
      ),
    );
  }
}

class QuizMainBody extends StatefulWidget {
  String? week;
  String? moduleSlug;
  dynamic quiz;
  QuizMainBody(
      {Key? key,
        required this.week,
        required this.moduleSlug,
        required this.quiz})
      : super(key: key);

  @override
  State<QuizMainBody> createState() => _QuizMainBodyState();
}

class _QuizMainBodyState extends State<QuizMainBody>
    with TickerProviderStateMixin {
  final HtmlEditorController subjectiveController = HtmlEditorController();
  bool isloading = false;
  int quizCurrentIndex = 0;
  late TabController _tabController;
  List listofFlaggedQuizId = [];
  late QuizViewModel _provider;
  late String timerCount;
  BuildContext? _context;
  late CommonViewModel _commonViewModel;

  @override
  void initState() {
    super.initState();
    _context = context;

    listofFlaggedQuizId.clear();
    getData();

    _tabController = TabController(
        length: widget.quiz['questions'] == null
            ? 0
            : widget.quiz['questions'].length,
        vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<QuizViewModel>(context, listen: false);
      _commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
      _provider.fetchMyQuizAnswer(
          widget.quiz['questions'][_tabController.index]["_id"].toString());
      setTimer();
    });
  }

  Future<void> setTimer() async {
    bool passedOneFifty = false;
    bool passedFIveFifty = false;
    bool finalTime = false;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (this.mounted) {
        setState(() {
          _provider.setDuration(_provider.meDuration - Duration(seconds: 1));
        });
      }
      if (_provider.meDuration.inSeconds == 0) {
        timer.cancel();
        timeOutSaveAnswer(_commonViewModel);
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });
  }

  getData() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _provider = Provider.of<QuizViewModel>(context, listen: false);
      _provider.fetchServerTimeQuiz().then((dynamic value3) {
        _provider
            .getStartQuiz(widget.moduleSlug.toString(), widget.week.toString())
            .then((_) {
          DateTime convertToNepaliTime =
          DateTime.parse(_provider.quizserverTime["raw"])
              .add(const Duration(hours: 5, minutes: 45));

          DateTime endDate = DateTime.parse(_provider.startquiz['endDate'])
              .add(const Duration(hours: 5, minutes: 45));

          _provider.setDuration(endDate.difference(convertToNepaliTime));
        });
      });
    });
  }

  Future uploadFile(PlatformFile file) async {
    setState(() {
      isloading = true;
    });
    if (file != null) {
      FileUploadResponse res = await HomeworkRepository()
          .addHomeWorkFile(file.path.toString(), file.name);
      setState(() {
        isloading = true;
      });
      try {
        if (res.success == true) {
          subjectiveController.insertLink(file.name, res.link.toString(), true);
          setState(() {
            isloading = true;
          });
        } else {
          setState(() {
            isloading = true;
          });
        }
      } on Exception catch (e) {
        setState(() {
          isloading = true;
        });
        print("EXCEPTION:::${e.toString()}");
        Navigator.of(context).pop();
        setState(() {
          isloading = true;
        });
      }
    } else {
      setState(() {
        isloading = true;
      });
    }
  }

  timeOutSaveAnswer(CommonViewModel common) async {
    try {
      setState(() {
        isloading = true;
      });
      var content = widget.quiz?["questions"][_tabController.index]
      ["question_type"] ==
          "subjective"
          ? await subjectiveController.getText()
          : null;
      final request = jsonEncode({
        "answer": widget.quiz?["questions"][_tabController.index]
        ["question_type"] ==
            "Subjective"
            ? content
            : "",
        "isSubjective": widget.quiz?["questions"][_tabController.index]
        ["question_type"] ==
            "subjective"
            ? true
            : false,
        "objectiveAnswers": widget
            .quiz!["questions"][_tabController.index]["options"].isNotEmpty
            ? common.quizselectedAnswer
            : [],
        "question":
        widget.quiz["questions"][_tabController.index]["_id"].toString()
      });
      PostQuizAnswerResponse res =
      await QuizRepository().postQuizAnswer(request);
      if (res.success == true) {
        setState(() {
          isloading = true;
        });

        Fluttertoast.showToast(
            msg: "Answer Submitted Sucessfully",
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16,
            gravity: ToastGravity.TOP);
        setState(() {
          isloading = false;
        });
      } else {
        setState(() {
          isloading = true;
        });

        Fluttertoast.showToast(
            msg: "Failed to Submit Answer",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16,
            gravity: ToastGravity.TOP);
        setState(() {
          isloading = false;
        });
      }

      setState(() {
        isloading = false;
      });
    } catch (e) {
      setState(() {
        isloading = true;
      });

      Fluttertoast.showToast(
          msg: "Failed to Submit Answer",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16,
          gravity: ToastGravity.TOP);
    }

    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isloading == true ) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Consumer2<QuizViewModel, CommonViewModel>(
      builder: (context, viewModel, common, child) {
        var questionIndex =
        widget.quiz != null && widget.quiz['questions'] != null
            ? widget.quiz['questions'].length - 1
            : 0;

        return Scaffold(
            bottomSheet: Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              color: kWhite,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _tabController.index == 0
                        ? Container(
                      height: 1,
                    )
                        : ElevatedButton(
                        onPressed: () async {
                          if (_tabController.index > 0) {
                            try {
                              setState(() {
                                isloading = true;
                              });

                              var content = widget.quiz?["questions"]
                              [_tabController.index]
                              ["question_type"] ==
                                  "subjective"
                                  ? await subjectiveController.getText()
                                  : null;
                              final request = jsonEncode({
                                "answer": widget.quiz["questions"]
                                [_tabController.index]
                                ["question_type"] ==
                                    "subjective"
                                    ? content
                                    : "",
                                "isSubjective": widget.quiz?["questions"]
                                [_tabController.index]
                                ["question_type"] ==
                                    "subjective"
                                    ? true
                                    : false,
                                "objectiveAnswers": widget
                                    .quiz["questions"]
                                [_tabController.index]
                                ["options"]
                                    .isNotEmpty
                                    ? common.quizselectedAnswer
                                    : [],
                                "question": widget.quiz!["questions"]![
                                _tabController.index]["_id"]
                                    .toString()
                              });
                              PostQuizAnswerResponse res =
                              await QuizRepository()
                                  .postQuizAnswer(request);
                              if (res.success == true) {
                                setState(() {
                                  isloading = true;

                                  common.quizselectedAnswer.clear();
                                });

                                Fluttertoast.showToast(
                                    msg: "Answer Submitted Sucessfully",
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16,
                                    gravity: ToastGravity.TOP);

                                // snackThis(
                                //     context: context,
                                //     content: Text(
                                //         "Answer was saved Sucessfully"),
                                //     color: Colors.green,
                                //     duration: 1,
                                //     behavior: SnackBarBehavior.floating);

                                subjectiveController.clear();

                                viewModel
                                    .fetchMyQuizAnswer(widget
                                    .quiz['questions']
                                [_tabController.index - 1]
                                ["_id"]
                                    .toString())
                                    .then((_) {
                                  if (viewModel.myQuizAnswer.answer!
                                      .isSubjective ==
                                      true) {
                                    setState(() {
                                      subjectiveController.insertText(
                                          viewModel.myQuizAnswer.answer
                                              ?.answer ??
                                              '');
                                    });
                                  } else {
                                    for (int i = 0;
                                    i <
                                        viewModel.myQuizAnswer.answer!
                                            .objectiveAnswers!.length;
                                    i++) {
                                      setState(() {
                                        common.quizselectedAnswer.add(
                                            viewModel.myQuizAnswer.answer!
                                                .objectiveAnswers![i]);
                                      });
                                    }
                                  }
                                });

                                setState(() {
                                  _tabController
                                      .animateTo(_tabController.index - 1);
                                  isloading = false;
                                });
                              } else {
                                setState(() {
                                  isloading = true;
                                });

                                Fluttertoast.showToast(
                                    msg: "Failed to Submit Answer",
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16,
                                    gravity: ToastGravity.TOP);


                                setState(() {
                                  isloading = false;
                                });
                              }
                              setState(() {
                                isloading = false;
                              });
                            } catch (e) {
                              setState(() {
                                isloading = true;
                              });

                              Fluttertoast.showToast(
                                  msg: e.toString(),
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16,
                                  gravity: ToastGravity.TOP);
                              setState(() {
                                isloading = false;
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: logoTheme,
                            fixedSize: const Size(150, 55),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: const Text(
                          "Previous",
                          style: TextStyle(
                              fontSize: 16,
                              color: kWhite,
                              fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    _tabController.index == questionIndex
                        ? ElevatedButton(
                        onPressed: () async {
                          try {
                            List finalQuizAnswer = [];
                            setState(() {
                              isloading = true;
                            });

                            var content = widget.quiz?["questions"]
                            [_tabController.index]
                            ["question_type"] ==
                                "subjective"
                                ? await subjectiveController.getText()
                                : null;
                            final request = jsonEncode({
                              "answer": widget.quiz?["questions"]
                              [_tabController.index]
                              ["question_type"] ==
                                  "Subjective"
                                  ? content
                                  : "",
                              "isSubjective": widget.quiz?["questions"]
                              [_tabController.index]
                              ["question_type"] ==
                                  "subjective"
                                  ? true
                                  : false,
                              "objectiveAnswers": widget
                                  .quiz!["questions"]
                              [_tabController.index]["options"]
                                  .isNotEmpty
                                  ? common.quizselectedAnswer
                                  : [],
                              "question": widget.quiz["questions"]
                              [_tabController.index]["_id"]
                                  .toString()
                            });
                            PostQuizAnswerResponse res =
                            await QuizRepository()
                                .postQuizAnswer(request);
                            if (res.success == true) {
                              setState(() {
                                isloading = true;
                              });
                              finishQuizShowAlertDialog(
                                  context, widget.quiz!["_id"].toString());

                              Fluttertoast.showToast(
                                  msg: "Answer Submitted Sucessfully",
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16,
                                  gravity: ToastGravity.TOP);

                              // snackThis(
                              //     context: context,
                              //     content:
                              //         Text("Answer Submitted Sucessfully"),
                              //     color: Colors.green,
                              //     duration: 1,
                              //     behavior: SnackBarBehavior.floating);
                              setState(() {
                                isloading = false;
                              });
                            } else {
                              setState(() {
                                isloading = true;
                              });

                              Fluttertoast.showToast(
                                  msg: "Failed to Submit Answer",
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16,
                                  gravity: ToastGravity.TOP);


                              setState(() {
                                isloading = false;
                              });
                            }

                            setState(() {
                              isloading = false;
                            });
                          } catch (e) {
                            setState(() {
                              isloading = true;
                            });

                            Fluttertoast.showToast(
                                msg: "Failed to Submit Answer",
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16,
                                gravity: ToastGravity.TOP);

                          }

                          setState(() {
                            isloading = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kpink,
                            fixedSize: const Size(150, 55),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: const Text(
                          "Finish",
                          style: TextStyle(
                              color: kWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ))
                        : ElevatedButton(
                        onPressed: () async {
                          if (_tabController.index <
                              widget.quiz['questions'].length) {
                            try {
                              setState(() {
                                isloading = true;
                              });

                              var content = widget.quiz?["questions"]
                              [_tabController.index]
                              ["question_type"] ==
                                  "subjective"
                                  ? await subjectiveController.getText()
                                  : null;
                              final request = jsonEncode({
                                "answer": widget.quiz["questions"]
                                [_tabController.index]
                                ["question_type"] ==
                                    "subjective"
                                    ? content
                                    : "",
                                "isSubjective": widget.quiz?["questions"]
                                [_tabController.index]
                                ["question_type"] ==
                                    "subjective"
                                    ? true
                                    : false,
                                "objectiveAnswers": widget
                                    .quiz["questions"]
                                [_tabController.index]
                                ["options"]
                                    .isNotEmpty
                                    ? common.quizselectedAnswer
                                    : [],
                                "question": widget.quiz!["questions"]![
                                _tabController.index]["_id"]
                                    .toString()
                              });
                              PostQuizAnswerResponse res =
                              await QuizRepository()
                                  .postQuizAnswer(request);
                              if (res.success == true) {
                                setState(() {
                                  isloading = true;

                                  common.quizselectedAnswer.clear();
                                });

                                // snackThis(
                                //     context: context,
                                //     content: Text(
                                //         "Answer was saved Sucessfully"),
                                //     color: Colors.green,
                                //     duration: 1,
                                //     behavior: SnackBarBehavior.floating);

                                Fluttertoast.showToast(
                                    msg: "Answer Submitted Sucessfully",
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16,
                                    gravity: ToastGravity.TOP);

                                subjectiveController.clear();

                                viewModel
                                    .fetchMyQuizAnswer(widget
                                    .quiz['questions']
                                [_tabController.index + 1]
                                ["_id"]
                                    .toString())
                                    .then((_) {
                                  if (viewModel.myQuizAnswer.answer!
                                      .isSubjective ==
                                      true) {
                                    setState(() {
                                      subjectiveController.insertText(
                                          viewModel.myQuizAnswer.answer
                                              ?.answer ??
                                              '');
                                    });
                                  } else {
                                    for (int i = 0;
                                    i <
                                        viewModel.myQuizAnswer.answer!
                                            .objectiveAnswers!.length;
                                    i++) {
                                      setState(() {
                                        common.quizselectedAnswer.add(
                                            viewModel.myQuizAnswer.answer!
                                                .objectiveAnswers![i]);
                                      });
                                    }
                                  }
                                });

                                setState(() {
                                  _tabController
                                      .animateTo(_tabController.index + 1);
                                  isloading = false;
                                });
                              } else {
                                setState(() {
                                  isloading = true;
                                });

                                Fluttertoast.showToast(
                                    msg: "Failed to Submit Answer",
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16,
                                    gravity: ToastGravity.TOP);


                                setState(() {
                                  isloading = false;
                                });
                              }
                              setState(() {
                                isloading = false;
                              });
                            } catch (e) {
                              setState(() {
                                isloading = true;
                              });

                              Fluttertoast.showToast(
                                  msg: e.toString(),
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16,
                                  gravity: ToastGravity.TOP);

                              setState(() {
                                isloading = false;
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff38853B),
                            fixedSize: const Size(150, 55),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: const Text(
                          "Next",
                          style: TextStyle(
                              color: kWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              centerTitle: false,
              title: const Text("Weekly Quiz", style: TextStyle(color: white)),
              elevation: 0.0,
              actions: [],
            ),
            body: isLoading(viewModel.myQuizAnswerApiResponse)
                ? const Center(child: CupertinoActivityIndicator())
                : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      isLoading(viewModel.quizServerTimeApiResponse)
                          ? Container()
                          : Builder(builder: (context) {
                        String time = viewModel.meDuration.toString();
                        List<String> parts = time.split('.');
                        return Text(
                          parts[0].toString(),
                          style: const TextStyle(
                              color: Color(0xfff33066),
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        );
                      }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 70,
                          child: Card(
                            color: logoTheme,
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Attempted Questions ${_tabController.index + 1}/${widget.quiz!["questions"]?.length}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: kWhite),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.visibility,
                                      color: kWhite,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          content: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Container(
                                              constraints:
                                              const BoxConstraints(
                                                  maxHeight: 130),
                                              child: Column(
                                                mainAxisSize:
                                                MainAxisSize.max,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        "Review Your Answers",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.close),
                                                        onPressed: () {
                                                          Navigator.of(
                                                              context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Divider(
                                                          color: kpink,
                                                          thickness: 2,
                                                          endIndent: 8,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 1,
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .arrow_forward_ios_sharp,
                                                        color: kpink,
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TabBar(
                                                    isScrollable: true,
                                                    labelColor: Colors.white,
                                                    unselectedLabelStyle:
                                                    const TextStyle(
                                                        color:
                                                        Colors.black),
                                                    labelPadding:
                                                    EdgeInsets.zero,
                                                    indicatorSize:
                                                    TabBarIndicatorSize
                                                        .tab,
                                                    padding: EdgeInsets.zero,
                                                    indicatorColor:
                                                    Colors.white,
                                                    onTap: (int value) {
                                                      setState(() {
                                                        quizCurrentIndex =
                                                            value;
                                                      });
                                                      subjectiveController
                                                          .clear();
                                                      common
                                                          .quizselectedAnswer
                                                          .clear();
                                                      viewModel
                                                          .fetchMyQuizAnswer(widget
                                                          .quiz[
                                                      'questions']
                                                      [
                                                      quizCurrentIndex]
                                                      ["_id"]
                                                          .toString())
                                                          .then((_) {
                                                        if (viewModel
                                                            .myQuizAnswer
                                                            .answer!
                                                            .isSubjective ==
                                                            true) {
                                                          setState(() {
                                                            subjectiveController
                                                                .insertText(viewModel
                                                                .myQuizAnswer
                                                                .answer
                                                                ?.answer ??
                                                                '');
                                                          });
                                                        } else {
                                                          for (int i = 0;
                                                          i <
                                                              viewModel
                                                                  .myQuizAnswer
                                                                  .answer!
                                                                  .objectiveAnswers!
                                                                  .length;
                                                          i++) {
                                                            setState(() {
                                                              common
                                                                  .quizselectedAnswer
                                                                  .add(viewModel
                                                                  .myQuizAnswer
                                                                  .answer!
                                                                  .objectiveAnswers![i]);
                                                            });
                                                          }
                                                        }
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    controller:
                                                    _tabController,
                                                    labelStyle:
                                                    const TextStyle(
                                                        color:
                                                        Colors.white,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                    tabs: [
                                                      ...List.generate(
                                                          widget
                                                              .quiz![
                                                          "questions"]
                                                              .length,
                                                              (index) => Tab(
                                                              child:
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                    right:
                                                                    15),
                                                                child:
                                                                Container(
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        35),
                                                                    color: _tabController.index ==
                                                                        index
                                                                        ? kpink
                                                                        : Colors
                                                                        .grey,
                                                                  ),
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                      15,
                                                                      horizontal:
                                                                      20),
                                                                  child: Text(
                                                                    "${index + 1}",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                        16),
                                                                  ),
                                                                ),
                                                              )))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          color: const Color(0XFFffe9e9),
                          child: RichText(
                            text: TextSpan(
                                text:
                                'This is just for navigation. It will not submit your answer. Click ',
                                style: const TextStyle(
                                    color: Color(0xfff33066), fontSize: 16),
                                children: [
                                  WidgetSpan(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0xff38853B),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 0),
                                      margin: const EdgeInsets.only(right: 5),
                                      child: const Text(
                                        "Next",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const TextSpan(
                                    text: "/ ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                  ),
                                  WidgetSpan(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: logoTheme,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 0),
                                      child: const Text(
                                        "Previous",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const TextSpan(
                                    text: " to submit you answer.",
                                    style:
                                    TextStyle(color: Color(0xfff33066)),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: TabBarView(
                            controller: _tabController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              ...List.generate(
                                  widget.quiz['questions'].length, (index) {
                                return _questionAnswerWidget(
                                    widget.quiz['questions'][index],
                                    viewModel);
                              })
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )));
      },
    );
  }

  Widget _questionWidget(dynamic quizquestions, QuizViewModel quizViewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Html(
                      style: {
                        "body": Style(
                          fontSize: FontSize(18.0),
                          fontWeight: FontWeight.bold,
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                        ),
                        "p": Style(
                          margin: const EdgeInsets.all(3),
                        ),
                        "h1": Style(margin: const EdgeInsets.all(3)),
                        "table": Style(margin: const EdgeInsets.all(3)),
                        "tr": Style(margin: const EdgeInsets.all(3)),
                        "td": Style(margin: const EdgeInsets.all(3)),
                      },
                      shrinkWrap: true,
                      data: '${quizquestions['question'].toString()} ',
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
                        var linkUrl = url!.replaceAll(" ", "%20");
                        launch(linkUrl);
                      },
                      onImageTap: (String? url,
                          RenderContext context,
                          Map<String, String> attributes,
                          dom.Element? element) {
                        launch(url!);
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Row(children: [
                  quizquestions["question_type"] == "single" ||
                      quizquestions["question_type"] == "true/false"
                      ? const Text(
                    "(Choose one option)",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )
                      : quizquestions["question_type"] == "multiple"
                      ? const Text(
                    "(Choose all possible options)",
                    style: TextStyle(color: Colors.grey),
                  )
                      : Container(),
                ]),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _oneOptionQuestionWidget(
      dynamic quizquestions, QuizViewModel viewModel) {
    return Consumer<CommonViewModel>(builder: (context, common, child) {
      return Column(
        children: [
          _questionWidget(quizquestions, viewModel),
          ListView.builder(
              padding: EdgeInsets.zero,
              physics: const ScrollPhysics(),
              itemCount: quizquestions['options'].length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var datas = quizquestions['options'][index];
                return Row(
                  children: [
                    Checkbox(
                      value: common.quizselectedAnswer.contains(datas),
                      onChanged: (_) {
                        if (quizquestions["question_type"]
                            .toString()
                            .toLowerCase() ==
                            "single" ||
                            quizquestions["question_type"]
                                .toString()
                                .toLowerCase() ==
                                "true/false") {
                          setState(() {
                            common.quizselectedAnswer.clear();
                            common.quizselectedAnswer.add(datas);
                          });
                        } else if (quizquestions["question_type"]
                            .toString()
                            .toLowerCase() ==
                            "multiple") {
                          if (common.quizselectedAnswer.contains(datas)) {
                            setState(() {
                              common.quizselectedAnswer.remove(datas);
                            });
                          } else {
                            setState(() {
                              common.quizselectedAnswer.add(datas);
                            });
                          }
                        }
                      },
                      activeColor: Colors.blueAccent,
                    ),
                    Expanded(child: Text(datas.toString()))
                  ],
                );
              }),
        ],
      );
    });
  }

  Widget _subjectiveQuestionWidget(
      dynamic quizquestions, QuizViewModel viewModel) {
    return Column(
      children: [
        _questionWidget(quizquestions, viewModel),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "(${((quizquestions['questionWeightage'].toString()))} Marks)",
                  style: const TextStyle(
                    fontSize: 16.0,
                  )),
            ],
          ),
        ),
        ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            HtmlEditor(
              controller: subjectiveController,
              htmlEditorOptions: HtmlEditorOptions(
                initialText: viewModel.myQuizAnswer.answer == null
                    ? ""
                    : viewModel.myQuizAnswer.answer?.answer,
                shouldEnsureVisible: true,
                hint: "Your answer here...",
              ),
              htmlToolbarOptions: HtmlToolbarOptions(
                defaultToolbarButtons: [
                  const StyleButtons(),
                  const FontSettingButtons(),
                  const ListButtons(),
                  const ParagraphButtons(),
                  const InsertButtons(
                      otherFile: true, video: false, audio: false),
                  const OtherButtons(
                    copy: false,
                    paste: false,
                  ),
                ],
                onOtherFileUpload: (file) async {
                  var response = await uploadFile(file);
                  return response;
                },
                toolbarPosition: ToolbarPosition.aboveEditor,
                toolbarType: ToolbarType.nativeExpandable,
                mediaLinkInsertInterceptor: (String url, InsertFileType type) {
                  return true;
                },
                mediaUploadInterceptor:
                    (PlatformFile file, InsertFileType type) async {
                  return true;
                },
              ),
              otherOptions: const OtherOptions(height: 500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _questionAnswerWidget(dynamic quizquestions, QuizViewModel viewModel) {
    Widget outer = Container();
    return Builder(builder: (context) {
      if (quizquestions["question_type"] == "subjective") {
        outer = _subjectiveQuestionWidget(quizquestions, viewModel);
      } else if (quizquestions["question_type"] == "single" ||
          quizquestions["question_type"] == "multiple" ||
          quizquestions["question_type"] == "true/false") {
        outer = _oneOptionQuestionWidget(quizquestions, viewModel);
      } else {
        outer = Container();
      }
      return outer;
    });
  }

  finishQuizShowAlertDialog(BuildContext context, String quizId) {
    Widget okButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Color(0xfff33066),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        child: Text(
          "Confirm",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          try {
            setState(() {
              isloading = true;
            });
            QuizCompleteResponse res =
            await QuizRepository().updateQuizCompletion(quizId);
            if (res.success == true) {
              setState(() {
                isloading = true;
              });
              Navigator.of(context).popUntil((route) => route.isFirst);

              Fluttertoast.showToast(
                  msg: "Quiz Submitted Sucessfully",
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16,
                  gravity: ToastGravity.TOP);


              // snackThis(
              //     context: context,
              //     content: Text("Quiz Submitted Sucessfully"),
              //     color: Colors.green,
              //     duration: 1,
              //     behavior: SnackBarBehavior.floating);
              setState(() {
                isloading = false;
              });
            } else {
              setState(() {
                isloading = true;
              });
              Navigator.pop(context);

              Fluttertoast.showToast(
                  msg: "Failed to Submit Quiz",
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16,
                  gravity: ToastGravity.TOP);
              setState(() {
                isloading = false;
              });
            }
            setState(() {
              isloading = false;
            });
          } catch (e) {
            setState(() {
              isloading = true;
            });
            Navigator.pop(context);

            Fluttertoast.showToast(
                msg: "Failed to Submit Quiz",
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16,
                gravity: ToastGravity.TOP);

            // snackThis(
            //     context: context,
            //     content: Text("Failed to Submit Quiz"),
            //     color: Colors.red,
            //     duration: 1,
            //     behavior: SnackBarBehavior.floating);
            setState(() {
              isloading = false;
            });
          }
        });

    Widget cancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: logoTheme,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      child: Text(
        "Cancel",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Finish Quiz",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      content: Text(
        "Make sure you have submitted and rechecked all of your answers",
      ),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}