import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/gallery/album_screen.dart';
import 'package:schoolworkspro_app/Screens/login/login.dart';
import 'package:schoolworkspro_app/Screens/more/issued_book/issued_book.dart';
import 'package:schoolworkspro_app/Screens/more/my_journal/my_journal.dart';
import 'package:schoolworkspro_app/Screens/more/view_profile_photo.dart';
import 'package:schoolworkspro_app/Screens/physical_library/physical_library.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/components/internetcheck.dart';
import 'package:schoolworkspro_app/components/nointernet_widget.dart';
import '../../../../../constants.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:schoolworkspro_app/constants/fonts.dart';
import 'package:schoolworkspro_app/request/institution_request.dart';
import 'package:schoolworkspro_app/request/parent/getfeesparent_request.dart';
import 'package:schoolworkspro_app/response/addproject_response.dart';
import 'package:schoolworkspro_app/response/authenticateduser_response.dart';
// import 'package:schoolworkspro_app/response/login_response.dart' ;
import 'package:schoolworkspro_app/response/offensehistory_response.dart';
import 'package:schoolworkspro_app/services/authenticateduser_service.dart';
import 'package:schoolworkspro_app/services/fees_service.dart';
import 'package:schoolworkspro_app/services/login_service.dart';

import 'package:schoolworkspro_app/services/parents/getfeesparent_service.dart';
import 'package:schoolworkspro_app/services/updateimage_service.dart';
import 'package:schoolworkspro_app/components/menubar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';

import '../../common_view_model.dart';
import '../../config/api_response_config.dart';
import '../prinicpal/principal_common_view_model.dart';

class More extends StatefulWidget {
  // User finaldetail;

  More({
    Key? key,
  }) : super(key: key);

  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  late CommonViewModel _provider;
  bool connected = true;

  late Future<OffenceHistoryResponse> offense_response;
  PickedFile? _imageFile;

