import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/stats_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/request/add_request_letter_screen.dart';
import 'package:schoolworkspro_app/Screens/request/addrequest_screen.dart';
import 'package:schoolworkspro_app/Screens/request/request_view_model.dart';
import 'package:schoolworkspro_app/constants/colors.dart';

class AddRequestTabScreen extends StatefulWidget {
  const AddRequestTabScreen({Key? key}) : super(key: key);

  @override
  State<AddRequestTabScreen> createState() => _AddRequestTabScreenState();
}

class _AddRequestTabScreenState extends State<AddRequestTabScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            bottom: const TabBar(
              indicatorColor: logoTheme,
              indicatorWeight: 4.0,
              isScrollable: true,
              tabs: [
                Tab(
                  child: Text(
                    'Add Request',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    'Add Request Letter',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Addrequestscreen(
              showAppbar: false,
              isFromRoutine: false,
              isUpdate: false,
            ),
            AddRequestLetterScreen(),
          ],
        ),
      ),
    );
  }
}
