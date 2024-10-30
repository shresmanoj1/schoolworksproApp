import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:schoolworkspro_app/Screens/lecturer/ID-lecturer/idcard_view_model.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/components/hex_color.dart';
import 'package:schoolworkspro_app/components/internetcheck.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/institutiondetail_response.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:schoolworkspro_app/services/institution_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class IDCardlecturer extends StatefulWidget {
  const IDCardlecturer({Key? key}) : super(key: key);

  @override
  _IDCardlecturerState createState() => _IDCardlecturerState();
}

class _IDCardlecturerState extends State<IDCardlecturer> {
  User? user;
  bool connected = true;

  bool isBack = true;
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<IDCardLecturerViewModel>(context, listen: false)
          .fetchInstitution();
    });
    getData();
    checkInternet();
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
        Fluttertoast.showToast(
          msg: "No Internet connection",
        );
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
        // backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: false,
        // iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<IDCardLecturerViewModel>(
              builder: (context, value, child) {
                return isLoading(value.institutionApiResponse)
                    ? Center(
                        child: SpinKitDualRing(
                          color: kPrimaryColor,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Now we will start making our Card
                          //the principe is basic
                          //we will create a container that will display the back face or the front face
                          // and we will wrap it in a Transform widget
                          //then we will make a tween animation for animating our card
                          //now let's wrap our tween animation inside a gesture detector

                          GestureDetector(
                            onTap: _flip,
                            child: TweenAnimationBuilder(
                                tween: Tween<double>(begin: 0, end: angle),
                                duration: const Duration(seconds: 1),
                                builder:
                                    (BuildContext context, double val, __) {
                                  //here we will change the isBack val so we can change the content of the card
                                  if (val >= (pi / 2)) {
                                    isBack = false;
                                  } else {
                                    isBack = true;
                                  }
                                  return (Transform(
                                    //let's make the card flip by it's center
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()
                                      ..setEntry(3, 2, 0.001)
                                      ..rotateY(val),
                                    child: Container(
                                        width: double.infinity,
                                        height: 750,
                                        child: !isBack
                                            ? Transform(
                                                alignment: Alignment.center,
                                                transform: Matrix4.identity()
                                                  ..rotateY(pi),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10)),
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      QrImageView(
                                                          size: 150,
                                                          data:
                                                              '{"username":"${user!.username}","institution":"${user!.institution}"}'),
                                                      const SizedBox(
                                                        height: 300,
                                                      ),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 40),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'Powered By',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              // Text('Schoolworkspro',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                                              Image.asset(
                                                                'assets/images/logo.png',
                                                                height: 70,
                                                                width: 250,
                                                              )
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ) //el//if it's back we will display here
                                            : Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
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
                                                          : HexColor(value
                                                                  .institution[
                                                              'primaryColor']),
                                                      width: double.infinity,
                                                      height: 30,
                                                      child: const Center(
                                                        child: Text(
                                                          'IDENTIFICATION CARD',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                        // width: double.infinity,
                                                        width: MediaQuery.of(context).size.width /2,
                                                        height: 80,
                                                        child:
                                                            CachedNetworkImage(
                                                          // fit: BoxFit.fill,
                                                              fit: BoxFit.contain,
                                                          imageUrl: api_url2 +
                                                              '/uploads/institutions/' +
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
                                                          width:
                                                              double.infinity,
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
                                                          left: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3.5,
                                                          top: -50,
                                                          child: user?.userImage ==
                                                                  null
                                                              ? Container(
                                                                  width: 150,
                                                                  height: 150,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade100,
                                                                  child: Center(
                                                                      child:
                                                                          Text(
                                                                    user!.firstname![0]
                                                                            .toString()
                                                                            .toUpperCase() +
                                                                        "" +
                                                                        user!
                                                                            .lastname![0]
                                                                            .toString()
                                                                            .toUpperCase(),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            22,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )),
                                                                )
                                                              : Container(
                                                                  // color: Colors.red,
                                                                  width: 150,
                                                                  height: 150,
                                                                  decoration: BoxDecoration(
                                                                      image: DecorationImage(
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          image: NetworkImage(api_url2 +
                                                                              "/uploads/users/" +
                                                                              user!.userImage.toString())))),
                                                        ),
                                                        Positioned(
                                                          // left: MediaQuery.of(context).size.width / 4.4,
                                                          top: 100,
                                                          child: Container(
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
                                                                  user!.firstname
                                                                          .toString()
                                                                          .toUpperCase() +
                                                                      " " +
                                                                      user!
                                                                          .lastname
                                                                          .toString()
                                                                          .toUpperCase(),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                                user!.batch ==
                                                                        null
                                                                    ? SizedBox()
                                                                    : Text(
                                                                        user!
                                                                            .batch
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 16)),
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                user!.address ==
                                                                        null
                                                                    ? SizedBox()
                                                                    : Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child: Text(
                                                                            user!.address
                                                                                .toString()
                                                                                .toUpperCase(),
                                                                            style: const TextStyle(
                                                                                color: Colors.white,
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
                                                      color:
                                                          Colors.grey.shade100,
                                                      width: double.infinity,
                                                      height: 120,
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
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          Text(
                                                            value.institution[
                                                                    'address']
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          Text(
                                                            value.institution[
                                                                    'website']
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10,
                                                          horizontal: 20.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            height: 85,
                                                            width: 85,
                                                            child: QrImageView(
                                                                data:
                                                                    '{"username":"${user!.username}","institution":"${user!.institution}"}'),
                                                            // child: const Center(child: Text('STUDENT ID CARD',style:  TextStyle(
                                                            //     color: Colors.white,
                                                            //     fontWeight: FontWeight.bold,
                                                            //     fontSize: 20))),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ) //else we will display it here,
                                        ),
                                  ));
                                }),
                          )
                        ],
                      );
              },
            )),
      ),
    );
  }
}
