import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/physical_library/library_view_model.dart';
import 'package:schoolworkspro_app/api/repositories/library_repo.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/issuedbook_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api.dart';
import '../../../config/api_response_config.dart';
import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../helper/custom_loader.dart';
import '../../../response/common_response.dart';
import '../../../response/login_response.dart';
import '../../library/book_view_screen.dart';
import '../../widgets/snack_bar.dart';

class IssuedBook extends StatefulWidget {
  const IssuedBook({Key? key}) : super(key: key);

  @override
  _IssuedBookState createState() => _IssuedBookState();
}

class _IssuedBookState extends State<IssuedBook> {
  Future<Issuedbookresponse>? issue_book;
  late LibraryViewModel _provider;
  User? user;
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<LibraryViewModel>(context, listen: false);
    });
    getData();
    super.initState();
  }

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });

    _provider
        .fetchAllIssuedBooks(user == null ? "" : user!.username.toString());
    _provider.fetchDigitalBookMarkedBooks();
  }

  @override
  Widget build(BuildContext context) {
    if (isloading == true ) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: const Text(
            "Books",
            style: TextStyle(color: white),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(55),
            child: Builder(builder: (context) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: TabBar(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  unselectedLabelColor: white,
                  labelColor: Color(0xff004D96),
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: p1),
                  indicator: BoxDecoration(
                    border: Border(),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                    color: white,
                  ),
                  tabs: [
                    Tab(
                      text: "Issued Books",
                    ),
                    Tab(
                      text: "Bookmarks",
                    )
                  ],
                ),
              );
            }),
          ),
        ),
        body: Consumer<LibraryViewModel>(
          // future: issue_book,
          builder: (context, snapshot, child) {
            return TabBarView(
              children: [
                SingleChildScrollView(
                  child: isLoading(snapshot.allIssuedBooksApiResponse)
                      ? const Center(child: CupertinoActivityIndicator())
                      : snapshot.allIssuedBooks.issueHistory == null ||
                              snapshot.allIssuedBooks.issueHistory!.isEmpty
                          ? Column(
                              children: [
                                Image.asset("assets/images/no_content.PNG"),
                              ],
                            )
                          : snapshot.allIssuedBooks.issueHistory!.isEmpty ||
                                  snapshot.allIssuedBooks.issueHistory == null
                              ? Column(children: <Widget>[
                                  Image.asset("assets/images/no_content.PNG"),
                                ])
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount: snapshot.allIssuedBooks
                                              .issueHistory!.length,
                                          physics: const ScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            var datas = snapshot.allIssuedBooks
                                                .issueHistory![index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xff767676))),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child:
                                                                  CachedNetworkImage(
                                                                height: 90,
                                                                fit:
                                                                    BoxFit.fill,
                                                                imageUrl:
                                                                    "$api_url2/uploads/library/${datas["book"]['thumbnail']}",
                                                                placeholder: (context,
                                                                        url) =>
                                                                    const Center(
                                                                        child:
                                                                            CupertinoActivityIndicator()),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    const Icon(Icons
                                                                        .error),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    datas["book"]
                                                                        [
                                                                        'name'],
                                                                    style: const TextStyle(
                                                                        color:
                                                                            black,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 1,
                                                                  ),
                                                                  Text(
                                                                    "by ${datas["book"]['author']}",
                                                                    style: const TextStyle(
                                                                        color: Color(
                                                                            0xff767676),
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Container(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                6.0,
                                                                            vertical:
                                                                                4.0),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(4),
                                                                          color: datas["returned"] == true
                                                                              ? const Color(0xff006400)
                                                                              : const Color(0xff886861),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          datas["returned"] == true
                                                                              ? "Returned"
                                                                              : "Borrowed",
                                                                          style: const TextStyle(
                                                                              color: white,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 14),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      InkWell(
                                                          onTap: () {
                                                            booksDetailDialog(
                                                                context, datas);
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10),
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                              color: logoTheme,
                                                            ),
                                                            child: const Text(
                                                                "View Details",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: white,
                                                                )),
                                                          )),
                                                    ],
                                                  )),
                                            );
                                          }),
                                      const SizedBox(
                                        height: 50,
                                      )
                                    ]),
                ),
                SingleChildScrollView(
                  child: isLoading(snapshot.digitalBookMarkedBooksApiResponse)
                      ? const SpinKitDualRing(color: kPrimaryColor)
                      : snapshot.digitalBookMarkedBooks.bookmarks == null ||
                              snapshot.digitalBookMarkedBooks.bookmarks!.isEmpty
                          ? Column(
                              children: [
                                Image.asset("assets/images/no_content.PNG"),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: snapshot.digitalBookMarkedBooks
                                          .bookmarks!.length,
                                      physics: const ScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var datas = snapshot
                                            .digitalBookMarkedBooks
                                            .bookmarks![index];
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        BookViewScreen(
                                                            page: datas
                                                                .pageNumber,
                                                            file: datas
                                                                .bookId!.file
                                                                .toString(),
                                                            book_id: datas
                                                                .bookId!.id
                                                                .toString()),
                                                  ));
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xffB4B4B4))),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            datas.bookId!.file
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color: black,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          const SizedBox(
                                                            height: 1,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 12,
                                                          vertical: 8),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                              text: 'Page: ',
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                  text: (datas.pageNumber! +
                                                                          1)
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              showRemoveBookMarkAlertDialog(
                                                                  context,
                                                                  datas.id
                                                                      .toString());
                                                            },
                                                            child: Container(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 4,
                                                                  horizontal:
                                                                      4),
                                                              decoration: const BoxDecoration(
                                                                  color: Color(
                                                                      0xffE80000),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              3))),
                                                              child: Row(
                                                                children: const [
                                                                  Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color:
                                                                        white,
                                                                    size: 20,
                                                                  ),
                                                                  Text(
                                                                    "Delete",
                                                                    style: TextStyle(
                                                                        color:
                                                                            white),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        );
                                      }),
                                  const SizedBox(
                                    height: 50,
                                  )
                                ]),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  showRemoveBookMarkAlertDialog(BuildContext context, String id) {
    Widget okButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
      ),
      child: const Text(
        "Yes, Remove this bookmark!",
        style: TextStyle(color: white),
      ),
      onPressed: () async {
        setState(() {
          isloading = true;
        });
        try {
          setState(() {
            isloading = true;
          });
          Commonresponse res =
              await LibraryRepository().removeDigitalBookMark(id);
          if (res.success == true) {
            _provider.fetchDigitalBookMarkedBooks();
            setState(() {
              isloading = false;
            });
            Navigator.pop(context);
            Fluttertoast.showToast(
                msg: res.message.toString(),
                backgroundColor: Colors.green,
                textColor: white,
                fontSize: 16.0);
          } else {
            setState(() {
              isloading = false;
            });
            Fluttertoast.showToast(
                msg: res.message.toString(),
                backgroundColor: Colors.red,
                textColor: white,
                fontSize: 16.0);
          }
        } catch (e) {
          setState(() {
            isloading = false;
          });
          snackThis(
              context: context,
              content: Text(e.toString()),
              color: Colors.red,
              duration: 1,
              behavior: SnackBarBehavior.floating);
        }
      },
    );
    Widget cancelButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(black),
      ),
      child: const Text(
        "Cancel",
        style: TextStyle(color: white),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Confirmation!"),
      actions: [
        okButton,
        cancelButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

booksDetailDialog(BuildContext context, dynamic datas) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 10),
          child: StatefulBuilder(builder: (context, StateSetter setState) {
            return Container(
              height: 580,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: ListView(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.close),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            datas["book"]["name"],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: datas["returned"] == true
                                ? const Color(0xff006400)
                                : const Color(0xff886861),
                          ),
                          child: Text(
                            datas["returned"] == true ? "Returned" : "Borrowed",
                            style: const TextStyle(
                                color: white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Issued: ",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Center(
                            child: Text(
                          DateFormat.yMMMd().format(
                              DateTime.parse(datas["issue_date"])
                                  .add(const Duration(hours: 5, minutes: 45))),
                          style: const TextStyle(
                              fontSize: 17,
                              // fontWeight: FontWeight.w600,
                              color: Colors.black),
                        )),
                        const Text(" - "),
                        Center(
                            child: Text(
                          DateFormat.yMMMd().format(
                              DateTime.parse(datas["due_date"])
                                  .add(const Duration(hours: 5, minutes: 45))),
                          style: const TextStyle(
                              fontSize: 17,
                              // fontWeight: FontWeight.w600,
                              color: Colors.black),
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text("Renewed History",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline)),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      // height: 40,
                      child: datas['renewed_history'] == null ||
                              datas["renewed_history"].isEmpty
                          ? const SizedBox()
                          : ListView.builder(
                              shrinkWrap: true,
                              // physics: ScrollPhysics(),
                              itemCount: datas['renewed_history'].length,
                              itemBuilder: (context, j) {
                                var datas2 = datas['renewed_history'][j];
                                return Row(
                                  children: [
                                    const Text(
                                      "Issued on: ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Builder(builder: (context) {
                                            DateTime issued = DateTime.parse(
                                                datas2['issue_date']);

                                            issued = issued.add(const Duration(
                                                hours: 5, minutes: 45));

                                            var formattedTime =
                                                DateFormat('MM/dd/yy')
                                                    .format(issued);

                                            DateTime due = DateTime.parse(
                                                datas2['due_date']);

                                            due = due.add(const Duration(
                                                hours: 5, minutes: 45));

                                            var formattedDueTime =
                                                DateFormat('MM/dd/yyyy')
                                                    .format(due);
                                            return Text(
                                                '$formattedTime - $formattedDueTime');
                                          }),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      });
}
