import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/components/internetcheck.dart';
import 'package:schoolworkspro_app/components/nointernet_widget.dart';
import 'package:schoolworkspro_app/config/preference_utils.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:schoolworkspro_app/constants/fonts.dart';
import 'package:schoolworkspro_app/request/add_project.dart';
import 'package:schoolworkspro_app/services/addproject_service.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_response.dart';
import '../../api/repositories/journey_repository.dart';
import '../../config/api_response_config.dart';
import '../../helper/custom_loader.dart';
import '../../response/authenticateduser_response.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({Key? key}) : super(key: key);

  @override
  _JourneyScreenState createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  bool _isPublic = false;

  bool connected = true;

  final TextEditingController titlecontroller = TextEditingController();
  final TextEditingController linkcontroller = TextEditingController();

  late CommonViewModel common;
  User? user;
  final SharedPreferences localStorage = PreferenceUtils.instance;
  @override
  void initState() {
    // TODO: implement initState

    getData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CommonViewModel>(context, listen: false);
      // .fetchjourney();
      checkInternet();
    });

    super.initState();
  }

  getData() {
    if (localStorage.getString('token') != null) {
      user = User.fromJson(
          jsonDecode(localStorage.getString("_auth_").toString()));
    }
  }

  checkInternet() async {
    internetCheck().then((value) {
      if (value) {
        setState(() {
          connected = true;
        });
      } else {
        setState(() {
          connected = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("My Journey",
                style: TextStyle(color: kWhite, fontWeight: FontWeight.w800)),
            elevation: 0.0,
            iconTheme: const IconThemeData(
              color: kWhite, //change your color here
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    await Share.share(
                        "https://schoolworkspro.com/profile/${user?.username ?? ""}");
                  },
                  icon: const Icon(Icons.share))
            ],
            backgroundColor: logoTheme),
        body: connected == false
            ? const NoInternetWidget()
            : SingleChildScrollView(child: Consumer<CommonViewModel>(
                builder: (context, common, child) {
                  return isLoading(common.journeyApiResponse)
                      ? const Center(child: CupertinoActivityIndicator())
                      : common.journey == null ||
                              common.journey.isEmpty ||
                              common.juser == null
                          ? const Text("")
                          : Builder(builder: (context) {
                              var user = common.juser;
                              var institution = common.journey[0].institution;
                              var academic = common.journey[0].academicDetails;
                              var module = common.journey[0].modules;
                              DateTime now = DateTime.parse(
                                  academic!.createdAt.toString());
                              now = now
                                  .add(const Duration(hours: 5, minutes: 45));
                              var formattedTime =
                                  DateFormat('yMMMMd').format(now);
                              return Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Image.network(
                                        '$api_url2/uploads/institutions/${institution!.footerLogo!}',
                                        height: 90,
                                        width: double.infinity,
                                      )),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0),
                                            child: SizedBox(
                                              height: 130,
                                              width: 130,
                                              child: ClipRect(
                                                child: user!.userImage ==
                                                            null ||
                                                        user.userImage!.isEmpty
                                                    ? Container(
                                                        color: logoTheme,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          '${user.firstname![0].toUpperCase()}${user.lastname![0].toUpperCase()}',
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: kWhite,
                                                            fontSize: h1,
                                                          ),
                                                        ),
                                                      )
                                                    : Image.network(
                                                        '$api_url2/uploads/users/${user.userImage}',
                                                        height: 90,
                                                        width: 90,
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                        flex: 5,
                                        child: SizedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2.0, right: 15),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${user.firstname!} ${user.lastname!}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: p0),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 2.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Expanded(
                                                        flex: 1,
                                                        child: Icon(
                                                          Icons.mail_outline,
                                                          size: 21,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 2,
                                                      ),
                                                      Expanded(
                                                        flex: 10,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 2.0,
                                                                  right: 5),
                                                          child: user
                                                                      .email ==
                                                                  null
                                                              ? const Text(" ")
                                                              : Text(
                                                                  user.email
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      color:
                                                                          kBlack,
                                                                      fontSize:
                                                                          p2)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 2.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Expanded(
                                                        flex: 1,
                                                        child: Icon(
                                                          Icons.phone,
                                                          size: 21,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 2,
                                                      ),
                                                      Expanded(
                                                        flex: 10,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 2.0,
                                                                  right: 5),
                                                          child: user.contact ==
                                                                  null
                                                              ? Text(" ")
                                                              : Text(
                                                                  user.contact
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      color:
                                                                          kBlack,
                                                                      fontSize:
                                                                          p2)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 2.0),
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        const TextSpan(
                                                          text: "Joined: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: kBlack),
                                                        ),
                                                        TextSpan(
                                                          text: formattedTime,
                                                          style:
                                                              const TextStyle(
                                                                  color: kBlack,
                                                                  fontSize: p2),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 2.0),
                                                  child: SizedBox(
                                                    height: 30,
                                                    width: 230,
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        customLoadStart();
                                                        final res =
                                                            await JourneyRepository()
                                                                .updatePublicStatus();
                                                        if (res.success ==
                                                            true) {
                                                          setState(() {
                                                            _isPublic =
                                                                !_isPublic;
                                                          });
                                                          common.fetchjourney();
                                                          Future.delayed(
                                                              const Duration(
                                                                  milliseconds:
                                                                      20), () {
                                                            customLoadStop();
                                                          });
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg: res.message
                                                                  .toString());
                                                          Future.delayed(
                                                              const Duration(
                                                                  milliseconds:
                                                                      20), () {
                                                            customLoadStop();
                                                          });
                                                        }

                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    20), () {
                                                          customLoadStop();
                                                        });
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: kpink,
                                                        onPrimary: Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      2.0),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        _isPublic
                                                            ? 'Make Private'
                                                            : 'Make Public',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: p1),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: module!.isEmpty
                                        ? const SizedBox()
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                physics: const ScrollPhysics(),
                                                scrollDirection: Axis.vertical,
                                                itemCount: module.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 15),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 10),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0),
                                                              child: Text(
                                                                module[index]
                                                                    .moduleTitle!,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        p2,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  const Text(
                                                                    "Progress",
                                                                    style: TextStyle(
                                                                        color:
                                                                            kBlack,
                                                                        fontSize:
                                                                            p2),
                                                                  ),
                                                                  // const SizedBox(
                                                                  //   width: 60,
                                                                  // ),
                                                                  Text(
                                                                      "${module[index].progress ?? 0}%"),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            LinearPercentIndicator(
                                                              lineHeight: 8.0,
                                                              // width: 180,
                                                              percent: module[index]
                                                                          .progress ==
                                                                      null
                                                                  ? 0
                                                                  : double.parse(module[
                                                                              index]
                                                                          .progress!
                                                                          .toString()
                                                                          .split(
                                                                              ".")[0]) /
                                                                      100,
                                                              backgroundColor:
                                                                  grey_300,
                                                              progressColor:
                                                                  logoTheme,
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const Text(
                                                                    "Attendance",
                                                                    style: TextStyle(
                                                                        color:
                                                                            kBlack,
                                                                        fontSize:
                                                                            p2),
                                                                  ),
                                                                  Builder(builder:
                                                                      (context) {
                                                                    var value =
                                                                        module[index].attendance ??
                                                                            "0";
                                                                    return Text(
                                                                        "$value%");
                                                                  }),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            LinearPercentIndicator(
                                                              lineHeight: 8.0,
                                                              // width: 180,
                                                              percent: (double.parse(module[
                                                                          index]
                                                                      .attendance!
                                                                      .toString()
                                                                      .split(
                                                                          ".")[0]) /
                                                                  100),
                                                              backgroundColor:
                                                                  grey_300,
                                                              progressColor:
                                                                  kpink,
                                                            ),
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                  ),
                                ),
                                ListTile(
                                  title: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Projects",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: p1),
                                    ),
                                  ),
                                  trailing: ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder:
                                                (BuildContext dialogcontext) {
                                              return AlertDialog(
                                                  title: const Text(
                                                    "Add project",
                                                  ),
                                                  content: SizedBox(
                                                    height: 200,
                                                    child: Column(
                                                      children: [
                                                        TextFormField(
                                                          controller:
                                                              titlecontroller,
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText:
                                                                'Title of project',
                                                            labelText:
                                                                'Project',
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              linkcontroller,
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText:
                                                                'link of project',
                                                            labelText: 'link',
                                                          ),
                                                        ),
                                                        ButtonBar(children: [
                                                          ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                final data = Addprojectrequest(
                                                                    link: linkcontroller
                                                                        .text,
                                                                    title:
                                                                        titlecontroller
                                                                            .text,
                                                                    username:
                                                                        academic
                                                                            .username);

                                                                final res =
                                                                    await Addprojectservice()
                                                                        .addproject(
                                                                            data);
                                                                if (res.success ==
                                                                    true) {
                                                                  linkcontroller
                                                                      .clear();
                                                                  titlecontroller
                                                                      .clear();
                                                                  Navigator.pop(
                                                                      dialogcontext);
                                                                  final snackBar =
                                                                      SnackBar(
                                                                    content:
                                                                        Text(res
                                                                            .message!),
                                                                    backgroundColor:
                                                                        (Colors
                                                                            .black),
                                                                    action:
                                                                        SnackBarAction(
                                                                      label:
                                                                          'dismiss',
                                                                      onPressed:
                                                                          () {
                                                                        ScaffoldMessenger.of(context)
                                                                            .hideCurrentSnackBar();
                                                                      },
                                                                    ),
                                                                  );
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          snackBar);
                                                                } else {
                                                                  Navigator.pop(
                                                                      dialogcontext);
                                                                  final snackBar =
                                                                      SnackBar(
                                                                    content:
                                                                        Text(res
                                                                            .message!),
                                                                    backgroundColor:
                                                                        (Colors
                                                                            .black),
                                                                    action:
                                                                        SnackBarAction(
                                                                      label:
                                                                          'dismiss',
                                                                      onPressed:
                                                                          () {
                                                                        ScaffoldMessenger.of(context)
                                                                            .hideCurrentSnackBar();
                                                                      },
                                                                    ),
                                                                  );
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          snackBar);
                                                                }
                                                              },
                                                              child: const Text(
                                                                  "Save"))
                                                        ]),
                                                      ],
                                                    ),
                                                  ));
                                            });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary:
                                            logoTheme, // set the color here
                                      ),
                                      child: const Text(
                                        "Add project",
                                        style: TextStyle(
                                            color: kWhite,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          common.journey[0].projects!.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              title: Text(
                                                  "project title: ${common.journey[0].projects![index].title!}"),
                                              subtitle: Text(
                                                  "project link: ${common.journey[0].projects![index].link!}"),
                                              trailing: GestureDetector(
                                                  onTap: () async {
                                                    final data =
                                                        Addprojectrequest(
                                                            title: common
                                                                .journey[0]
                                                                .projects![
                                                                    index]
                                                                .title!,
                                                            link: common
                                                                .journey[0]
                                                                .projects![
                                                                    index]
                                                                .link!,
                                                            username: academic
                                                                .username);

                                                    final res =
                                                        await Addprojectservice()
                                                            .deleteproject(
                                                                data);
                                                    if (res.success == true) {
                                                      final snackBar = SnackBar(
                                                        content:
                                                            Text(res.message!),
                                                        backgroundColor:
                                                            (Colors.black),
                                                        action: SnackBarAction(
                                                          label: 'dismiss',
                                                          onPressed: () {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .hideCurrentSnackBar();
                                                          },
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    } else {
                                                      final snackBar = SnackBar(
                                                        content:
                                                            Text(res.message!),
                                                        backgroundColor:
                                                            (Colors.black),
                                                        action: SnackBarAction(
                                                          label: 'dismiss',
                                                          onPressed: () {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .hideCurrentSnackBar();
                                                          },
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    }
                                                  },
                                                  child:
                                                      const Icon(Icons.delete)),
                                            )
                                          ],
                                        );
                                      }),
                                ),
                              ]);
                            });
                },
              )));
  }
}
