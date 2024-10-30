import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/Screens/parents/More_parent/parent_request/view_parentrequest/assign_to_request.dart';
import 'package:schoolworkspro_app/Screens/parents/More_parent/parent_request/view_parentrequest/view_parentrequestscreen.dart';

import '../../../../request/AssignedTicketScreen.dart';

class ParentRequestTab extends StatefulWidget {
  final bool showAppBar;
  const ParentRequestTab({Key? key, this.showAppBar = false}) : super(key: key);

  @override
  State<ParentRequestTab> createState() => _ParentRequestTabState();
}

class _ParentRequestTabState extends State<ParentRequestTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: widget.showAppBar == true
              ? const Size.fromHeight(100.0)
              : const Size.fromHeight(50.0),
          child: AppBar(
            centerTitle: true,
            title: widget.showAppBar == true
                ? const Text(
                    'My request',
                    style: TextStyle(color: Colors.black),
                  )
                : const SizedBox(),
            automaticallyImplyLeading: true,
            elevation: 0.0,
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            bottom: const TabBar(
              isScrollable: true,
              // labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
              tabs: [
                Tab(
                  child: Text(
                    'Pending',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    'In Progress',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    'Resolved',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    'Assigned To Me',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Viewparentrequestscreen(requestName: 'Pending'),
            Viewparentrequestscreen(requestName: 'Approved'),
            Viewparentrequestscreen(requestName: 'Resolved'),
            if (widget.showAppBar == false)
              const AssignedTicketScreen()
            else const ParentAssignedToRequest(),
          ],
        ),
      ),
    );
  }
}
