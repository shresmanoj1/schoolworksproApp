import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/news%20and%20announcement/announcement_view_model.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/api/repositories/principal/markread_repo.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../response/login_response.dart';

class NewsAnnouncmentScreen extends StatefulWidget {
  const NewsAnnouncmentScreen({Key? key}) : super(key: key);

  @override
  _NewsAnnouncmentScreenState createState() => _NewsAnnouncmentScreenState();
}

class _NewsAnnouncmentScreenState extends State<NewsAnnouncmentScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AnnouncementViewModel>(
        create: (_) => AnnouncementViewModel(), child: AnnouncementBody());
  }
}

class AnnouncementBody extends StatefulWidget {
  const AnnouncementBody({Key? key}) : super(key: key);

  @override
  _AnnouncementBodyState createState() => _AnnouncementBodyState();
}

class _AnnouncementBodyState extends State<AnnouncementBody> {
  ScrollController? _controller = new ScrollController();
  bool _showBackToTopButton = false;
  bool _isVisible = false;
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AnnouncementViewModel>(context, listen: false)
          .fetchannouncement();
      _controller?.addListener(() {
        if (_controller!.offset >= _controller!.position.maxScrollExtent &&
            !_controller!.position.outOfRange) {
          loadMore();
          print("reached dowm");
          // setState(() {
          //   _isVisible = true;
          //   print(_isVisible);
          // });
        }

        if (_controller!.offset >= 320) {
          setState(() {
            _showBackToTopButton = true; // show the back-to-top button
          });
        } else {
          setState(() {
            _showBackToTopButton = false; // hide the back-to-top button
          });
        }
      });
      // _hideButtonController!.addListener(() {
      //

      // });
    });
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
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> refresh() async {
    await Provider.of<AnnouncementViewModel>(context, listen: false).setPage(1);
    await Provider.of<AnnouncementViewModel>(context, listen: false)
        .fetchannouncement();
  }

  Future<void> loadMore() async {
    await Provider.of<AnnouncementViewModel>(context, listen: false).loadMore();
  }

  void _scrollToTop() {
    _controller?.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _showBackToTopButton == false
          ? null
          : FloatingActionButton(
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward),
            ),
      body: Consumer<AnnouncementViewModel>(builder: (context, data, child) {
        return Container(
            color: Colors.white,
            child: SafeArea(
                child: ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: RefreshIndicator(
                      edgeOffset: 50,
                      onRefresh: () => refresh(),
                      child:
                          CustomScrollView(controller: _controller, slivers: <
                              Widget>[
                        SliverAppBar(
                          toolbarHeight: 50,
                          titleSpacing: 10,
                          elevation: 0.0,
                          pinned: true,
                          // automaticallyImplyLeading: false,
                          title: Container(
                            margin: const EdgeInsets.only(right: 10),
                            alignment: Alignment.centerRight,
                            height: 50,
                            decoration: const BoxDecoration(
                                // color: Colors.red
                                ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "News and Announcement",

                                )
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: isLoading(data.announcementApiResponse)
                              ? const Center(
                                  child: CupertinoActivityIndicator()
                                )
                              : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    if (data.notices.isEmpty)
                                      Center(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Image.asset(
                                                  "assets/images/no-content.PNG"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (data.notices.isNotEmpty)
                                      ...List.generate(
                                          data.notices.length,
                                          (index) =>
                                              Builder(builder: (context) {
                                                var notice =
                                                    data.notices[index];

                                                DateTime now = DateTime.parse(
                                                    notice.createdAt
                                                        .toString());

                                                now = now.add(const Duration(
                                                    hours: 5, minutes: 45));

                                                var formattedTime = DateFormat(
                                                        'dd MMM - hh:mm a')
                                                    .format(now);

                                                var publishedBy = notice
                                                        .postedBy!.firstname! +
                                                    " " +
                                                    notice.postedBy!.lastname!;
                                                var nameInital = notice
                                                        .postedBy!.firstname![0]
                                                        .toUpperCase() +
                                                    "" +
                                                    notice
                                                        .postedBy!.lastname![0]
                                                        .toUpperCase();
                                                // var readTest = notice.

                                                return Card(
                                                  clipBehavior: Clip.antiAlias,
                                                  margin:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ListTile(
                                                        leading: notice
                                                                    .postedBy!
                                                                    .userImage !=
                                                                null
                                                            ? CircleAvatar(
                                                                backgroundImage:
                                                                    NetworkImage(api_url2 +
                                                                        '/uploads/users/' +
                                                                        notice
                                                                            .postedBy!
                                                                            .userImage!))
                                                            : CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .pinkAccent,
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
                                                        title: Text(
                                                          notice.noticeTitle!,
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        subtitle: Text(
                                                          publishedBy,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: ReadMoreText(
                                                          notice.noticeContent!,
                                                          style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.6),
                                                          ),
                                                          trimLines: 3,
                                                          // colorClickableText: Colors.blueAccent,
                                                          trimMode:
                                                              TrimMode.Line,
                                                          trimCollapsedText:
                                                              ' Read more',
                                                          trimExpandedText:
                                                              ' Less',
                                                        ),
                                                      ),
                                                      notice.filename == null
                                                          ? const SizedBox
                                                              .shrink()
                                                          : TextButton(
                                                              child: Text(
                                                                notice
                                                                    .filename!,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                              onPressed: () {
                                                                _launchURL(notice
                                                                    .filename!);
                                                                // html.window
                                                                //     .open('www.facebook.com', "filename");
                                                              },
                                                            ),
                                                      ButtonBar(
                                                        alignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          // notice.readBy!
                                                          //         .contains(user
                                                          //             ?.username
                                                          //             .toString())
                                                          //     ? ElevatedButton(
                                                          //         style: ElevatedButton
                                                          //             .styleFrom(
                                                          //                 primary: Colors
                                                          //                     .green),
                                                          //         onPressed:
                                                          //             () {},
                                                          //         child: Text(
                                                          //           'seen',
                                                          //           style: TextStyle(
                                                          //               color: Colors
                                                          //                   .white),
                                                          //         ))
                                                          //     : OutlinedButton(
                                                          //         onPressed:
                                                          //             () async {
                                                          //           final res = await Markreadrepo()
                                                          //               .markread(notice
                                                          //                   .id
                                                          //                   .toString());
                                                          //           if (res.success ==
                                                          //               true) {
                                                          //             data.fetchannouncement();
                                                          //
                                                          //             Fluttertoast
                                                          //                 .showToast(
                                                          //                     msg: "Marked as read");
                                                          //           } else {
                                                          //             Fluttertoast
                                                          //                 .showToast(
                                                          //                     msg: "Unable to mark as read");
                                                          //           }
                                                          //         },
                                                          //         child: Text(
                                                          //           'mark as read',
                                                          //           style: TextStyle(
                                                          //               color: Colors
                                                          //                   .black),
                                                          //         )),
                                                          // Icon(Icons.timer),
                                                          Row(
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons.timer,
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                              Text(
                                                                formattedTime,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),

                                                              // : InkWell(
                                                              //     child:
                                                              //         Text(notice.filename),
                                                              //     onTap: _launchURL(
                                                              //         notice.filename)),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              })),
                                    SizedBox(
                                      height: 50,
                                    )
                                  ],
                                ),
                        )
                      ]),
                    ))));
      }),
    );
  }

  _launchURL(String abc) async {
    String url = api_url2 + '/uploads/files/' + abc;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
