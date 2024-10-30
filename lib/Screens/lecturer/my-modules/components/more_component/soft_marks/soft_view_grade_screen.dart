import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:schoolworkspro_app/Screens/lecturer/NumberIncDec.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/more_component/grade_view_model.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/edit_marks_repository.dart';
import 'package:schoolworkspro_app/api/repositories/lecturer/grade_repository.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/lecturer/studentgrading_request.dart';

class SoftViewMarkStudentGrade extends StatefulWidget {
  final moduleSlug;
  final examId;
  const SoftViewMarkStudentGrade({Key? key, this.moduleSlug, this.examId})
      : super(key: key);
  @override
  _SoftViewMarkStudentGradeState createState() =>
      _SoftViewMarkStudentGradeState();
}

class _SoftViewMarkStudentGradeState extends State<SoftViewMarkStudentGrade> {
  late CommonViewModel _provider;
  late GradeViewModel _provider2;
  String? selected_batch;
  String? courseSlug;
  List<List<TextEditingController>> __controller = [];
  @override
  void initState() {
    // TODO: implement initState WidgetsBinding.instance WidgetsBinding.instance WidgetsBinding
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<CommonViewModel>(context, listen: false);
      _provider.setSlug(widget.moduleSlug);
      _provider.fetchBatches();
      _provider2 = Provider.of<GradeViewModel>(context, listen: false); //
    });
    super.initState();
  }

  String selectedMarksId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Soft View Marks",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer2<CommonViewModel, GradeViewModel>(
          builder: (context, common, grade, child) {
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
              items: common.batchArr.map((pt) {
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
                  grade
                      .fetchViewStudentGrade(widget.moduleSlug,
                          selected_batch.toString(), widget.examId.toString(), "soft")
                      .then((value) {
                    courseSlug = grade.studentGrade.first.student['courseSlug'];
                    for (int i = 0; i < grade.studentGrade.length; i++) {
                      __controller.add([]);
                      for (int j = 0;
                          j < grade.studentGrade[i].marks!.length;
                          j++) {
                        __controller[i].add(TextEditingController());
                        __controller[i][j].text =
                            grade.studentGrade[i].marks![j].marks.toString();
                      }
                    }
                  });
                });
              },
              value: selected_batch,
            ),
            selected_batch == null
                ? const SizedBox()
                : grade.studentGrade.isEmpty
                    ? Image.asset('assets/images/no_content.PNG')
                    : isLoading(grade.viewGradeApiResponse)
                        ? const VerticalLoader()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: grade.studentGrade.length,
                            itemBuilder: (context, index) {
                              var leadingIndex = index + 1;
                              var datas = grade.studentGrade[index];
                              __controller.add([]);
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    leading: Builder(builder: (context) {
                                      int sn = index + 1;
                                      return Text(sn.toString());
                                    }),
                                    title: Text(datas.student['firstname'] +
                                        " " +
                                        datas.student['lastname']),
                                    subtitle: Text(datas.username.toString()),
                                    trailing: Wrap(
                                      children: [
                                        // Checkbox(
                                        //   value: datas.isAbsent,
                                        //   activeColor: Colors.green,
                                        //   onChanged: (value) {
                                        //     setState(() {
                                        //       datas.isAbsent = value;
                                        //     });
                                        //   },
                                        // ),
                                        OutlinedButton(
                                            child: const Text("Update"),
                                            onPressed: () async {
                                              try {
                                                Provider.of<CommonViewModel>(
                                                        context,
                                                        listen: false)
                                                    .setLoading(true);
                                                Datum _datum;
                                                List<Datum> _list = <Datum>[];

                                                selectedMarksId =
                                                    datas.id.toString();

                                                for (int k = 0;
                                                    k < datas.marks!.length;
                                                    k++) {
                                                  setState(() {
                                                    _datum = Datum(
                                                        id: datas.marks![k].id
                                                            .toString(),
                                                        marks: __controller[
                                                                    index][k]
                                                                .text
                                                                .isEmpty
                                                            ? 0
                                                            : double.parse(
                                                                __controller[
                                                                            index]
                                                                        [k]
                                                                    .text),
                                                        heading: datas
                                                            .marks![k].heading
                                                            .toString());
                                                    _list.add(_datum);
                                                    print(
                                                        "DATAM MARKS:::${_datum.toJson()}");
                                                  });
                                                }
                                                // List<Mark> _listMark = <Mark>[];
                                                // Mark _mark = Mark();
                                                // setState(() {
                                                //   Mark _mark = Mark(
                                                //     // username: datas
                                                //     //     .username
                                                //     //     .toString(),
                                                //     moduleSlug: widget
                                                //         .moduleSlug
                                                //         .toString(),
                                                //     batch: selected_batch
                                                //         .toString(),
                                                //     data: _list,
                                                //     // isAbsent: datas.isAbsent
                                                //   );
                                                //   _listMark.add(_mark);
                                                // });
                                                // print("MARKS:::${_mark}");
                                                final request = {
                                                  "batch":
                                                      selected_batch.toString(),
                                                  "moduleSlug": widget
                                                      .moduleSlug
                                                      .toString(),
                                                  "marks": _list,
                                                };
                                                print(request);
                                                final ress =
                                                    await GradeRepository()
                                                        .updateSoftStudentGrade(
                                                            request,
                                                            selectedMarksId);
                                                if (ress.success == true) {
                                                  Alert(
                                                    context: context,
                                                    type: AlertType.success,
                                                    title: "Alert",
                                                    desc:
                                                        ress.message.toString(),
                                                    buttons: [
                                                      DialogButton(
                                                        child: Text(
                                                          "ok",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        color: Color.fromRGBO(
                                                            0, 179, 134, 1.0),
                                                      ),
                                                    ],
                                                  ).show();

                                                  Provider.of<CommonViewModel>(
                                                          context,
                                                          listen: false)
                                                      .setLoading(false);
                                                } else {
                                                  Alert(
                                                    context: context,
                                                    type: AlertType.warning,
                                                    title: "Alert",
                                                    desc:
                                                        ress.message.toString(),
                                                    buttons: [
                                                      DialogButton(
                                                        child: Text(
                                                          "ok",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        color: Color.fromRGBO(
                                                            0, 179, 134, 1.0),
                                                      ),
                                                    ],
                                                  ).show();
                                                  Provider.of<CommonViewModel>(
                                                          context,
                                                          listen: false)
                                                      .setLoading(false);
                                                }
                                              } on Exception catch (e) {
                                                Provider.of<CommonViewModel>(
                                                        context,
                                                        listen: false)
                                                    .setLoading(true);
                                                Alert(
                                                  context: context,
                                                  type: AlertType.error,
                                                  title: "Alert",
                                                  desc: e.toString(),
                                                  buttons: [
                                                    DialogButton(
                                                      child: Text(
                                                        "ok",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      color: Color.fromRGBO(
                                                          0, 179, 134, 1.0),
                                                    ),
                                                  ],
                                                ).show();
                                                Provider.of<CommonViewModel>(
                                                        context,
                                                        listen: false)
                                                    .setLoading(false);
                                                // TODO
                                              }
                                            }),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemCount: datas.marks!.length,
                                    itemBuilder: (context, Insideindex) {
                                      var insideData =
                                          datas.marks![Insideindex];
                                      __controller[index]
                                          .add(TextEditingController());
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(insideData.heading.toString()),
                                            TextFormField(
                                              controller: __controller[index]
                                                  [Insideindex],
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true,
                                                      signed: true),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                ],
                              );
                            },
                          )
          ],
        );
      }),
    );
  }
}
