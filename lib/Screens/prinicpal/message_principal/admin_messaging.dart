import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/my_learning/tab_button.dart';
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

import '../../../helper/custom_loader.dart';

class PrincipalMessageScreen extends StatefulWidget {
  const PrincipalMessageScreen({Key? key}) : super(key: key);

  @override
  _PrincipalMessageScreenState createState() => _PrincipalMessageScreenState();
}

class _PrincipalMessageScreenState extends State<PrincipalMessageScreen> {
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

    // message_response =
    //     MessageService().getrefreshmessage(Duration(milliseconds: 200));
    super.initState();
    getData();
  }

  List<dynamic> _users = <dynamic>[];
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          'Quick Message',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton.small(
          backgroundColor: Colors.pinkAccent,
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    child: SearchUserScreen(),
                    type: PageTransitionType.leftToRight));

          },
          child: isVisibility == false ? Icon(Icons.add) : Icon(Icons.clear)),
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
                      SizedBox(height: 10),
                      const Text(
                        'Receiver Username',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      DropdownSearch<String>(

                        //mode of dropdown
                        // mode: Mode.DIALOG,


                        //to show search box
                        // showSearchBox: true,

                        //list of dropdown items
                        items: [
                          "India",
                          "USA",
                          "Brazil",
                          "Canada",
                          "Australia",
                          "Singapore",
                        ],

                        onChanged: print,
                        //show selected item
                        selectedItem: "India",
                      ),
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
                      SizedBox(height: 5),
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
                                        content: Text(res.message.toString()));
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
                                        content: Text(res.message.toString()));
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
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TabButton(
                      text: "Unread",
                      pageNumber: 0,
                      selectedPage: _selectedPage,
                      onPressed: () {
                        _changePage(0);
                      },
                    ),
                    TabButton(
                      text: "My Messages",
                      pageNumber: 1,
                      selectedPage: _selectedPage,
                      onPressed: () {
                        _changePage(1);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (int page) {
                setState(() {
                  _selectedPage = page;
                });
              },
              controller: _pageController,
              children: [
                ChangeNotifierProvider<UnreadMessageService>(
                    create: (context) => UnreadMessageService(),
                    child: Consumer<UnreadMessageService>(
                        builder: (context, provider, child) {
                      provider.getUnreadMessage(context);
                      if (provider.data?.allMessages == null) {
                        provider.getUnreadMessage(context);
                        return const Center(
                            child: SpinKitDualRing(
                          color: kPrimaryColor,
                        ));
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
                                                      behavior: SnackBarBehavior
                                                          .fixed,
                                                      duration: 1,
                                                      content: Text(res.message
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
                                                      behavior: SnackBarBehavior
                                                          .fixed,
                                                      duration: 1,
                                                      content: Text(res.message
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
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                        )
                                                      : ClipOval(
                                                          child: Image.network(
                                                            api_url2 +
                                                                '/uploads/users/' +
                                                                datas['sender'][
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
                                                          color: kPrimaryColor),
                                                ),
                                                subtitle: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                    datas['sender']['lastname']
                                                        .toString())),
                                          ),
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.end,
                                          //   crossAxisAlignment: CrossAxisAlignment.end,
                                          //   children: [
                                          //     TextButton(onPressed: (){}, child: const Text("Mark as read")),
                                          //   ],
                                          // )
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
                            child: SpinKitDualRing(
                          color: kPrimaryColor,
                        ));
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

                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                              leading: CircleAvatar(
                                                radius: 18,
                                                backgroundColor: datas['sender']
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
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    : ClipOval(
                                                        child: Image.network(
                                                          api_url2 +
                                                              '/uploads/users/' +
                                                              datas['sender']
                                                                  ['userImage'],
                                                          height: 30,
                                                          width: 30,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                              ),
                                              subtitle: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(datas['message']
                                                      .toString()),
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
                                                  datas['sender']['lastname']
                                                      .toString())),
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.end,
                                          //   crossAxisAlignment: CrossAxisAlignment.end,
                                          //   children: [
                                          //     TextButton(onPressed: (){}, child: const Text("Mark as read")),
                                          //   ],
                                          // )
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
