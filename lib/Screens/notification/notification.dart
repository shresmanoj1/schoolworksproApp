import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:schoolworkspro_app/Screens/exam_test.dart';
import 'package:schoolworkspro_app/Screens/lecturer/events/events_lecturer.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/routines-lecturer/routine-lecturer.dart';
import 'package:schoolworkspro_app/Screens/notice/notice.dart';
import 'package:schoolworkspro_app/Screens/routines/routine_screen.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:schoolworkspro_app/helper/navigation_handler.dart';
import 'package:schoolworkspro_app/response/notification_response.dart';
import 'package:schoolworkspro_app/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../../constants/text_style.dart';
import '../../response/authenticateduser_response.dart';
import '../../utils/preference_utils.dart';
import '../lecturer/assigned_requestlecturer/assigned_request_lecturer.dart';
import '../prinicpal/news and announcement/newsannouncent_screen.dart';
import '../prinicpal/notice/view_mynoticeprinicpal.dart';

class Notificationscreen extends StatefulWidget {
  const Notificationscreen({Key? key}) : super(key: key);

  @override
  _NotificationscreenState createState() => _NotificationscreenState();
}

class _NotificationscreenState extends State<Notificationscreen> {
  // bool available = false;
  late LecturerCommonViewModel lecturerCommonViewModel;
  late CommonViewModel commonViewModel;
  late User user;


  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
      lecturerCommonViewModel = Provider.of<LecturerCommonViewModel>(context, listen: false);
      commonViewModel.fetchNotifications();

      getData();
    });
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
    return Consumer<CommonViewModel>(
      builder: (context, value, child) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          final SharedPreferences localStorage =
          await SharedPreferences.getInstance();
          localStorage.setInt('insidecount', value.noticeCount);
        });
        return Scaffold(
            appBar: AppBar(
                title: const Text(
                  "Notifications",
                  style: TextStyle(color: white),
                ),
                elevation: 0.0,
                centerTitle: false,
            ),
            body: isLoading(value.notificationApiResponse)
                ? const Center(
              child: SpinKitDualRing(color: kPrimaryColor),
            )
                : value.notification.isEmpty
                ? Column(children: <Widget>[
              Image.asset("assets/images/no_content.PNG"),
            ])
                :
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: ListView.builder(
                  itemCount: value.notification.length,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  itemBuilder: (context, index) {
                    var datas = value.notification[index];
                    var publishedBy = datas.sender;
                    final String dateString = datas.createdAt.toString();
                    final DateTime date = DateTime.parse(dateString);
                    bool isSameDate = true;
                    if (index == 0) {
                    isSameDate = false;
                    } else {
                    final String prevDateString = value.notification[index - 1].createdAt.toString();
                    final DateTime prevDate = DateTime.parse(prevDateString);
                    isSameDate = date.isSameDate(prevDate);
                    }
                    if (index == 0 || !(isSameDate)) {
                    return  Column(
                      children: [
                        Container(
                          // height: 40,
                          width: double.infinity,
                          child: Padding(
                            padding:
                            const EdgeInsets.fromLTRB(12, 8, 12, 0),
                            child: Text(' ${date.formatDate()}',
                              style: p16.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: logoTheme),
                            ),
                          ),
                        ),
                        _buildBody(datas,dateString, publishedBy.toString()),
                      ],
                    );
                    } else {
                    return  Column(children: [_buildBody(datas,dateString, publishedBy.toString()),  SizedBox(height: isSameDate == true ? 10 : 0,)],);
                    }
                  }),
            ));
      },
    );
  }

  Widget _buildBody(Notificationss datas, String dateString, String publishedBy){
    return InkWell(
      onTap: (){
        notificationClickHandler(context, Notificationss(path: datas.path.toString()));
      },
      child: Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.2)))),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: logoTheme,
            child: Text(
              publishedBy.toString().substring(0, 1),
              style: const TextStyle(color: white),
            ),
          ),
         title: Text(
            datas.notificationTitle.toString(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height:3),
              Text(datas.notificationContent.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 14)),
              SizedBox(height:5),
              RichText(
                text: TextSpan(
                  children: [
                    const WidgetSpan(child: Icon(Icons.access_time_filled_rounded, size: 18,)),
                    TextSpan(
                      text: " ${timeAgoSinceDate(dateString)}",
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime date = DateTime.parse(dateString);
    final date2 = DateTime.now();
    // date = date.add(const Duration(hours: 5, minutes: 45));
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numericDates) ? '1 year ago' : 'Last year';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} months ago';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1 month ago' : 'Last month';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}

const String dateFormatter = 'MMMM dd, y';

extension DateHelper on DateTime {
  String formatDate() {
    final formatter = DateFormat(dateFormatter);
    return formatter.format(this);
  }

  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }

  int getDifferenceInDaysWithNow() {
    final now = DateTime.now();
    return now.difference(this).inDays;
  }
}


