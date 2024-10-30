import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html/dom.dart' as dom;
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/student/exam/exam_view_model.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/response/exam_with_question_response.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../api/repositories/exam_repo.dart';
import '../../../api/repositories/lecturer/homework_repository.dart';
import '../../../config/api_response_config.dart';
import '../../../constants.dart';
import '../../../constants/colors.dart';
import '../../../helper/custom_loader.dart';
import '../../../response/exam_completed_response.dart';
import '../../../response/exam_submit_answer_response.dart';
// import '../../../response/exam_with_question_response.dart' ;
import '../../../response/file_upload_response.dart';
// import '../../../response/question_answer_response.dart';
import '../../widgets/snack_bar.dart';

class ExamQuestionScreen extends StatefulWidget {
  Exam? exam;
  String? examId;
  ExamQuestionScreen({Key? key, required this.exam, required this.examId})
      : super(key: key);
  @override
  State<ExamQuestionScreen> createState() => _ExamQuestionScreenState();
}

class _ExamQuestionScreenState extends State<ExamQuestionScreen>
    with TickerProviderStateMixin {
  final HtmlEditorController subjectiveController = HtmlEditorController();
  // bool isloading = false;
  int currentIndex = 0;
  late TabController _tabController;
  late ExamViewModel _provider;
  late CommonViewModel _provider2;
  late String timeerCount;
  bool markQuestionValue = true;
  List listOfFlaggedQuestionId = [];

  @override
  void initState() {
    super.initState();

    _tabController =
        TabController(vsync: this, length: widget.exam!.questions!.length);
    listOfFlaggedQuestionId.clear();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider2 = Provider.of<CommonViewModel>(context, listen: false);
      _provider = Provider.of<ExamViewModel>(context, listen: false);
      getData().then((_) {
        setTimer();
      });
      try {
        _provider2.removeSelectAnswer();
        if (_provider.examWithQuestion.exam != null &&
            _provider.examWithQuestion.exam!.questions != null &&
            _provider.examWithQuestion.exam!.questions!.isNotEmpty) {
          _provider
              .fetchMyAnswer(_provider
                  .examWithQuestion.exam!.questions![_tabController.index].sId
                  .toString())
              .then((_) {
            _provider.examWithQuestion.exam!.questions![_tabController.index]
                .options!
                .asMap()
                .forEach((key, value) {
              if (_provider.myAnswer.answer != null) {
                if (_provider.myAnswer.answer!.isSubjective == false) {
                  if (_provider.myAnswer.answer!.objectiveAnswers!
                      .contains(value)) {
                    _provider2.setSelectAnswerList(key);
                  }
                } else if (_provider.myAnswer.answer!.isSubjective == true) {
                  subjectiveController
                      .setText(_provider.myAnswer.answer!.answer.toString());
                }
              }
            });
          });
        }
      } catch (e) {}
      subjectiveController.clear();
    });
  }

  Future<void> setTimer() async {
    bool passedOneFifty = false;
    bool passedFIveFifty = false;
    bool finalTime = false;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (this.mounted) {
        setState(() {
          _provider.setDuration(_provider.myDuration - const Duration(seconds: 1));
        });
      }
      if (_provider.myDuration.inMinutes >= 5 &&
          _provider.myDuration.inSeconds >= 50) {
        if (!passedFIveFifty) {
          Future.delayed(Duration(minutes: _provider.myDuration.inMinutes - 5),
              () {
            if (mounted) {
               getData();
            }
          });
          passedFIveFifty = true;
        }
      }
      else if (_provider.myDuration.inMinutes >= 1 &&
          _provider.myDuration.inSeconds >= 50) {
        if (!passedOneFifty) {
          Future.delayed(Duration(minutes: _provider.myDuration.inMinutes - 1),
              () {
            if (mounted) {
              getData();
            }
          });
          passedOneFifty = true;
        }
      }
      else if (_provider.myDuration.inSeconds <= 0 && finalTime == false) {
        setState(() {
          finalTime = true;
        });
        print("TIME CANCLEDD:::");
        timer.cancel();
        submitFinalAnswerApi();
        return;
      }
    });
  }

  Future<void> getData() async {
    // await _provider.fetchAExamQuestionAnswer(widget.examId.toString());

    await _provider.fetchServerTime().then((dynamic value2) {
      DateTime convertToNepaliTime = DateTime.parse(_provider.serverTime["raw"])
          .add(const Duration(hours: 5, minutes: 45));
      DateTime endDate =
          DateTime.parse(_provider.examWithQuestion.exam!.endDate!)
              .add(const Duration(hours: 5, minutes: 45));
      _provider.setDuration(endDate.difference(convertToNepaliTime));
      // setTimer();
      // });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    subjectiveController.clear();
    super.dispose();
  }

  Future uploadFile(PlatformFile file) async {
    customLoadStart();
    if (file != null) {
      try {
      FileUploadResponse res = await HomeworkRepository()
          .addHomeWorkFile(file.path.toString(), file.name);
        if (res.success == true) {
          subjectiveController.insertLink(file.name, res.link.toString(), true);
        }
      } on Exception catch (e) {

        print("EXCEPTION:::${e.toString()}");
        Navigator.of(context).pop();
      }
      finally {
        customLoadStop();
      }
    }
  }

  submitFinalAnswerApi() async {
    try {
      ExamCompletedResponse res = await ExamRepository()
          .examCompleted(_provider.examWithQuestion.exam?.sId ?? "");
      // setState(() {
      //   isloading = false;
      // });
      //You have already completed this exam!

      Fluttertoast.showToast(
          msg: "You have completed this exam!",
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green);
      if (context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    finally {
      customLoadStop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (isloading == true ) {
    //   customLoadStart();
    // } else {
    //   customLoadStop();
    // }
    return Consumer2<ExamViewModel, CommonViewModel>(
        builder: (context, viewModel, common, child) {
      return Scaffold(
        body: isLoading(viewModel.examWithQuestionApiResponse)
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : DefaultTabController(
                length: viewModel.examWithQuestion.exam?.questions?.length ?? 0,
                child: Scaffold(
                  appBar: AppBar(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.timer,
                          size: 28,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        isLoading(viewModel.serverTimeApiResponse)
                            ? const Text("--")
                            : Builder(builder: (context) {
                                String time = viewModel.myDuration.toString();
                                List<String> parts = time.split('.');
                                var splitTime = parts[0].split(":");
                                return Text(
                                  parts[0].toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                );
                              }),
                      ],
                    ),
                    elevation: 0,
                  ),
                  body: RefreshIndicator(
                    onRefresh: () async {
                      await getData();
                      await viewModel.fetchExamWithQuestion(
                          viewModel.examDetails.exam?.id ?? "");
                    },
                    child: NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverOverlapAbsorber(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                            sliver: SliverAppBar(
                              automaticallyImplyLeading: false,
                              title: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0XFFffe9e9),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: RichText(
                                      text: const TextSpan(
                                          text:
                                              'This is just for navigation. It will not submit your answer. Click ',
                                          style: TextStyle(
                                              color: Color(0xfff33066),
                                              fontSize: 16),
                                          children: [
                                            TextSpan(
                                              text: " Next ",
                                              style: TextStyle(
                                                  color: Color(0xfff33066)),
                                            ),
                                            TextSpan(
                                              text: "/ ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black),
                                            ),
                                            TextSpan(
                                              text: " Previous",
                                              style: TextStyle(
                                                  color: Color(0xfff33066)),
                                            ),
                                            TextSpan(
                                              text: " to submit you answer.",
                                              style: TextStyle(
                                                  color: Color(0xfff33066)),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                              floating: true,
                              pinned: true,
                              snap: false,
                              primary: true,
                              expandedHeight: 130,
                              forceElevated: innerBoxIsScrolled,
                              bottom: TabBar(
                                isScrollable: true,
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.white,
                                unselectedLabelStyle:
                                    const TextStyle(color: Colors.black),
                                labelPadding: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                indicator: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.transparent, width: 0)),
                                ),
                                onTap: (int value) {
                                  setState(() {
                                    currentIndex = value;
                                  });
                                  subjectiveController.clear();
                                  common.selectedAnswer.clear();
                                  viewModel
                                      .fetchMyAnswer(viewModel
                                          .examWithQuestion.exam?.questions?[_tabController.index].sId ?? "")
                                      .then((value) {
                                    viewModel
                                        .examWithQuestion
                                        .exam?.questions?[_tabController.index].options?.asMap()
                                        .forEach((key, value) {
                                      if (viewModel
                                          .myAnswer.answer!.objectiveAnswers!
                                          .contains(value)) {
                                        common.selectedAnswer.add(key);
                                      }
                                    });
                                  });
                                },
                                controller: _tabController,
                                labelStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                tabs: [
                                  ...List.generate(
                                      viewModel.examWithQuestion.exam?.questions?.length ?? 0,
                                      (index) => Tab(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: _tabController.index ==
                                                          index
                                                      ? Colors.blueAccent
                                                      : Colors.black,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 15),
                                                child:
                                                    Text("Q.N. ${index + 1}"),
                                              ),
                                            ),
                                          ))
                                ],
                              ),
                            ),
                          ),
                        ];
                      },
                      body: isLoading(viewModel.myAnswerApiResponse)
                          ? const Center(child: CupertinoActivityIndicator())
                          : TabBarView(
                              controller: _tabController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: <Widget>[
                                ...List.generate(
                                    viewModel.examWithQuestion.exam?.questions?.length ?? 0, (index) {
                                  return SafeArea(
                                    top: false,
                                    bottom: false,
                                    child: Builder(
                                      builder: (BuildContext context) {
                                        return CustomScrollView(
                                          // key: PageStorageKey<String>(name),
                                          slivers: <Widget>[
                                            SliverOverlapInjector(
                                              handle: NestedScrollView
                                                  .sliverOverlapAbsorberHandleFor(
                                                      context),
                                            ),
                                            SliverPadding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              sliver: SliverToBoxAdapter(
                                                child: _questionAnswerWidget(
                                                    viewModel
                                                        .examWithQuestion
                                                        .exam!
                                                        .questions![index],
                                                    viewModel,
                                                    common),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                })
                              ],
                            ),
                    ),
                  ),
                ),
              ),
      );
    });
  }

  Widget _questionAnswerWidget(
      Questions questions, ExamViewModel viewModel, CommonViewModel common) {
    Widget outer = Container();
    return Builder(builder: (context) {
      if (questions.questionType == "subjective") {
        outer = _subjectiveQuestionWidget(questions, viewModel, common);
      } else if (questions.questionType == "single" ||
          questions.questionType == "multiple" ||
          questions.questionType == "true/false") {
        outer = _oneOptionQuestionWidget(questions, viewModel, common);
      } else {
        outer = Container();
      }
      return outer;
    });
  }

  Widget _questionWidget(Questions questions, ExamViewModel examViewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                        "ol": Style(margin: const EdgeInsets.all(5)),
                        "p": Style(margin: const EdgeInsets.all(3)),
                        "h1": Style(margin: const EdgeInsets.all(3)),
                        "table": Style(margin: const EdgeInsets.all(3)),
                        "tr": Style(margin: const EdgeInsets.all(3)),
                        "td": Style(margin: const EdgeInsets.all(3)),
                      },
                      shrinkWrap: true,
                      data: questions.question.toString(),
                      customRender: {
                        "table": (context, child) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: (context.tree as TableLayoutElement)
                                .toWidget(context),
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
                  // const SizedBox(
                  //   width: 8,
                  // ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                questions.questionType == "single" ||
                        questions.questionType == "true/false"
                    ? const Text(
                        "(Choose one option)",
                        style: TextStyle(color: Colors.grey),
                      )
                    : questions.questionType == "multiple"
                        ? const Text(
                            "(Choose multiple option)",
                            style: TextStyle(color: Colors.grey),
                          )
                        : Container(),
                Text(
                  "(${questions.fullMarks.toString()} Marks)",
                  style: const TextStyle(fontSize: 14),
                ),
              ]),
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
      Questions questions, ExamViewModel viewModel, CommonViewModel common) {
    return Column(
      children: [
        _questionWidget(questions, viewModel),
        ListView.builder(
            padding: EdgeInsets.zero,
            physics: const ScrollPhysics(),
            itemCount: questions.options?.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Builder(builder: (context) {
                    return Checkbox(
                      value: common.selectedAnswer.contains(index),
                      onChanged: (newValue) {
                        if (questions.questionType == "single" ||
                            questions.questionType == "true/false") {
                          if (newValue == true) {
                            setState(() {
                              common.selectedAnswer.clear();
                              common.selectedAnswer.add(index);
                            });
                          } else if (newValue == false) {
                            common.selectedAnswer.clear();
                          }
                        } else if (questions.questionType == "multiple") {
                          print("VALUE::::::${newValue}");
                          if (newValue == true) {
                            common.selectedAnswer.add(index);
                          } else if (newValue == false) {
                            common.selectedAnswer.remove(index);
                          }
                        }
                      },
                      activeColor: Colors.blueAccent,
                    );
                  }),
                  Expanded(child: Text(questions.options![index]))
                ],
              );
            }),
        const SizedBox(
          height: 10,
        ),
        _navigationWidget(viewModel, common),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _subjectiveQuestionWidget(
      Questions questions, ExamViewModel viewModel, CommonViewModel common) {
    return Column(
      children: [
        _questionWidget(questions, viewModel),
        ListView(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          children: [
            Builder(builder: (context) {
              if (viewModel.examWithQuestion.exam?.questions?[currentIndex]
                      .questionType ==
                  " subjective") {}

              return HtmlEditor(
                controller: subjectiveController,
                htmlEditorOptions: HtmlEditorOptions(
                  // mobileLongPressDuration: const Duration(seconds: 6),
                  spellCheck: false,
                  // mobileContextMenu: ContextMenu(onContextMenuActionItemClicked: null, ),
                  adjustHeightForKeyboard: false,
                  initialText: viewModel.myAnswer.answer == null
                      ? ""
                      : viewModel.myAnswer.answer?.answer,
                  shouldEnsureVisible: true,
                  hint: "Your text here...",
                ),
                htmlToolbarOptions: HtmlToolbarOptions(
                  defaultToolbarButtons: [
                    const StyleButtons(style: false),
                    const FontSettingButtons(
                        fontName: false, fontSize: false, fontSizeUnit: false),
                    const ListButtons(),
                    const ParagraphButtons(
                        alignCenter: false,
                        alignJustify: false,
                        alignLeft: false,
                        alignRight: false,
                        caseConverter: false,
                        decreaseIndent: false,
                        increaseIndent: false,
                        lineHeight: false,
                        textDirection: false),
                    const InsertButtons(
                      otherFile: true,
                      video: false,
                      audio: false,
                      table: false,
                      hr: false,
                    ),
                    const OtherButtons(
                        copy: false,
                        paste: false,
                        fullscreen: false,
                        codeview: false,
                        help: false,
                        redo: false,
                        undo: false),
                  ],
                  onOtherFileUpload: (file) async {
                    print(file);
                    var response = await uploadFile(file);
                    print(response);
                    return response;
                  },
                  toolbarPosition: ToolbarPosition.aboveEditor,
                  toolbarType: ToolbarType.nativeExpandable,
                  mediaLinkInsertInterceptor:
                      (String url, InsertFileType type) {
                    return true;
                  },
                  mediaUploadInterceptor:
                      (PlatformFile file, InsertFileType type) async {
                    return true;
                  },
                ),
                otherOptions: OtherOptions(
                  height: 500,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0)),
                ),
              );
            }),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        _navigationWidget(viewModel, common),
      ],
    );
  }

  Widget _navigationWidget(ExamViewModel viewModel, CommonViewModel common) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      color: Colors.white,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        color: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                          _tabController.animateTo(_tabController.index - 1);
                          try {
                            customLoadStart();

                            List finalAnswer = [];

                            common.selectedAnswer.forEach((element) {
                              finalAnswer.add(viewModel
                                  .examWithQuestion
                                  .exam!
                                  .questions![_tabController.previousIndex]
                                  .options![element]);
                            });
                            var content = viewModel
                                        .examWithQuestion.exam?.questions?[
                                            _tabController.previousIndex]
                                        .questionType ==
                                    "subjective"
                                ? await subjectiveController.getText()
                                : null;
                            final request = jsonEncode({
                              "answer": viewModel
                                          .examWithQuestion.exam?.questions?[
                                              _tabController.previousIndex]
                                          .questionType ==
                                      "subjective"
                                  ? content
                                  : " ",
                              "codeAnswer": viewModel
                                          .examWithQuestion.exam?.questions?[
                                              _tabController.previousIndex]
                                          .hasCodeAnswer ==
                                      false
                                  ? ""
                                  : "",
                              "isSubjective": viewModel
                                          .examWithQuestion.exam?.questions?[
                                              _tabController.previousIndex]
                                          .questionType ==
                                      "subjective"
                                  ? true
                                  : false,
                              "objectiveAnswers": viewModel
                                      .examWithQuestion
                                      .exam!
                                      .questions![_tabController.previousIndex]
                                      .options!
                                      .isNotEmpty
                                  ? finalAnswer
                                  : [],
                              "question": viewModel.examWithQuestion.exam?.questions?[_tabController.previousIndex].sId
                                  .toString(),
                              "examId":viewModel.examWithQuestion.exam?.sId
                            });
                            ExamSubmitAnswerResponse res =
                                await ExamRepository().submitAnswer(request);
                            if (res.success == true) {
                              if (context.mounted) {
                                Fluttertoast.showToast(
                                    msg: "Answer Submitted Sucessfully",
                                    gravity: ToastGravity.TOP,
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.green);
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: res.message ?? "Failed to Submit Answer",
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 2,
                                  toastLength: Toast.LENGTH_LONG,
                                  backgroundColor: Colors.red);
                            }
                          } catch (e) {
                            Fluttertoast.showToast(
                                msg: "Failed to Submit Answer",
                                gravity: ToastGravity.TOP,
                                toastLength: Toast.LENGTH_LONG,
                                backgroundColor: Colors.red);
                          }
                          finally {
                            customLoadStop();
                          }
                          subjectiveController.clear();
                          common.selectedAnswer.clear();
                          viewModel
                              .fetchMyAnswer(viewModel.examWithQuestion.exam!
                                  .questions![_tabController.index].sId
                                  .toString())
                              .then((value) {
                            viewModel.examWithQuestion.exam!
                                .questions![_tabController.index].options!
                                .asMap()
                                .forEach((key, value) {
                              if (viewModel.myAnswer.answer != null) {
                                if (viewModel.myAnswer.answer!.objectiveAnswers!
                                    .contains(value)) {
                                  common.selectedAnswer.add(key);
                                }
                              }
                            });
                          });
                        }
                      },
                      child: const Text("Previous",
                          style: TextStyle(fontSize: 16))),
              const SizedBox(
                width: 10,
              ),
              _tabController.index ==
                      (viewModel.examWithQuestion.exam!.questions!.length - 1)
                  ? ElevatedButton(
                      onPressed: () async {
                        try {
                          customLoadStart();

                          List finalAnswer = [];

                          common.selectedAnswer.forEach((element) {
                            finalAnswer.add(viewModel
                                .examWithQuestion.exam?.questions?[_tabController.index].options?[element]);
                          });

                          var content = viewModel
                                      .examWithQuestion.exam?.questions?[_tabController.index]
                                      .questionType ==
                                  "subjective"
                              ? await subjectiveController.getText()
                              : null;
                          final request = jsonEncode({
                            "answer": viewModel
                                        .examWithQuestion
                                        .exam?.questions?[_tabController.index]
                                        .questionType ==
                                    "subjective"
                                ? content
                                : " ",
                            "codeAnswer": viewModel
                                        .examWithQuestion
                                        .exam?.questions?[_tabController.index]
                                        .hasCodeAnswer ==
                                    false
                                ? ""
                                : "",
                            "isSubjective": viewModel
                                        .examWithQuestion
                                        .exam?.questions?[_tabController.index]
                                        .questionType ==
                                    "subjective"
                                ? true
                                : false,
                            "objectiveAnswers": viewModel
                                    .examWithQuestion
                                    .exam!
                                    .questions![_tabController.index]
                                    .options!
                                    .isNotEmpty
                                ? finalAnswer
                                : [],
                            "question": viewModel.examWithQuestion.exam?.questions?[_tabController.index].sId
                                .toString(),
                            "examId":viewModel.examWithQuestion.exam?.sId
                          });
                          ExamSubmitAnswerResponse res =
                              await ExamRepository().submitAnswer(request);
                          if (res.success == true) {
                            showAlertDialog(
                                context,
                                viewModel.examWithQuestion.exam?.sId ?? "");
                            Fluttertoast.showToast(
                                msg: "Answer Submitted Sucessfully",
                                gravity: ToastGravity.TOP,
                                toastLength: Toast.LENGTH_SHORT,
                                backgroundColor: Colors.green);
                          }
                          else {
                            Fluttertoast.showToast(
                                msg: res.message ?? "Failed to Submit Answer",
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 2,
                                toastLength: Toast.LENGTH_LONG,
                                backgroundColor: Colors.red);
                          }
                        } catch (e) {

                          Fluttertoast.showToast(
                              msg: "Failed to Submit Answer",
                              gravity: ToastGravity.TOP,
                              toastLength: Toast.LENGTH_LONG,
                              backgroundColor: Colors.red);
                        } finally {
                          customLoadStop();
                        }
                      },
                      style:
                          ElevatedButton.styleFrom(primary: const Color(0xfff33066)),
                      child: const Text(
                        "Finish",
                        style: TextStyle(fontSize: 16),
                      ))
                  : ElevatedButton(
                      onPressed: () async {
                        if (_tabController.index <
                            viewModel
                                .examWithQuestion.exam!.questions!.length) {
                          _tabController.animateTo(_tabController.index + 1);
                          try {

                            customLoadStart();

                            List finalAnswer = [];

                            common.selectedAnswer.forEach((element) {
                              finalAnswer.add(viewModel
                                  .examWithQuestion.exam?.questions?[_tabController.previousIndex].options?[element]);
                            });
                            var content = viewModel
                                        .examWithQuestion.exam?.questions?[
                                            _tabController.previousIndex]
                                        .questionType ==
                                    "subjective"
                                ? await subjectiveController.getText()
                                : null;

                            final request = jsonEncode({
                              "answer": viewModel
                                          .examWithQuestion
                                          .exam?.questions?[
                                              _tabController.previousIndex]
                                          .questionType ==
                                      "subjective"
                                  ? content
                                  : " ",
                              "codeAnswer": viewModel
                                          .examWithQuestion
                                          .exam?.questions?[
                                              _tabController.previousIndex]
                                          .hasCodeAnswer ==
                                      false
                                  ? ""
                                  : "",
                              "isSubjective": viewModel
                                          .examWithQuestion
                                          .exam?.questions?[
                                              _tabController.previousIndex]
                                          .questionType ==
                                      "subjective"
                                  ? true
                                  : false,
                              "objectiveAnswers": viewModel
                                      .examWithQuestion
                                      .exam!
                                      .questions![_tabController.previousIndex]
                                      .options!
                                      .isNotEmpty
                                  ? finalAnswer
                                  : [],
                              "question": viewModel.examWithQuestion.exam?.questions?[_tabController.previousIndex].sId
                                  .toString(),
                              "examId":viewModel.examWithQuestion.exam?.sId
                            });

                            print("REQUEST:::${request}");
                            ExamSubmitAnswerResponse res =
                                await ExamRepository().submitAnswer(request);
                            if (res.success == true) {
                              print("MESSAGE:::${res.message}");
                              Fluttertoast.showToast(
                                  msg: "Answer Submitted Sucessfully",
                                  gravity: ToastGravity.TOP,
                                  toastLength: Toast.LENGTH_SHORT,
                                  backgroundColor: Colors.green);
                            }
                            else {
                              print("MESSAGE:::${res.message}");
                              Fluttertoast.showToast(
                                  msg: res.message ?? "Failed to Submit Answer",
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 2,
                                  toastLength: Toast.LENGTH_LONG,
                                  backgroundColor: Colors.red);
                            }
                          } catch (e) {
                            Fluttertoast.showToast(
                                msg: "Failed to Submit Answer",
                                gravity: ToastGravity.TOP,
                                toastLength: Toast.LENGTH_LONG,
                                backgroundColor: Colors.red);
                          }
                          finally {
                            customLoadStop();
                          }
                          subjectiveController.clear();
                          common.selectedAnswer.clear();
                          viewModel
                              .fetchMyAnswer(viewModel.examWithQuestion.exam?.questions?[_tabController.index].sId
                                  ?? "")
                              .then((value) {
                            viewModel.examWithQuestion.exam?.questions?[_tabController.index].options?.asMap()
                                .forEach((key, value) {
                              if (viewModel.myAnswer.answer != null) {
                                if (viewModel.myAnswer.answer!.objectiveAnswers!
                                    .contains(value)) {
                                  common.selectedAnswer.add(key);
                                }
                              }
                            });
                          });
                        }
                      },
                      child:
                          const Text("Next", style: TextStyle(fontSize: 16))),
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String examId) {
    Widget okButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: const Color(0xfff33066),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        child: const Text(
          "Confirm",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          try {
            ExamCompletedResponse res =
                await ExamRepository().examCompleted(examId);
            if (res.success == true) {
              Fluttertoast.showToast(
                  msg: "You have completed this exam!",
                  gravity: ToastGravity.TOP,
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Colors.green);
              if (context.mounted) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }

            }
            else {
              Fluttertoast.showToast(
                  msg: "Failed to Submit Answer",
                  gravity: ToastGravity.TOP,
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.red);
              if (context.mounted) {
                Navigator.pop(context);
              }
            }
          } catch (e) {
            Fluttertoast.showToast(
                msg: "Failed to Submit Answer",
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.red);
            Navigator.pop(context);

          }
          finally {
            customLoadStop();
          }
        });

    Widget cancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      child: const Text(
        "Cancel",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Finish Exam"),
      content: const Text(
          "Make sure you have submitted and rechecked all of your answers"),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
