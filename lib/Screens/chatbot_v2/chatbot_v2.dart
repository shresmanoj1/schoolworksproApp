import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/extension/sizebox_ex.dart';
import 'package:schoolworkspro_app/response/get_all_chat_ai_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/preference_utils.dart';
import '../../../constants/text_style.dart';
import '../../../response/authenticateduser_response.dart';
import '../../api/repositories/chatbot/chat_repo.dart';

class ChatBotLecturerScreen extends StatelessWidget {
  const ChatBotLecturerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ChatBotBodyLecturer();
  }
}

class ChatBotBodyLecturer extends StatefulWidget {
  const ChatBotBodyLecturer({Key? key}) : super(key: key);

  @override
  State<ChatBotBodyLecturer> createState() => _ChatBotLecturerScreenState();
}

class _ChatBotLecturerScreenState extends State<ChatBotBodyLecturer> {
  User? user;
  TextEditingController chatController = TextEditingController();
  final SharedPreferences sharedPreferences = PreferenceUtils.instance;
  late CommonViewModel commonViewModel;
  bool isGenerating = false;
  bool typing = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    setD();
    super.initState();
  }

  FocusNode _focuNode = FocusNode();

  setD() async {
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
      commonViewModel
          .fetchAllMessagesNewChatBot(user?.username ?? "")
          .then((value) {
        // print(commonViewModel.allMessagesV2);
        if (commonViewModel.allMessagesV2.length == 1) {
          setState(() {
            _allMessages.add(Message(
                role: "assistant",
                content: "Hello! How can I assist you today?"));
            typing = false;
          });
        } else {
          setState(() {
            for (var a in commonViewModel.allMessagesV2) {
              if (a.role != "system") {
                _allMessages.add(a);
              }
            }
            typing = false;
          });
        }
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

  final List<Message> _allMessages = <Message>[];
  static const String botImage = "assets/images/chatbot_ai.png";

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollDown();
    });
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      appBar: AppBar(
        // backgroundColor: lo,
        backgroundColor: const Color(0xFF004F96),
        actions: [
          IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Confirm"),
                      content:
                          const Text("Your messages history will be deleted"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel")),
                        TextButton(
                            onPressed: () async {
                              if (_allMessages.isEmpty) {
                                // showTopOverlayNotificationError(
                                //     title: "Chat history not found");
                                snackThis(
                                    context: context,
                                    content:
                                        const Text("Chat history not found"));
                              } else {
                                final res = await ChatBotRepo()
                                    .deleteHistory(user?.username ?? "");
                                if (res.data?.success == true) {
                                  setState(() {
                                    _allMessages.clear();
                                    _allMessages.add(Message(
                                        role: "assistant",
                                        content:
                                            "Hello! How can I assist you today?"));
                                  });
                                  // showTopOverlayNotification(
                                  //     title: "Chat history deleted");
                                  snackThis(
                                      context: context,
                                      content:
                                          const Text("Chat history deleted"));
                                } else {
                                  // showTopOverlayNotificationError(
                                  //     title: "Unable to delete Chat History");
                                  snackThis(
                                      context: context,
                                      content: const Text(
                                          "Unable to delete Chat History"));
                                }
                              }
                              // RouteGenerator.goBack();
                              Navigator.pop(context);
                            },
                            child: const Text("Ok")),
                      ],
                    );
                  },
                );
              }),
        ],
        centerTitle: true,
        title: const Text("ChatBot"),
        elevation: 0.0,
        // iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
          child: Consumer<CommonViewModel>(builder: (context, value, child) {
        return Column(
          children: <Widget>[
            Expanded(
                child: ListView(
              controller: _scrollController,
              shrinkWrap: true,
              children: [
                SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: Stack(
                      clipBehavior: Clip.antiAlias,
                      fit: StackFit.loose,
                      children: [
                        ClipPath(
                          clipper: CurvedBottomClipper(),
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            decoration:
                                const BoxDecoration(color: Color(0xFF004F96)),
                          ),
                        ),
                        Positioned.fill(
                          bottom: 10.0,
                          child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(botImage,
                                height: 100, width: 100, fit: BoxFit.contain),
                          ),
                        ),
                      ],
                    )),
                Column(
                  children: [
                    staticMessage(
                        value: value,
                        text:
                            "Generate an image of an AI Robot running in the midst of a desert 🤖🌵🐫"),
                    8.sH,
                    staticMessage(
                        value: value,
                        text: "Example of encapsulation in Python 🧑‍💻"),
                    8.sH,
                    staticMessage(
                        value: value, text: "How is my student rating? ⭐"),
                    8.sH,
                    staticMessage(
                        value: value, text: "Suggest me 3 Books on DSA 📚"),
                  ],
                ),
                20.sH,
                ListView.builder(
                  itemCount: _allMessages.length,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    _scrollDown();
                    var datas = _allMessages[index];
                    return Column(
                      children: [
                        datas.role != "user"
                            ? Row(
                                children: [
                                  10.sW,
                                  Expanded(
                                    flex: 2,
                                    child: datas.role != "user"
                                        ? Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Image.asset(botImage))
                                        : const SizedBox(),
                                  ),
                                  15.sW,
                                  Expanded(
                                    flex: 20,
                                    child: Padding(
                                        padding: datas.role == "user"
                                            ? const EdgeInsets.only(right: 8.0)
                                            : const EdgeInsets.only(
                                                bottom: 5,
                                              ),
                                        child: CustomBubble(
                                          recipient: datas.role,
                                          message: datas.content,
                                        )),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: CustomBubble(
                                        recipient: datas.role,
                                        message: datas.content,
                                      )),
                                  10.sW,
                                ],
                              ),
                      ],
                    );
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
                          50.sH,
                        ],
                      )
                    : const SizedBox(),
                50.sH
              ],
            )),
            Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                children: [
                  isGenerating == true
                      ? Center(
                          child: OutlinedButton.icon(
                              icon: const Icon(Icons.stop, color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  isGenerating = false;
                                });
                              },
                              label: Text(
                                "Stop generating",
                                style: p14.copyWith(color: Colors.black),
                              )),
                        )
                      : const SizedBox(),
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    padding: const EdgeInsets.only(left: 10),
                    height: 70,
                    width: double.infinity,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 12,
                          child: Container(
                              // height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextFormField(
                                focusNode: _focuNode,
                                style: GoogleFonts.poppins().copyWith(
                                    color: Colors.grey.shade700, fontSize: 16),
                                onChanged: (value) {
                                  _scrollDown();
                                },
                                controller: chatController,
                                decoration: InputDecoration(
                                  hintText: "Type a question...",
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 0.0, 0.0, 10.0),
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
                                      GoogleFonts.poppins(color: Colors.grey),
                                  border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              )),
                        ),
                        15.sW,

                        Expanded(
                          flex: 2,
                          child: InkWell(
                              onTap: () async {
                                if (isGenerating == true) {
                                  snackThis(
                                      context: context,
                                      content: const Text(
                                          "Please wait while response is generated"));
                                } else {
                                  if (chatController.text.isNotEmpty) {
                                    setState(() {
                                      _focuNode.unfocus();
                                    });
                                    tapMe(chatController.text, "", value);
                                  } else {
                                    setState(() {
                                      _allMessages.add(Message(
                                          role: "assistant",
                                          content:
                                              "Hi ${user?.firstname}, please enter some message to send"));
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
                                      color: const Color(0xFF004F96),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: const Center(
                                      child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  )))),
                        ),
                        5.sW,
                        // FloatingActionButton( //   onPressed: () { //     if (chatController.text != null && //         chatController.text != "") { //       var token = localStorage.getString('token'); //       socket?.emit('user_uttered', { //         "customData": { //           "firstname": user?.firstname.toString(), //           "studentId": user?.username.toString(), //           "batch": user?.batch.toString(), //           "institution": user?.institution.toString(), //           "courseSlug": user?.courseSlug.toString(), //           "token": token.toString() //         }, //         "sender": user?.firstname.toString(), //         "message": chatController.text //       }); //       setState(() { //         messages.add(ChatMessage( //             messageContent: chatController.text, //             messageType: "Sender")); //       }); // //       socket?.on('bot_uttered', (data) { //         setState(() { //           messages.add(ChatMessage( //               messageContent: data["text"], //               messageType: "receiver")); //         }); //         print(data.toString()); //         print("RESPONSE CHAT::::${chatAI["text"]}"); //         // Handle event data //       }); // //       // chatFire(chatController.text); //       chatController.clear(); //     } //   }, //   child: Icon( //     Icons.send, //     color: Colors.white, //     size: 18, //   ), //   backgroundColor: Colors.blue, //   elevation: 0, // ),
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

  Widget staticMessage({required String text, required CommonViewModel value}) {
    return InkWell(
      onTap: () {
        tapMe(text, "", value);
      },
      child: Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.2),
          decoration: BoxDecoration(
              // color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade300)),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(text)),
    );
  }

  tapMe(String message, String payload, CommonViewModel value) async {
    setState(() {
      _allMessages.add(Message(role: "user", content: message));
      typing = true;
      chatController.clear();
    });

    await value
        .sendMessageToBot(user?.email ?? "", message.replaceAll(' ', '+'),
            user?.email ?? "", user?.type == "Student" ? true : false)
        .then((e) {
      setState(() {
        typing = true;
        isGenerating = true;
        typing = false;
      });
      _allMessages.add(
          Message(role: "assistant", content: value.inputData.response ?? ""));
      setState(() {
        typing = false;
        isGenerating = false;
        typing = false;
      });
    });
  }
}

class CustomBubble extends StatelessWidget {
  String recipient;

  String message;

  CustomBubble({Key? key, required this.message, required this.recipient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment:
            recipient == "user" ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: recipient == "user"
                  ? const BorderRadius.only(
                      bottomRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      topLeft: Radius.circular(12))
                  : const BorderRadius.only(
                      bottomRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
              color: recipient == "user"
                  ? const Color(0xFF004F96)
                  : Colors.grey.shade200,
            ),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 1.5, minWidth: 0),
            child: MarkdownBody(
              data: message.toString(),
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                    color: recipient != "user" ? Colors.black : Colors.white),
              ),
            )));
  }
}

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final roundingHeight = size.height * 3 / 5;
    final filledRectangle =
        Rect.fromLTRB(0, 0, size.width, size.height - roundingHeight);
    final roundingRectangle = Rect.fromLTRB(
        -2, size.height - roundingHeight * 2, size.width + 5, size.height);

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
