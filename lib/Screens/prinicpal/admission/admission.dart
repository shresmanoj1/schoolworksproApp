import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/admission/addadmission_screen.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/admission/admission_detail.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/principal_common_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';

import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../lecturer/admission/advisor_screen.dart';

class AdvisorScreen extends StatefulWidget {
  const AdvisorScreen({Key? key}) : super(key: key);

  @override
  _AdvisorScreenState createState() => _AdvisorScreenState();
}

class _AdvisorScreenState extends State<AdvisorScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PrinicpalCommonViewModel>(context, listen: false)
          .fetchadvisor();
    });

    super.initState();
  }

  Future<void> _handleRefresh() async {
    await Provider.of<PrinicpalCommonViewModel>(context, listen: false)
        .fetchadvisor();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PrinicpalCommonViewModel>(builder: (context, value, child) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: const Text(
                "Enquiries/Admission",
              ),
              bottom:  TabBar(
                physics: NeverScrollableScrollPhysics(),
                indicatorWeight: 4.0,
                isScrollable: false,
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                labelColor: Colors.white,
                indicatorColor: white,
                unselectedLabelColor: Colors.white.withOpacity(0.6),
                labelStyle:
                    TextStyle(fontWeight: FontWeight.w500, fontSize: p1),
                tabs: [
                  Tab(
                    text: "View Advisor",
                  ),
                  Tab(
                    text: "New Admission",
                  ),
                ],
              ),
            ),
            body: TabBarView(children: [
              RefreshIndicator(
                onRefresh: _handleRefresh,
                child: isLoading(value.advisorApiResponse)
                    ? const Center(
                        child: CupertinoActivityIndicator()
                      )
                    : ListView(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: value.advisor.length,
                              physics: const ScrollPhysics(),
                              itemBuilder: (context, index) {
                                var datas = value.advisor[index];
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        datas.admission == null
                                            ? const SizedBox()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Chip(
                                                    backgroundColor:
                                                        datas.admission ==
                                                                "Admitted"
                                                            ? Colors.green
                                                            : Colors.orange,
                                                    label: Text(
                                                      datas.admission
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    )),
                                              ),
                                        ListTile(
                                          trailing: IconButton(
                                            icon: const Icon(Icons.visibility),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      child:
                                                          AdvisorDetailScreen(
                                                              value: datas),
                                                      type: PageTransitionType
                                                          .leftToRight));
                                            },
                                          ),
                                          title: Builder(builder: (context) {
                                            var name =
                                                "${datas.firstName} ${datas.lastName}";
                                            return RichText(
                                              text: TextSpan(
                                                text: 'Name: ',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: name,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                          subtitle: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Email: ',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: datas.email ?? "",
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'course: ',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: datas.course
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Contact: ',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: datas.contact
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Grade/Percentage: ',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: datas.percentage ==
                                                              null
                                                          ? "n/a"
                                                          : datas.percentage
                                                              .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                          const SizedBox(
                            height: 80,
                          )
                        ],
                      ),
              ),
              const LecturerAdvisorScreen(
                showAppBar: false,
              )
            ])),
      );
    });
  }
}
