import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/physical_library/library_view_model.dart';
import 'package:schoolworkspro_app/api/repositories/library_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../config/api_response_config.dart';
import '../../constants/text_style.dart';
import '../../helper/custom_loader.dart';
import '../../response/authenticateduser_response.dart';

class BookViewScreen extends StatefulWidget {
  String file;
  int page = 1;
  String book_id;
  BookViewScreen(
      {Key? key, required this.page, required this.book_id, required this.file})
      : super(key: key);

  @override
  State<BookViewScreen> createState() => _BookViewScreenState();
}

class _BookViewScreenState extends State<BookViewScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  PdfViewerController _pdfViewerController = PdfViewerController();
  final TextEditingController _pageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  User? user;
  bool showAppbar = true;

  @override
  void initState() {
    // TODO: implement initState
    getData();
    navigate();
    super.initState();
  }

  navigate() {
    _pdfViewerController.jumpToPage(widget.page);
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
        appBar: showAppbar == true ? AppBar() : null,
        body: Consumer<LibraryViewModel>(builder: (context, values, child) {
          return SafeArea(
            child: (values.url.isEmpty ||
                    isLoading(values.generateTokenApiResponse))
                ? const Center(child: CupertinoActivityIndicator())
                : Stack(
                    children: [
                      SfPdfViewer.network(
                        values.url,
                        key: _pdfViewerKey,
                        controller: _pdfViewerController,
                        canShowPaginationDialog: false,
                        enableDocumentLinkAnnotation: true,
                        enableDoubleTapZooming: true,
                        enableHyperlinkNavigation: true,
                        pageLayoutMode: PdfPageLayoutMode.continuous,
                        enableTextSelection: true,
                      ),
                      Positioned.fill(
                        bottom: 10,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 350,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.black45),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible:
                                            false, // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text(
                                                    "Go to page",
                                                    style: p16.copyWith(
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                  TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller: _pageController,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Ok'),
                                                onPressed: () {
                                                  _pdfViewerController
                                                      .jumpToPage(int.parse(
                                                          _pageController.text
                                                              .toString()));
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.directions_walk,
                                      color: Colors.white,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      _pdfViewerController.previousPage();
                                    },
                                    icon: const Icon(
                                      Icons.first_page,
                                      color: Colors.white,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      _pdfViewerController.zoomLevel =
                                          _pdfViewerController.zoomLevel - 0.2;
                                    },
                                    icon: const Icon(
                                      Icons.zoom_out,
                                      color: Colors.white,
                                      size: 30,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      _pdfViewerController.zoomLevel =
                                          _pdfViewerController.zoomLevel + 0.2;
                                    },
                                    icon: const Icon(
                                      Icons.zoom_in,
                                      color: Colors.white,
                                      size: 30,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      _pdfViewerController.nextPage();
                                    },
                                    icon: const Icon(Icons.last_page,
                                        color: Colors.white)),
                                IconButton(
                                    onPressed: () async {
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible:
                                            false, // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text(
                                                    "Bookmark this page  [${_pdfViewerController.pageNumber}]",
                                                    style: p16.copyWith(
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Ok'),
                                                onPressed: () async {
                                                  customLoadStart();
                                                  try {
                                                    Map<String, dynamic> datas =
                                                        {
                                                      "username":
                                                          user?.username ?? "",
                                                      "book_id": widget.book_id,
                                                      "pageNumber":
                                                          _pdfViewerController
                                                              .pageNumber
                                                    };

                                                    final res =
                                                        await LibraryRepository()
                                                            .addBookMarks(
                                                                datas);
                                                    if (res.success == true) {
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds: 20),
                                                          () {
                                                        customLoadStop();
                                                      });

                                                      Fluttertoast.showToast(
                                                          msg: res.message
                                                              .toString());
                                                    } else {
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds: 20),
                                                          () {
                                                        customLoadStop();
                                                      });
                                                      Fluttertoast.showToast(
                                                          msg: res.message
                                                              .toString());
                                                    }
                                                  } on Exception catch (e) {
                                                    Future.delayed(
                                                        const Duration(
                                                            milliseconds: 20),
                                                        () {
                                                      customLoadStop();
                                                    });
                                                    Fluttertoast.showToast(
                                                        msg: e.toString());
                                                    // TODO
                                                  }
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 20),
                                                      () {
                                                    customLoadStop();
                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                        Icons.bookmark_add_outlined,
                                        size: 30,
                                        color: Colors.white)),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showAppbar = !showAppbar;
                                      });
                                    },
                                    icon: showAppbar
                                        ? const Icon(
                                            Icons.fullscreen_outlined,
                                            color: Colors.white,
                                            size: 35,
                                          )
                                        : const Icon(
                                            Icons.fullscreen_exit,
                                            color: Colors.white,
                                            size: 35,
                                          ))
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
          );
        }));
  }
}
