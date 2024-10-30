import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/lecturer/submissionstats_response.dart';

class SubmissionStatsScreen extends StatefulWidget {
  final id;
  final batch;
  const SubmissionStatsScreen({Key? key, this.id, this.batch})
      : super(key: key);

  @override
  _SubmissionStatsScreenState createState() => _SubmissionStatsScreenState();
}

class _SubmissionStatsScreenState extends State<SubmissionStatsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LecturerCommonViewModel>(context, listen: false)
          .fetchsubmissionstats(widget.id, widget.batch);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<LecturerCommonViewModel>(builder: (context, value, child) {
        return isLoading(value.submissionStatsApiResponse)
            ? Center(
                child: SpinKitDualRing(
                  color: kPrimaryColor,
                ),
              )
            : ListView(
                children: [
                  ...List.generate(
                      value.submission.length,
                      (index) => ListTile(
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Batch/section: " +
                                    value.submission[index].batch.toString()),
                                Text("username: " +
                                    value.submission[index].username
                                        .toString()),
                                value.submission[index].submission == null
                                    ? const Text(
                                        "Not submitted",
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : Builder(builder: (context) {
                                        return Text("submitted on: " +
                                            value.submission[index].submission!
                                                .createdAt
                                                .toString());
                                      }),
                              ],
                            ),
                            // trailing:  InkWell(
                            //     onTap: (){
                            //       showModalBottomSheet(
                            //         context: context,
                            //         builder: ((builder) =>
                            //             bottomSheet(value.submission[index])),
                            //       );
                            //     },
                            //     child: Icon(Icons.more_vert,size: 20,)),
                            title: Text(value.submission[index].firstname
                                    .toString() +
                                " " +
                                value.submission[index].lastname.toString()),
                          )),
                ],
              );
      }),
    );
  }

  Widget bottomSheet(SubmissionElement data) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      height: 200.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text(
            data.firstname.toString() + " " + data.lastname.toString(),
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => LessoncontentLecturer(
              //         data: value,
              //         moduleSlug: widget.data['moduleSlug'],
              //         index: index,
              //       )),
              // );
            },
          ),
          ListTile(
            onTap: () {},
            title: Text("Submit"),
            leading: Icon(Icons.send_and_archive),
          ),
        ],
      ),
    );
  }
}
