import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/driver/Dashboard-driver/dashboard_driver.dart';
import 'package:schoolworkspro_app/Screens/driver/Event-driver/event_driver.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/fcm_request.dart';
import 'package:schoolworkspro_app/services/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../response/login_response.dart';

class NavigationDriver extends StatefulWidget {
  const NavigationDriver({Key? key}) : super(key: key);

  @override
  State<NavigationDriver> createState() => _NavigationDriverState();
}

class _NavigationDriverState extends State<NavigationDriver> {
  PageController pagecontroller = PageController();
  int selectedIndex = 0;
  String title = 'Home';
  User? user;

  late CommonViewModel _provider;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<CommonViewModel>(context, listen: false);
      _provider.getAuthenticatedUser();
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
    try {
      FirebaseMessaging.instance.getToken().then((value) async {
        String? token = value;
        // print("fcm: " + token.toString());
        final data = FcmTokenRequest(
            username: user?.username.toString(),
            batch: user?.batch.toString(),
            type: user?.type.toString(),
            institution: user?.institution.toString(),
            token: token.toString());
        final res = await LoginService().postFCM(data);
        if (res.success == true) {
          // print("FCM token registered");
        } else {
          // print("Error registering FCM token");
        }
      });
    } on Exception catch (e) {
      snackThis(
          content: Text(e.toString()),
          color: Colors.red,
          behavior: SnackBarBehavior.fixed,
          duration: 2,
          context: context);
      // TODO
    }
  }

  _onPageChanged(int index) {
    // onTap
    setState(() {
      selectedIndex = index;
      switch (index) {
        case 0:
          {
            title = 'Home';
          }
          break;
        case 1:
          {
            title = 'Events';
          }
          break;

          break;
      }
    });
  }

  _itemTapped(int selectedIndex) {
    pagecontroller.jumpToPage(selectedIndex);
    setState(() {
      this.selectedIndex = selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (selectedIndex == 0) {
          // Navigator.of(context).pushReplacementNamed(NavigationDriver.routeName);
          Navigator.of(context).popUntil((route) => route.isFirst);
          return Future.value(false);
        } else {
          _itemTapped(0);
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        body: PageView(
          controller: pagecontroller,
          children: <Widget>[
            DashboardDriver(),
            EventDriverScreen(),
            // Accountscreen()
          ],
          onPageChanged: _onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: _itemTapped,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard,
                  color: selectedIndex == 0 ? kPrimaryColor : Colors.grey),
              label: 'Home',
              backgroundColor: selectedIndex == 0 ? kPrimaryColor : Colors.grey,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event,
                  color: selectedIndex == 1 ? kPrimaryColor : Colors.grey),
              label: 'Events',
              backgroundColor: selectedIndex == 1 ? kPrimaryColor : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
