import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/dashboard/prinicipal_dashboard.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/navigation/drawer.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/request/fcm_request.dart';
import 'package:schoolworkspro_app/services/lecturer/punch_service.dart';
import 'package:schoolworkspro_app/services/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../response/login_response.dart';
import '../../../services/notification_navigate_service.dart';
import '../principal_common_view_model.dart';

class NavigationPrincipal extends StatefulWidget {
  NavigationPrincipal({
    Key? key,
  }) : super(key: key);

  @override
  _NavigationPrincipalState createState() => _NavigationPrincipalState();
}

class _NavigationPrincipalState extends State<NavigationPrincipal> {
  String _title = 'Home';

  String _scanBarcode = 'Unknown';
  PageController _pageController = PageController();
  int _selectedIndex = 0;
  bool connected = false;
  User? user;
  late PrinicpalCommonViewModel _provider;
  late LecturerCommonViewModel _provider2;

  @override
  void initState() {
    // TODO: implement initState

    // getCompletedLesson();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      NotificationRoute.NavigationNavigateService(context);

      _provider = Provider.of<PrinicpalCommonViewModel>(context, listen: false);
      _provider2 = Provider.of<LecturerCommonViewModel>(context, listen: false);

      _provider.fetchMyPermissions();
      _provider2.fetchRoutinePreference();
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

    sharedPreferences.setBool("changedToAdmin", true);

    try {
      FirebaseMessaging.instance.getToken().then((value) async {
        String? token = value;
        print("fcm: " + token.toString());
        final data = FcmTokenRequest(
            username: user?.username.toString(),
            batch: user?.batch.toString(),
            type: user?.type.toString(),
            institution: user?.institution.toString(),
            token: token.toString());
        final res = await LoginService().postFCM(data);
        if (res.success == true) {
          print("FCM token registered");
        } else {
          print("Error registering FCM token");
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



  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: DrawerPrinicpal(),
      body: PrincipalDashboardScreen(),
    );
  }
}
