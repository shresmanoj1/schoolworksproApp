import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/admin/dashboard/myrequest_admin.dart';
import 'package:schoolworkspro_app/Screens/admin/request_detail/addrequest_screen.dart';
import 'package:schoolworkspro_app/Screens/admin/request_detail/adminrequestdetail_screen.dart';
import 'package:schoolworkspro_app/Screens/login/login.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/routine/routine_principal_screen.dart';
import 'package:schoolworkspro_app/Screens/splash/splashscreen.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/api/repositories/switch_repo.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/switch_request.dart';
import 'package:schoolworkspro_app/response/admin/adminrequest_response.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:schoolworkspro_app/services/admin/getassignedrequest_service.dart';
import 'package:schoolworkspro_app/services/authenticateduser_service.dart';
import 'package:schoolworkspro_app/services/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/app_image.dart';
import '../../../response/admin/adminmyrequest_response.dart';
import '../../../services/admin/getmyrequestadmin_service.dart';
import '../../prinicpal/news and announcement/newsannouncent_screen.dart';

class DashboardAdminscreen extends StatefulWidget {
  const DashboardAdminscreen({Key? key}) : super(key: key);

  @override
  _DashboardAdminscreenState createState() => _DashboardAdminscreenState();
}

class _DashboardAdminscreenState extends State<DashboardAdminscreen> {
  User? user;

  // Stream<AdminRequestResponse>? admin_response;
  Future<AdminMyRequestResponse>? res;
  int myRequest = 0;

