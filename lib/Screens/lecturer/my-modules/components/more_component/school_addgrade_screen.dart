import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Dashboardlecturer/lecturer_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/group_result/group_result_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/group_result/view/group_result_screen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/more_component/grade_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/more_component/mark_student.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/more_component/view_grade_student.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/principal_common_view_model.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/grade_repository.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/config/preference_utils.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getgradesheading_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../constants/colors.dart';
import '../../../../../response/login_response.dart';

class SchoolAddScreen extends StatefulWidget {
  List<dynamic> modules;
  SchoolAddScreen({Key? key, required this.modules}) : super(key: key);

  @override
  _SchoolAddScreenState createState() => _SchoolAddScreenState();
}

class _SchoolAddScreenState extends State<SchoolAddScreen> {
  final _gradeController = TextEditingController();
  final _weightageController = TextEditingController();
  final _idController = TextEditingController();
  final _fullmarksController = TextEditingController();
  final _passmarksController = TextEditingController();
  bool update = false;
  String? selected_teacher;
  String? selected_module;
  String? selected_examtype;
  String? selected_headingType;
  int totalWeightage = 0;

  final List<dynamic> _headingtype = [
    {"name": "Percent", "value": "percent"},
    {"name": "Value", "value": "value"}
  ];
  late GradeViewModel _provider;
  late PrinicpalCommonViewModel _principalProvider;
  late GroupResultViewModel _provider4;
  late User user;
  late LecturerViewModel _modulesProvidera;
  bool checkedValue = false;
  late GradeViewModel _gradeViewModel;
  late CommonViewModel _commonViewModel;

  final SharedPreferences localStorage = PreferenceUtils.instance;
  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _principalProvider =
          Provider.of<PrinicpalCommonViewModel>(context, listen: false);
      _principalProvider.fetchallteacher();

