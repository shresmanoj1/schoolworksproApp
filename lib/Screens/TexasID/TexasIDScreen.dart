import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/components/hex_color.dart';
import 'package:schoolworkspro_app/components/internetcheck.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:schoolworkspro_app/response/institutiondetail_response.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:schoolworkspro_app/services/institution_service.dart';
import 'package:schoolworkspro_app/utils/hive_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../lecturer/ID-lecturer/idcard_view_model.dart';

class TexasIDScreen extends StatefulWidget {
  const TexasIDScreen({Key? key}) : super(key: key);

  @override
  _TexasIDScreenState createState() => _TexasIDScreenState();
}

class _TexasIDScreenState extends State<TexasIDScreen> {
  User? user;
  bool connected = false;
  double angle = 0;

  bool? _displayFront;
  bool? _flipXAxis;

  void _flip() {
    setState(() {
      angle = (angle + pi) % (2 * pi);
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    getData();
    _displayFront = true;
    _flipXAxis = true;

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
        // snackThis(context: context,content: const Text("No Internet Connection"),duration: 10,color: Colors.red.shade500);
        Fluttertoast.showToast(msg: "No Internet connection");
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: logoTheme,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Consumer<IDCardLecturerViewModel>(
              builder: (context, value, child) {
            return isLoading(value.institutionApiResponse)
                ? const Center(child: CupertinoActivityIndicator())
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: double.infinity,
                            height: 750,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                const BorderRadius.only(
                                    topLeft:
                                    Radius.circular(10),
                                    topRight:
                                    Radius.circular(10),
                                    bottomLeft:
                                    Radius.circular(10),
                                    bottomRight:
                                    Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0,
                                        3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    color: value.institution[
                                    'primaryColor'] ==
                                        null
                                        ? kPrimaryColor
                                        : HexColor(
                                        value.institution[
                                        'primaryColor']),
                                    width: double.infinity,
                                    height: 30,
                                    child: const Center(
                                      child: Text(
                                        'IDENTIFICATION CARD',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets
                                        .symmetric(
                                        horizontal: 15.0),
                                    child: Container(
                                      width:
                                      MediaQuery.of(context)
                                          .size
                                          .width /
                                          2,
                                      height: 80,
                                      child: CachedNetworkImage(
                                        fit: BoxFit.contain,
                                        imageUrl:
                                        '$api_url2/uploads/institutions/' +
                                            value.institution[
                                            'footerLogo'],
                                        placeholder: (context,
                                            url) =>
                                            Container(
                                                child: const Center(
                                                    child:
                                                    CupertinoActivityIndicator())),
                                        errorWidget: (context,
                                            url, error) =>
                                            Icon(Icons.error),
                                      ),
                                      // child: Image.network(
                                      //   api_url2 +
                                      //       'uploads/institutions/' +
                                      //       value.institution[
                                      //           'footerLogo'],
                                      //   width:
                                      //       double.infinity,
                                      //   height: 100,
                                      // ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 90,
                                  ),
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        // alignment: Alignment.centerRight,
                                        width: double.infinity,
                                        height: 260,
                                        color: value.institution[
                                        'primaryColor'] ==
                                            null
                                            ? kPrimaryColor
                                            : HexColor(value
                                            .institution[
                                        'primaryColor']),
                                      ),
                                      Positioned(
                                        left:
                                        MediaQuery.of(context)
                                            .size
                                            .width /
                                            3.5,
                                        top: -50,
                                        child: user?.userImage ==
                                            null
                                            ? Container(
                                          width: 150,
                                          height: 150,
                                          color: Colors.grey
                                              .shade100,
                                          child: Center(
                                              child: Text(
                                                user == null
                                                    ? ""
                                                    : "${user!.firstname![0].toString().toUpperCase()}${user!.lastname![0].toString().toUpperCase()}",
                                                style: const TextStyle(
                                                    fontSize:
                                                    22,
                                                    color: Colors
                                                        .black,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold),
                                              )),
                                        )
                                            : Container(
                                          width: 150,
                                          height: 150,
                                          child:
                                          CachedNetworkImage(
                                            fit:
                                            BoxFit.fill,
                                            imageUrl:
                                            '$api_url2/uploads/users/${user!.userImage}',
                                            placeholder: (context,
                                                url) =>
                                                Container(
                                                    child: const Center(
                                                        child:
                                                        CupertinoActivityIndicator())),
                                            errorWidget: (context,
                                                url,
                                                error) =>
                                                Icon(Icons
                                                    .error),
                                          ),
                                          // child: Image.network(
                                          //   api_url2 +
                                          //       'uploads/institutions/' +
                                          //       value.institution[
                                          //           'footerLogo'],
                                          //   width:
                                          //       double.infinity,
                                          //   height: 100,
                                          // ),
                                        ),
                                        // Container(
                                        //         // color: Colors.red,
                                        //         width: 150,
                                        //         height: 150,
                                        //         decoration: BoxDecoration(
                                        //             image: DecorationImage(
                                        //                 fit:
                                        //                     BoxFit.fill,
                                        //                 image: NetworkImage(api_url2 +
                                        //                     "uploads/users/" +
                                        //                     user!
                                        //                         .userImage
                                        //                         .toString())))),
                                      ),
                                      Positioned(
                                        // left: MediaQuery.of(context).size.width / 4.4,
                                        top: 100,
                                        child: SizedBox(
                                          width: MediaQuery.of(
                                              context)
                                              .size
                                              .width -
                                              16,
                                          height: 140,
                                          // color: Colors.red,
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center,
                                            children: [
                                              Text(
                                                user == null
                                                    ? ""
                                                    : "${user!.firstname.toString().toUpperCase()} ${user!.lastname.toString().toUpperCase()}",
                                                style: const TextStyle(
                                                    color: Colors
                                                        .white,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    fontSize: 18),
                                              ),
                                              user!.batch == null
                                                  ? SizedBox()
                                                  : Text(
                                                  user!.batch
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors
                                                          .white,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      fontSize:
                                                      16)),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              user!.address ==
                                                  null
                                                  ? SizedBox()
                                                  : Padding(
                                                padding:
                                                const EdgeInsets.all(
                                                    8.0),
                                                child: Text(
                                                    user!
                                                        .address
                                                        .toString()
                                                        .toUpperCase(),
                                                    textAlign:
                                                    TextAlign
                                                        .center,
                                                    style: const TextStyle(
                                                        color:
                                                        Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15)),
                                              ),
                                              Text(
                                                  user!.email
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors
                                                          .white,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      fontSize:
                                                      15)),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    color: Colors.grey.shade100,
                                    width: double.infinity,
                                    height: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .center,
                                      children: [
                                        Text(
                                          value.institution[
                                          'contact']
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.bold,
                                              color:
                                              Colors.black),
                                        ),
                                        Text(
                                          value.institution[
                                          'address']
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.bold,
                                              color:
                                              Colors.black),
                                        ),
                                        Text(
                                          value.institution[
                                          'website']
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.bold,
                                              color:
                                              Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets
                                        .symmetric(
                                        vertical: 10,
                                        horizontal: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: 150,
                                          width: 150,
                                          child: QrImageView(
                                              data:
                                              '{"username":"${user!.username}","institution":"${user!.institution}","batch":"${user!.batch}","type":"${user!.type}"}'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ) //else we will display it here,
                        ),
                      ],
                    ),
                );
          }),
        ));
  }
}