  String ? selected_role;
  @override
  void initState() {
    // TODO: implement initState

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
    selected_role = user?.type.toString();
    final dataas = await MyRequestAdminService().myticketAdmin();
    setState(() {
      myRequest = dataas.requests!.length;
    });

    // admin_response =
    //     AssignedRequestService().getRefreshAssignedTickets(const Duration(seconds: 2),user!.username.toString());
    // final data = await AssignedRequestService().getAssignedTickets(user!.username.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ChangeNotifierProvider<Authenticateduserservice>(
              create: (context) => Authenticateduserservice(),
              child: Consumer<Authenticateduserservice>(
                  builder: (context, provider, child) {
                // provider.getAuthentication(context);
                if (provider.data?.user == null) {
                  provider.getAuthentication(context);
                  return const Center(
                      child: VerticalLoader(

                  ));
                }

                return Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Stack(children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: CircleAvatar(
                                radius: 18,
                                backgroundColor:
                                provider.data!.user!.userImage ==
                                    null
                                    ? Colors.grey
                                    : Colors.white,
                                child: provider.data!.user!
                                    .userImage ==
                                    null
                                    ? Text(
                                  provider.data!.user!
                                      .firstname![0]
                                      .toUpperCase() +
                                      "" +
                                      provider.data!.user!
                                          .lastname![0]
                                          .toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight:
                                      FontWeight.bold,
                                      color: Colors.white),
                                )
                                    : ClipOval(
                                  child: Image.network(
                                    api_url2 +
                                        '/uploads/users/' +
                                        provider.data!.user!
                                            .userImage!,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ),
                        ),

                      ]),
                    ),
                    Expanded(
                      flex: 8,
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              provider.data!.user!.firstname == null
                                  ? const Text("")
                                  : Text(
                                provider.data!.user!.firstname
                                    .toString() +
                                    " " +
                                    provider
                                        .data!.user!.lastname
                                        .toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: const Icon(
                                      Icons.mail_outline,
                                      size: 21,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10),
                                      child: provider.data?.user
                                          ?.email ==
                                          null
                                          ? const Text(" ")
                                          : Text(
                                          provider
                                              .data!.user!.email
                                              .toString(),
                                          style: const TextStyle(
                                              fontWeight:
                                              FontWeight
                                                  .bold)),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Image.asset(
                                      "assets/icons/institution.png",
                                      height: 22,
                                      width: 22,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, top: 3),
                                      child: provider.data!.user!
                                          .institution ==
                                          null
                                          ? const Text("")
                                          : Text(
                                        provider.data!.user!
                                            .institution
                                            .toString(),
                                        style: const TextStyle(
                                            fontWeight:
                                            FontWeight
                                                .bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Expanded(
                              //         flex: 1,
                              //         child: Icon(Icons.people)
                              //     ),
                              //     Expanded(
                              //       flex: 10,
                              //       child: Padding(
                              //           padding: const EdgeInsets.only(
                              //               left: 10.0, top: 3),
                              //           child: Container(
                              //             width: 120,
                              //             child: user!.roles!.isEmpty ? Text(user!.type.toString()) :
                              //             DropdownButton(
                              //               style: const TextStyle(color: Colors.black, fontSize: 14),
                              //               isExpanded: true,
                              //               // decoration: const InputDecoration(
                              //               //   border: InputBorder.none,
                              //               //   filled: true,
                              //               //   hintText: 'Select role',
                              //               // ),
                              //               icon: const Icon(Icons.arrow_drop_down_outlined),
                              //               items: user?.roles!.map((pt) {
                              //                 return DropdownMenuItem(
                              //                   value: pt,
                              //                   child: Text(
                              //                     pt,
                              //                     style: const TextStyle(
                              //                         color: Colors.black, fontSize: 14),
                              //                     overflow: TextOverflow.ellipsis,
                              //                   ),
                              //                 );
                              //               }).toList(),
                              //               onChanged: (newVal) async {
                              //                 setState(() {
                              //                   selected_role = newVal as String?;
                              //                 });
                              //
                              //                 final req = SwitchRequest(type: selected_role);
                              //                 final ress = await SwitchRepo().
                              //                 switchrole(req);
                              //                 if (ress.success == true) {
                              //                   final SharedPreferences localStorage =
                              //                   await SharedPreferences.getInstance();
                              //                   localStorage.setString(
                              //                       "token", ress.token.toString());
                              //                   localStorage.setString(
                              //                       "_auth_", jsonEncode(ress.user));
                              //                   Navigator.pushReplacement(
                              //                       context,
                              //                       MaterialPageRoute(
                              //                         builder: (context) => Splashscreen(),
                              //                       ));
                              //                   Fluttertoast.showToast(
                              //                       msg: "Role switched to ${selected_role}");
                              //                 } else {
                              //                   Fluttertoast.showToast(
                              //                       msg: "Failed switching role to ${selected_role}");
                              //                 }
                              //
                              //               },
                              //               value: selected_role,
                              //             ),
                              //           )
                              //       ),
                              //     ),
                              //   ],
                              // ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              })),
          ChangeNotifierProvider<AssignedRequestService>(
              create: (context) => AssignedRequestService(),
              child: Consumer<AssignedRequestService>(
                  builder: (context, provider, child) {
                provider.getassignedrequest(context, user?.username.toString());
                if (provider.data?.requests == null) {
                  provider.getassignedrequest(
                      context, user?.username.toString());
                  return const Center(
                      child: VerticalLoader(
                  ));
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // crossAxisAlignment: CrossAxisAlignment.,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Tickets Resolved',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Builder(builder: (context) {
                                      int count = 0;
                                      for (int i = 0;
                                          i < provider.data!.requests!.length;
                                          i++)
                                        if (provider.data!.requests![i]
                                                ['status'] ==
                                            "Resolved") count++;

                                      return CircularPercentIndicator(
                                        radius: 80.0,
                                        lineWidth: 10.0,
                                        percent: (count /
                                            provider.data!.requests!.length),
                                        center: Builder(
                                          builder: (context) {
                                            int count = 0;
                                            for (int i = 0;
                                                i <
                                                    provider
                                                        .data!.requests!.length;
                                                i++)
                                              if (provider.data!.requests![i]
                                                      ['status'] ==
                                                  "Resolved") count++;

                                            return Text(count.toString() +
                                                "/" +
                                                provider.data!.requests!.length
                                                    .toString());
                                          },
                                        ),
                                        progressColor: Colors.green,
                                        animationDuration: 100,
                                        animateFromLastPercent: true,
                                        arcType: ArcType.FULL,
                                        arcBackgroundColor: Colors.black12,
                                        backgroundColor: Colors.white,
                                        animation: true,
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                      );
                                    }),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddRequestAdminScreen(),
                                    ));
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green),
                              ),
                              child: const Text('Create new request')),
                        )),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green),
                              ),
                              child:
                                  Text("My Request"),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AdminMyRequestScreen(),
                                    ));
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdminRequestDetailScreen(
                                            title: "Request"),
                                  ));
                            },
                            child: Card(
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/tickets-ticket.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    const Text(
                                      'Request',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Builder(
                                      builder: (context) {
                                        try {
                                          return Text(provider
                                              .data!.requests!.length
                                              .toString());
                                        } catch (e) {
                                          return const Text("0");
                                        }
                                      },
                                    )
                                  ],
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdminRequestDetailScreen(
                                            title: "Complain"),
                                  ));
                            },
                            child: Card(
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/complain.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    Text(
                                      'Complain',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Builder(
                                      builder: (context) {
                                        int count = 0;
                                        for (int i = 0;
                                            i < provider.data!.requests!.length;
                                            i++)
                                          if (provider.data!.requests![i]
                                                  ['subject'] ==
                                              "Complain") count++;

                                        return Text(count.toString());
                                      },
                                    ),
                                  ],
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdminRequestDetailScreen(
                                            title: "Leave"),
                                  ));
                            },
                            child: Card(
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/leave.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    Text(
                                      'Leave',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Builder(
                                      builder: (context) {
                                        int count = 0;
                                        for (int i = 0;
                                            i < provider.data!.requests!.length;
                                            i++)
                                          if (provider.data!.requests![i]
                                                  ['subject'] ==
                                              "Leave") count++;

                                        return Text(count.toString());
                                      },
                                    ),
                                  ],
                                )),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (context) =>
                          //               AdminRequestDetailScreen(
                          //                   title: "New Feature"),
                          //         ));
                          //   },
                          //   child: Card(
                          //       color: Colors.white,
                          //       child: Column(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         crossAxisAlignment: CrossAxisAlignment.center,
                          //         children: [
                          //           Image.asset(
                          //             'assets/icons/feature.png',
                          //             height: 30,
                          //             width: 30,
                          //           ),
                          //           Text(
                          //             'Feature',
                          //             style: TextStyle(fontSize: 12),
                          //           ),
                          //           Builder(
                          //             builder: (context) {
                          //               int count = 0;
                          //               for (int i = 0;
                          //                   i < provider.data!.requests!.length;
                          //                   i++)
                          //                 if (provider.data!.requests![i]
                          //                         ['subject'] ==
                          //                     "New Feature") count++;
                          //
                          //               return Text(count.toString());
                          //             },
                          //           ),
                          //         ],
                          //       )),
                          // ),
                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (context) =>
                          //               AdminRequestDetailScreen(
                          //                   title: "New Deployment"),
                          //         ));
                          //   },
                          //   child: Card(
                          //       color: Colors.white,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.center,
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           Image.asset(
                          //             'assets/icons/deployment.png',
                          //             height: 30,
                          //             width: 30,
                          //           ),
                          //           const Text(
                          //             'Deployment',
                          //             style: TextStyle(fontSize: 12),
                          //           ),
                          //
                          //           // provider.data.requests.map((e) => Text(e['subject'] == "New Deployment").length.toString())
                          //
                          //           Builder(
                          //             builder: (context) {
                          //               int count = 0;
                          //               for (int i = 0;
                          //                   i < provider.data!.requests!.length;
                          //                   i++)
                          //                 if (provider.data!.requests![i]
                          //                         ['subject'] ==
                          //                     "New Deployment") count++;
                          //
                          //               return Text(count.toString());
                          //             },
                          //           ),
                          //
                          //           // if (list[i]['subject'] == element) {
                          //           // count++;
                          //           // }
                          //           // }
                          //           // Text(countOccurrencesUsingLoop(
                          //           //         provider.data!.requests!,
                          //           //         "New Deployment")
                          //           //     .toString())
                          //           // Builder(builder: (context) {
                          //           //   int count = 0;
                          //           //   for(int i = 0;i<provider.data!.requests!.length;i++)
                          //           //     if(provider.data!.requests![i]['subject'] == "New Deployment")
                          //           //       count++;
                          //           //
                          //           //     return count;
                          //           // },)
                          //
                          //           // Text(provider.data!.requests!.contains("New Deployment").toString())
                          //         ],
                          //       )),
                          // ),
                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (context) =>
                          //               AdminRequestDetailScreen(
                          //                   title: "Upgrade"),
                          //         ));
                          //   },
                          //   child: Card(
                          //       color: Colors.white,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.center,
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           Image.asset(
                          //             'assets/icons/upgrade.png',
                          //             height: 30,
                          //             width: 30,
                          //           ),
                          //           Text(
                          //             'Upgrade',
                          //             style: TextStyle(fontSize: 12),
                          //           ),
                          //           Builder(
                          //             builder: (context) {
                          //               int count = 0;
                          //               for (int i = 0;
                          //                   i < provider.data!.requests!.length;
                          //                   i++)
                          //                 if (provider.data!.requests![i]
                          //                         ['subject'] ==
                          //                     "Upgrade") count++;
                          //
                          //               return Text(count.toString());
                          //             },
                          //           ),
                          //         ],
                          //       )),
                          // ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdminRequestDetailScreen(
                                            title: "General Enquiry"),
                                  ));
                            },
                            child: Card(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/enquiry.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    Text(
                                      'Enquires',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Builder(
                                      builder: (context) {
                                        int count = 0;
                                        for (int i = 0;
                                            i < provider.data!.requests!.length;
                                            i++)
                                          if (provider.data!.requests![i]
                                                  ['subject'] ==
                                              "General Enquiry") count++;

                                        return Text(count.toString());
                                      },
                                    ),
                                  ],
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdminRequestDetailScreen(
                                            title: "Meetings"),
                                  ));
                            },
                            child: Card(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/meeting.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    Text(
                                      'Meetings',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Builder(
                                      builder: (context) {
                                        int count = 0;
                                        for (int i = 0;
                                            i < provider.data!.requests!.length;
                                            i++)
                                          if (provider.data!.requests![i]
                                                  ['subject'] ==
                                              "Meetings") count++;

                                        return Text(count.toString());
                                      },
                                    ),
                                  ],
                                )),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (context) =>
                          //               AdminRequestDetailScreen(
                          //                   title: "Others"),
                          //         ));
                          //   },
                          //   child: Card(
                          //       color: Colors.white,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.center,
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           Image.asset(
                          //             'assets/icons/other.png',
                          //             height: 30,
                          //             width: 30,
                          //           ),
                          //           Text(
                          //             'Others',
                          //             style: TextStyle(fontSize: 12),
                          //           ),
                          //           Builder(
                          //             builder: (context) {
                          //               int count = 0;
                          //               for (int i = 0;
                          //                   i < provider.data!.requests!.length;
                          //                   i++)
                          //                 if (provider.data!.requests![i]
                          //                         ['subject'] ==
                          //                     "Others") count++;
                          //
                          //               return Text(count.toString());
                          //             },
                          //           ),
                          //         ],
                          //       )),
                          // ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: RoutinePrincipal(),
                                      type: PageTransitionType.leftToRight));
                            },
                            child: Card(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      studentDashboardRoutine,
                                      height: 30,
                                      width: 30,
                                    ),
                                    Text(
                                      'Routines',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                )),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: NewsAnnouncmentScreen(),
                                      type: PageTransitionType.leftToRight));
                            },
                            child: Card(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/budget.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    const Text(
                                      'News & Announcement',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                )),
                          ),
                        ]),
                  ],
                );
              })),
        ],
      ),
    );
  }

  int countOccurrencesUsingLoop(List<dynamic> list, String element) {
    if (list == null || list.isEmpty) {
      return 0;
    }

    int count = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i]['subject'] == element) {
        count++;
      }
    }

    return count;
  }
}
