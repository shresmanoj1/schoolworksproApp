import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/more_component/grade_view_model.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/grade_repository.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/lecturer/studentgrading_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../helper/custom_loader.dart';
import '../../../../../response/login_response.dart';

class MarkStudentGrade extends StatefulWidget {
  final moduleSlug;
  final data;
  final examId;

  const MarkStudentGrade({Key? key, this.moduleSlug, this.data, this.examId})
      : super(key: key);

  @override
  _MarkStudentGradeState createState() => _MarkStudentGradeState();
}

class _MarkStudentGradeState extends State<MarkStudentGrade> {
  late CommonViewModel _provider;
  late GradeViewModel _provider2;
  late LecturerCommonViewModel lecturerCommonViewModel;

  late final responseProvider2;
  String? courseSlug;

  List<List<TextEditingController>> __controllers = [];

  String? selected_batch;
  late User user;

  int? studentIndex;
  List<dynamic> listForDisplay = [];

  bool isAbsent = false;

  var alertStyle = AlertStyle(
    overlayColor: Colors.blue,
    animationType: AnimationType.fromBottom,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: const TextStyle(fontWeight: FontWeight.bold),
    animationDuration: const Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0),
      side: const BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: const TextStyle(
      color: Color.fromRGBO(91, 55, 185, 1.0),
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<CommonViewModel>(context, listen: false);
      lecturerCommonViewModel = Provider.of<LecturerCommonViewModel>(context, listen: false);

      _provider.setSlug(widget.moduleSlug);
      _provider.fetchCurrentBatches();

      _provider2 = Provider.of<GradeViewModel>(context, listen: false);
    });

    getData();

    super.initState();
  }

  getData() async {
    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    if (isloading == true ) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mark Students",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer3<CommonViewModel, GradeViewModel, LecturerCommonViewModel>(
          builder: (context, common, grade, lecturer , child) {

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                hintText: 'select batch/section',
              ),
              icon: const Icon(Icons.arrow_drop_down_outlined),
              items: common.currentBatch.map((pt) {
                return DropdownMenuItem(
                  value: pt,
                  child: Text(
                    pt,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  selected_batch = newVal as String?;
                  _provider2.fetchViewStudentGrade(widget.moduleSlug,
                      selected_batch.toString(), widget.examId, "School");
                  _provider2.fetchMarksHeadings(widget.moduleSlug, selected_batch.toString(), widget.examId, "School").then((value){
                    common.fetchStudentformarking(selected_batch).then((e) {
                      if (common.studentMarking.length > 0 &&
                          (grade.marksHeading.marksTitle == null
                              ? 0
                              : grade.marksHeading.marksTitle!.length) >
                              0) {

                        dynamic data22 = {
                          "lecturerEmail":
                          user.email.toString(),
                          "moduleSlug":
                          widget.moduleSlug.toString(),
                        };

                        lecturer.fetchModuleDetails(data22).then((_){
                          listForDisplay.clear();
                          __controllers.clear();
                          if(lecturer.modules["isOptional"]){
                            for (var i = 0; i < common.studentMarking.length; i++) {
                              if(lecturer.modules["optionalStudent"].contains(common.studentMarking[i]['username'])){

                                studentIndex = i -1;
                                listForDisplay.add(
                                    {...common.studentMarking[i], "isAbsent": false});
                                __controllers.add([]);
                                courseSlug = common.studentMarking.first['courseSlug'];
                                for (var j = 0;
                                j <
                                    (grade.marksHeading.marksTitle == null
                                        ? 0
                                        : grade.marksHeading.marksTitle!.length);
                                j++) {
                                  var lastIndex = __controllers.length - 1;
                                  __controllers[lastIndex].add(TextEditingController());
                                }
                              }
                            }
                          }
                          else{
                            for (var i = 0; i < common.studentMarking.length; i++) {
                              listForDisplay.add({...common.studentMarking[i], "isAbsent": false});
                              __controllers.add([]);
                              courseSlug = common.studentMarking.first['courseSlug'];
                              for (var j = 0;
                              j <
                                  (grade.marksHeading.marksTitle == null
                                      ? 0
                                      : grade.marksHeading.marksTitle!.length);
                              j++) {
                                __controllers[i].add(TextEditingController());
                              }
                            }
                          }
                        });
                      }
                    });
                  });
                });
              },
              value: selected_batch,
            ),
            selected_batch != null
                ? grade.studentGrade.isEmpty
                    ? grade.hasMarksHeading == true
                        ? isLoading(common.studentMarkingApiResponse) || isLoading(lecturer.modulesApiResponse)
                            ? const Center(
                                child: CupertinoActivityIndicator(),
                              )
                            : common.studentMarking.isEmpty || listForDisplay.isEmpty
                                ? Image.asset('assets/images/no_content.PNG')
                                : Column(
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        itemCount: listForDisplay.length,
                                        itemBuilder: (context, index) {
                                          var st = listForDisplay[index];
                                          return Column(children: [
                                            ListTile(
                                              leading:
                                              Builder(builder: (context) {
                                                int sn = index + 1;
                                                return Text(sn.toString());
                                              }),
                                              title:
                                              Builder(builder: (context) {
                                                var name = st["firstname"] +
                                                    " " +
                                                    st["lastname"];
                                                return RichText(
                                                  text: TextSpan(
                                                    text: 'Name: ',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: name.toString(),
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                            FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                              subtitle:
                                              Builder(builder: (context) {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        text: 'Student Id: ',
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: st['username'] ??
                                                                "",
                                                            style: const TextStyle(
                                                                color: Colors.black,
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // st['studentId'] == null || st['studentId'] == "" ? SizedBox() :
                                                    // RichText(
                                                    //   text: TextSpan(
                                                    //     text: 'Student ID: ',
                                                    //     style: const TextStyle(
                                                    //         color: Colors.black,
                                                    //         fontWeight:
                                                    //         FontWeight.bold),
                                                    //     children: <TextSpan>[
                                                    //       TextSpan(
                                                    //         text: st['studentId'] ??
                                                    //             "",
                                                    //         style: const TextStyle(
                                                    //             color: Colors.black,
                                                    //             fontWeight:
                                                    //             FontWeight
                                                    //                 .normal),
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                  ],
                                                );
                                              }),
                                              // trailing: Checkbox(
                                              //   value: st["isAbsent"],
                                              //   activeColor: Colors.green,
                                              //   onChanged: (value) {
                                              //     setState(() {
                                              //       st["isAbsent"] = value;
                                              //     });
                                              //   },
                                              // ),
                                            ),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                physics: const ScrollPhysics(),
                                                itemCount: grade.marksHeading.marksTitle!.length,
                                                itemBuilder:
                                                    (context, inner_index) {
                                                  var e = grade.marksHeading
                                                      .marksTitle![inner_index];

                                                  return TextFormField(
                                                      controller: __controllers[index]
                                                      [inner_index],
                                                      keyboardType: const TextInputType.numberWithOptions(decimal: true,signed: true),
                                                      decoration:
                                                      InputDecoration(
                                                        floatingLabelStyle:
                                                        const TextStyle(
                                                            color: Colors
                                                                .black),
                                                        label: Text(grade
                                                            .marksHeading
                                                            .marksTitle![
                                                        inner_index]
                                                            .heading
                                                            .toString()),
                                                      ));
                                                }),
                                            const SizedBox(height: 50,),
                                          ]);
                                        },
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.green),
                                            onPressed: () async {
                                              setState(() {
                                                isloading = true;
                                              });
                                              try {
                                                // Provider.of<CommonViewModel>(context,listen: false).setLoading(true);

                                                List<Mark> marks = [];
                                                for (var i = 0;
                                                    i < listForDisplay.length;
                                                    i++) {
                                                  Mark _mark = Mark(
                                                      username:
                                                      listForDisplay[i]["username"],
                                                      data: [], isAbsent: listForDisplay[i]["isAbsent"]);
                                                  // marks.add({, "data":[]});
                                                  for (var j = 0;
                                                      j <
                                                          (grade.marksHeading
                                                                      .marksTitle ==
                                                                  null
                                                              ? 0
                                                              : grade
                                                                  .marksHeading
                                                                  .marksTitle!
                                                                  .length);
                                                      j++) {
                                                    _mark.data?.add(Datum(
                                                        heading: grade.marksHeading
                                                                    .marksTitle !=
                                                                null
                                                            ? grade
                                                                .marksHeading
                                                                .marksTitle![j]
                                                                .heading
                                                                .toString()
                                                            : "",
                                                        marks: __controllers[i][j].text.isEmpty ? 0 : double.parse(__controllers[i][j].text)));
                                                  }
                                                  marks.add(_mark);
                                                }
                                                final request =
                                                    StudentGradingRequest(
                                                        examSlug: widget.examId,
                                                        courseSlug:
                                                            courseSlug.toString(),
                                                        marks: marks,
                                                        batch: selected_batch,
                                                        moduleSlug:
                                                            widget.moduleSlug);


                                                final ress = await GradeRepository()
                                                    .addStudentGrade(request);
                                                if (ress.success == true) {
                                                  setState(() {
                                                    isloading = false;
                                                  });
                                                  Alert(
                                                    context: context,
                                                    type: AlertType.success,
                                                    title: "Alert",
                                                    desc: ress.message.toString(),
                                                    buttons: [
                                                      DialogButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                          Navigator.pop(context);
                                                        },
                                                        color: Color.fromRGBO(0, 179, 134, 1.0),
                                                        child: const Text(
                                                          "ok",
                                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                                        ),
                                                      ),

                                                    ],
                                                  ).show();
                                                  // Provider.of<CommonViewModel>(context,listen: false).setLoading(false);
                                                } else {
                                                  setState(() {
                                                    isloading = false;
                                                  });
                                                  Alert(
                                                    context: context,
                                                    type: AlertType.warning,
                                                    title: "Alert",
                                                    desc: ress.message.toString(),
                                                    buttons: [
                                                      DialogButton(
                                                        child: Text(
                                                          "ok",
                                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(context);

                                                        },
                                                        color: Color.fromRGBO(0, 179, 134, 1.0),
                                                      ),

                                                    ],
                                                  ).show();
                                                  // Provider.of<CommonViewModel>(context,listen: false).setLoading(false);

                                                }
                                              } on Exception catch (e) {
                                                setState(() {
                                                  isloading = false;
                                                });
                                                // Provider.of<CommonViewModel>(context,listen: false).setLoading(true);
                                                Alert(
                                                  context: context,
                                                  type: AlertType.error,
                                                  title: "Alert",
                                                  desc: e.toString(),
                                                  buttons: [
                                                    DialogButton(
                                                      child: Text(
                                                        "ok",
                                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);

                                                      },
                                                      color: Color.fromRGBO(0, 179, 134, 1.0),
                                                    ),

                                                  ],
                                                ).show();
                                                // Provider.of<CommonViewModel>(context,listen: false).setLoading(false);
                                                // TODO
                                              }
                                            },
                                            child: const Text("Save")),
                                      ),
                                      const SizedBox(
                                        height: 100,
                                      ),
                                    ],
                                  )
                        : Image.asset('assets/images/no_content.PNG')
                    :  Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "You have already submitted marks for this batch/section",
                            textAlign: TextAlign.center,
                          )
                        ],
                      )
                : const SizedBox()
          ],
        );
      }),
    );
  }
}
