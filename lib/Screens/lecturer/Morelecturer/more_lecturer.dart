import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:schoolworkspro_app/Screens/gallery/album_screen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/QrView.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/leave/book_leave.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/student_stats/lecturerstudentstats_screen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/admission/advisor_screen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/almuni_stats/alumni_screen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/student_leave/view_student_leave_screen.dart';
import 'package:schoolworkspro_app/Screens/login/login.dart';
import 'package:schoolworkspro_app/Screens/splash/splashscreen.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/api/repositories/switch_repo.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/components/internetcheck.dart';
import 'package:schoolworkspro_app/components/nointernet_widget.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/switch_request.dart';
import 'package:schoolworkspro_app/response/alumuni_response.dart';
import 'package:schoolworkspro_app/response/authenticateduser_response.dart';
import 'package:schoolworkspro_app/response/lecturer/checkpunchstatus_response.dart';
import 'package:schoolworkspro_app/response/login_response.dart' as lr;
import 'package:schoolworkspro_app/response/logout_response.dart';
import 'package:schoolworkspro_app/services/authenticateduser_service.dart';
import 'package:schoolworkspro_app/services/lecturer/punch_service.dart';
import 'package:schoolworkspro_app/services/login_service.dart';
import 'package:schoolworkspro_app/services/updateimage_service.dart';
import 'package:schoolworkspro_app/components/menubar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth_view_model.dart';
import '../../../components/more_data.dart';
import '../../../config/api_response_config.dart';
import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../more/view_profile_photo.dart';
import '../../prinicpal/navigation/navigation.dart';

class Morelecturer extends StatefulWidget {
  const Morelecturer({Key? key}) : super(key: key);

  @override
  _MorelecturerState createState() => _MorelecturerState();
}

