import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schoolworkspro_app/Screens/survey/surveydetailscreen.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/survey_response.dart';
import 'package:schoolworkspro_app/services/survey_service.dart';

class Surveyscreen extends StatefulWidget {
  const Surveyscreen({Key? key}) : super(key: key);

  @override
  _SurveyscreenState createState() => _SurveyscreenState();
}

class _SurveyscreenState extends State<Surveyscreen> {
  Future<Surveyresponse>? survey_response;
  bool available = true;

  @override
  void initState() {
    // TODO: implement initState
    survey_response = Surveyservice().getsurveys();
    getsurvey();
    super.initState();
  }

  getsurvey() async {
    final data = await Surveyservice().getsurveys();
    if (data.survey!.isEmpty) {
      setState(() {
        available = false;
      });
    } else {
      setState(() {
        available = true;
      });
    }
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
      body: available == false
          ? Column(children: <Widget>[
              Image.asset("assets/images/no_content.PNG"),
              const Text(
                "No survey available",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
            ])
          : FutureBuilder<Surveyresponse>(
              future: survey_response,
              builder: (BuildContext context,
                  AsyncSnapshot<Surveyresponse> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.survey!.length,
                      itemBuilder: (context, index) {
                        var survey = snapshot.data!.survey![index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: InkWell(
                              onTap: () {
                                // Fluttertoast.showToast(
                                //     msg: "On Development phase");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Surveydetailscreen(
                                            data: snapshot.data,
                                            index: index,
                                          )),
                                );
                              },
                              child: ListTile(
                                  trailing: const Icon(
                                    Icons.play_circle,
                                    color: Colors.green,
                                  ),
                                  title: Text(
                                    survey.surveyName!,
                                  )),
                            ),
                          ),
                        );
                      });
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  return const Center(
                    child: SpinKitDualRing(color: kPrimaryColor),
                  );
                }
              },
            ),
    );
  }
}
