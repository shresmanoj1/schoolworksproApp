import 'dart:convert';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/components/input_container.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/postmessage_request.dart';
import 'package:schoolworkspro_app/response/get_active_users_response.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:schoolworkspro_app/response/post_messageresponse.dart';
import 'package:schoolworkspro_app/services/message_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendMessageScreen extends StatefulWidget {
  ActiveUser data;
  SendMessageScreen({Key? key, required this.data}) : super(key: key);

  @override
  _SendMessageScreenState createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  late User user;

  final TextEditingController messagecontroller = TextEditingController();
  String? message;
  bool delivered = false;
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  bool received = false;
  bool sent = false;

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
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        // leading: Icon(Icons.arrow_back_ios),
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back)),
            Expanded(
                flex: 1,
                child: Container(
                  height: 50,
                  child: CircleAvatar(
                      radius: 18,
                      backgroundColor: widget.data.userImage == null
                          ? Colors.primaries[
                              Random().nextInt(Colors.primaries.length)]
                          : Colors.white,
                      child: widget.data.userImage == null
                          ? Text(
                              widget.data.userImage
                                      .toString()[0]
                                      .toUpperCase() +
                                  "" +
                                  widget.data.lastname
                                      .toString()[0]
                                      .toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          : ClipOval(
                              child: Image.network(
                                api_url2 +
                                    '/uploads/users/' +
                                    widget.data.userImage.toString(),
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            )),
                )),
            Expanded(
                flex: 4,
                child: Container(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data.firstname.toString() +
                            " " +
                            widget.data.lastname.toString(),
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.data.username.toString(),
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      )
                    ],
                  ),
                )),
          ],
        ),

        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: ChangeNotifierProvider<MessageService>(
                  create: (context) => MessageService(),
                  child: Consumer<MessageService>(
                      builder: (context, provider, child) {
                    provider.getAuthentication(context);

                    if (provider.data?.allMessages == null) {
                      provider.getAuthentication(context);
                      return const Center(
                          child: SpinKitDualRing(
                        color: kPrimaryColor,
                      ));
                    }
                    for (int i = 0;
                        i < provider.data!.allMessages!.length;
                        i++) {
                      var datasss = provider.data!.allMessages![i];
                      if (datasss['receiver']['username'] ==
                          widget.data.username.toString()) {
                        sent = true;
                      } else if (datasss['sender']['username'] ==
                          widget.data.username.toString()) {
                        received = true;
                      }
                    }
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          sent == false && received == false
                              ? Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/bubble.jpg'),
                                      Text(
                                        'No message to display',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        'Only seen message will appear here',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: provider.data?.allMessages?.length,
                                  itemBuilder: (context, index) {
                                    var datas =
                                        provider.data?.allMessages?[index];

                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        datas['sender']['username'] ==
                                                user.username
                                            //sent message
                                            ? Builder(builder: (context) {
                                                if (datas['receiver']
                                                        ['username'] ==
                                                    widget.data.username
                                                        .toString()) {
                                                  return Column(
                                                    children: [
                                                      Center(
                                                        child: Text(
                                                          timeAgoSinceDate(
                                                              datas['createdAt']
                                                                  .toString(),
                                                              numericDates:
                                                                  false),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                      ListTile(
                                                          trailing:
                                                              CircleAvatar(
                                                            radius: 18,
                                                            backgroundColor:
                                                                datas['sender'][
                                                                            'userImage'] ==
                                                                        null
                                                                    ? Colors
                                                                        .grey
                                                                    : Colors
                                                                        .white,
                                                            child: datas['sender']
                                                                        [
                                                                        'userImage'] ==
                                                                    null
                                                                ? Text(
                                                                    datas['sender']['firstname'][0]
                                                                            .toUpperCase() +
                                                                        "" +
                                                                        datas['sender']['lastname'][0]
                                                                            .toUpperCase(),
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  )
                                                                : ClipOval(
                                                                    child: Image
                                                                        .network(
                                                                      api_url2 +
                                                                          '/uploads/users/' +
                                                                          datas['sender']
                                                                              [
                                                                              'userImage'],
                                                                      height:
                                                                          30,
                                                                      width: 30,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                          ),
                                                          subtitle: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                datas['message']
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                              ),
                                                            ],
                                                          ),
                                                          title: Text(
                                                            datas['sender'][
                                                                        'firstname']
                                                                    .toString() +
                                                                " " +
                                                                datas['sender'][
                                                                        'lastname']
                                                                    .toString(),
                                                            textAlign:
                                                                TextAlign.end,
                                                          )),
                                                    ],
                                                  );
                                                }
                                                return SizedBox();
                                              })

                                            // received message
                                            : Builder(builder: (context) {
                                                if (datas['sender']
                                                        ['username'] ==
                                                    widget.data.username
                                                        .toString()) {
                                                  return Column(
                                                    children: [
                                                      Center(
                                                        child: Text(
                                                          timeAgoSinceDate(
                                                              datas['createdAt']
                                                                  .toString(),
                                                              numericDates:
                                                                  false),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                      ListTile(
                                                        leading: CircleAvatar(
                                                          radius: 18,
                                                          backgroundColor:
                                                              datas['sender'][
                                                                          'userImage'] ==
                                                                      null
                                                                  ? Colors.grey
                                                                  : Colors
                                                                      .white,
                                                          child: datas['sender']
                                                                      [
                                                                      'userImage'] ==
                                                                  null
                                                              ? Text(
                                                                  datas['sender']['firstname']
                                                                              [
                                                                              0]
                                                                          .toUpperCase() +
                                                                      "" +
                                                                      datas['sender']['lastname']
                                                                              [
                                                                              0]
                                                                          .toUpperCase(),
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                                )
                                                              : ClipOval(
                                                                  child: Image
                                                                      .network(
                                                                    api_url2 +
                                                                        '/uploads/users/' +
                                                                        datas['sender']
                                                                            [
                                                                            'userImage'],
                                                                    height: 30,
                                                                    width: 30,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                        ),
                                                        subtitle: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                datas['message']
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start),
                                                          ],
                                                        ),
                                                        title: Text(
                                                          datas['sender'][
                                                                      'firstname']
                                                                  .toString() +
                                                              " " +
                                                              datas['sender'][
                                                                      'lastname']
                                                                  .toString(),
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                                return SizedBox();
                                              })
                                      ],
                                    );
                                  },
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    );
                  })),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              children: [
                Expanded(
                    flex: 5,
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: kPrimaryColor.withAlpha(50)),
                        child: TextField(
                            cursorColor: kPrimaryColor,
                            controller: messagecontroller,
                            decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.message,
                                  color: kPrimaryColor,
                                ),
                                hintText: "Write something",
                                border: InputBorder.none)))
                    // Container(
                    //     margin: EdgeInsets.only(left: 10),
                    //     padding:
                    //     const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(30),
                    //         color: kPrimaryColor.withAlpha(50)),
                    //     child: TextField(
                    //         keyboardType: TextInputType.multiline,
                    //         maxLines: 1,
                    //
                    //         cursorColor: kPrimaryColor,
                    //         controller: messagecontroller,
                    //         decoration: const InputDecoration(
                    //           filled: true,
                    //             icon: Icon(
                    //               Icons.message,
                    //               color: kPrimaryColor,
                    //             ),
                    //             hintText: 'Write something..',
                    //             border: InputBorder.none))),
                    ),
                Expanded(
                    flex: 1,
                    child: IconButton(
                        onPressed: () async {
                          final request = PostMessageRequest(
                              message: messagecontroller.text,
                              to: widget.data.username.toString());

                          PostMessageResponse res =
                              await MessageService().sendMessage(request);
                          if (res.success == true) {
                            setState(() {
                              delivered = true;
                              message = messagecontroller.text;
                            });

                            messagecontroller.clear();

                            Fluttertoast.showToast(msg: res.message.toString());
                          } else {
                            setState(() {
                              delivered = false;
                            });
                            Fluttertoast.showToast(msg: res.message.toString());
                          }
                        },
                        icon: Icon(Icons.send_sharp)))
              ],
            ),
          ),
        ],
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

class Delivered extends StatelessWidget {
  User? user;
  String msg;
  Delivered({Key? key, this.user, required this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35.0),
      child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Center(
                child: Builder(builder: (context) {
                  DateTime now = DateTime.parse(DateTime.now().toString());

                  // now = now.add(const Duration(hours: 5, minutes: 45));

                  var formattedTime = DateFormat('hh mm aa').format(now);
                  return Text(
                    formattedTime,
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  );
                }),
              ),
              ListTile(
                  leading: CircleAvatar(
                      radius: 18,
                      backgroundColor: user?.userImage == null
                          ? Colors.primaries[
                              Random().nextInt(Colors.primaries.length)]
                          : Colors.white,
                      child: user?.userImage == null
                          ? Text(
                              user!.firstname.toString()[0].toUpperCase() +
                                  "" +
                                  user!.lastname.toString()[0].toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          : ClipOval(
                              child: Image.network(
                                api_url2 +
                                    '/uploads/users/' +
                                    user!.userImage.toString(),
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            )),
                  title: Text(msg)),
            ],
          )),
    );
  }
}
