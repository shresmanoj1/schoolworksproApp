import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/Morelecturer/student_stats/stats_screen.dart';
import 'package:schoolworkspro_app/Screens/physical_library/issue_book.dart';
import 'package:schoolworkspro_app/Screens/physical_library/library_view_model.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/physicalbook_response.dart';
import 'package:schoolworkspro_app/services/physicalbook_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../config/api_response_config.dart';
import '../../constants/colors.dart';
import '../../response/authenticateduser_response.dart';

class Physicallibraryscreen extends StatefulWidget {
  const Physicallibraryscreen({
    Key? key,
  }) : super(key: key);

  @override
  _PhysicallibraryscreenState createState() => _PhysicallibraryscreenState();
}

class _PhysicallibraryscreenState extends State<Physicallibraryscreen> {

  late LibraryViewModel _libraryViewModel;
  ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;
  ScrollPhysics _physics = ClampingScrollPhysics();
  final TextEditingController _search = TextEditingController();
  int pageIndex = 1;
  User? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _libraryViewModel = Provider.of<LibraryViewModel>(context, listen: false);
    });
    print("init state called");
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
    await _libraryViewModel.loadMore();
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
    return Consumer<LibraryViewModel>(builder: (context, datas, child) {
      return ListView(
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
              SizedBox(height: 10,),
              const Text(
                "Explore thousand of E-Books under E-Library and learn without boundaries",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: grey_600,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 10,),
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
                              disabledBorder:
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
                        datas.updateBookName(
                            _search.text);
                        datas.updateSearchPage(1);
                        datas
                            .searchBooks(pageIndex);
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)), color: logoTheme,),
                          height: getHeight() * (1 / 12.5),

                          child: Center(child: Text("Search", style: TextStyle(color: white, fontWeight: FontWeight.w600),))),
                    ),
                  ],
                ),
              )
            ],
          ),
          isLoading(datas.allBooksApiResponse)
              ? const CupertinoActivityIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: datas.allBooks.length,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: grey_300)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // https://file.schoolworkspro.com/schoolworkspro/public/uploads/books/Multidisciplinarity%20and%20Interdisciplinarity%20in%20Health.pdf?AWSAccessKeyId=xizsCkdgyVpWg3xh&Expires=1710327197&Signature=0S6vXLcetRMSfFqap%2BgqBjCuC58%3D
                                    // https://file.schoolworkspro.com/schoolworkspro/public/uploads/books/Multidisciplinarity%20and%20Interdisciplinarity%20in%20Health.pdf
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl:
                                              "${api_url2}/uploads/library/${datas.allBooks[index]['thumbnail']}",
                                          placeholder: (context, url) => Container(
                                              child: const Center(
                                                  child:
                                                      CupertinoActivityIndicator())),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            datas.allBooks[index]['name'],
                                            style: TextStyle(
                                                color: black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            "by ${datas.allBooks[index]['author']}",
                                            style: TextStyle(
                                                color: grey_400, fontSize: 12),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          RichText(
                                            text: TextSpan(
                                                text: 'Category:  ',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                    color: black),
                                                children: [
                                                  TextSpan(
                                                    text: datas.allBooks[index][
                                                                    'category'] ==
                                                                null ||
                                                            datas
                                                                .allBooks[index]
                                                                    ['category']
                                                                .isEmpty
                                                        ? "N/A"
                                                        : datas.allBooks[index]
                                                                ['category']
                                                                ['name']
                                                            .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: black),
                                                  ),
                                                ]),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          RichText(
                                            text: TextSpan(
                                                text: 'Quantity:  ',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                    color: black),
                                                children: [
                                                  TextSpan(
                                                    text: datas.allBooks[index]
                                                            ['quantity']
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: black),
                                                  ),
                                                ]),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6.0,
                                                        vertical: 4.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: datas.allBooks[index]
                                                              ['quantity'] ==
                                                          0
                                                      ? Colors.grey
                                                      : Color(0xff006400),
                                                ),
                                                child: Text(
                                                  datas.allBooks[index]
                                                              ['quantity'] ==
                                                          0
                                                      ? "Not Available"
                                                      : "Available",
                                                  style: TextStyle(
                                                      color: white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14),
                                                ),
                                              ),
                                              datas.allBooks[index]
                                                          ['quantity'] ==
                                                      0
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Container(
                                                        color: Colors.grey,
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  6.0),
                                                          child: Icon(
                                                            Icons.shopping_cart,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            PageTransition(
                                                                child: IssueBook(
                                                                    data: datas
                                                                            .allBooks[
                                                                        index]),
                                                                type: PageTransitionType
                                                                    .rightToLeftWithFade));
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Container(
                                                          color: logoTheme,
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    6.0),
                                                            child: Icon(
                                                              Icons
                                                                  .shopping_cart,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          );
                        }),
                    isLoadingOnly(datas.loadMoreApiResponse)
                        ? const Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          )
                        : datas.hasMore
                            ? const SizedBox(
                                height: 100,
                              )
                            : const Center(
                                child: Text("End of section"),
                              )
                  ],
                ),
        ],
      );
    });
  }

