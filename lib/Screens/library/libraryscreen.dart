import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/library/digital_library_screen.dart';
import 'package:schoolworkspro_app/constants/app_image.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:schoolworkspro_app/response/authenticateduser_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/fonts.dart';
import '../../constants/text_style.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../physical_library/issue_book.dart';
import '../physical_library/library_view_model.dart';
import '../physical_library/physical_library.dart';

class LibraryScreen extends StatefulWidget {
  LibraryScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;
  ScrollPhysics _physics = const ClampingScrollPhysics();
  late LibraryViewModel _libraryViewModel;
  final TextEditingController _search = TextEditingController();
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // _libraryViewModel = Provider.of<LibraryViewModel>(context, listen: false);
      // _libraryViewModel.fetchDigitalBooks();
      // _libraryViewModel.fetchAllBooks();
    });
    print("init state called");
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
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
  }

  Future<void> loadMore() async {
    print("LOAD MORE::::::");
    if (_libraryViewModel.bookName.isEmpty ||
        _libraryViewModel.bookName == "") {
      if (pageIndex == 0) {
        await _libraryViewModel.loadMoreDigitalBooks();
      } else {
        await _libraryViewModel.loadMore();
      }
    } else {
      print("PAGE INDEX::::$pageIndex");
      await _libraryViewModel.loadMoreSearchBooks(pageIndex);
    }
  }

  double getHeight() {
    return 600;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Consumer<LibraryViewModel>(builder: (context, snapshot, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              centerTitle: false,
              title: const Text('Library',
                  style: TextStyle(color: white, fontWeight: FontWeight.w800)),
              elevation: 0.0,
              iconTheme: const IconThemeData(
                color: white,
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(55),
                child: Builder(builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TabBar(
                      indicatorColor: logoTheme,
                      indicatorWeight: 4.0,
                      isScrollable: true,
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      unselectedLabelColor: white,
                      labelColor: const Color(0xff004D96),
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: p1),
                      indicator: const BoxDecoration(
                        border: Border(),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                        color: white,
                      ),
                      onTap: (value) {
                        setState(() {
                          snapshot.updateBookName('');
                          _search.clear();
                          pageIndex = value;
                        });
                      },
                      tabs: const [
                        Tab(
                          text: "E-Books",
                        ),
                        Tab(
                          text: "Physical LIbrary Books",
                        ),
                      ],
                    ),
                  );
                }),
              ),
              backgroundColor: logoTheme),
          body: Column(
            children: const [
              Expanded(
                child: TabBarView(physics: ScrollPhysics(), children: [
                  DigitalLibraryScreen(),
                  Physicallibraryscreen()
                ]),
              ),
            ],
          ),
        );
      }),
    );
  }
}