  User? user;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<CommonViewModel>(context, listen: false);
      // common.getAuthenticatedUser();
      // common.fetchoffenses();
    });



    dueStart();
    checkInternet();
    super.initState();
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

  dueStart() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }

  Future<void> _pickImage(ImageSource source, CommonViewModel common) async {
    var selected =
        await ImagePicker().pickImage(source: source, imageQuality: 10);

    setState(() {
      if (selected != null) {
        _imageFile = PickedFile(selected.path);
        Update(_imageFile!, common);
      } else {
        Fluttertoast.showToast(msg: 'No image selected.');
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    Widget bottomSheet(CommonViewModel common) {
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: <Widget>[
            const Text(
              "choose photo",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton.icon(
                  icon: const Icon(Icons.camera, color: Colors.red),
                  onPressed: () async {
                    _pickImage(ImageSource.camera, common);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  label: const Text("Camera"),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.image, color: Colors.green),
                  onPressed: () {
                    _pickImage(ImageSource.gallery, common);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  label: const Text("Gallery"),
                ),
              ],
            )
          ],
        ),
      );
    }

    return Scaffold(
      body: connected == false
          ? const NoInternetWidget()
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      Consumer<CommonViewModel>(
                          builder: (context, common, child) {

                        return LayoutBuilder(builder:
                            (BuildContext context, BoxConstraints constraints) {
                          final imageWidth = constraints.maxWidth * 0.28;
                          const double baseFontSize = 12.0;

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              isLoading(
                                      common.authenticatedUserDetailApiResponse)
                                  ? Container(
                                      height: screenHeight * 0.15,
                                      width: screenWidth * 0.25,
                                      child: Center(
                                          child:
                                              const CupertinoActivityIndicator()),
                                    )
                                  : SizedBox(
                                      width: imageWidth,
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2.0, bottom: 2),
                                            child: SizedBox(
                                                height: screenHeight * 0.15,
                                                width: screenWidth * 0.25,
                                                child: InkWell(
                                                  onTap:
                                                      common.authenticatedUserDetail
                                                                  .userImage ==
                                                              null
                                                          ? null
                                                          : () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ProfileImageViewPage(
                                                                            imageUrl: api_url2 +
                                                                                '/uploads/users/' +
                                                                                common.authenticatedUserDetail.userImage.toString(),
                                                                          )));
                                                            },
                                                  child: ClipRect(
                                                    child: common.authenticatedUserDetail
                                                                    .userImage ==
                                                                null ||
                                                            common
                                                                .authenticatedUserDetail
                                                                .userImage!
                                                                .isEmpty
                                                        ? Container(
                                                            color: logoTheme,
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "${common.authenticatedUserDetail.firstname != null && common.authenticatedUserDetail.firstname!.isNotEmpty ? common.authenticatedUserDetail.firstname![0] : 'firstname'}"
                                                              "${common.authenticatedUserDetail.lastname != null && common.authenticatedUserDetail.lastname!.isNotEmpty ? common.authenticatedUserDetail.lastname![0] : 'lastname'}",
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: kWhite,
                                                                fontSize: h1,
                                                              ),
                                                            ),
                                                          )
                                                        : Image.network(
                                                            api_url2 +
                                                                '/uploads/users/' +
                                                                common
                                                                    .authenticatedUserDetail
                                                                    .userImage
                                                                    .toString(),
                                                            height: 130,
                                                            width: 135,
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                )),
                                          ),
                                          Positioned(
                                              bottom: -6,
                                              right: -2,
                                              child: InkWell(
                                                onTap: () async {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder: ((builder) =>
                                                        bottomSheet(common)),
                                                  );
                                                },
                                                child: Container(
                                                  height: imageWidth * 0.35,
                                                  width: imageWidth * 0.35,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      width: 4,
                                                      color: Theme.of(context)
                                                          .scaffoldBackgroundColor,
                                                    ),
                                                    color: grey_300,
                                                  ),
                                                  child: const Icon(
                                                    Icons.edit,
                                                    color: logoTheme,
                                                  ),
                                                ),
                                              )),
                                        ],
                                      )),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 6,
                                child: SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Card(
                                          color: kBlack,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: common
                                                        .authenticatedUserDetail
                                                        .batch ==
                                                    null
                                                ? const Text("")
                                                : Text(
                                                    common
                                                        .authenticatedUserDetail
                                                        .batch
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: kWhite),
                                                  ),
                                          ),
                                        ),
                                        common.authenticatedUserDetail
                                                    .firstname ==
                                                null
                                            ? const Text("")
                                            : Text(
                                                common.authenticatedUserDetail
                                                        .firstname
                                                        .toString() +
                                                    " " +
                                                    common
                                                        .authenticatedUserDetail
                                                        .lastname
                                                        .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: baseFontSize *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        360),
                                              ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.mail_sharp,
                                              size: 21,
                                            ),
                                            Expanded(
                                              flex: 10,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 2.0, right: 5),
                                                  child:
                                                      common.authenticatedUserDetail
                                                                  .email ==
                                                              null
                                                          ? Text(" ")
                                                          : Text(
                                                              common
                                                                  .authenticatedUserDetail
                                                                  .email
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: kBlack,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: baseFontSize *
                                                                      MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      360),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                            )),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/icons/institution.png",
                                              height: 22,
                                              width: 22,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3, top: 3),
                                              child:
                                                  common.authenticatedUserDetail
                                                              .institution ==
                                                          null
                                                      ? const Text("")
                                                      : Text(
                                                          common
                                                              .authenticatedUserDetail
                                                              .institution
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: kBlack,
                                                              fontSize: baseFontSize *
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  360),
                                                        ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.credit_card_outlined,
                                              size: 22,
                                            ),
                                            Expanded(
                                              flex: 10,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 2.0, right: 5),
                                                  child: common.authenticatedUserDetail
                                                                  .coventryID ==
                                                              null ||
                                                          common.authenticatedUserDetail
                                                                  .coventryID ==
                                                              ""
                                                      ? const Text("N/A")
                                                      : Text(
                                                          common
                                                              .authenticatedUserDetail
                                                              .coventryID
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: kBlack,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: baseFontSize *
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  360),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        )),
                                            ),
                                          ],
                                        ),
                                        !isLoading(common
                                                    .studentBusApiResponse) &&
                                                common.studentBus.bus != null &&
                                                common.studentBus.bus
                                                        ?.busName !=
                                                    null &&
                                                common.studentBus.bus
                                                        ?.busName !=
                                                    ""
                                            ? Row(
                                                children: [
                                                  const Icon(
                                                    Icons.directions_bus_filled,
                                                    size: 21,
                                                  ),
                                                  Expanded(
                                                    flex: 10,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 2.0,
                                                              right: 5),
                                                      child: Text(
                                                        common.studentBus.bus
                                                                ?.busName ??
                                                            '',
                                                        style: TextStyle(
                                                          color: kBlack,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: baseFontSize *
                                                              MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              360,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                        common.currentLevel == null ||
                                                common.currentLevel!.isEmpty ||
                                                common.currentLevel! ==
                                                    "Good student"
                                            ? const SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 5,
                                                      vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xffE80000),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  "Disciplinary Level: ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: white,
                                                                  fontSize: baseFontSize *
                                                                      MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      360),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  "${common.currentLevel}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  color: white,
                                                                  fontSize: baseFontSize *
                                                                      MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      360),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      InkWell(
                                                          onTap: () {
                                                            Widget okButton =
                                                                Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  ElevatedButton(
                                                                child: Text(
                                                                    "Close"),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            );
                                                            Dialog alert =
                                                                Dialog(
                                                              insetPadding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          20),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        const Text(
                                                                          "Your Disciplinary Act History",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16),
                                                                        ),
                                                                        InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Icon(Icons.close))
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Container(
                                                                      width: double
                                                                          .maxFinite,
                                                                      // height: 250,
                                                                      child: ListView
                                                                          .builder(
                                                                        itemCount: common
                                                                            .offenses
                                                                            .length,
                                                                        shrinkWrap:
                                                                            true,
                                                                        physics:
                                                                            ScrollPhysics(),
                                                                        itemBuilder:
                                                                            (context,
                                                                                i) {
                                                                          var datas =
                                                                              common.offenses[i];
                                                                          DateTime
                                                                              committed =
                                                                              DateTime.parse(datas.date.toString());

                                                                          committed = committed.add(const Duration(
                                                                              hours: 5,
                                                                              minutes: 45));

                                                                          var formattedTime =
                                                                              DateFormat('yMMMMd').format(committed);

                                                                          return GFListTile(
                                                                            color:
                                                                                white,
                                                                            title: datas.level != null
                                                                                ? Text(
                                                                                    "Offence Type: ${datas.level!.level.toString()}",
                                                                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                                                  )
                                                                                : Text(""),
                                                                            subTitle:
                                                                                Text(formattedTime.toString()),
                                                                            description:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                const Text("Remarks:"),
                                                                                Text(datas.remarks.toString())
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                    // okButton
                                                                  ],
                                                                ),
                                                              ),
                                                            );

                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return alert;
                                                              },
                                                            );
                                                            // Navigator.pushNamed(context, "/disciplinaryActHistoryScreen");
                                                          },
                                                          child: const Icon(
                                                            Icons
                                                                .remove_red_eye,
                                                            color: white,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        SizedBox(width: 6),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        });
                      }),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Container(
                          height: 2.0,
                          width: double.infinity,
                          color: const Color(0XFFD9D9D9),
                        ),
                      ),
                      //

                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 15),
                        child: ListView(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: <Widget>[
                            ListTile(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    '/editprofile',
                                  );
                                },
                                leading: Image.asset(
                                  "assets/icons/profileicons/user.png",
                                  height: 35,
                                  width: 35,
                                ),
                                title: const Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: p2),
                                ),
                                subtitle: const Text("Edit your information")),

                            ListTile(
                                onTap: () {
                                  Navigator.pushNamed(context, '/documents');
                                },
                                leading: Image.asset(
                                  "assets/icons/profileicons/reading-book.png",
                                  height: 35,
                                  width: 35,
                                ),
                                title: const Text(
                                  'My Documents',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: p2),
                                ),
                                subtitle: const Text("View Your Document")),

                            ListTile(
                                onTap: () {
                                  Navigator.of(context).pushNamed('/activities',
                                      arguments: user == null
                                          ? ""
                                          : user!.username.toString());
                                },
                                leading: Image.asset(
                                  "assets/icons/profileicons/homework.png",
                                  height: 35,
                                  width: 35,
                                ),
                                title: const Text(
                                  'Tasks',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: p2),
                                ),
                                subtitle:
                                    const Text("View Task for each week")),

                            ListTile(
                                onTap: () {
                                  Navigator.of(context).pushNamed('/journey');
                                },
                                leading: Image.asset(
                                  "assets/icons/profileicons/destination.png",
                                  height: 35,
                                  width: 35,
                                ),
                                title: const Text(
                                  'My Journey',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: p2),
                                ),
                                subtitle: const Text(
                                    "View your progress of each module")),

                            ListTile(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) =>
                                //           const Physicallibraryscreen(),
                                //     ));
                                Navigator.pushNamed(context, "/issuedBook");
                              },
                              leading: Image.asset(
                                "assets/icons/profileicons/book.png",
                                height: 35,
                                width: 35,
                              ),
                              title: const Text(
                                'Books',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: p2),
                              ),
                              subtitle:
                                  const Text('Books you requested to borrow'),
                            ),

                            ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const MyJournal(),
                                      ));
                                },
                                leading: Image.asset(
                                  "assets/icons/profileicons/notebook.png",
                                  height: 35,
                                  width: 35,
                                ),
                                title: const Text(
                                  'My Journals',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: p2),
                                ),
                                subtitle:
                                    const Text("Add or view your journal")),

                            ListTile(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    '/supportStaff',
                                  );
                                },
                                leading: Image.asset(
                                  "assets/icons/profileicons/support.png",
                                  height: 35,
                                  width: 35,
                                ),
                                title: const Text(
                                  'Support Staffs',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: p2),
                                ),
                                subtitle:
                                    const Text("Request here to get support ")),

                            ListTile(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, "/settingScreen");
                                },
                                leading: Image.asset(
                                  "assets/icons/profileicons/user-profile.png",
                                  height: 35,
                                  width: 35,
                                ),
                                title: const Text(
                                  'Settings',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: p2),
                                ),
                                subtitle: const Text(
                                    "Update password and details here")),

                            ListTile(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  '/disciplinaryActHistoryScreen',
                                );
                              },
                              leading: Image.asset(
                                "assets/icons/profileicons/no-stopping.png",
                                height: 35,
                                width: 35,
                              ),
                              title: const Text(
                                'Disciplinary Acts',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: p2),
                              ),
                              subtitle: const Text('View Offence Levels'),
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.of(context).pushNamed(
                            //       '/surveyscreen',
                            //     );
                            //   },
                            //   child: ListTile(
                            //     trailing: const Icon(Icons.arrow_forward_ios_rounded),
                            //     leading: Image.asset(
                            //       "assets/icons/survey.png",
                            //       height: 30,
                            //       width: 30,
                            //     ),
                            //     title: const Text('Survey'),
                            //     subtitle: const Text('Take part in survey'),
                            //   ),
                            // ),
                            //

                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.of(context).pushNamed(
                            //       '/feesscreen',
                            //     );
                            //   },
                            //   child: ListTile(
                            //     trailing: const Icon(Icons.arrow_forward_ios_rounded),
                            //     leading: Image.asset(
                            //       "assets/icons/fees.png",
                            //       height: 30,
                            //       width: 30,
                            //     ),
                            //     title: const Text('Fees'),
                            //     subtitle: const Text('Fees detail'),
                            //   ),
                            // ),

                            // GestureDetector(
                            //   onTap: () {
                            //     // Navigator.of(context).pushNamed(
                            //     //   '/galleryscreen',
                            //     // );
                            //     //
                            //     Navigator.of(context).pushNamed(
                            //       '/albumscreen',
                            //     );
                            //   },
                            //   child: ListTile(
                            //     trailing: const Icon(Icons.arrow_forward_ios_rounded),
                            //     leading: Image.asset(
                            //       "assets/images/gallery.jpg",
                            //       height: 30,
                            //       width: 30,
                            //     ),
                            //     title: const Text('Gallery'),
                            //     subtitle: const Text('Image gallery of events'),
                            //   ),
                            // ),

                            ListTile(
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
                                          builder: (context) =>
                                              const LoginScreen()));
                                } else {
                                  snackThis(
                                      context: context,
                                      content: Text(res.success.toString()),
                                      color: Colors.red,
                                      duration: 1,
                                      behavior: SnackBarBehavior.floating);
                                }
                              },
                              // trailing: Icon(Icons.arrow_forward_ios_rounded),
                              leading: Image.asset(
                                "assets/icons/profileicons/logout.png",
                                height: 35,
                                width: 35,
                              ),
                              title: const Text(
                                'Logout',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: p2),
                              ),
                              subtitle:
                                  const Text('Logout your account from device'),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Update(PickedFile abc, CommonViewModel common) async {
    final result = await Imageservice().updateImage("users", abc);
    if (result.success == true) {
      common.getAuthenticatedUser();
      Fluttertoast.showToast(msg: "Image updated succesfully");
    } else {
      Fluttertoast.showToast(msg: "Error updating image");
    }
  }

  Future<bool> onBackPressed() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text("NO"),
            ),
          ),
          // SizedBox(height: 16),
          TextButton(
            onPressed: () {
              exit(0);
            },
            child: const Padding(
              padding: EdgeInsets.only(bottom: 8, right: 8),
              child: Text("YES"),
            ),
          ),
        ],
      ),
    );
    return true;
  }

  void choiceAction(String choice) {
    if (choice == menubar.password) {
      Navigator.of(context)
          .pushNamed('/updatepasswordscreen', arguments: false);
    } else {
      Navigator.of(context).pushNamed('/updatedetailscreen');
    }
  }
}