// List<dynamic> getListElements() {
//   var items = List<dynamic>.generate(
//       _listForDisplay.length, (counter) => _listForDisplay[counter]);
//   return items;
// }
//
// Widget getListView(LibraryViewModel datas) {
//   var listItems = getListElements();
//   var listview = ListView(
//     physics: BouncingScrollPhysics(),
//     shrinkWrap: true,
//     controller: _scrollController,
//     children: [
//       ListView.builder(
//       shrinkWrap: true,
//       itemCount: listItems.length,
//       physics: const ScrollPhysics(),
//       itemBuilder: (context, index) {
//         return Card(
//             child: Column(
//               children: [
//                 GFListTile(
//                   title: Text(listItems[index]['name']),
//                   subTitle: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       RichText(
//                         text: TextSpan(
//                             text: 'Author: ',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, color: Colors.black),
//                             children: [
//                               TextSpan(
//                                 text: listItems[index]['author'],
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     color: Colors.black),
//                               ),
//                             ]),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       RichText(
//                         text: TextSpan(
//                             text: 'Available quantity: ',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, color: Colors.black),
//                             children: [
//                               TextSpan(
//                                 text: listItems[index]['quantity'].toString(),
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     color: Colors.black),
//                               ),
//                             ]),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       listItems[index]['category'] == null ||
//                           listItems[index]['category'].isEmpty
//                           ? const Chip(
//                         label: Text(
//                           "No category",
//                           style:
//                           TextStyle(color: Colors.white, fontSize: 12),
//                         ),
//                         elevation: 0.0,
//                         backgroundColor: Colors.black,
//                       )
//                           : Chip(
//                         label: Text(
//                           listItems[index]['category']['name'],
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 12),
//                         ),
//                         elevation: 0.0,
//                         backgroundColor: Colors.black,
//                       ),
//                       Row(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                             child: RichText(
//                               text: TextSpan(
//                                   text: 'Quantity: ',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black),
//                                   children: [
//                                     TextSpan(
//                                       text:
//                                       listItems[index]['quantity'].toString(),
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.normal,
//                                           color: Colors.black),
//                                     ),
//                                   ]),
//                             ),
//                           ),
//                           listItems[index]['quantity'] == 0
//                               ? ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Container(
//                               color: Colors.grey,
//                               child: const Padding(
//                                 padding: EdgeInsets.all(6.0),
//                                 child: Icon(
//                                   Icons.shopping_cart,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           )
//                               : InkWell(
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   PageTransition(
//                                       child:  IssueBook(data: listItems[index]),
//                                       type: PageTransitionType.rightToLeftWithFade));
//
//
//                             },
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: Container(
//                                 color: Colors.green,
//                                 child: const Padding(
//                                   padding: EdgeInsets.all(6.0),
//                                   child: Icon(
//                                     Icons.shopping_cart,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ));
//       }),
//       isLoadingOnly(datas.loadMoreApiResponse)
//           ? const Padding(
//         padding: EdgeInsets.all(10),
//         child: Center(
//           child: CircularProgressIndicator(),
//         ),
//       )
//           : datas.hasMore
//           ? const SizedBox(
//         height: 100,
//       )
//           : const Center(
//         child: Text("End of section"),
//       )
//   ],);
//   return listview;
// }
}
