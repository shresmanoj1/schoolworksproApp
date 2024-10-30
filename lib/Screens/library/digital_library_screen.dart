import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/library/book_view_screen.dart';
import 'package:schoolworkspro_app/Screens/physical_library/library_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/text_style.dart';
import '../../response/authenticateduser_response.dart';

class DigitalLibraryScreen extends StatefulWidget {
  const DigitalLibraryScreen({Key? key}) : super(key: key);

  @override
  State<DigitalLibraryScreen> createState() => _DigitalLibraryScreenState();
}

class _DigitalLibraryScreenState extends State<DigitalLibraryScreen> {
// instantiate the controller in your state
//   final NumberPaginatorController _controller = NumberPaginatorController();
  late LibraryViewModel _libraryViewModel;
  bool _showBackToTopButton = false;
  ScrollPhysics _physics = ClampingScrollPhysics();
  ScrollController _scrollController = ScrollController();
  final TextEditingController _search = TextEditingController();
  int pageIndex = 0;
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _libraryViewModel = Provider.of<LibraryViewModel>(context, listen: false);
      // _libraryViewModel.fetchDigitalBooks();
    });
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          print("LOADIN MORE::::");
          loadMore();
        }
        setState(() {
          if (_scrollController.offset >= 300) {
            _showBackToTopButton = true; // show the back-to-top button
          } else {
            _showBackToTopButton = false; // hide the back-to-top button
          }
          if (_scrollController.position.pixels <= 60) {
            _physics = const BouncingScrollPhysics();
          } else {
            _physics = const ClampingScrollPhysics();
          }
        });
      });
    getData();
    super.initState();
  }
  Future<void> loadMore() async {
    print("LOAD MORE::::::");
    await _libraryViewModel.loadMoreDigitalBooks();
  }

  Future<void> onRefresh() async {
    await _libraryViewModel.fetchDigitalBooks();
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

  double getHeight() {
    return 600;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryViewModel>(builder: (context, value, child) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          controller: _scrollController,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Welcome To ${user?.institution} E-Library",
                  style: const TextStyle(
                      color: Color(0xff001930),
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10,),
                const Text(
                  "Explore thousand of E-Books under E-Library and learn without boundaries",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: grey_600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, top: 20, bottom: 10, right: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                            height: getHeight() * (1 / 11),
                            width: double.infinity,
                            child: TextFormField(
                              onChanged: (value) {
                                if(value.isEmpty){
                                  _libraryViewModel.fetchDigitalBooks();
                                  _libraryViewModel.fetchAllBooks();
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: "Search book by Name",
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                focusedBorder:
                                OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey), borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))),
                                enabledBorder:
                                OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey), borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))),
                                border:
                                OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey), borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))),
                              ),
                              controller: _search,
                            )
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          print("PAGE INDEX:::$pageIndex");
                          value.updateBookName(
                              _search.text);
                          value.updateSearchPage(1);
                          value
                              .searchBooks(pageIndex);
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: getHeight() * (1 / 12.5),
                            decoration: const BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)), color: logoTheme,),
                            child: const Center(child: Text("Search", style: TextStyle(color: white, fontWeight: FontWeight.w600),))),
                      ),
                    ],
                  ),
                )
              ],
            ),
            isLoading(value.digitalBookApiResponse)
                ? const CupertinoActivityIndicator()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),

                    // gridDelegate:
                    //     const SliverGridDelegateWithMaxCrossAxisExtent(
                    //         maxCrossAxisExtent: 200,
                    //         childAspectRatio: 3 / 2,
                    //         crossAxisSpacing: 8,
                    //         mainAxisSpacing: 8),
                    itemCount: value.digitalBooks.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return InkWell(
                        onTap: () {
                          value.generateBookToken(value.digitalBooks[index]['_id']);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookViewScreen(
                                    page: 1,
                                    file:
                                        value.digitalBooks[index]['file'] ?? "",
                                    book_id: value.digitalBooks[index]["_id"]),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    value.digitalBooks[index]['name'] ?? "",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: p14.copyWith(
                                      fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.black),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                      child: value.digitalBooks[index]
                                                  ['category'] ==
                                              null
                                          ? const Text(
                                              "n/a",
                                              style: TextStyle(
                                                  color: white, fontSize: 12),
                                            )
                                          : Text(
                                              value.digitalBooks[index]
                                                      ['category']['name'] ??
                                                  "",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
            isLoadingOnly(value.loadMoreDigitalApiResponse)
                ? Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: const SizedBox(
                        height: 50,
                        child: Center(child: CupertinoActivityIndicator())))
                : const SizedBox(
                    height: 50,
                  ),
          ],
        ),
      );
    });
  }
}
