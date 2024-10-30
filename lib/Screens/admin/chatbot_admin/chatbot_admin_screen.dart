import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/dashboard/chat_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../config/preference_utils.dart';
import '../../../constants/text_style.dart';
import '../../../response/authenticateduser_response.dart';
import '../../chat_bot_help/chat_bot_help_modal.dart';
import '../../widgets/snack_bar.dart';

class ChatBotAdminScreen extends StatelessWidget {
  const ChatBotAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatViewModel>(
      create: (_) => ChatViewModel(),
      child: const ChatBotBodyAdmin(),
    );
  }
}

class ChatBotBodyAdmin extends StatefulWidget {
  const ChatBotBodyAdmin({Key? key}) : super(key: key);
  @override
  State<ChatBotBodyAdmin> createState() => _ChatBotAdminScreenState();
}

class _ChatBotAdminScreenState extends State<ChatBotBodyAdmin> {
  User? user;
  TextEditingController chatController = TextEditingController();
  final SharedPreferences sharedPreferences = PreferenceUtils.instance;
  bool isGenerating = false;
  bool typing = true;

  @override
  void initState() {
    setD();
    super.initState();
  }

  FocusNode _focuNode = FocusNode();
  late ChatViewModel _model;
  setD() async {
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });

    var adminData = {
      "metadata": {
        "firstname": "${user?.firstname}",
        "type": "${user?.type}",
        "studentId": "${user?.username}",
        "batch": "",
        "institution": "${user?.institution}",
        "courseSlug": "",
        "token": sharedPreferences.getString('token'),
      },
      "sender": "${user?.firstname}",
      "message": "hi"
    };

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _model = Provider.of<ChatViewModel>(context, listen: false);
      _model.fetchChatAdmin(adminData).then((value) {
        setState(() {
          _allMessages.add(_model.adminMessages);
          typing = false;
        });
      });
    });
  }

  final ScrollController _scrollController = ScrollController();
  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 10),
      curve: Curves.linearToEaseOut,
    );
  }

  final List<List<Map<String, dynamic>>> _allMessages =
      <List<Map<String, dynamic>>>[];
  static const String botImage = "assets/bot.png";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      endDrawer: Drawer(
        child: ChatBotHelpModal(),
      ),
      appBar: AppBar(
          actions: [
            IconButton(
                icon: const Icon(Icons.help),
                onPressed: () {
                  try {
                    _scaffoldKey.currentState?.openEndDrawer();
                  } catch (e) {
                    snackThis(
                        context: _scaffoldKey.currentContext!,
                        color: red,
                        duration: 2,
                        content: Text(e.toString()));
                  }
                }),
          ],
          centerTitle: true,
          title: const Text("ChatBot"),
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Color(0xFF004F96)),
      body: SafeArea(
          child: Consumer<ChatViewModel>(builder: (context, value, child) {
        return Column(
          children: <Widget>[
            Expanded(
                child: Container(
                    child: ListView(
              controller: _scrollController,
              shrinkWrap: true,
              children: [
                Container(
                    height: 120,
                    width: double.infinity,
                    child: Stack(
                      clipBehavior: Clip.antiAlias,
                      fit: StackFit.loose,
                      children: [
                        ClipPath(
                          clipper: CurvedBottomClipper(),
                          child: Container(
                            height: 80,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Color(0xFF004F96),
                              // borderRadius: BorderRadius.only(bottomRight: Radius.circular(100),bottomLeft: Radius.circular(100))
                            ),
                          ),
                        ),
                        Positioned.fill(
                          bottom: -20.0,
                          child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(botImage,
                                height: 100, width: 80, fit: BoxFit.contain),
                          ),
                        )
                      ],
                    )),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  itemCount: _allMessages.length,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    _scrollDown();
                    return Column(
                        children: _allMessages[index].isEmpty
                            ? [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Container(
                                          child: Image.asset(botImage),
                                        )),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                        flex: 20,
                                        child: CustomBubble(
                                          index: index,
                                          message:
                                              "Could not found data for ${_allMessages[index - 1].map((e) => e['text']).toString()}",
                                          recipient: "user",
                                        )),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                )
                              ]
                            : [
                                ListView.builder(
                                  physics: const ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _allMessages[index].length,
                                  itemBuilder: (context, i2) {
                                    var e = _allMessages[index][i2];
                                    _scrollDown();
                                    return Column(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            e['recipient_id'] != "bot"
                                                ? Row(
                                                    children: [
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        flex: 2,
                                                        child: i2 ==
                                                                (_allMessages[
                                                                            index]
                                                                        .length -
                                                                    1)
                                                            ? Container(
                                                                child:
                                                                    Image.asset(
                                                                        botImage),
                                                              )
                                                            : const SizedBox(),
                                                      ),
                                                      const SizedBox(width: 15),
                                                      Expanded(
                                                        flex: 20,
                                                        child: Padding(
                                                            padding: e['recipient_id'] ==
                                                                    "bot"
                                                                ? const EdgeInsets
                                                                        .only(
                                                                    right: 8.0)
                                                                : const EdgeInsets
                                                                    .only(
                                                                    bottom: 5,
                                                                  ),
                                                            child: (e['text'] ==
                                                                        null &&
                                                                    e['image'] ==
                                                                        null)
                                                                ? SizedBox()
                                                                : e['text'] ==
                                                                        null
                                                                    ? Align(
                                                                        alignment: e['recipient_id'] ==
                                                                                "bot"
                                                                            ? Alignment.centerRight
                                                                            : Alignment.centerLeft,
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          height:
                                                                              200,
                                                                          width:
                                                                              200,
                                                                          imageUrl:
                                                                              e['image'],
                                                                          placeholder: (context, url) =>
                                                                              Container(child: const Center(child: CupertinoActivityIndicator())),
                                                                          errorWidget: (context, url, error) =>
                                                                              const Icon(Icons.error),
                                                                        ),
                                                                      )
                                                                    : CustomBubble(
                                                                        recipient:
                                                                            e['recipient_id'],
                                                                        message:
                                                                            e['text'],
                                                                        index:
                                                                            i2,
                                                                      )),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 8),
                                                          child: (e['text'] ==
                                                                      null &&
                                                                  e['image'] ==
                                                                      null)
                                                              ? SizedBox()
                                                              : e['text'] ==
                                                                      null
                                                                  ? Align(
                                                                      alignment: e['recipient_id'] ==
                                                                              "bot"
                                                                          ? Alignment
                                                                              .centerRight
                                                                          : Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        height:
                                                                            200,
                                                                        width:
                                                                            200,
                                                                        imageUrl:
                                                                            e['image'],
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                Container(child: const Center(child: CupertinoActivityIndicator())),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            const Icon(Icons.error),
                                                                      ),
                                                                    )
                                                                  : CustomBubble(
                                                                      index:
                                                                          index,
                                                                      recipient:
                                                                          e['recipient_id'],
                                                                      message: e[
                                                                          'text'],
                                                                    )),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                        e['buttons'] == null
                                            ? const SizedBox()
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Expanded(
                                                        flex: 2,
                                                        child: SizedBox(),
                                                      ),
                                                      Expanded(
                                                        flex: 15,
                                                        child: Wrap(
                                                          direction:
                                                              Axis.horizontal,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          10,
                                                                      left: 10),
                                                              child: Container(
                                                                height: 40,
                                                                width: double
                                                                    .infinity,
                                                                child: ListView
                                                                    .builder(
                                                                        shrinkWrap:
                                                                            true,
                                                                        physics:
                                                                            const ScrollPhysics(),
                                                                        scrollDirection:
                                                                            Axis
                                                                                .horizontal,
                                                                        itemCount:
                                                                            e['buttons']
                                                                                .length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                j) {
                                                                          _scrollDown();
                                                                          return Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(right: 8.0),
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () {
                                                                                tapMe(e['buttons'][j]['title'], e['buttons'][j]['payload'], value);
                                                                                setState(() {
                                                                                  _allMessages[index][i2].removeWhere((key, value) => key == "buttons");
                                                                                  _allMessages[index][i2].removeWhere((key, value) => value == "Quick Response");
                                                                                });
                                                                              },
                                                                              child: Container(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(12),
                                                                                      border: Border.all(
                                                                                        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                                                                                      )),
                                                                                  child: Text(
                                                                                    e['buttons'][j]['title'],
                                                                                    style: const TextStyle(color: Colors.black),
                                                                                  )),
                                                                            ),
                                                                          );
                                                                        }),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                      ],
                                    );
                                  },
                                ),
                              ]);
                  }),
                ),
                typing == true
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 50.0),
                            child: SizedBox(
                                height: 60,
                                width: 60,
                                child: Lottie.asset('assets/77160-typing.json',
                                    fit: BoxFit.fill)),
                          ),
                          const SizedBox(
                            height: 50,
                          )
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 50,
                ),
              ],
            ))),
            Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                children: [
                  isGenerating == true
                      ? Center(
                          child: OutlinedButton.icon(
                              icon: const Icon(Icons.stop, color: grey_600),
                              onPressed: () {
                                setState(() {
                                  isGenerating = false;
                                });
                              },
                              label: Text(
                                "Stop generating",
                                style: p14.copyWith(color: black),
                              )),
                        )
                      : const SizedBox(),
                  Container(
                    decoration: BoxDecoration(color: Colors.grey.shade300),
                    padding: const EdgeInsets.only(left: 10),
                    height: 70,
                    width: double.infinity,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 12,
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextFormField(
                                focusNode: _focuNode,
                                maxLines: 1,
                                style: GoogleFonts.poppins().copyWith(
                                    color: Colors.grey.shade700, fontSize: 16),
                                onChanged: (value) {
                                  _scrollDown();
                                },
                                controller: chatController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 10.0),
                                  focusedBorder: OutlineInputBorder(

                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 1)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 1)),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(12)),
                                  hintStyle:
                                      const TextStyle(color: Colors.black54),
                                  border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 15,
                        ),

                        Expanded(
                          flex: 2,
                          child: InkWell(
                              onTap: () async {
                                if(isGenerating == true){
                                  Fluttertoast.showToast(
                                      msg: "Please wait while response is generated");

                                }else{
                                  if (chatController.text.isNotEmpty) {
                                    setState(() {
                                      _focuNode.unfocus();
                                    });
                                    tapMe(chatController.text, "", value);
                                  } else {
                                    setState(() {
                                      _allMessages.add([
                                        {
                                          "recipient_id": "${user?.firstname}",
                                          "text":
                                          "Hi ${user?.firstname}, please enter some message to send"
                                        }
                                      ]);
                                      _focuNode.unfocus();
                                    });
                                  }
                                }

                                _scrollDown();
                              },
                              child: Container(
                                  height: 50,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF004D96),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: const Center(
                                      child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  )))),
                        ),
                        const SizedBox(
                          width: 5,
                        ), // FloatingActionButton( //   onPressed: () { //     if (chatController.text != null && //         chatController.text != "") { //       var token = localStorage.getString('token'); //       socket?.emit('user_uttered', { //         "customData": { //           "firstname": user?.firstname.toString(), //           "studentId": user?.username.toString(), //           "batch": user?.batch.toString(), //           "institution": user?.institution.toString(), //           "courseSlug": user?.courseSlug.toString(), //           "token": token.toString() //         }, //         "sender": user?.firstname.toString(), //         "message": chatController.text //       }); //       setState(() { //         messages.add(ChatMessage( //             messageContent: chatController.text, //             messageType: "Sender")); //       }); // //       socket?.on('bot_uttered', (data) { //         setState(() { //           messages.add(ChatMessage( //               messageContent: data["text"], //               messageType: "receiver")); //         }); //         print(data.toString()); //         print("RESPONSE CHAT::::${chatAI["text"]}"); //         // Handle event data //       }); // //       // chatFire(chatController.text); //       chatController.clear(); //     } //   }, //   child: Icon( //     Icons.send, //     color: Colors.white, //     size: 18, //   ), //   backgroundColor: Colors.blue, //   elevation: 0, // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      })),
    );
  }

  tapMe(String message, String payload, ChatViewModel value) async {
    var adminData = {
      "metadata": {
        "firstname": "${user?.firstname}",
        "type": "${user?.type}",
        "studentId": "${user?.username}",
        "batch": "",
        "institution": "${user?.institution}",
        "courseSlug": "",
        "token": sharedPreferences.getString('token')
      },
      "sender": "${user?.firstname}",
      "message": payload.isEmpty ? message : payload,
    };

    setState(() {
      _allMessages.add([
        {"recipient_id": "bot", "text": message.toString()}
      ]);
      typing = true;
      chatController.clear();
    });

    await value.fetchChatAdmin(adminData).then((e) {
      if (value.adminMessages.length > 1) {
        List<Map<String, dynamic>> _abc = [
          {"blank": ""}
        ];

        setState(() {
          typing = true;
          _allMessages.add(_abc);
          isGenerating = true;
          typing = false;
        });
        _scrollDown();
        addMultipleData(
            _allMessages.indexOf(_allMessages.last), value.adminMessages);
      } else {
        _scrollDown();
        setState(() {
          typing = true;
        });
        _allMessages.add(value.adminMessages);
        setState(() {
          typing = false;
        });
        _scrollDown();
      }
    });
  }

  Future<void> addDataWithDelay(int index, Map<String, dynamic> newData) async {
    // Add a delay of 2 seconds before adding the new data
    if (isGenerating == true) {
      _scrollDown();
      await Future.delayed(const Duration(seconds: 1));
      _scrollDown();
      setState(() {
        _allMessages[index].add(newData);
      });
      _scrollDown();
      print('New data added: $newData to index $index');
    } else {}
  }

  Future<void> addMultipleData(index, List<Map<String, dynamic>> data) async {
    if (isGenerating == true) {
      for (int i = 0; i < data.length; i++) {
        setState(() {
          typing = true;
        });
        _scrollDown();

        await addDataWithDelay(index, data[i]);

        setState(() {
          typing = false;
        });

        if (i == (data.length - 1)) {
          setState(() {
            print("i am last index setting value to false");
            isGenerating = false;
          });
        }
      }
    } else {}
  }
}

class CustomBubble extends StatelessWidget {
  String recipient;
  int index;
  String message;
  CustomBubble(
      {Key? key,
      required this.message,
      required this.index,
      required this.recipient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment:
            recipient == "bot" ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: recipient == "bot"
                ? const BorderRadius.only(
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    topLeft: Radius.circular(12))
                : const BorderRadius.only(
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
            color:
                recipient == "bot" ? const Color(0xFF004F96) : Colors.grey.shade300,
          ),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width / 1.5, minWidth: 0),
          child: Text(
            message.toString(),
            // delay: const Duration(milliseconds: 20),
            style: GoogleFonts.poppins(
                fontSize: 16,
                color: recipient != "bot" ? Colors.black : Colors.white),
          ),
        ));
  }
}

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final roundingHeight = size.height * 3 / 5;
    final filledRectangle =
        Rect.fromLTRB(0, 0, size.width, size.height - roundingHeight);
    final roundingRectangle = Rect.fromLTRB(
        -5, size.height - roundingHeight * 2, size.width + 5, size.height);

    final path = Path();
    path.addRect(filledRectangle);
    path.arcTo(roundingRectangle, pi, -pi, true);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
