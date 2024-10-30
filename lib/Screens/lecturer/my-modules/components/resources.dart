import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/lessoncontent_lecturer.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/lessoncontent_manipulate.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/lesson_repository.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/markcomplete_repository.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/lecturer/weekmarkascomplete_request.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/lecturer/senddraft_response.dart';
import 'package:schoolworkspro_app/response/lesson_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common_widgets/alert_box_widget.dart';
import '../../../../constants/colors.dart';
import '../../../../response/authenticateduser_response.dart';
import '../../../my_learning/learning_view_model.dart';

class ResourcesScreen extends StatefulWidget {
  final data;
  const ResourcesScreen({Key? key, this.data}) : super(key: key);

  @override
  _ResourcesScreenState createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  List<String> _selectedBatch = <String>[];
  List<bool> _isExpandedList = <bool>[];

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var _provider =
          Provider.of<LecturerCommonViewModel>(context, listen: false);
      var _provider2 = Provider.of<CommonViewModel>(context, listen: false);
      _provider.setSlug(widget.data['moduleSlug']);
      _provider.checkprogress(widget.data['moduleSlug']);
      _provider2.setSlug(widget.data['moduleSlug']);
      _provider.fetchlessons();
      _provider2.setSlug(widget.data['moduleSlug']);
      _provider2.fetchBatches();
      _provider2.fetchCurrentBatches();
    });
    _isExpandedList =
        List.generate(widget.data["lessons"].length, (index) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<LecturerCommonViewModel, CommonViewModel,
        LearningViewModel>(builder: (context, value, common, snapshot, child) {
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 80,
            child: Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xffCF407F),
                    onPrimary: Colors.white,
                  ),
                  icon: const Icon(
                    Icons.file_open_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LessonContentManipulate(
                              week: 1,
                              module: widget.data['moduleSlug'],
                              moduleTitle: widget.data['moduleTitle']),
                        ));
                  },
                  label: const Text(
                    "Add new lesson",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Lessons",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          isLoading(value.resourcesApiResponse)
              ? const Center(child: CupertinoActivityIndicator())
              : value.lessons.isEmpty
                  ? Container()
                  : Builder(builder: (context) {
                      var categories = snapshot.weekCategory;
                      List<dynamic> elseLessArr = [];
                      List<dynamic> elseWeekArr = [];
                      Map<String, dynamic> untitledData = {
                        "title": "Untitled",
                        "lessons": elseLessArr,
                        "weeks": elseWeekArr
                      };
                      var lessonsWithTitle = [];
                      var weeksWithCategories = [];
                      elseLessArr.clear();
                      elseWeekArr.clear();
                      lessonsWithTitle.clear();
                      weeksWithCategories.clear();

                      if (categories.length > 0) {
                        for (var k = 0; k < categories.length; k++) {
                          weeksWithCategories = [
                            ...weeksWithCategories,
                            ...categories[k].weeks!
                          ];
                        }
                      }
                      for (var i = 0; i < value.lessons.length; i++) {
                        Map<String, dynamic> newData = {
                          "title": "",
                          "lessons": [],
                          "weeks": []
                        };
                        var week = value.lessons[i].week.toString();
                        for (var j = 0; j < categories.length; j++) {
                          if (categories[j].weeks!.contains(week)) {
                            // find category in lessonsWithTitle array
                            var index = lessonsWithTitle.indexWhere((element) =>
                                element['title'] == categories[j].title);
                            if (index != -1) {
                              var lessonsWithTitleObj = lessonsWithTitle[index];
                              if (lessonsWithTitleObj != null) {
                                if (!lessonsWithTitleObj["weeks"]
                                    .contains(week)) {
                                  lessonsWithTitleObj["lessons"]
                                      .add(value.lessons[i]);
                                  lessonsWithTitleObj["weeks"].add(week);
                                  lessonsWithTitle[index] = lessonsWithTitleObj;
                                }
                              } else {
                                newData['title'] = categories[j].title;
                                newData['lessons'] = [value.lessons[i]];
                                newData['weeks'] = [week];
                                lessonsWithTitle.add(newData);
                              }
                            } else {
                              newData['title'] = categories[j].title;
                              newData['lessons'] = [value.lessons[i]];
                              newData['weeks'] = [week];
                              lessonsWithTitle.add(newData);
                            }
                          }
                        }

                        if (!weeksWithCategories.contains(week)) {
                          untitledData['lessons'] = [
                            ...untitledData['lessons'],
                            value.lessons[i]
                          ];
                          untitledData['weeks'] = [
                            ...untitledData['weeks'],
                            week
                          ];
                        }
                      }

                      if (untitledData["lessons"].length > 0) {
                        lessonsWithTitle.add(untitledData);
                      }

                      return ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: lessonsWithTitle.length,
                          itemBuilder: (BuildContext context, index2) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5, top: 5, bottom: 5),
                                  child: Text(
                                    lessonsWithTitle[index2]["title"]
                                        .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ),
                                ...List.generate(
                                    lessonsWithTitle[index2]["lessons"].length
                                    // value.lessons.length
                                    , (index) {
                                  var datas = lessonsWithTitle[index2]
                                      ["lessons"][index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(color: grey_400)),
                                      child: ExpansionTile(
                                        onExpansionChanged: (isExpanded) {
                                          setState(() {
                                            _isExpandedList[index] = isExpanded;
                                            for (int i = 0;
                                                i < _isExpandedList.length;
                                                i++) {
                                              if (i != index) {
                                                _isExpandedList[i] = false;
                                              }
                                            }
                                          });
                                        },
                                        maintainState: true,
                                        childrenPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10),
                                        title: Text(
                                          "Week ${datas.week}",
                                          style: const TextStyle(
                                              color: black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                        children: [
                                          Row(
                                            children: [
                                              value.weeks.contains(value
                                                      .lessons[index].week
                                                      .toString())
                                                  ? Expanded(
                                                      child:
                                                          ElevatedButton.icon(
                                                        label:
                                                            Text("Completed"),
                                                        icon: Icon(
                                                            Icons.check_circle),
                                                        onPressed: null,
                                                      ),
                                                    )
                                                  : Expanded(
                                                      child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary: Color(
                                                                      0xff006400)),
                                                          onPressed: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    actions: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child: ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(primary: Colors.transparent),
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                  _selectedBatch.clear();
                                                                                },
                                                                                child: const Text("Cancel")),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child: ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(primary: Colors.green),
                                                                                onPressed: () async {
                                                                                  try {
                                                                                    if (_selectedBatch.isNotEmpty) {
                                                                                      final req = WeekMarkCompleteRequest(batches: _selectedBatch, moduleSlug: widget.data['moduleSlug'], week: datas.week);
                                                                                      Commonresponse res = await MarkCompleteRepository().markcomplete(req);
                                                                                      if (res.success == true) {
                                                                                        common.setLoading(true);
                                                                                        Navigator.of(context).pop();

                                                                                        _selectedBatch.clear();
                                                                                        Fluttertoast.showToast(msg: res.message.toString());

                                                                                        value.setSlug(widget.data['moduleSlug']);
                                                                                        value.checkprogress(widget.data['moduleSlug']);
                                                                                        value.fetchlessons();
                                                                                        common.setLoading(false);
                                                                                      } else {
                                                                                        common.setLoading(true);
                                                                                        Fluttertoast.showToast(msg: res.message.toString());
                                                                                        common.setLoading(false);
                                                                                      }
                                                                                    } else {
                                                                                      common.setLoading(true);
                                                                                      Fluttertoast.showToast(msg: 'select batch/section to mark complete');
                                                                                      common.setLoading(false);
                                                                                    }
                                                                                  } on Exception catch (e) {
                                                                                    common.setLoading(true);
                                                                                    Fluttertoast.showToast(msg: e.toString());
                                                                                    common.setLoading(false);

                                                                                    // TODO
                                                                                  }
                                                                                },
                                                                                child: const Text("Confirm")),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                    title: const Text(
                                                                        'Mark this week as complete'),
                                                                    content:
                                                                        Container(
                                                                      height:
                                                                          170,
                                                                      child:
                                                                          MultiSelectDialogField(
                                                                        // validator: ,
                                                                        items: common
                                                                            .currentBatch
                                                                            .map((e) =>
                                                                                MultiSelectItem(e, e))
                                                                            .toList(),
                                                                        listType:
                                                                            MultiSelectListType.CHIP,
                                                                        initialValue:
                                                                            _selectedBatch,
                                                                        autovalidateMode:
                                                                            AutovalidateMode.always,
                                                                        onConfirm:
                                                                            (List<String>
                                                                                values) {
                                                                          setState(
                                                                              () {
                                                                            _selectedBatch =
                                                                                values;
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  );
                                                                });
                                                          },
                                                          child: const Text(
                                                              "Complete")),
                                                    ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: logoTheme),
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => LessonContentManipulate(
                                                                week: datas.week
                                                                    .toString(),
                                                                module: widget
                                                                        .data[
                                                                    'moduleSlug'],
                                                                moduleTitle: widget
                                                                        .data[
                                                                    'moduleTitle']),
                                                          ));
                                                    },
                                                    child: const Text("Add Lesson")),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                          ...List.generate(
                                              datas.lessons!.length, (i) {
                                            var lectureLength = i + 1;
                                            return Container(
                                              decoration: BoxDecoration(
                                                  border: i ==
                                                          (datas.lessons!
                                                                  .length -
                                                              1)
                                                      ? null
                                                      : const Border(
                                                          bottom: BorderSide(
                                                              color:
                                                                  grey_400))),
                                              child: ListTile(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder: ((builder) =>
                                                        bottomSheet(
                                                            value,
                                                            common,
                                                            i,
                                                            datas,
                                                            datas.lessons![i]
                                                                .lessonTitle
                                                                .toString(),
                                                            datas.week,
                                                            datas.lessons![i].id
                                                                .toString())),
                                                  );
                                                },
                                                title: RichText(
                                                  // textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    children: [
                                                      const WidgetSpan(
                                                        child: Icon(
                                                            Icons
                                                                .play_arrow_outlined,
                                                            color: Colors.grey,
                                                            size: 20),
                                                      ),
                                                      TextSpan(
                                                          text:
                                                              "Lecture ${lectureLength.toString()} ",
                                                          style:
                                                              const TextStyle(
                                                            color: black,
                                                          )),
                                                      TextSpan(
                                                          text: datas
                                                              .lessons![i]
                                                              .lessonTitle,
                                                          style:
                                                              const TextStyle(
                                                                  color: black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      15)),
                                                    ],
                                                  ),
                                                ),
                                                minLeadingWidth: 0,
                                                visualDensity: VisualDensity(
                                                    horizontal: 0),
                                                contentPadding: EdgeInsets.zero,
                                              ),
                                            );
                                          })
                                        ],
                                      ),
                                    ),
                                  );
                                })
                              ],
                            );
                          });
                    })
        ],
      );
    });
  }

  Widget bottomSheet(
    LecturerCommonViewModel lc,
    CommonViewModel cm,
    int index,
    LessonresponseLesson value,
    String data,
    int week,
    String lessonId,
  ) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      height: 260.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(children: <Widget>[
        Text(
          data.toString(),
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 8,
        ),
        ListTile(
          leading: Icon(Icons.visibility),
          title: Text("View lesson"),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LessoncontentLecturer(
                        data: value,
                        moduleSlug: widget.data['moduleSlug'],
                        index: index,
                        moduelTitle: widget.data['moduleTitle'],
                      )),
            );
          },
        ),
        ListTile(
          onTap: () {
            alertBoxWidget(
                context: context,
                title: "Draft Lesson",
                content:
                    "Are you sure you want to save this lesson as a draft?",
                onTap: () async {
                  try {
                    final datas = {"type": "private"};

                    SendDraftResponse res = await LessonRepository().senddrafts(
                        value.lessons![index].lessonSlug.toString(), datas);
                    if (res.success == true) {
                      cm.setLoading(true);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      snackThis(
                          context: context,
                          color: Colors.green,
                          content: Text("Lesson sent to draft"));
                      lc.setSlug(widget.data['moduleSlug']);
                      lc.fetchlessons();
                      cm.setLoading(false);
                    } else {
                      cm.setLoading(true);
                      snackThis(
                          context: context,
                          color: Colors.red,
                          content: Text("Failed to draft the lesson"));
                      cm.setLoading(false);
                    }
                  } on Exception catch (e) {
                    cm.setLoading(true);
                    snackThis(
                        context: context,
                        color: Colors.red,
                        content: Text(e.toString()));

                    cm.setLoading(false);
                    // TODO
                  }
                });
          },
          title: Text("Send to draft"),
          leading: Icon(Icons.send_and_archive),
        ),
        ListTile(
          onTap: () {
            showMyDialog(week, lessonId);
     
          },
          title: const Text("Lesson Progress"),
          leading: const Icon(Icons.menu_outlined),
        ),
        ListTile(
          onTap: () async {
            alertBoxWidget(
                context: context,
                title: "Delete Lesson",
                content:
                    "Are you sure you want to delete this resource? This action cannot be undone!",
                onTap: () async {
                  Commonresponse res = await LessonRepository().deletelesson(
                      value.lessons![index].lessonSlug.toString());
                  if (res.success == true) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    cm.setLoading(true);
                    lc.setSlug(widget.data['moduleSlug']);
                    lc.fetchlessons();
                    snackThis(
                        context: context,
                        color: Colors.green,
                        content: Text(res.message.toString()));
                    cm.setLoading(false);
                  } else {
                    cm.setLoading(true);
                    snackThis(
                        context: context,
                        color: Colors.red,
                        content: Text(res.message.toString()));
                    cm.setLoading(false);
                  }
                });
          },
          title: Text("Delete this lesson"),
          leading: Icon(Icons.delete),
        ),
      ]
          // ],
          ),
    );
  }

  void showMyDialog(int week, String lessonId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          title: Text(
            'Update Lesson Status',
            style: TextStyle(color: black, fontWeight: FontWeight.bold),
          ),
          content: Builder(
            builder: (context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              return SizedBox(
                width: width / 1.1,
                height: height / 1.7,
                // height: 100/0,
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return LessonProgressAlertBox(
                    moduleSlug: widget.data["moduleSlug"],
                    week: week,
                    lessonId: lessonId,
                  );
                }),
              );
            },
          ),
        );
      },
    );
  }
}

