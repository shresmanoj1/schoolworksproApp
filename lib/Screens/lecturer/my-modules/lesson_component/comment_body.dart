import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/comment_request.dart';
import 'package:schoolworkspro_app/response/lesson_response.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:schoolworkspro_app/services/commentserviceprovider_service.dart';
import 'package:schoolworkspro_app/services/like_service.dart';
import 'package:schoolworkspro_app/services/replycomment_service.dart';
import 'package:schoolworkspro_app/services/report_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Commentbody extends StatefulWidget {
  final moduleSlug;

  final LessonresponseLesson? data;
  final index;
  const Commentbody({Key? key, this.moduleSlug, this.data, this.index})
      : super(key: key);

  @override
  _CommentbodyState createState() => _CommentbodyState();
}

class _CommentbodyState extends State<Commentbody> {
  List<TextEditingController> _replycontrollers = [];
  User? user;
  bool showreplyfield = false;

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ChangeNotifierProvider<CommentServiceprovider>(
            create: (context) => CommentServiceprovider(),
            child: Consumer<CommentServiceprovider>(
                builder: (context, provider, child) {
              provider.getCommentsprovider(
                  widget.data!.lessons![widget.index].lessonSlug!, context);
              if (provider.data == null) {
                return const Center(
                    child: SpinKitDualRing(
                  color: kPrimaryColor,
                ));
              } else if (provider.data!.comments!.isEmpty) {
                return Container(
                  child: Image.asset('assets/images/no_content.PNG'),
                );
              }
              return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  itemCount: provider.data!.comments!.length,
                  itemBuilder: (context, i) {
                    var data = provider.data!.comments![i];

                    DateTime now = DateTime.parse(data.createdAt.toString());

                    now = now.add(const Duration(hours: 5, minutes: 45));

                    var formattedTime2 = DateFormat('yyyy/dd/mm').format(now);
                    var nameInital =
                        data.postedBy!.firstname![0].toUpperCase() +
                            "" +
                            data.postedBy!.lastname![0].toUpperCase();
                    _replycontrollers.add(TextEditingController());
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ListTile(
                            leading: data.postedBy!.userImage != null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(api_url2 +
                                        '/uploads/users/' +
                                        data.postedBy!.userImage!))
                                : CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Text(
                                      nameInital,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                            subtitle: data.postedBy!.type.toString() ==
                                    "Lecturer"
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Chip(
                                          backgroundColor: Colors.red,
                                          label: Text(
                                            data.postedBy!.type.toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                      Text(data.comment.toString()),
                                    ],
                                  )
                                : Text(data.comment.toString()),
                            trailing: Text(formattedTime2),
                            title: Text(data.postedBy!.firstname! +
                                " " +
                                data.postedBy!.lastname!)),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            // mainAxisAlignment:
                            //     MainAxisAlignment
                            //         .spaceAround,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    final res = await Likeservice().putlikes(
                                        provider.data!.comments![i].id!);
                                    if (res.success == true) {}
                                  },
                                  icon: data.likes!.contains(user!.username)
                                      ? const Icon(Icons.thumb_up_alt)
                                      : const Icon(
                                          Icons.thumb_up_alt_outlined)),
                              Text(data.likes!.length.toString()),
                              const SizedBox(
                                width: 20,
                              ),
                              IconButton(
                                  onPressed: () async {
                                    final res = await Reportservice().putreport(
                                        provider.data!.comments![i].id!);
                                    if (res.success == true) {}
                                  },
                                  icon: data.reports!.contains(user!.username)
                                      ? const Icon(Icons.flag)
                                      : const Icon(Icons.flag_outlined)),
                              Text(data.reports!.length.toString()),
                              const SizedBox(
                                width: 20,
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showreplyfield = true;
                                    });
                                  },
                                  icon: const Icon(Icons.reply)),
                              Text(data.replies!.length.toString()),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50.0, top: 10.0, right: 10),
                          child: TextFormField(
                            controller: _replycontrollers[i],
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: "Add a reply",
                              prefixIcon: Icon(Icons.comment),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              // border:
                              //     OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, left: 50.0, right: 10),
                          child: TextButton(
                            child: Text('Reply'),
                            onPressed: () async {
                              final datass = Commentrequest(
                                comment: _replycontrollers[i].text,
                              );
                              final result = await Replycommentservice()
                                  .replycomment(data.id!, datass);
                              if (result.success == true) {
                                setState(() {
                                  _replycontrollers[i].clear();
                                });
                                final snackBar = SnackBar(
                                  content:
                                      const Text("Reply added successfully"),
                                  backgroundColor: (Colors.black),
                                  action: SnackBarAction(
                                    label: 'dismiss',
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    },
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                final snackBar = SnackBar(
                                  content: const Text("Unable to save reply"),
                                  backgroundColor: (Colors.black),
                                  action: SnackBarAction(
                                    label: 'dismiss',
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    },
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                          ),
                        ),
                        Container(
                          color: Colors.grey[300],
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        data.replies!.isEmpty
                            ? const SizedBox(
                                height: 1,
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: ScrollPhysics(),
                                itemCount: data.replies!.length,
                                itemBuilder: (context, replyindex) {
                                  var nameInital2 = data.replies![replyindex]
                                          .postedBy!.firstname![0]
                                          .toUpperCase() +
                                      "" +
                                      data.replies![replyindex].postedBy!
                                          .lastname![0]
                                          .toUpperCase();
                                  DateTime replieddate = DateTime.parse(data
                                      .replies![replyindex].createdAt
                                      .toString());

                                  replieddate = replieddate.add(
                                      const Duration(hours: 5, minutes: 45));

                                  var formattedreply = DateFormat('yyyy/dd/mm')
                                      .format(replieddate);
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: ListTile(
                                      trailing: Text(formattedreply),
                                      leading: data.replies![replyindex]
                                                  .postedBy!.userImage !=
                                              null
                                          ? CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  api_url2 +
                                                      '/uploads/users/' +
                                                      data
                                                          .replies![replyindex]
                                                          .postedBy!
                                                          .userImage!))
                                          : CircleAvatar(
                                              backgroundColor: Colors.grey,
                                              child: Text(
                                                nameInital2,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                      title: Row(
                                        children: [
                                          Text(data.replies![replyindex]
                                                  .postedBy!.firstname! +
                                              " " +
                                              data.replies![replyindex]
                                                  .postedBy!.lastname!),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: data.replies![replyindex]
                                                          .postedBy!.type! ==
                                                      "Lecturer"
                                                  ? Chip(
                                                      backgroundColor:
                                                          Colors.red[800],
                                                      label: Text(
                                                        data
                                                                    .replies![
                                                                        replyindex]
                                                                    .postedBy!
                                                                    .type! ==
                                                                "Lecturer"
                                                            ? data
                                                                .replies![
                                                                    replyindex]
                                                                .postedBy!
                                                                .type!
                                                            : " ",
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))
                                                  : const SizedBox(height: 1))
                                        ],
                                      ),
                                      subtitle: Text(
                                          data.replies![replyindex].comment!),
                                    ),
                                  );
                                },
                              ),
                        Divider(
                          height: 20,
                          thickness: 10,
                          indent: 2,
                          color: Colors.grey.shade200,
                        ),
                      ],
                    );
                  });
            })),
      ],
    );
  }
}