class _MorelecturerState extends State<Morelecturer> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // Barcode? result;
  // QRViewController? controller;
  late Future authenticationmodel;
  PickedFile? _imageFile;
  bool isloading = false;
  final ImagePicker _picker = ImagePicker();
  // Stream<CheckPunchStatus>? punch_status;
  bool connected = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void reassemble() {
    super.reassemble();
    // if (Platform.isAndroid) {
    //   controller?.pauseCamera();
    // } else if (Platform.isIOS) {
    //   controller?.resumeCamera();
    // }
  }

  String? selected_role;
  late Authenticateduserservice _auth;
  late PunchService _punchService;
  late CommonViewModel _provider2;
  @override
  void initState() {
    // TODO: implement initState
    // getAuthenticateduser();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // _auth = Provider.of<Authenticateduserservice>(context, listen: false);
      // _auth.getAuthentication(context);

      _provider2 = Provider.of<CommonViewModel>(context, listen: false);
      // _provider2.getAuthenticatedUser();

      _punchService = Provider.of<PunchService>(context, listen: false);

      _punchService.checkPunchStatus(context);
    });

    getMenu();
    // punch_status =
    //     PunchService().getRefreshPunchstatus(Duration(milliseconds: 10));
    checkInternet();
    getData();
    super.initState();
  }

  List<MenuLecturer> _listForDisplay = <MenuLecturer>[];
  List<MenuLecturer> _list = <MenuLecturer>[];

  getMenu() async {
    for (int i = 0; i < menu_lecturer.length; i++) {
      _list.add(menu_lecturer[i]);
      _listForDisplay = _list;
    }
    // print("i cam herer" + _listForDisplay));
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
        // snackThis(context: context,content: const Text("No Internet Connection"),duration: 10,color: Colors.red.shade500);
        // Fluttertoast.showToast(msg: "No Internet connection");
      }
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


  lr.User? user;

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    lr.User userD = lr.User.fromJson(userMap);
    setState(() {
      user = userD;
    });

    selected_role = user?.type.toString();
  }

  @override
  Widget build(BuildContext context) {
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

    return Consumer2<CommonViewModel, AuthViewModel>(
        builder: (context, common, auth, child) {
      return Scaffold(
        body: connected == false
            ? NoInternetWidget()
            : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      isLoading(common.authenticatedUserDetailApiResponse)
                          ? const
                              // Center(child: CupertinoActivityIndicator())
                              Center(
                                  child: SpinKitFoldingCube(
                              color: kPrimaryColor,
                            ))
                          : Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Stack(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, bottom: 20),
                                      child: SizedBox(
                                        height: 150,
                                        width: 155,
                                        child: InkWell(
                                          onTap: common.authenticatedUserDetail
                                                      .userImage ==
                                                  null
                                              ? null
                                              : () {
                                                  print("BUTTON CLICKED:::");
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProfileImageViewPage(
                                                                imageUrl:
                                                                    '$api_url2/uploads/users/${common.authenticatedUserDetail.userImage}',
                                                              )));
                                                },
                                          child: ClipRect(
                                            child: (common
                                                        .authenticatedUserDetail
                                                        .userImage ==
                                                    null)
                                                ? Container(
                                                    color: logoTheme,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "${common.authenticatedUserDetail.firstname != null ? common.authenticatedUserDetail.firstname![0] : 'N/A'}"
                                                      "${common.authenticatedUserDetail.lastname != null ? common.authenticatedUserDetail.lastname![0] : 'N/A'}",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: kWhite,
                                                        fontSize: h1,
                                                      ),
                                                    ),
                                                  )
                                                : CachedNetworkImage(
                                                    height: 100,
                                                    width: 100,
                                                    fit: BoxFit.cover,
                                                    imageUrl:
                                                        '$api_url2/uploads/users/${common.authenticatedUserDetail.userImage}',
                                                    placeholder: (context,
                                                            url) =>
                                                        const Center(
                                                            child:
                                                                CupertinoActivityIndicator()),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Image.asset(
                                                            "assets/images/button/user.png"),
                                                  ),
                                            // Image.network(
                                            //   api_url2 + '/uploads/users/' + common.authenticatedUserDetail.userImage.toString(),
                                            //   height: 100,
                                            //   width: 100,
                                            //   fit: BoxFit.cover,
                                            // ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 2,
                                        right: -6,
                                        child: InkWell(
                                          onTap: () async {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: ((builder) =>
                                                  bottomSheet(common)),
                                            );
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 40,
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
                                  ]),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: SizedBox(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
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
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 22),
                                                ),
                                          Row(
                                            children: [
                                              const Expanded(
                                                flex: 1,
                                                child: Icon(
                                                  Icons.mail_sharp,
                                                  size: 21,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 10,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10),
                                                  child: common
                                                              .authenticatedUserDetail
                                                              .email ==
                                                          null
                                                      ? const Text(" ")
                                                      : Text(
                                                          common
                                                              .authenticatedUserDetail
                                                              .email
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Image.asset(
                                                  "assets/icons/institution.png",
                                                  height: 22,
                                                  width: 22,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 10,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0, top: 3),
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
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Row(
                                          //   children: [
                                          //     const Expanded(
                                          //         flex: 1,
                                          //         child: Icon(Icons.people)),
                                          //     Expanded(
                                          //       flex: 10,
                                          //       child: Padding(
                                          //           padding:
                                          //               const EdgeInsets.only(
                                          //             left: 8.0,
                                          //           ),
                                          //           child: Container(
                                          //             width: 120,
                                          //             child: common
                                          //                         .authenticatedUserDetail
                                          //                         .type ==
                                          //                     null
                                          //                 ? Text(common
                                          //                     .authenticatedUserDetail
                                          //                     .type
                                          //                     .toString())
                                          //                 : DropdownButton(
                                          //                     style: const TextStyle(
                                          //                         color: Colors
                                          //                             .black,
                                          //                         fontSize: 14),
                                          //                     isExpanded: true,
                                          //                     icon: const Icon(Icons
                                          //                         .arrow_drop_down_outlined),
                                          //                     items: user
                                          //                         ?.roles!
                                          //                         .map((pt) {
                                          //                       return DropdownMenuItem(
                                          //                         value: pt,
                                          //                         child: Text(
                                          //                           pt,
                                          //                           style: const TextStyle(
                                          //                               color: Colors
                                          //                                   .black,
                                          //                               fontSize:
                                          //                                   14),
                                          //                           overflow:
                                          //                               TextOverflow
                                          //                                   .ellipsis,
                                          //                         ),
                                          //                       );
                                          //                     }).toList(),
                                          //                     onChanged:
                                          //                         (newVal) async {
                                          //                       setState(() {
                                          //                         selected_role =
                                          //                             newVal
                                          //                                 as String?;
                                          //                       });
                                          //
                                          //                       final req =
                                          //                           SwitchRequest(
                                          //                               type:
                                          //                                   selected_role);
                                          //                       final ress =
                                          //                           await SwitchRepo()
                                          //                               .switchrole(
                                          //                                   req);
                                          //                       if (ress.success ==
                                          //                           true) {
                                          //                         final SharedPreferences
                                          //                             localStorage =
                                          //                             await SharedPreferences
                                          //                                 .getInstance();
                                          //                         localStorage.setString(
                                          //                             "token",
                                          //                             ress.token
                                          //                                 .toString());
                                          //                         localStorage.setString(
                                          //                             "_auth_",
                                          //                             jsonEncode(
                                          //                                 ress.user));
                                          //                         Navigator.pushReplacement(
                                          //                             context,
                                          //                             MaterialPageRoute(
                                          //                               builder:
                                          //                                   (context) =>
                                          //                                       Splashscreen(),
                                          //                             ));
                                          //                         Fluttertoast
                                          //                             .showToast(
                                          //                                 msg:
                                          //                                     "Role switched to ${selected_role}");
                                          //                       } else {
                                          //                         Fluttertoast
                                          //                             .showToast(
                                          //                                 msg:
                                          //                                     "Failed switching role to ${selected_role}");
                                          //                       }
                                          //                     },
                                          //                     value:
                                          //                         selected_role,
                                          //                   ),
                                          //           )),
                                          //     ),
                                          //   ],
                                          // ),
                                          common.authenticatedUserDetail
                                                      .designation ==
                                                  null
                                              ? Container()
                                              : Chip(
                                                  backgroundColor: logoTheme,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 4,
                                                      vertical: 0),
                                                  labelPadding:
                                                      const EdgeInsets.all(0),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6)),
                                                  label: Text(
                                                    common
                                                        .authenticatedUserDetail
                                                        .designation
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white),
                                                  )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Container(
                          height: 2.0,
                          width: 390,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _listForDisplay.isEmpty
                          ? EmptyWidget.kEmpty
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: _listForDisplay.length,
                                itemBuilder: (context, index) => ListTile(
                                  onTap: () async {
                                    if (_listForDisplay[index].tapValue == 0) {
                                      Navigator.of(context)
                                          .pushNamed('/updatedetailscreen');
                                    } else if (_listForDisplay[index]
                                            .tapValue ==
                                        1) {
                                      Navigator.of(context).pushNamed(
                                        '/overtimelecturer',
                                      );
                                    } else if (_listForDisplay[index]
                                            .tapValue ==
                                        2) {
                                      Navigator.pushNamed(
                                          context, "/issuedBook");
                                    } else if (_listForDisplay[index]
                                            .tapValue ==
                                        3) {
                                      Navigator.of(context)
                                          .pushNamed('/updatepasswordscreen', arguments: false);
                                    }

                                    //
                                    // else if (_listForDisplay[index].tapValue ==
                                    //     4) {
                                    //   Navigator.of(context).pushNamed(
                                    //     '/LogisticsLecturerScreen',
                                    //   );
                                    // } else if (_listForDisplay[index].tapValue ==
                                    //     5) {
                                    //   Navigator.of(context).pushNamed(
                                    //     '/lecturerrequestinventory',
                                    //   );
                                    // } else if (_listForDisplay[index].tapValue ==
                                    //     6) {
                                    //   Navigator.of(context).pushNamed(
                                    //     '/UpdatelogisticsInventory',
                                    //   );
                                    // } else if (_listForDisplay[index].tapValue ==
                                    //     7) {
                                    //   Navigator.of(context).pushNamed(
                                    //     '/AttendanceReportLecturer',
                                    //   );
                                    // } else if (_listForDisplay[index].tapValue ==
                                    //     8) {
                                    //   Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             LecturerStudentStats(),
                                    //       ));
                                    // } else if (_listForDisplay[index].tapValue ==
                                    //     9) {
                                    //   Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             const ViewStudentLeaveScreen(),
                                    //       ));
                                    // }

                                    else if (_listForDisplay[index].tapValue ==
                                        4) {
                                      final res = await LoginService().logout();
                                      if (res.success == true) {
                                        SharedPreferences sharedPreferences =
                                            await SharedPreferences
                                                .getInstance();
                                        await sharedPreferences.clear();

                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen()));
                                      } else {
                                        snackThis(
                                            context: context,
                                            content:
                                                Text(res.success.toString()),
                                            color: Colors.red,
                                            duration: 1);
                                      }
                                    }
                                  },
                                  trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded),
                                  leading: Image.asset(
                                    _listForDisplay[index].image.toString(),
                                    height: 30,
                                    width: 30,
                                  ),
                                  title: Text(
                                      _listForDisplay[index].title.toString()),
                                  subtitle: Text(_listForDisplay[index]
                                      .description
                                      .toString()),
                                ),
                              ),
                            ),
                      user?.domains != null && user!.domains!.contains("Admin")
                          ? ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  kPrimaryColor,
                                ),
                              ),
                              onPressed: () async {
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();

                                sharedPreferences.setBool("changedToAdmin", true);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Splashscreen(),
                                    ));
                              },
                              child: const Text('Admin View'),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
      );
    });
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