class LessonProgressAlertBox extends StatefulWidget {
  final String? moduleSlug;
  final int week;
  final String lessonId;
  const LessonProgressAlertBox(
      {Key? key,
      required this.moduleSlug,
      required this.week,
      required this.lessonId})
      : super(key: key);

  @override
  State<LessonProgressAlertBox> createState() => _LessonProgressAlertBoxState();
}

class _LessonProgressAlertBoxState extends State<LessonProgressAlertBox>
    with TickerProviderStateMixin {
  late TabController _tabController;
  User? user;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    getuserData();
    super.initState();
  }

  getuserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');

    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<String> tabList = ["Update Status", "View Status"];

  int selectedTabIndex = 0;
  List<String> selected_batch = <String>[];
  String? selected_status;
  String? selected_batch_view;
  bool isLoadingStatic = false;

  TextEditingController _remarkController = TextEditingController();
  final _formKey = GlobalKey();
  final _multiSelectKey = GlobalKey<FormFieldState<dynamic>>();

  @override
  Widget build(BuildContext context) {
    return Consumer2<CommonViewModel, LecturerCommonViewModel>(
        builder: (context, common, lc, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              isScrollable: true,
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xff8d97ad),
              unselectedLabelStyle: const TextStyle(
                  color: Color(0xff8d97ad), fontWeight: FontWeight.bold),
              labelPadding: EdgeInsets.zero,
              indicatorSize: TabBarIndicatorSize.tab,
              padding: EdgeInsets.zero,
              indicatorColor: Colors.white,
              onTap: (int value) {
                setState(() {
                  selectedTabIndex = value;
                });
              },
              controller: _tabController,
              labelStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              tabs: [
                ...List.generate(
                    2,
                    (index) => Tab(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: selectedTabIndex == index
                                    ? Colors.blueAccent
                                    : const Color(0xffeef0f3),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              child: Text(tabList[index]),
                            ),
                          ),
                        ))
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  updateStatusWidget(common),
                  viewStatusWidget(common, lc),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget updateStatusWidget(CommonViewModel common) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 1,
              height: 2,
              color: Colors.blueAccent,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Select Batches/Sections",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(
              height: 5,
            ),
            MultiSelectDialogField(
              key: _multiSelectKey,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select Batches';
                }
                return null;
              },
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.fromBorderSide(
                  BorderSide(
                    color: black,
                  ),
                ),
              ),
              items: common.batchArr.map((e) => MultiSelectItem(e, e)).toList(),
              listType: MultiSelectListType.CHIP,
              initialValue: selected_batch,
              autovalidateMode: AutovalidateMode.disabled,
              onConfirm: (List<String> values) {
                setState(() {
                  selected_batch = values;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Status",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(
              height: 5,
            ),
            DropdownButtonFormField(
              validator: (value) {
                if (value == null) {
                  return 'Please select status';
                }
                return null;
              },
              value: selected_status,
              isExpanded: true,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                enabledBorder:
                    OutlineInputBorder(borderSide: BorderSide(color: black)),
                focusedBorder:
                    OutlineInputBorder(borderSide: BorderSide(color: black)),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent)),
                filled: true,
              ),
              icon: const Icon(Icons.arrow_drop_down_outlined),
              items: ["In Progress", "Completed"].map((pt) {
                return DropdownMenuItem(
                  value: pt,
                  child: Text(
                    pt.toString(),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  selected_status = newVal as String;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Remark"),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: _remarkController,
              keyboardType: TextInputType.visiblePassword,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                hintText: 'Remarks',
                filled: true,
                enabledBorder:
                    OutlineInputBorder(borderSide: BorderSide(color: black)),
                focusedBorder:
                    OutlineInputBorder(borderSide: BorderSide(color: black)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            isLoadingStatic == true
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                    onPressed: isLoadingStatic == true
                        ? null
                        : () async {
                            if (_multiSelectKey.currentState!.validate() &&
                                (_formKey.currentState as FormState)
                                    .validate()) {
                              try {
                                setState(() {
                                  isLoadingStatic = true;
                                });
                                final data = {
                                  "lecturer": user?.email,
                                  "lesson": widget.lessonId,
                                  "moduleSlug": widget.moduleSlug,
                                  "remarks": _remarkController.text,
                                  "selectedBatches": selected_batch,
                                  "status": selected_status,
                                  "week": widget.week
                                };
                                print(data);
                                Commonresponse res = await LessonRepository()
                                    .lessonProgress(data);

                                if (res.success == true) {
                                  setState(() {
                                    isLoadingStatic = false;
                                  });
                                  selected_batch = [];
                                  selected_status = null;
                                  _remarkController.clear();
                                  // snackThis(
                                  //     context: context,
                                  //     color: Colors.green,
                                  //     content: Text(res.message.toString()));

                                  Navigator.pop(context);
                                } else {
                                  setState(() {
                                    isLoadingStatic = false;
                                  });
                                  snackThis(
                                      context: context,
                                      color: Colors.green,
                                      content: Text(res.message.toString()));
                                }
                              } catch (e) {
                                setState(() {
                                  isLoadingStatic = false;
                                });
                                snackThis(
                                    context: context,
                                    color: Colors.green,
                                    content: Text("Error occured"));
                              }
                            }
                          },
                    child: const Text("Save")),
          ],
        ),
      ),
    );
  }

  Widget viewStatusWidget(CommonViewModel common, LecturerCommonViewModel lc) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          const Divider(
            thickness: 1,
            height: 2,
            color: Colors.blueAccent,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Batches",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(
            height: 5,
          ),
          DropdownButtonFormField(
            value: selected_batch_view,
            isExpanded: true,
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              enabledBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: black)),
              focusedBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: black)),
              filled: true,
            ),
            icon: const Icon(Icons.arrow_drop_down_outlined),
            items: common.batchArr.map((pt) {
              return DropdownMenuItem(
                value: pt,
                child: Text(
                  pt.toString(),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            hint: const Text("Select Batches"),
            onChanged: (newVal) {
              setState(() {
                selected_batch_view = newVal as String;
              });
              final data = {
                "batch": selected_batch_view,
                "lesson": widget.lessonId
              };
              print(data);
              lc.fetchLessonProgress(data);
            },
          ),
          const SizedBox(
            height: 10,
          ),
          selected_batch_view == null
              ? Container()
              : isLoading(lc.lessonProgressApiResponse)
                  ? const Center(child: CupertinoActivityIndicator())
                  : lc.lessonProgress.syllabus == null ||
                          lc.lessonProgress.syllabus!.isEmpty
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...List.generate(lc.lessonProgress.syllabus!.length,
                                (index) {
                              final datas = lc.lessonProgress.syllabus![index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    richTextWidget(
                                        title: "Lecturer: ",
                                        value: datas.lecturer.toString()),
                                    richTextWidget(
                                        title: "Status: ",
                                        value: datas.status.toString()),
                                    richTextWidget(
                                        title: "Remark: ",
                                        value: datas.remarks.toString()),
                                  ],
                                ),
                              );
                            }),

                      
                          ],
                        )
        ],
      ),
    );
  }

  Widget richTextWidget({required String title, required String value}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          WidgetSpan(
              child: Container(
            // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
                // color: value == "In Progress"
                //     ? const Color(0xffe74c3c)
                //     : Colors.green,
                // borderRadius: BorderRadius.circular(5),
                ),
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          )),
        ],
      ),
    );
  }
}
