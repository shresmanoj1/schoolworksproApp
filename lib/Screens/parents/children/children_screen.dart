import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getwidget/getwidget.dart';
import 'package:new_version/new_version.dart';
import 'package:schoolworkspro_app/Screens/login/login.dart';
import 'package:schoolworkspro_app/Screens/parents/Dashboard_parent/dashboard_parent.dart';
import 'package:schoolworkspro_app/Screens/parents/navigation/navigation_parents.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/fcm_request.dart';
import 'package:schoolworkspro_app/response/parents/getchildren_response.dart';
import 'package:schoolworkspro_app/services/login_service.dart';
import 'package:schoolworkspro_app/services/parents/getchildren_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/colors.dart';
import '../../../helper/app_version.dart';
import '../../../response/login_response.dart';
import '../More_parent/parentchange_password/parentchangepassword_screen.dart';

class Childrenscreen extends StatefulWidget {
  const Childrenscreen({Key? key}) : super(key: key);

  @override
  _ChildrenscreenState createState() => _ChildrenscreenState();
}

class _ChildrenscreenState extends State<Childrenscreen> {
  Future<Getchildrenresponse>? children_response;

  User? user;
  @override
  void initState() {
    // TODO: implement initState
    children_response = Getchildrenservice().getchildren();
    Future.delayed(Duration.zero, () {
      VersionChecker.checkVersion(context);
    });
    postFcm();
    super.initState();
  }

  postFcm() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });

    try {
      FirebaseMessaging.instance.getToken().then((value) async {
        String? token = value;
        print("fcm: " + token.toString());
        final data = FcmTokenRequest(
            username: user?.username.toString(),
            batch: user?.batch.toString(),
            type: user?.type.toString(),
            institution: user?.institution.toString(),
            token: token.toString());
        final res = await LoginService().postFCM(data);
        if (res.success == true) {
          print("FCM token registered");
        } else {
          print("Error registering FCM token");
        }
      });
    } on Exception catch (e) {
      snackThis(
          content: Text(e.toString()),
          color: Colors.red,
          behavior: SnackBarBehavior.fixed,
          duration: 2,
          context: context);
      // TODO
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Are you sure'),
                  content:
                      const Text('Are you sure you want to close application'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          // _dismissDialog();
                          Navigator.of(context).pop();
                        },
                        child: const Text('No')),
                    TextButton(
                      onPressed: () => exit(0),
                      child: Text('Yes'),
                    )
                  ],
                ))) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: Padding(
      //   padding: EdgeInsets.only(bottom: 45.0),
      //   child: ElevatedButton(
      //
      //     style: ButtonStyle(
      //       backgroundColor: MaterialStateProperty.all(Colors.transparent),
      //     ),
      //     onPressed: () {
      //
      //     },
      //     child: Text(
      //       'Logout',
      //       style: TextStyle(color: Colors.white),
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Parentchangepasswordscreen(),
                    ));
              },
              icon: Icon(Icons.settings))
        ],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          "Home",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Stack(
          children: [
            Center(
              child: FutureBuilder<Getchildrenresponse>(
                future: children_response,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Parents name: ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              children: [
                                TextSpan(
                                  text: user!.firstname.toString() +
                                      " " +
                                      user!.lastname.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Username: ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              children: [
                                TextSpan(
                                  text: user!.username.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "children: ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              children: [
                                TextSpan(
                                  text: snapshot.data!.children!.length
                                      .toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        //   child: Text(
                        //     "Total Children: " +
                        //         snapshot.data!.children!.length.toString(),
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.bold, fontSize: 15),
                        //   ),
                        // ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: snapshot.data!.children!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Dashboardparent(
                                                data: snapshot.data!,
                                                index: index,
                                              )));
                                },
                                child: GFCard(
                                  boxFit: BoxFit.cover,
                                  title: GFListTile(
                                    color: white,
                                    shadow: BoxShadow(color: Colors.transparent),
                                    avatar: CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.grey,
                                        child: snapshot.data!.children![index]
                                                    .userImage ==
                                                null
                                            ? Text(
                                                snapshot.data!.children![index]
                                                        .firstname![0]
                                                        .toUpperCase() +
                                                    "" +
                                                    snapshot
                                                        .data!
                                                        .children![index]
                                                        .lastname![0]
                                                        .toUpperCase(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              )
                                            : ClipOval(
                                                child: Image.network(
                                                  api_url2 +
                                                      '/uploads/users/' +
                                                      snapshot
                                                          .data!
                                                          .children![index]
                                                          .userImage!,
                                                  height: 120,
                                                  width: 120,
                                                  fit: BoxFit.cover,
                                                ),
                                              )),
                                    // avatar:  Image.network(   api_url2 +
                                    //       '/uploads/users/' +
                                    //       snapshot.data!.children![index]["userImage"],height: 100,width: 100,),

                                    title: Text(
                                      snapshot.data!.children![index]
                                              .firstname! +
                                          ' ' +
                                          snapshot
                                              .data!.children![index].lastname!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    subTitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(snapshot
                                            .data!.children![index].course!),
                                        Text(snapshot
                                            .data!.children![index].institute!),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return const Center(
                        child: SpinKitDualRing(
                      color: kPrimaryColor,
                    ));
                  }
                },
              ),
            ),
            // Align(alignment: ,)
            Positioned(
                bottom: 50,
                left: MediaQuery.of(context).size.width / 2.4,
                child: InkWell(
                    onTap: () async {
                      final res = await LoginService().logout();
                      if (res.success == true) {
                        print(res);
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        await sharedPreferences.clear();

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      } else {
                        snackThis(
                            context: context,
                            content: Text(res.success.toString()),
                            color: Colors.red,
                            duration: 1,
                            behavior: SnackBarBehavior.floating);
                      }
                    },
                    child: Text(
                      "Sign out",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )))
          ],
        ),
      ),
    );
  }
}
