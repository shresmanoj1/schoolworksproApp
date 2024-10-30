import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/stats_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/request/add_request_tab_screen.dart';
import 'package:schoolworkspro_app/Screens/request/request_letter_screen.dart';
import 'package:schoolworkspro_app/Screens/request/request_view_model.dart';
import 'package:schoolworkspro_app/Screens/ticket/viewticketscreen.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../parents/More_parent/parent_request/view_parentrequest/parent_request_tab.dart';

class RequestTabScreen extends StatefulWidget {
  const RequestTabScreen({Key? key}) : super(key: key);

  @override
  State<RequestTabScreen> createState() => _RequestTabScreenState();
}

class _RequestTabScreenState extends State<RequestTabScreen> {
  late StatsCommonViewModel _provider;
  late RequestViewModel _provider2;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<StatsCommonViewModel>(context, listen: false);
      _provider2 = Provider.of<RequestViewModel>(context, listen: false);
      _provider.fetchCertificateNames();
      _provider2.fetchparentRequest();
      _provider2.fetchRequestLetter();
      _provider2.fetchMyTicket();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBar(
                centerTitle: false,
                title: const Text("Request",
                    style: TextStyle(
                        color: white, fontWeight: FontWeight.w800)),
                elevation: 0.0,
                iconTheme: const IconThemeData(
                  color: white,
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(
                      55),
                  child: Builder(builder: (context) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: TabBar(
                        indicatorColor: logoTheme,
                        indicatorWeight: 4.0,
                        isScrollable: true,
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        unselectedLabelColor: white,
                        labelColor: Color(0xff004D96),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: p1),
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
                            text: "Create Request",
                          ),
                          Tab(
                            text: "My Request",
                          ),
                          Tab(
                            text: "Tickets",
                          ),
                          Tab(
                            text: "Request Letter",
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                backgroundColor: logoTheme),

            // AppBar(
            //     elevation: 0.0,
            //     title: const Text(
            //       "My Request",
            //       style: TextStyle(color: Colors.black),
            //     ),
            //     iconTheme: const IconThemeData(
            //       color: Colors.black, //change your color here
            //     ),
            //     backgroundColor: Colors.white),
            body: const TabBarView(children: [
              AddRequestTabScreen(),
              ParentRequestTab(),
              Ticketscreen(),
              RequestLetterScreen()
            ])));
  }
}
