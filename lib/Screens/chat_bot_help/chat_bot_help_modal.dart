import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'dart:core';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/preference_utils.dart';
import '../../constants/text_style.dart';
import '../../response/authenticateduser_response.dart';
import '../dashboard/chat_view_model.dart';

class ChatBotHelpModal extends StatefulWidget {
  ChatBotHelpModal({
    Key? key,
  }) : super(key: key);

  @override
  _ChatBotHelpModalState createState() => _ChatBotHelpModalState();
}

class _ChatBotHelpModalState extends State<ChatBotHelpModal> {
  final SharedPreferences sharedPreferences = PreferenceUtils.instance;
  User? user;
  late ChatViewModel _model;
  final List<List<Map<String, dynamic>>> _allMessages =
      <List<Map<String, dynamic>>>[];

  @override
  void initState() {
    // TODO: implement initState
    setD();
    super.initState();
  }

  static const String botImage = "assets/bot.png";

  setD() async {
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });

    var studentData = {
      "metadata": {
        "firstname": "${user?.firstname}",
        "studentId": "${user?.username}",
        "batch": "${user?.batch}",
        "institution": "${user?.institution}",
        "courseSlug": "${user?.courseSlug}",
        "token": sharedPreferences.getString('token')
      },
      "sender": "${user?.firstname}",
      "message": "/intent_return"
    };

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _model = Provider.of<ChatViewModel>(context, listen: false);
      _model.fetchChat(studentData).then((value) {
        setState(() {
          _allMessages.add(_model.messages);
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ChatViewModel>(builder: (context, chat, child) {
        return  Container(
          color: Colors.white,
          child:  ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                itemCount: _allMessages.length,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: ((context, index) {
                  var datas = _allMessages[index].first;
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          botImage,
                          height: 80,
                          width: 80,
                        ),

                        Text("V ${datas['text'].split(",").first}",
                            style: p16.copyWith(
                              fontWeight: FontWeight.w800,
                            )),

                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0,bottom: 8,top: 8),
                              child: Text("What can i assist you with ?",style: p14.copyWith(fontWeight: FontWeight.w600),),
                            )),
                        ...List.generate(
                            datas['text'].split(",").length - 2,
                            (i) => ListTile(
                                visualDensity: const VisualDensity(
                                    horizontal: 0, vertical: -4.0),
                                title: Text(
                                  datas['text'].split(",")[i + 2].toString().capitalize(),
                                  style: p14,
                                ),
                                minLeadingWidth: 0,
                                leading: Text(
                                  "\u2022",
                                  style: p16.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800),
                                )))
                      ]);
                }),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        );
      }),
    );
  }


}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