      _commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
      _provider4 = Provider.of<GroupResultViewModel>(context, listen: false);
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _gradeController.dispose();
    _weightageController.dispose();
    _idController.dispose();
    _fullmarksController.dispose();
    _passmarksController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: false,
        // iconTheme: const IconThemeData(color: Colors.black),
        // backgroundColor: Colors.white,
        title: const Text(
          "Add Grades",
          style: TextStyle(color: white),
        ),
      ),
      body: Consumer4<GradeViewModel, CommonViewModel, PrinicpalCommonViewModel,
              GroupResultViewModel>(
          builder: (context, grade, common, principal, group, child) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          children: [
            const Text(
              'Select module/subject',
              style: TextStyle(),
            ),

            // DropdownSearch<String>(
            //   dropdownSearchDecoration: const InputDecoration(
            //     enabledBorder: OutlineInputBorder(
            //         borderSide: BorderSide(
            //             color: Colors.black38)),
            //     focusedBorder: OutlineInputBorder(
            //         borderSide: BorderSide(
            //             color: Colors.black38)),
            //     border: OutlineInputBorder(),
            //     contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
            //     filled: true,
            //     hintText: 'Select module/Subject',
            //   ),
            //   showSearchBox: true,
            //   maxHeight: MediaQuery.of(context).size.height / 1.2,
            //   items: widget.modules.map<String>((pt) {
            //     return
            //       pt['alias'] == null
            //         ? pt['moduleTitle']
            //         : pt["alias"];
            //   }).toList(),
            //   mode: Mode.BOTTOM_SHEET,
            //
            //   onChanged: (newVal) {
            //     setState(() {
            //       selected_module = newVal as String;
            //       selected_examtype = null;
            //
            //       selected_teacher == null;
            //       _fullmarksController.clear();
            //       _passmarksController.clear();
            //       selected_headingType = null;
            //       _gradeController.clear();
            //       _weightageController.clear();
            //       checkedValue = false;
            //       // selected_headingType == null;
            //
            //       group.fetchGroupResultType(selected_module.toString());
            //
            //       grade
            //           .fetchheadings(selected_module.toString())
            //           .then((value) {
            //         if (grade.heading.passMark != null ||
            //             grade.heading.fullMark != null ||
            //             grade.heading.weightageType != null) {
            //           print(
            //               "HEADING:::::::${grade.heading.weightageType.toString()}");
            //           selected_headingType =
            //           grade.heading.weightageType == null
            //               ? ""
            //               : grade.heading.weightageType
            //               .toString();
            //           _fullmarksController.text =
            //               grade.heading.fullMark.toString();
            //           _passmarksController.text =
            //               grade.heading.passMark.toString();
            //         }
            //       });
            //       grade.fetchexamsfordropdown(
            //           selected_module.toString());
            //     });
            //   },
            //   selectedItem: selected_module,
            // ),

            Builder(builder: (context) {
              return DropdownButtonFormField(
                isExpanded: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  hintText: 'Select module/Subject',
                ),
                icon: const Icon(Icons.arrow_drop_down_outlined),
                items: widget.modules.map((pt) {
                  return DropdownMenuItem(
                    value: pt['moduleSlug'],
                    child: pt['alias'] == null
                        ? Text(
                            pt['moduleTitle'],
                            overflow: TextOverflow.ellipsis,
                          )
                        : Text(
                            pt["alias"],
                            overflow: TextOverflow.ellipsis,
                          ),
                  );
                }).toList(),
                onChanged: (newVal) {
                  setState(() {
                    selected_module = newVal as String;
                    selected_examtype = null;

                    selected_teacher == null;
                    _fullmarksController.clear();
                    _passmarksController.clear();
                    selected_headingType = null;
                    _gradeController.clear();
                    _weightageController.clear();
                    checkedValue = false;
                    // selected_headingType == null;

                    group.fetchGroupResultType(selected_module.toString());

                    grade
                        .fetchheadings(selected_module.toString())
                        .then((value) {
                      if (grade.heading.passMark != null ||
                          grade.heading.fullMark != null ||
                          grade.heading.weightageType != null) {
                        selected_headingType =
                            grade.heading.weightageType == null
                                ? ""
                                : grade.heading.weightageType.toString();
                        _fullmarksController.text =
                            grade.heading.fullMark.toString();
                        _passmarksController.text =
                            grade.heading.passMark.toString();
                      }
                    });
                    grade.fetchexamsfordropdown(selected_module.toString());
                  });
                },
                value: selected_module,
              );
            }),
            const SizedBox(
              height: 10,
            ),
            isLoading(group.groupResultTypeApiResponse)
                ? const SizedBox()
                : selected_module != null &&
                        group.groupResultType.allResultType != null &&
                        group.groupResultType.allResultType!.isNotEmpty
                    ? Row(
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: kPrimaryColor),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => GroupResultScreen(
                                            moduleSlug:
                                                selected_module.toString())));
                              },
                              child: const Text("Internal Evaluation")),
                        ],
                      )
                    : SizedBox(),
            const SizedBox(
              height: 10,
            ),
            selected_module == null
                ? const SizedBox()
                : isLoading(grade.headingApiResponse) ||
                        isLoading(grade.examTitleApiResponse)
                    ? const VerticalLoader()
                    : Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Full marks"),
                                    TextFormField(
                                      controller: _fullmarksController,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                        hintText: 'Full marks',
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.green)),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Pass marks"),
                                    TextFormField(
                                      controller: _passmarksController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: 'Pass marks',
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.green)),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField(
                            isExpanded: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              hintText: 'Select weightage type',
                            ),
                            icon: const Icon(Icons.arrow_drop_down_outlined),
                            items: _headingtype.map((pt) {
                              return DropdownMenuItem(
                                value: pt['value'],
                                child: Text(
                                  pt['name'],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                selected_headingType = newVal as String;
                              });
                            },
                            value: selected_headingType,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Grade Title"),
                                    TextFormField(
                                      controller: _gradeController,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                        hintText: 'Eg. viva/exam',
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.green)),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Weightage"),
                                    TextFormField(
                                      controller: _weightageController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: '25%',
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.green)),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Optional',
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Checkbox(
                                      value: checkedValue,
                                      activeColor: Colors.green,
                                      onChanged: (value) {
                                        setState(() {
                                          checkedValue = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: false,
                            child: TextFormField(
                              controller: _idController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: 'Eg. viva/exam',
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              update == false
                                  ? Builder(builder: (context) {
                                      try {
                                        totalWeightage = 0;
                                        for (int i = 0;
                                            i <
                                                grade
                                                    .heading.marksTitle!.length;
                                            i++) {
                                          totalWeightage += grade.heading
                                              .marksTitle![i].weightage!;
                                        }
                                      } catch (e) {
                                        print(e);
                                      }
                                      return OutlinedButton(
                                          onPressed: () async {
                                            try {
                                              if (selected_headingType ==
                                                  null) {
                                                Fluttertoast.showToast(
                                                    msg: "Select Heading Type");
                                              } else if (int.parse(
                                                      _fullmarksController
                                                          .text) ==
                                                  0) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Full Marks can't be 0");
                                              } else {
                                                if (int.parse(
                                                        _fullmarksController
                                                            .text) !=
                                                    0) {
                                                  int weightageValue =
                                                      _weightageController
                                                              .text.isEmpty
                                                          ? 0
                                                          : int.parse(
                                                              _weightageController
                                                                  .text);
                                                  if ((totalWeightage +
                                                          weightageValue) >
                                                      int.parse(
                                                          _fullmarksController
                                                              .text)) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Total weightage cannot be greater than 100");
                                                  } else {
                                                    Map<String, dynamic> datas =
                                                        {
                                                      "fullMark":
                                                          _fullmarksController
                                                              .text,
                                                      "passMark":
                                                          _passmarksController
                                                              .text,
                                                      "moduleSlug":
                                                          selected_module,
                                                      "heading":
                                                          _gradeController.text,
                                                      "weightage":
                                                          _weightageController
                                                              .text,
                                                      "optional": checkedValue,
                                                      "weightageType":
                                                          selected_headingType
                                                    };
                                                    Commonresponse res =
                                                        await GradeRepository()
                                                            .addHeadings(datas);
                                                    if (res.success == true) {
                                                      _gradeController.clear();
                                                      _weightageController
                                                          .clear();
                                                      // grade.setModuleSlug(
                                                      //     selected_module.toString());
                                                      grade.fetchheadings(
                                                          selected_module
                                                              .toString());
                                                      // grade.fetchheading();
                                                      Fluttertoast.showToast(
                                                          msg: res.message
                                                              .toString());
                                                      // common.setLoading(false);
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg: res.message
                                                              .toString());
                                                      // common.setLoading(false);
                                                    }
                                                  }
                                                }
                                              }
                                            } on Exception catch (e) {
                                              Fluttertoast.showToast(
                                                  msg: "Error");
                                              // common.setLoading(false);
                                              // TODO
                                            }
                                          },
                                          child: const Text(
                                            'Add',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ));
                                    })
                                  : OutlinedButton(
                                      onPressed: () async {
                                        try {
                                          common.setLoading(true);
                                          Map<String, dynamic> datas = {
                                            "fullMark":
                                                _fullmarksController.text,
                                            "passMark":
                                                _passmarksController.text,
                                            "moduleSlug": selected_module,
                                            "heading": _gradeController.text,
                                            "weightage":
                                                _weightageController.text,
                                            "optional": checkedValue,
                                            "weightageType":
                                                selected_headingType
                                          };
                                          final res = await GradeRepository()
                                              .editHeading(
                                                  datas, _idController.text);
                                          if (res.success == true) {
                                            setState(() {
                                              update = false;
                                            });
                                            _gradeController.clear();
                                            _weightageController.clear();
                                            grade.fetchheadings(
                                                selected_module.toString());
                                            Fluttertoast.showToast(
                                                msg: res.message.toString());
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: res.message.toString());
                                          }

                                          common.setLoading(false);
                                        } on Exception catch (e) {
                                          Fluttertoast.showToast(
                                              msg: e.toString());
                                          common.setLoading(false);
                                          // TODO
                                        }
                                      },
                                      child: const Text(
                                        'Update',
                                        style: TextStyle(color: Colors.black),
                                      )),
                            ],
                          ),
                          isLoading(grade.headingApiResponse)
                              ? const Center(
                                  child: VerticalLoader(),
                                )
                              : grade.hasData == true
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListView.builder(
                                          physics: const ScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              grade.heading.marksTitle?.length,
                                          itemBuilder: (context, index) {
                                            var grades = grade
                                                .heading.marksTitle?[index];
                                            return Card(
                                              child: ListTile(
                                                trailing: InkWell(
                                                  onTap: () {
                                                    // set up the buttons

                                                    Widget cancelButton =
                                                        TextButton(
                                                      child:
                                                          const Text("Cancel"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    );
                                                    Widget continueButton =
                                                        TextButton(
                                                      child: const Text(
                                                          "Continue"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        showModalBottomSheet(
                                                          context: context,
                                                          builder: ((builder) =>
                                                              bottomSheet(
                                                                  grade.heading,
                                                                  grades!,
                                                                  common,
                                                                  grade)),
                                                        );
                                                      },
                                                    );

                                                    // set up the AlertDialog
                                                    AlertDialog alert =
                                                        AlertDialog(
                                                      title: const Text(
                                                          "Are you sure"),
                                                      content: const Text(
                                                          "If you edit or delete marks heading all the marks entered will be clear"),
                                                      actions: [
                                                        cancelButton,
                                                        continueButton,
                                                      ],
                                                    );

                                                    // show the dialog
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return alert;
                                                      },
                                                    );
                                                  },
                                                  child: const Icon(
                                                      Icons.more_vert),
                                                ),
                                                title: RichText(
                                                  text: TextSpan(
                                                    text: 'Grade: ',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: grades?.heading
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        text: 'Weightage: ',
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: grades
                                                                ?.weightage
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    grades!.optional == false
                                                        ? const Text(
                                                            "Compulsory")
                                                        : const Text("Optional")
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        grade.exams.isEmpty
                                            ? const Text("No examination found")
                                            : Padding(
                                              padding: const EdgeInsets.only(top: 10.0),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("Exam type"),
                                                    DropdownButtonFormField(
                                                      isExpanded: true,
                                                      decoration:
                                                          const InputDecoration(
                                                        border: InputBorder.none,
                                                        filled: true,
                                                        hintText: 'Select Exam',
                                                      ),
                                                      icon: const Icon(Icons
                                                          .arrow_drop_down_outlined),
                                                      items:
                                                          grade.exams.map((pt) {
                                                        return DropdownMenuItem(
                                                          value: pt.examSlug,
                                                          child: Builder(
                                                              builder: (context) {
                                                            return Text(
                                                              pt.examTitle
                                                                  .toString(),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            );
                                                          }),
                                                        );
                                                      }).toList(),
                                                      onChanged: (newVal) {
                                                        setState(() {
                                                          selected_examtype =
                                                              newVal as String;

                                                          // grade.fetchheading();
                                                        });
                                                      },
                                                      value: selected_examtype,
                                                    ),
                                                  ],
                                                ),
                                            ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )
                                  : Image.asset("assets/images/no_content.PNG"),
                          const SizedBox(
                            height: 10,
                          ),

                          // grade.heading.marksTitle?.length != null
                          //     ? Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           const Text("Secondary marker"),
                          //           const SizedBox(
                          //             height: 5,
                          //           ),
                          //           DropdownButtonFormField(
                          //             isExpanded: true,
                          //             decoration: const InputDecoration(
                          //               border: InputBorder.none,
                          //               filled: true,
                          //               hintText: 'Select Secondary Marker',
                          //             ),
                          //             icon: const Icon(
                          //                 Icons.arrow_drop_down_outlined),
                          //             items: principal.allteacher.map((pt) {
                          //               return DropdownMenuItem(
                          //                 value: pt.email,
                          //                 child: Text(
                          //                   pt.firstname.toString() +
                          //                       " " +
                          //                       pt.lastname.toString(),
                          //                   overflow: TextOverflow.ellipsis,
                          //                 ),
                          //               );
                          //             }).toList(),
                          //             onChanged: (newVal) {
                          //               setState(() {
                          //                 selected_teacher = newVal as String?;
                          //                 WidgetsBinding.instance
                          //                     .addPostFrameCallback(
                          //                         (timeStamp) async {
                          //                   Map<String, dynamic> datas = {
                          //                     "secondaryMarker": [
                          //                       selected_teacher.toString()
                          //                     ]
                          //                   };
                          //                   final res = await GradeRepository()
                          //                       .addSecondaryMarker(datas,
                          //                           grade.heading.id.toString());
                          //                   if (res.success == true) {
                          //                     Fluttertoast.showToast(
                          //                         msg: res.message.toString());
                          //                   } else {
                          //                     Fluttertoast.showToast(
                          //                         msg: res.message.toString());
                          //                   }
                          //                 });
                          //               });
                          //             },
                          //             value: selected_teacher,
                          //           ),
                          //         ],
                          //       )
                          //     : SizedBox(),
                          //
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green)),
                                  onPressed: () async {
                                    if (selected_module == null ||
                                        selected_examtype == null) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "select module/subject and exam type");
                                    } else if (selected_headingType == null) {
                                      Fluttertoast.showToast(
                                          msg: "select Weightage type");
                                    } else if (grade.heading.marksTitle ==
                                            null ||
                                        grade.heading.marksTitle!.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: "Weightage not found");
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MarkStudentGrade(
                                                    moduleSlug: selected_module,
                                                    examId: selected_examtype,
                                                    data: grade
                                                        .heading.marksTitle),
                                          ));
                                    }
                                  },
                                  child: const Text(
                                    'Mark Student',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green)),
                                  onPressed: () async {
                                    // ViewMarkStudentGrade
                                    if (selected_module == null ||
                                        selected_examtype == null) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "select module/subject and exam type");
                                    } else if (grade.heading.marksTitle ==
                                            null ||
                                        grade.heading.marksTitle!.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: "Weightage not found");
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ViewMarkStudentGrade(
                                              examId:
                                                  selected_examtype.toString(),
                                              moduleSlug:
                                                  selected_module.toString(),
                                            ),
                                          ));
                                    }
                                  },
                                  child: const Text(
                                    'View Marks',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ],
                          ),
                        ],
                      ),
            const SizedBox(
              height: 100,
            )
          ],
        );
      }),
    );
  }

  //
  Widget bottomSheet(MarksHeading heading, MarksTitle data,
      CommonViewModel common, GradeViewModel grade) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      height: 130.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 8,
          ),
          ListTile(
            leading: const Icon(
              Icons.edit,
              color: Colors.green,
            ),
            title: const Text("Edit"),
            onTap: () {
              setState(() {
                update = true;
              });
              Navigator.of(context).pop();
              _idController.text = data.id.toString();
              _gradeController.text = data.heading.toString();
              _fullmarksController.text = heading.fullMark.toString();
              _passmarksController.text = heading.passMark.toString();
              selected_headingType = heading.weightageType.toString();
              checkedValue = data.optional == true ? true : false;
              _weightageController.text = data.weightage.toString();
            },
          ),
          ListTile(
            onTap: () async {
              Navigator.pop(context);
              try {
                common.setLoading(true);
                final res =
                    await GradeRepository().deleteheading(data.id.toString());
                if (res.success == true) {
                  // grade.setModuleSlug(selected_module.toString());
                  grade.fetchheadings(selected_module.toString());
                  // grade.fetchheading();
                  Fluttertoast.showToast(msg: res.message.toString());
                } else {
                  Fluttertoast.showToast(msg: res.message.toString());
                }
                common.setLoading(false);
              } on Exception catch (e) {
                common.setLoading(true);
                Fluttertoast.showToast(msg: e.toString());
                common.setLoading(false);
                // TODO
              }
            },
            title: const Text("Delete"),
            leading: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
