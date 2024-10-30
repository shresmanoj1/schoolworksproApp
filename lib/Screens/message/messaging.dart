import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/message_principal/search_user.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/postmessage_request.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:schoolworkspro_app/response/post_messageresponse.dart';
import 'package:schoolworkspro_app/services/message_service.dart';
import 'package:schoolworkspro_app/services/unread_messageservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../helper/custom_loader.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  // Stream<GetMessageResponse>? message_response;
  final TextEditingController usernamecontroller = new TextEditingController();
  final TextEditingController messagecontroller = new TextEditingController();
  final _key1 = GlobalKey();
  final _key2 = GlobalKey();
  final _key3 = GlobalKey();
  bool isVisibility = false;
  User? user;
  bool isloading = false;

  int _selectedPage = 0;
  late PageController _pageController;

  void _changePage(int pageNum) {
    setState(() {
      _selectedPage = pageNum;
      _pageController.animateToPage(
        pageNum,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    // getActivity();
    _pageController = PageController();

    super.initState();
    getData();
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

  _itemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
    setState(() {
      this._selectedPage = selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isloading == true ) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: white,
          ),
          title: const Text("Quick Message",
              style: TextStyle(color: white, fontWeight: FontWeight.w800)),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(55),
            child: Builder(builder: (context) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: TabBar(
                  indicatorColor: logoTheme,
                  indicatorWeight: 4.0,
                  isScrollable: true,
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  unselectedLabelColor: white,
                  labelColor: Color(0xff004D96),
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: p1),
                  indicator: BoxDecoration(
                    border: Border(),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                    color: white,
                  ),
                  tabs: [
                    Tab(
                      text: "Unread",
                    ),
                    Tab(
                      text: "My Messages",
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        floatingActionButton: FloatingActionButton.small(
            backgroundColor: Colors.pinkAccent,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchUserScreen(),
                  ));
            },
            child: isVisibility == false
                ? const Icon(Icons.add)
                : const Icon(Icons.clear)),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: isVisibility,
              child: Container(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Send Quick Message',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'From: ${user?.username.toString()}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Receiver Username',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: usernamecontroller,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            hintText: 'Enter username',
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green)),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Message',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: messagecontroller,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            hintText: 'Type a short message to send ...',
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green)),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    isVisibility = false;
                                  });
                                },
                                child: const Text(
                                  'cancel',
                                  style: TextStyle(color: Colors.black),
                                )),
                            const SizedBox(width: 10),
                            ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    isloading = true;
                                  });
                                  try {
                                    setState(() {
                                      isloading = true;
                                    });
                                    final request = PostMessageRequest(
                                        message: messagecontroller.text,
                                        to: usernamecontroller.text);

                                    PostMessageResponse res =
                                        await MessageService()
                                            .sendMessage(request);
                                    if (res.success == true) {
                                      setState(() {
                                        isloading = true;
                                        isVisibility = false;
                                      });
                                      usernamecontroller.clear();
                                      messagecontroller.clear();
                                      snackThis(
                                          context: context,
                                          color: Colors.green,
                                          behavior: SnackBarBehavior.fixed,
                                          duration: 1,
                                          content:
                                              Text(res.message.toString()));
                                      setState(() {
                                        isloading = false;
                                      });
                                    } else {
                                      setState(() {
                                        isloading = true;
                                      });
                                      snackThis(
                                          context: context,
                                          color: Colors.red,
                                          behavior: SnackBarBehavior.fixed,
                                          duration: 1,
                                          content:
                                              Text(res.message.toString()));
                                      setState(() {
                                        isloading = false;
                                      });
                                    }
                                  } catch (e) {
                                    setState(() {
                                      isloading = true;
                                    });
                                    Fluttertoast.showToast(msg: e.toString());
                                    setState(() {
                                      isloading = false;
                                    });
                                  }
                                },
                                child: const Text('Send')),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                children: [
                  ChangeNotifierProvider<UnreadMessageService>(
                      create: (context) => UnreadMessageService(),
                      child: Consumer<UnreadMessageService>(
                          builder: (context, provider, child) {
                        provider.getUnreadMessage(context);
                        if (provider.data?.allMessages == null) {
                          provider.getUnreadMessage(context);
                          return const Center(
                              child: CupertinoActivityIndicator());
                        }

                        return SingleChildScrollView(
                          child: provider.data!.allMessages!.isEmpty
                              ? Column(
                                  children: [
                                    Image.asset("assets/images/no_content.PNG"),
                                  ],
                                )
                              : Column(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      itemCount:
                                          provider.data?.allMessages?.length,
                                      itemBuilder: (context, index) {
                                        var datas =
                                            provider.data?.allMessages?[index];
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  isloading = true;
                                                });
                                                try {
                                                  setState(() {
                                                    isloading = true;
                                                  });
                                                  PostMessageResponse res =
                                                      await UnreadMessageService()
                                                          .markasread(
                                                              datas['_id']);
                                                  if (res.success == true) {
                                                    setState(() {
                                                      isloading = true;
                                                    });
                                                    snackThis(
                                                        context: context,
                                                        color: Colors.green,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .fixed,
                                                        duration: 1,
                                                        content: Text(res
                                                            .message
                                                            .toString()));
                                                    setState(() {
                                                      isloading = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      isloading = true;
                                                    });
                                                    snackThis(
                                                        context: context,
                                                        color: Colors.red,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .fixed,
                                                        duration: 1,
                                                        content: Text(res
                                                            .message
                                                            .toString()));
                                                    setState(() {
                                                      isloading = false;
                                                    });
                                                  }
                                                } catch (e) {
                                                  setState(() {
                                                    isloading = true;
                                                  });
                                                  Fluttertoast.showToast(
                                                      msg: e.toString());
                                                  setState(() {
                                                    isloading = false;
                                                  });
                                                }
                                              },
                                              child: ListTile(
                                                  leading: CircleAvatar(
                                                    radius: 18,
                                                    backgroundColor: datas[
                                                                    'sender']
                                                                ['userImage'] ==
                                                            null
                                                        ? Colors.grey
                                                        : Colors.white,
                                                    child: datas['sender']
                                                                ['userImage'] ==
                                                            null
                                                        ? Text(
                                                            datas['sender']['firstname']
                                                                        [0]
                                                                    .toUpperCase() +
                                                                "" +
                                                                datas['sender'][
                                                                        'lastname'][0]
                                                                    .toUpperCase(),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          )
                                                        : ClipOval(
                                                            child:
                                                                Image.network(
                                                              api_url2 +
                                                                  '/uploads/users/' +
                                                                  datas['sender']
                                                                      [
                                                                      'userImage'],
                                                              height: 30,
                                                              width: 30,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                  ),
                                                  trailing: Container(
                                                    height: 10,
                                                    width: 10,
                                                    decoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color:
                                                                kPrimaryColor),
                                                  ),
                                                  subtitle: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        datas['message']
                                                            .toString(),
                                                      ),
                                                      Text(timeAgoSinceDate(
                                                          datas['createdAt']
                                                              .toString(),
                                                          numericDates: false))
                                                    ],
                                                  ),
                                                  title: Text(datas['sender']
                                                              ['firstname']
                                                          .toString() +
                                                      " " +
                                                      datas['sender']
                                                              ['lastname']
                                                          .toString())),
                                            ),
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
                  ChangeNotifierProvider<MessageService>(
                      create: (context) => MessageService(),
                      child: Consumer<MessageService>(
                          builder: (context, provider, child) {
                        provider.getAuthentication(context);
                        if (provider.data?.allMessages == null) {
                          provider.getAuthentication(context);
                          return const Center(
                              child: CupertinoActivityIndicator());
                        }

                        return SingleChildScrollView(
                          child: provider.data!.allMessages!.isEmpty
                              ? Column(
                                  children: [
                                    Image.asset("assets/images/no_content.PNG"),
                                  ],
                                )
                              : Column(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      itemCount:
                                          provider.data?.allMessages?.length,
                                      itemBuilder: (context, index) {
                                        var datas =
                                            provider.data?.allMessages?[index];
                                        return Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ListTile(
                                                    leading: CircleAvatar(
                                                      radius: 18,
                                                      backgroundColor: datas[
                                                                      'sender'][
                                                                  'userImage'] ==
                                                              null
                                                          ? Colors.grey
                                                          : Colors.white,
                                                      child: datas['sender'][
                                                                  'userImage'] ==
                                                              null
                                                          ? Text(
                                                              datas['sender']['firstname']
                                                                          [0]
                                                                      .toUpperCase() +
                                                                  "" +
                                                                  datas['sender']
                                                                          [
                                                                          'lastname'][0]
                                                                      .toUpperCase(),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          : ClipOval(
                                                              child:
                                                                  Image.network(
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
                                                        Text(datas['message']
                                                            .toString()),
                                                        Text(timeAgoSinceDate(
                                                            datas['createdAt']
                                                                .toString(),
                                                            numericDates:
                                                                false))
                                                      ],
                                                    ),
                                                    title: datas['receiver']
                                                                ['username'] ==
                                                            user?.username
                                                                .toString()
                                                        ? Builder(
                                                            builder: (context) {
                                                            return Text("From: " +
                                                                datas['sender'][
                                                                    'firstname'] +
                                                                " " +
                                                                datas['sender'][
                                                                    'lastname']);
                                                          })
                                                        : Builder(
                                                            builder: (context) {
                                                            return Text("To: " +
                                                                datas['receiver']
                                                                    [
                                                                    'firstname'] +
                                                                " " +
                                                                datas['receiver']
                                                                    [
                                                                    'lastname']);
                                                          })),

                                                // Row(
                                                //   mainAxisAlignment: MainAxisAlignment.end,
                                                //   crossAxisAlignment: CrossAxisAlignment.end,
                                                //   children: [
                                                //     TextButton(onPressed: (){}, child: const Text("Mark as read")),
                                                //   ],
                                                // )
                                              ],
                                            ),
                                          ),
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
                ],
              ),
            ),
          ],
        ),
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
