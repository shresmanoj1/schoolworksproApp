import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schoolworkspro_app/request/survey_request.dart';
import 'package:schoolworkspro_app/response/survey_response.dart';
import 'package:schoolworkspro_app/services/postsurvey_service.dart';

class Surveydetailscreen extends StatefulWidget {
  final Surveyresponse? data;
  final index;
  const Surveydetailscreen({Key? key, this.data, this.index}) : super(key: key);

  @override
  _SurveydetailscreenState createState() => _SurveydetailscreenState();
}

class _SurveydetailscreenState extends State<Surveydetailscreen> {
  List<String>? groupvalue;

  List<String> status = [];
  List<AnswerArray> answer_list = [];
  String? surveyid;
  String? question;

  @override
  void initState() {
    // TODO: implement initState
    for (int j = 0;
        j < widget.data!.survey![widget.index].content!.length;
        j++) {
      groupvalue!.add(
        "ass",
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Survey",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    itemCount:
                        widget.data!.survey![widget.index].content!.length,
                    itemBuilder: (context, i) {
                      var datas =
                          widget.data!.survey![widget.index].content![i];
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        // Add Your Code here.
                        setState(() {
                          surveyid = widget.data!.survey![widget.index].id;
                          question = datas.question;
                        });
                      });

                      return ExpansionTile(
                          trailing: const Icon(
                            Icons.arrow_downward,
                            color: Colors.transparent,
                          ),
                          initiallyExpanded: true,
                          title: Text(
                            datas.question!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 12),
                          ),
                          children: List.generate(datas.options!.length, (i) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: Radio(
                                      onChanged: (value) {
                                        setState(() {
                                          groupvalue![0] = value as String;
                                        });
                                      },
                                      groupValue: groupvalue![0],
                                      value: datas.options![i].option!,
                                    ),
                                    title: Text(
                                      datas.options![i].option!,
                                    ),
                                  )
                                  // ListTile(
                                  //   leading: RadioGroup<String>.builder(
                                  //     groupValue: _verticalGroupValue,
                                  //     onChanged: (value) => setState(() {
                                  //       _verticalGroupValue = value!;
                                  //     }),
                                  //     items: status,
                                  //     itemBuilder: (item) => RadioButtonBuilder(
                                  //       item,
                                  //       textPosition: RadioButtonTextPosition.right,
                                  //     ),
                                  //   ),
                                  //   title: Text(
                                  //     datas.options![i].option!,
                                  //     style: const TextStyle(fontSize: 14),
                                  //   ),
                                  // trailing: completion
                                  //         .contains(datas
                                  //             .lessons[i]
                                  //             .id)
                                  //     ? Icon(
                                  //         Icons
                                  //             .check_circle,
                                  //         color: Colors
                                  //             .green,
                                  //       )
                                  //     : null,\
                                  // onTap: () {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder:
                                  //             (context) =>
                                  //                 Lessoncontent(
                                  //                   data: datas,
                                  //                   moduleSlug: widget.moduleslug,
                                  //                   index: i,
                                  //                 )),
                                  //   );
                                  // },
                                  // onTap: () async {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder:
                                  //           (context) =>

                                  // );
                                  //   final SharedPreferences
                                  //       sharedPreferences =
                                  //       await SharedPreferences
                                  //           .getInstance();
                                  //   sharedPreferences
                                  //       .setString(
                                  //           'lessonId',
                                  //           datas
                                  //               .lessons[
                                  //                   i]
                                  //               .id);
                                  // },
                                  // ),
                                ],
                              ),
                            );
                          }));
                    }
                    // return Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(datas.question!),
                    // RadioGroup<String>.builder(
                    //   groupValue: _verticalGroupValue,
                    //   onChanged: (value) => setState(() {
                    //     _verticalGroupValue = value!;
                    //   }),
                    //   items: status,
                    //   itemBuilder: (item) => RadioButtonBuilder(
                    //     item,
                    //     textPosition: RadioButtonTextPosition.right,
                    //   ),
                    // ),
                    //   ],
                    // ),
                    // );

                    ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              // ElevatedButton(
              //     onPressed: () async {
              //       WidgetsBinding.instance!.addPostFrameCallback((_) {
              //         setState(() {
              //           answer_list.add(AnswerArray(
              //               question: question, ans: groupvalue));
              //         });
              //       });

              //       final datas = await Surveyrequest(
              //           surveyId: surveyid, answerArray: answer_list);

              //       final res = await Postsurveyservice().addsurvey(datas);

              //       if (res.success == true) {
              //         print(surveyid);
              //         print(question);
              //         print(groupvalue);
              //         Fluttertoast.showToast(msg: res.message!);
              //       } else {
              //         Fluttertoast.showToast(msg: res.message!);
              //       }
              //     },
              //     child: const Text("Next")),
              // ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
