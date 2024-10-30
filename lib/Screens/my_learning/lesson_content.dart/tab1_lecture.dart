import 'dart:ui';

import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/my_learning/learning_view_model.dart';
import 'package:schoolworkspro_app/Screens/my_learning/tab_button.dart';
import 'package:schoolworkspro_app/Screens/widgets/custom_button.dart';
import 'package:schoolworkspro_app/Screens/widgets/custom_text_field.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:schoolworkspro_app/helper/image_from_network.dart';
import 'package:schoolworkspro_app/request/comment_request.dart';
import 'package:schoolworkspro_app/request/lessonratingrequest.dart';
import 'package:schoolworkspro_app/request/lessontrack_request.dart';
import 'package:schoolworkspro_app/response/comment_response.dart';
import 'package:schoolworkspro_app/response/lesson_response.dart';
import 'package:schoolworkspro_app/response/lessoncontent_response.dart';
import 'package:schoolworkspro_app/response/lessonrating_response.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:schoolworkspro_app/response/particularassessment_response.dart';
import 'package:schoolworkspro_app/services/comment_service.dart';
import 'package:schoolworkspro_app/services/commentserviceprovider_service.dart';
import 'package:schoolworkspro_app/services/lesson_service.dart';
import 'package:schoolworkspro_app/services/lessoncontent_service.dart';
import 'package:schoolworkspro_app/services/lessonrating_service.dart';
import 'package:schoolworkspro_app/services/like_service.dart';
import 'package:schoolworkspro_app/services/particularassessment_service.dart';
import 'package:schoolworkspro_app/services/postcomment_service.dart';
import 'package:schoolworkspro_app/services/replycomment_service.dart';
import 'package:schoolworkspro_app/services/report_service.dart';
import 'package:schoolworkspro_app/services/startlessonservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;
import 'package:intl/intl.dart';
// import 'package:universal_html/parsing.dart';

import '../../../config/api_response_config.dart';
import '../../../constants/text_style.dart';
import '../activity/student_assessment_task_screen.dart';
import '../additional_resources/additional_resource_screen.dart';
import '../additional_resources/additional_resources_view_model.dart';
import '../additional_resources/additional_screen_tab.dart';
import '../components/assessment_submission_card.dart';
import 'lesson_content.dart';

class Tab1Lecture extends StatefulWidget {
  final moduleSlug;
  dynamic lessonStatus;
  Function(bool index) callback;
  final LessonresponseLesson? data;
  final index;
  Tab1Lecture(
      {Key? key,
      this.moduleSlug,
      required this.callback,
      this.data,
      required this.lessonStatus,
      this.index})
      : super(key: key);

  @override
  State<Tab1Lecture> createState() => _Tab1LectureState();
}

