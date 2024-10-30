import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolworkspro_app/Screens/courses/particulardetailmodule.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/coursedetail_response.dart';
import 'package:schoolworkspro_app/services/coursedetail_service.dart';

class Coursedetail extends StatefulWidget {
  final data;
  const Coursedetail({Key? key, this.data}) : super(key: key);

  @override
  _CoursedetailState createState() => _CoursedetailState();
}

class _CoursedetailState extends State<Coursedetail> {
  Future<CoursedetailResponse>? coursedetail_response;
  List tags = [];

  @override
  void initState() {
    getCoursedetail();

    super.initState();
  }

  getCoursedetail() async {
    coursedetail_response = CourseDetailservice().getCoursedetail(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white),
      body: FutureBuilder<CoursedetailResponse>(
        future: coursedetail_response,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.course!.modules!.isEmpty
                ? Column(children: <Widget>[
                    Image.asset("assets/images/no_content.PNG"),
                  ])
                : GridView.builder(
                    itemCount: snapshot.data!.course!.modules!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      childAspectRatio: width / (height / 1.3),
                    ),
                    itemBuilder: (context, index) {
                      var module = snapshot.data!.course!.modules![index];
                      var extension = snapshot
                          .data!.course!.modules![index].imageUrl!
                          .split(".")
                          .last;
                      var moduleleader = module.moduleLeader!.firstname! +
                          " " +
                          module.moduleLeader!.lastname!;
                      var nameInital =
                          module.moduleLeader!.firstname![0].toUpperCase() +
                              "" +
                              module.moduleLeader!.lastname![0].toUpperCase();
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Particulardetailmodule(
                                      data: snapshot.data,
                                      index: index,
                                    )),
                          );
                        },
                        child: Wrap(children: [
                          Card(
                            margin: const EdgeInsets.only(
                                left: 8, bottom: 8, right: 8.0),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                // Text(module.moduleSlug),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          extension == "svg"
                                              ? SvgPicture.network(
                                                  api_url2 +
                                                      '/uploads/modules/' +
                                                      module.imageUrl!,
                                                  height: 128.0,
                                                  width: 180.0,
                                                )
                                              : Image.network(
                                                  api_url2 +
                                                      '/uploads/modules/' +
                                                      module.imageUrl!,
                                                  height: 128.0,
                                                  width: 180.0,
                                                ),
                                          Positioned(
                                            // The Positioned widget is used to position the text inside the Stack widget
                                            top: 0,
                                            left: 0,

                                            child: Container(
                                                // We use this Container to create a black box that wraps the white text so that the user can read the text even when the image is white
                                                width: 80,
                                                color: Colors.white,
                                                child: Text(
                                                  module.year!.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                )),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(module.moduleTitle!,
                                              overflow: TextOverflow.ellipsis)),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: module.moduleLeader!
                                                .toJson()
                                                .isEmpty
                                            ? const Text("moduleleader",
                                                style: TextStyle(fontSize: 12))
                                            : Text(moduleleader,
                                                style: const TextStyle(
                                                    fontSize: 12)),
                                      ),
                                      ButtonBar(
                                        alignment: MainAxisAlignment.end,
                                        children: [
                                          Chip(
                                            labelPadding:
                                                const EdgeInsets.all(2),
                                            backgroundColor: Colors.blueAccent,
                                            label: Row(
                                              children: [
                                                const Icon(
                                                  Icons.play_circle_outlined,
                                                  color: Colors.white,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0),
                                                  child: Text(
                                                      module.lessons!.length
                                                              .toString() +
                                                          " lessons",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      );
                    });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const Center(
                child: CupertinoActivityIndicator()
            //     SpinKitDualRing(
            //   color: kPrimaryColor,
            // )
            );
          }
        },
      ),
    );
  }
}
