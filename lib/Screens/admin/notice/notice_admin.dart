import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_version/new_version.dart';
import 'package:open_url/open_url.dart';
import 'package:readmore/readmore.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:schoolworkspro_app/response/notice_response.dart';
import 'package:schoolworkspro_app/services/notice_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticeAdminScreen extends StatefulWidget {
  const NoticeAdminScreen({Key? key}) : super(key: key);

  @override
  _NoticeAdminScreenState createState() => _NoticeAdminScreenState();
}

class _NoticeAdminScreenState extends State<NoticeAdminScreen> {
  // late Stream<Noticeresponse> notice_Model;
  late Future<Noticeresponse> noticel;
  int notificationCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    // notice_Model = NoticeService().getRefreshNotice(const Duration(seconds: 1));
    getNotice();


    super.initState();
  }



  getNotice() async {
    noticel = NoticeService().getNoticeAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text("Notice and Announcements",
              style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white),
      body: FutureBuilder<Noticeresponse>(
          future: noticel,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.notices!.isEmpty
                  ? Column(children: <Widget>[
                      Image.asset("assets/images/no_content.PNG"),
                    ])
                  : ListView.builder(
                      itemCount: snapshot.data!.notices!.length,
                      itemBuilder: (context, index) {
                        var notice = snapshot.data!.notices![index];

                        DateTime now =
                            DateTime.parse(notice.createdAt.toString());

                        now = now.add(const Duration(hours: 5, minutes: 45));

                        var formattedTime =
                            DateFormat('dd MMM - hh:mm a').format(now);

                        var publishedBy = notice.postedBy!.firstname! +
                            " " +
                            notice.postedBy!.lastname!;
                        var nameInital =
                            notice.postedBy!.firstname![0].toUpperCase() +
                                "" +
                                notice.postedBy!.lastname![0].toUpperCase();
                        // var readTest = notice.

                        return Card(
                          clipBehavior: Clip.antiAlias,
                          margin: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                leading: notice.postedBy!.userImage != null
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(api_url2 +
                                            '/uploads/users/' +
                                            notice.postedBy!.userImage!))
                                    : CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        child: Text(
                                          nameInital,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                title: Text(
                                  notice.noticeTitle!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  publishedBy,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ReadMoreText(
                                  notice.noticeContent!,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                  trimLines: 3,
                                  // colorClickableText: Colors.blueAccent,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: ' Read more',
                                  trimExpandedText: ' Less',
                                ),
                              ),
                              notice.filename == null
                                  ? const SizedBox.shrink()
                                  : TextButton(
                                      child: Text(
                                        notice.filename!,
                                        style:
                                            const TextStyle(color: Colors.blue),
                                      ),
                                      onPressed: () {
                                        _launchURL(notice.filename!);
                                        // html.window
                                        //     .open('www.facebook.com', "filename");
                                      },
                                    ),
                              ButtonBar(
                                alignment: MainAxisAlignment.end,
                                children: [
                                  // Icon(Icons.timer),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.timer,
                                        color: Colors.grey.withOpacity(0.5),
                                      ),
                                      Text(
                                        formattedTime,
                                        style:
                                            const TextStyle(color: Colors.grey),
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
                      });
            } else {
              return const Center(
                  child: SpinKitDualRing(
                color: kPrimaryColor,
              ));
            }
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