class _Tab1LectureState extends State<Tab1Lecture> {
  List<TextEditingController> _replycontrollers = [];
  final TextEditingController commentcontroller = TextEditingController();
  User? user;
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
    return Scaffold(
      bottomNavigationBar: Container(
        height: 60,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  // color: Colors.red,
                  child: widget.index <= 0
                      ? const SizedBox(
                          height: 1,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Lessoncontent(
                                          moduleSlug: widget.moduleSlug,
                                          data: widget.data!,
                                          index: widget.index - 1,
                                        )),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.arrow_back_ios_new),
                                    Text(
                                      "Previous",
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      maxLines: 1,
                                      style: p15,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
                Expanded(
                  // color: Colors.black,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: widget.index >= widget.data!.lessons!.length - 1
                        ? const SizedBox(
                            height: 1,
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Lessoncontent(
                                              moduleSlug: widget.moduleSlug,
                                              data: widget.data!,
                                              index: widget.index + 1,
                                            )));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const SizedBox(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("Next",
                                          softWrap: false,
                                          maxLines: 1,
                                          style: p15,
                                          overflow: TextOverflow.ellipsis),
                                      const Icon(
                                          Icons.arrow_forward_ios_rounded),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(child:
          Consumer<LearningViewModel>(builder: (context, snapshot, child) {
        return Column(children: [
          (isLoading(snapshot.trackingApiResponse) ||
                  isLoading(snapshot.lessonContentApiResponse))
              ? const Center(child: CupertinoActivityIndicator())
              : Column(
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        ImageFiltered(
                          imageFilter: ImageFilter.blur(
                              sigmaX: snapshot.lessonStatus == null ? 12 : 0,
                              sigmaY: snapshot.lessonStatus == null ? 12 : 0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Html(
                                  style: {
                                    "ol": Style(margin: const EdgeInsets.all(5))
                                  },
                                  shrinkWrap: true,
                                  data: snapshot.lessonContent.lessonContents!,
                                  customRender: {
                                    "table": (context, child) {
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: (context.tree as TableLayoutElement).toWidget(context),
                                      );
                                    }
                                  },
                                  onLinkTap: (String? url,
                                      RenderContext context,
                                      Map<String, String> attributes,
                                      dom.Element? element) {
                                    Future<void> _launchInBrowser(Uri url) async {
                                      if (await launchUrl(
                                        url,
                                        mode: LaunchMode.externalApplication,
                                      )) {
                                        throw 'Could not launch $url';
                                      }
                                    }
                                    var linkUrl = url!.replaceAll(" ", "%20");
                                    _launchInBrowser(Uri.parse(linkUrl));
                                  },
                                  onImageTap: (String? url,
                                      RenderContext context,
                                      Map<String, String> attributes,
                                      dom.Element? element) {
                                    // print(url!);
                                    //open image in webview, or launch image in browser, or any other logic here
                                    launch(url!);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        snapshot.lessonStatus == null
                            ? Positioned(
                                top: 15,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: CustomButton(
                                      borderRadius: 15,
                                      buttonColor: Colors.black,
                                      onClick: () async {
                                        final data = LessonTrackRequest(
                                            moduleSlug: widget.moduleSlug,
                                            lesson: widget.data!
                                                .lessons![widget.index].id);

                                        await snapshot.startLesson(
                                            data, context);
                                      },
                                      buttonName: "Start Lesson"),
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    snapshot.lessonStatus == null
                        ? SizedBox()
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "How did you find this lesson",
                                              style: p15,
                                            ),
                                            RatingBar.builder(
                                              initialRating: double.parse(
                                                  snapshot.rating.toString()),
                                              // minRating: 1,
                                              direction: Axis.horizontal,
                                              tapOnlyMode: false,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 25,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2.0),
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) async {
                                                final data = Lessonraterequest(
                                                    rating: rating,
                                                    lessonSlug: widget
                                                        .data!
                                                        .lessons![widget.index]
                                                        .lessonSlug);

                                                final req =
                                                    await Lessonratingservice()
                                                        .postratings(data);

                                                if (req.success == true) {
                                                } else {}

                                                // print(rating);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: InkWell(
                                            onTap: () async {
                                              final data = LessonTrackRequest(
                                                moduleSlug: widget.moduleSlug,
                                                lesson: widget.data!
                                                    .lessons![widget.index].id,
                                              );

                                              print(jsonEncode(data));
                                              // if(snapshot.lessonStatus['isCompleted'] == true){
                                              await snapshot.markAsComplete(
                                                  context, data);

                                              snapshot.fetchMyLearning("");
                                              snapshot.fetchMyNewLearning("");
                                              // }else{
                                              //   await snapshot.markAsComplete(data);
                                              // }

                                              // final res =
                                              // await Lessonservice()
                                              //     .marklessoncomplete(
                                              //     data);
                                              // if (res.success == true) {
                                              //   if (completed == false) {
                                              //     setState(() {
                                              //       completed = true;
                                              //     });
                                              //
                                              //     Fluttertoast.showToast(
                                              //         msg:
                                              //         'marked as complete');
                                              //   } else {
                                              //     setState(() {
                                              //       completed = false;
                                              //     });
                                              //     Fluttertoast.showToast(
                                              //         msg: 'Unmarked');
                                              //   }
                                              // } else {
                                              //   setState(() {
                                              //     completed = false;
                                              //   });
                                              //   Fluttertoast.showToast(
                                              //       msg:
                                              //       'Unable to mark as complete, plz start lesson again');
                                              //   Navigator.pushReplacement(
                                              //       context,
                                              //       MaterialPageRoute(
                                              //           builder: (BuildContext
                                              //           context) =>
                                              //           super.widget));
                                            },
                                            child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 20.0,
                                                    top: 20.0,
                                                    bottom: 20.0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: (widget.lessonStatus ==
                                                                null ||
                                                            widget.lessonStatus[
                                                                    'isCompleted'] ==
                                                                false)
                                                        ? Colors.pink
                                                        : Colors.green),
                                                child: (widget.lessonStatus ==
                                                            null ||
                                                        widget.lessonStatus[
                                                                'isCompleted'] ==
                                                            false)
                                                    ? const Text(
                                                        "Mark as \n complete",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
                                                    : const Text(
                                                        "Completed",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: white),
                                                      )),
                                          ),
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Comments",
                                      style: p15.copyWith(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      "${snapshot.comments.length} Comments",
                                      style: p15.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: logoTheme),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                    hintText: "Post a comment",
                                    controller: commentcontroller,
                                    hasBottomSpace: true),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: InkWell(
                                      onTap: () async {
                                        final data = Commentrequest(
                                            comment: commentcontroller.text);
                                        await snapshot.comment(
                                            data,
                                            widget.data?.lessons?[widget.index]
                                                    .lessonSlug ??
                                                "",
                                            context);
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFF004D96),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                            child: Text(
                                          "Post",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: white),
                                        )),
                                      ),
                                    )
                                    // CustomButton(
                                    //     width: 100,
                                    //     height: 20,
                                    //     buttonColor: const Color(0xFF004D96),
                                    //     buttonName: "Post",
                                    //     onClick: () async {
                                    //       final data = Commentrequest(
                                    //           comment: commentcontroller.text);
                                    //       await snapshot.comment(
                                    //           data,
                                    //           widget.data?.lessons?[widget.index]
                                    //                   .lessonSlug ??
                                    //               "",
                                    //           context);
                                    //     }),
                                    ),
                                const SizedBox(height: 5,),
                                const Divider(
                                  thickness: 1,
                                  color: logoTheme,
                                ),
                                const SizedBox(height: 5,),
                                isLoading(snapshot.commentApiResponse)
                                    ? const SizedBox()
                                    : Column(
                                        children: [
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics: const ScrollPhysics(),
                                              itemCount:
                                                  snapshot.comments.length,
                                              itemBuilder: (context, i) {
                                                var data = snapshot.comments[i];

                                                DateTime now = DateTime.parse(
                                                    data.createdAt.toString());

                                                now = now.add(const Duration(
                                                    hours: 5, minutes: 45));

                                                var formattedTime2 =
                                                    DateFormat('yyyy/dd/mm')
                                                        .format(now);
                                                var nameInital =
                                                    "${data.postedBy!.firstname![0].toUpperCase()}${data.postedBy!.lastname![0].toUpperCase()}";
                                                _replycontrollers.add(
                                                    TextEditingController());
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    ListTile(
                                                      contentPadding: EdgeInsets.zero,
                                                        minLeadingWidth: 5,
                                                        // leading: data.postedBy!
                                                        //             .userImage !=
                                                        //         null
                                                        //     ? CircleAvatar(
                                                        //         backgroundImage:
                                                        //             NetworkImage(
                                                        //                 ImageFromNetwork.fullImageUrl(
                                                        //                     'uploads/users/${data.postedBy?.userImage}')))
                                                        //     : CircleAvatar(
                                                        //         backgroundColor:
                                                        //             Colors.grey,
                                                        //         child: Text(
                                                        //           nameInital,
                                                        //           style: const TextStyle(
                                                        //               fontWeight:
                                                        //                   FontWeight
                                                        //                       .bold,
                                                        //               color: Colors
                                                        //                   .white),
                                                        //         ),
                                                        //       ),
                                                        subtitle:
                                                            Container(
                                                              margin: const EdgeInsets.only(left:45, top: 10, bottom: 10),
                                                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                              decoration: const BoxDecoration(color: Color(0xffF2F2F2)),
                                                                child: Text(data.comment!, style: TextStyle(color: black))),

                                                        // trailing: Text(
                                                        //     formattedTime2),
                                                        title: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            data.postedBy!
                                                                .userImage !=
                                                                null
                                                                ? CircleAvatar(
                                                                backgroundImage:
                                                                NetworkImage(
                                                                    ImageFromNetwork.fullImageUrl(
                                                                        'uploads/users/${data.postedBy?.userImage}')))
                                                                : CircleAvatar(
                                                              backgroundColor:
                                                              Colors.grey,
                                                              child: Text(
                                                                nameInital,
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 10,),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    "${data.postedBy!.firstname} ${data.postedBy!.lastname}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                                                Text(
                                                                    formattedTime2,style: TextStyle(color: Colors.grey, fontSize: 12),),
                                                              ],
                                                            ),
                                                            SizedBox(height: 5),
                                                          ],
                                                        ),),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Row(
                                                        // mainAxisAlignment:
                                                        //     MainAxisAlignment
                                                        //         .spaceAround,
                                                        children: [
                                                          const SizedBox(width:45),
                                                          IconButton(
                                                              padding: EdgeInsets.zero,
                                                              constraints: const BoxConstraints(),
                                                              onPressed:
                                                                  () async {
                                                                await snapshot.like(
                                                                    snapshot
                                                                        .comments[
                                                                            i]
                                                                        .id
                                                                        .toString(),
                                                                    widget
                                                                            .data
                                                                            ?.lessons?[widget.index]
                                                                            .lessonSlug ??
                                                                        "",
                                                                    context);
                                                              },
                                                              icon: data.likes!
                                                                      .contains(
                                                                          user!
                                                                              .username)
                                                                  ? const Icon(
                                                                      Icons
                                                                          .thumb_up_alt,
                                                                      color: Colors
                                                                          .blue,
                                                                    )
                                                                  : const Icon(Icons
                                                                      .thumb_up_alt_outlined)),
                                                          Text(data.likes!.isEmpty ? "" : data.likes!.length
                                                              .toString(), style:const TextStyle(fontWeight: FontWeight.bold)),
                                                          const SizedBox(width:3),
                                                          const Text("Likes", style:TextStyle(fontWeight: FontWeight.bold)),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          IconButton(
                                                              padding: EdgeInsets.zero,
                                                              constraints: const BoxConstraints(),
                                                              onPressed: () {},
                                                              icon: const Icon(
                                                                  Icons.reply)),
                                                          Text(data
                                                              .replies!.isEmpty ? "" : data.replies!.length.toString()
                                                              ),
                                                          const SizedBox(width:3),
                                                          const Text("Reply", style:TextStyle(fontWeight: FontWeight.bold)),

                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          IconButton(
                                                              padding: EdgeInsets.zero,
                                                              constraints: const BoxConstraints(),
                                                              onPressed:
                                                                  () async {
                                                                await snapshot.flag(
                                                                    snapshot
                                                                        .comments[
                                                                    i]
                                                                        .id
                                                                        .toString(),
                                                                    widget
                                                                        .data
                                                                        ?.lessons?[widget.index]
                                                                        .lessonSlug ??
                                                                        "",
                                                                    context);
                                                                // final res = await Reportservice()
                                                                //     .putreport(snapshot
                                                                //         .comments[
                                                                //             i]
                                                                //         .id!);
                                                                // if (res.success ==
                                                                //     true) {}
                                                              },
                                                              icon: data
                                                                  .reports!
                                                                  .contains(
                                                                  user!
                                                                      .username)
                                                                  ? const Icon(
                                                                Icons
                                                                    .flag,
                                                                color: Colors
                                                                    .red,
                                                              )
                                                                  : const Icon(Icons
                                                                  .flag_outlined)),
                                                          Text(data
                                                              .reports!.isEmpty ? "" : data.reports!.length
                                                              .toString(), style:TextStyle(fontWeight: FontWeight.bold)),
                                                          const SizedBox(width:3),
                                                          const Text("Report", style:TextStyle(fontWeight: FontWeight.bold)),

                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 30.0,
                                                              top: 10.0,
                                                              right: 10),
                                                      child: Container(
                                                        // decoration:
                                                        //     const BoxDecoration(
                                                        //         border: Border(
                                                        //             left:
                                                        //                 BorderSide(
                                                        //   color: grey_400,
                                                        //   width: 1,
                                                        // ))),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 17.0),
                                                          child: Column(
                                                            children: [
                                                              CustomTextField(
                                                                // height: 40,
                                                                hintText:
                                                                    "Add a reply",
                                                                controller:
                                                                    _replycontrollers[
                                                                        i],
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child:
                                                                    TextButton(
                                                                  child: const Text(
                                                                      'Reply'),
                                                                  onPressed:
                                                                      () async {
                                                                    final datass =
                                                                        Commentrequest(
                                                                      comment: _replycontrollers[
                                                                              i]
                                                                          .text,
                                                                    );
                                                                    await snapshot.reply(
                                                                        datass,
                                                                        snapshot
                                                                            .comments[
                                                                                i]
                                                                            .id
                                                                            .toString(),
                                                                        widget.data?.lessons?[widget.index].lessonSlug ??
                                                                            "",
                                                                        context);
                                                                    _replycontrollers[
                                                                            i]
                                                                        .clear();
                                                                    // final result =
                                                                    //     await Replycommentservice().replycomment(
                                                                    //         data.id!,
                                                                    //         datass);
                                                                    // if (result
                                                                    //         .success ==
                                                                    //     true) {
                                                                    //   setState(
                                                                    //       () {
                                                                    //     _replycontrollers[i]
                                                                    //         .clear();
                                                                    //   });
                                                                    //   final snackBar =
                                                                    //       SnackBar(
                                                                    //     content:
                                                                    //         const Text("Reply added successfully"),
                                                                    //     backgroundColor:
                                                                    //         (Colors.black),
                                                                    //     action:
                                                                    //         SnackBarAction(
                                                                    //       label:
                                                                    //           'dismiss',
                                                                    //       onPressed:
                                                                    //           () {
                                                                    //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                                    //       },
                                                                    //     ),
                                                                    //   );
                                                                    //   ScaffoldMessenger.of(
                                                                    //           context)
                                                                    //       .showSnackBar(
                                                                    //           snackBar);
                                                                    // } else {
                                                                    //   final snackBar =
                                                                    //       SnackBar(
                                                                    //     content:
                                                                    //         const Text("Unable to save reply"),
                                                                    //     backgroundColor:
                                                                    //         (Colors.black),
                                                                    //     action:
                                                                    //         SnackBarAction(
                                                                    //       label:
                                                                    //           'dismiss',
                                                                    //       onPressed:
                                                                    //           () {
                                                                    //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                                    //       },
                                                                    //     ),
                                                                    //   );
                                                                    //   ScaffoldMessenger.of(
                                                                    //           context)
                                                                    //       .showSnackBar(
                                                                    //           snackBar);
                                                                    // }
                                                                  },
                                                                ),
                                                              ),
                                                              data.replies!
                                                                      .isEmpty
                                                                  ? const SizedBox(
                                                                      height: 1,
                                                                    )
                                                                  : ListView
                                                                      .builder(
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          ScrollPhysics(),
                                                                      itemCount: data
                                                                          .replies!
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              replyindex) {
                                                                        var nameInital2 =
                                                                            "${data.replies![replyindex].postedBy!.firstname![0].toUpperCase()}${data.replies![replyindex].postedBy!.lastname![0].toUpperCase()}";
                                                                        DateTime replieddate = DateTime.parse(data
                                                                            .replies![replyindex]
                                                                            .createdAt
                                                                            .toString());

                                                                        replieddate = replieddate.add(const Duration(
                                                                            hours:
                                                                                5,
                                                                            minutes:
                                                                                45));

                                                                        var formattedreply =
                                                                            DateFormat('yyyy/dd/mm').format(replieddate);
                                                                        return ListTile(
                                                                          contentPadding: EdgeInsets.zero,
                                                                          // trailing:
                                                                          //     Text(formattedreply),
                                                                          // leading: data.replies![replyindex].postedBy!.userImage != null
                                                                          //     ? CircleAvatar(
                                                                          //         backgroundImage: NetworkImage(
                                                                          //         ImageFromNetwork.fullImageUrl('uploads/users/${data.replies?[replyindex].postedBy?.userImage}'),
                                                                          //       ))
                                                                          //     : CircleAvatar(
                                                                          //         backgroundColor: Colors.grey,
                                                                          //         child: Text(
                                                                          //           nameInital2,
                                                                          //           style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                                                          //         ),
                                                                          //       ),
                                                                          title:
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                            children: [
                                                                              data.replies![replyindex].postedBy!.userImage != null
                                                                                  ? CircleAvatar(
                                                                                  backgroundImage: NetworkImage(
                                                                                    ImageFromNetwork.fullImageUrl('uploads/users/${data.replies?[replyindex].postedBy?.userImage}'),
                                                                                  ))
                                                                                  : CircleAvatar(
                                                                                backgroundColor: Colors.grey,
                                                                                child: Text(
                                                                                  nameInital2,
                                                                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(width: 10,),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                Text("${data.replies![replyindex].postedBy!.firstname!} ${data.replies![replyindex].postedBy!.lastname!}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                                                                  Text(formattedreply,style: TextStyle(color: Colors.grey, fontSize: 12),),
                                                                                Padding(
                                                                                    padding: const EdgeInsets.only(left: 10.0),
                                                                                    child: data.replies![replyindex].postedBy!.type! == "Lecturer"
                                                                                        ? Chip(
                                                                                        backgroundColor: Colors.red[800],
                                                                                        label: Text(
                                                                                          data.replies![replyindex].postedBy!.type! == "Lecturer" ? data.replies![replyindex].postedBy!.type! : " ",
                                                                                          style: const TextStyle(color: Colors.white),
                                                                                        ))
                                                                                        : const SizedBox(height: 1))
                                                                              ],),

                                                                            ],
                                                                          ),
                                                                          subtitle:Container(
                                                                              margin: const EdgeInsets.only(left:45, top: 10, bottom: 10),
                                                                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                                              decoration: const BoxDecoration(color: Color(0xffF2F2F2)),
                                                                              child: Text(data
                                                                                  .replies![replyindex]
                                                                                  .comment!, style: TextStyle(color: black))),
                                                                        );
                                                                      },
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 20.0,
                                                          horizontal: 10),
                                                      child: Container(
                                                        height: 3,
                                                        width: double.infinity,
                                                        color: grey_200,
                                                      ),
                                                    )
                                                  ],
                                                );
                                              }),
                                          isLoadingOnly(snapshot
                                                  .loadMoreCommentApiResponse)
                                              ? const Center(
                                                  child:
                                                      CupertinoActivityIndicator(),
                                                )
                                              : const SizedBox(),
                                          snapshot.comments.isEmpty
                                              ? SizedBox()
                                              : (snapshot.hasMore == true &&
                                                      snapshot.comments
                                                              .length >=
                                                          10)
                                                  ? CustomButton(
                                                      buttonName: "Load more",
                                                      onClick: () async {
                                                        await snapshot
                                                            .loadMoreComment(widget
                                                                    .data
                                                                    ?.lessons?[
                                                                        widget
                                                                            .index]
                                                                    .lessonSlug ??
                                                                "");
                                                      })
                                                  : SizedBox(
                                                      child: Text(
                                                          "End of comment")),
                                        ],
                                      )
                              ],
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
        ]);
      })),
    );
  }
}
