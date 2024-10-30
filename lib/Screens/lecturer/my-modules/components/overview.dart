import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/activities.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/drafts.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/lecturer_collaboration_screen.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/more.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/resources.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/lecturer_lecturer/lecturer_lecturer.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import '../../../../config/api_response_config.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/text_style.dart';
import '../../../../response/authenticateduser_response.dart';
import '../../../my_learning/homework/assignment_screen.dart';
import '../../../my_learning/homework/assignment_tab_screen.dart';
import '../../../my_learning/learning_view_model.dart';
import '../../../student/module/my_study_material_screen.dart';
import '../../lecturer_common_view_model.dart';
import 'more_component/view_homework_screen.dart';

class OverViewScreen extends StatefulWidget {
  final modulSlug;
  final int tabIndex ;
  // final title;
  const OverViewScreen({Key? key, required this.modulSlug, required this.tabIndex}) : super(key: key);

  @override
  _OverViewScreenState createState() => _OverViewScreenState();
}

class _OverViewScreenState extends State<OverViewScreen>
    with TickerProviderStateMixin {
  int? experience;
  late LecturerCommonViewModel _provider;
  late LearningViewModel _learningViewModel;
  late CommonViewModel _provider2;
  User? user;
  late TabController tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    tabController = TabController(
      initialIndex: 0,
      length: widget.tabIndex,
      vsync: this,
    );
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      dynamic data = {
        "lecturerEmail": user?.email.toString(),
        "moduleSlug": widget.modulSlug
      };
      _provider = Provider.of<LecturerCommonViewModel>(context, listen: false);
      _provider2 = Provider.of<CommonViewModel>(context, listen: false);
      _provider.fetchModuleDetails(data);
      _learningViewModel =
          Provider.of<LearningViewModel>(context, listen: false);
      _learningViewModel.fetchAverageRating(widget.modulSlug);
      _learningViewModel.fetchMyStudyMaterial(widget.modulSlug);
      _learningViewModel.fetchLessonWeekCategory(widget.modulSlug);
      _provider2.setSlug(widget.modulSlug);
      _provider2.fetchBatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LecturerCommonViewModel, LearningViewModel>(
        builder: (context, snapshot, learning, child) {
          return Scaffold(
            // backgroundColor: const Color(0xffeef4fb),
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: logoTheme,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(125),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: isLoading(snapshot.modulesApiResponse) ||
                            isLoading(learning.averageRatingApiResponse)
                            ? GFShimmer(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Module Title",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: RatingBar.builder(
                                  initialRating:
                                  learning.averageRating == null
                                      ? 0
                                      : learning.averageRating!,
                                  direction: Axis.horizontal,
                                  tapOnlyMode: false,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  unratedColor: Colors.white,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    // print(rating);
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                snapshot.modules['moduleTitle'] ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: RatingBar.builder(
                                initialRating: learning.averageRating == null
                                    ? 0
                                    : learning.averageRating!,
                                direction: Axis.horizontal,
                                tapOnlyMode: false,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 20,
                                unratedColor: Colors.white,
                                itemPadding: const EdgeInsets.symmetric(
                                    horizontal: 2.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  // print(rating);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: white,
                                ),
                                onPressed: () {
                                  var index = tabController.index - 1;
                                  if (index >= 0) {
                                    tabController.animateTo(index);
                                  }
                                },
                              )),
                          Expanded(
                            flex: 10,
                            child: TabBar(
                              indicatorSize: TabBarIndicatorSize.label,
                              labelColor: logoTheme,
                              controller: tabController,
                              labelStyle: p15.copyWith(fontWeight: FontWeight.w800),
                              unselectedLabelColor: white,
                              labelPadding:
                              const EdgeInsets.symmetric(horizontal: 5),
                              unselectedLabelStyle: p15.copyWith(color: white),
                              indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: white),
                              isScrollable: true,
                              onTap: (value) {
                                setState(() {
                                  selectedIndex = value;
                                });

                                // print(selectedIndex);
                              },
                              tabs: [
                                const Tab(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Overview"),
                                  ),
                                ),
                                const Tab(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Resources"),
                                  ),
                                ),
                                const Tab(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Teaching Materials"),
                                  ),
                                ),
                                const Tab(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Tasks"),
                                  ),
                                ),
                                const Tab(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Drafts"),
                                  ),
                                ),
                                const Tab(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Assignment"),
                                  ),
                                ),
                                if (snapshot.institutionName == "School")
                                  const Tab(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Digital Diary"),
                                    ),
                                  ),
                                if(snapshot.institutionName == "softwarica")
                                  const Tab(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Collaboration"),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: white,
                                ),
                                onPressed: () {
                                  var index = tabController.index + 1;
                                  if (index < 5) {
                                    tabController.animateTo(index);
                                  }
                                },
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: isLoading(snapshot.modulesApiResponse)
                ? const Center(child: CupertinoActivityIndicator())
                : TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  snapshot.modules == null
                      ? Image.asset("assets/images/no_content.PNG")
                      : Container(
                    color: const Color(0xffeef4fb),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10),
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Builder(builder: (context) {
                          var extension = snapshot.modules['imageUrl']
                              .split(".")
                              .last;

                          return extension == "svg"
                              ? SvgPicture.network(
                            '$api_url2/uploads/modules/' +
                                snapshot.modules['imageUrl'],
                            height: 200,
                            width:
                            MediaQuery.of(context).size.width,
                          )
                              : Image.network(
                            '$api_url2/uploads/modules/' +
                                snapshot.modules['imageUrl'],
                            height: 200,
                            width:
                            MediaQuery.of(context).size.width,
                          );
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                        snapshot.modules['moduleLeader']
                        ['firstname'] ==
                            null ||
                            snapshot.modules['moduleLeader']
                            ['lastname'] ==
                                null ||
                            snapshot.modules['moduleLeader']
                            ['email'] ==
                                null
                            ? const SizedBox()
                            : Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius:
                              BorderRadius.circular(10)),
                          child: ListTile(
                            title: Text(
                              snapshot.modules['moduleLeader']
                              ['firstname'] +
                                  " " +
                                  snapshot.modules['moduleLeader']
                                  ['lastname'],
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0),
                                  child: Row(
                                    children: <Widget>[
                                      const Icon(
                                        Icons.email,
                                        size: 18,
                                        color: black,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          snapshot.modules[
                                          'moduleLeader']
                                          ['email'],
                                          style:
                                          const TextStyle(
                                              fontSize: 13,
                                              fontWeight:
                                              FontWeight
                                                  .bold,
                                              color: black)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.timelapse_sharp,
                                        size: 18,
                                        color: black,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Builder(builder: (context) {
                                        var datas = snapshot
                                            .modules[
                                        'moduleLeader']
                                        ['joinDate'];
                                        DateTime joinedDate =
                                        DateTime.parse(
                                            datas.toString());
                                        joinedDate.add(
                                            const Duration(
                                                hours: 5,
                                                minutes: 45));

                                        var now = DateTime.now();

                                        experience = now.year -
                                            joinedDate.year;

                                        return Text(
                                            "Exp. $experience Years",
                                            style:
                                            const TextStyle(
                                                fontSize: 13,
                                                fontWeight:
                                                FontWeight
                                                    .bold,
                                                color:
                                                black));
                                      }),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Overview",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // Html(data:  snapshot.modules['moduleDesc'],),

                                Html(
                                  style: {
                                    "ol": Style(
                                        margin: const EdgeInsets.all(5),
                                        textAlign: TextAlign.justify),
                                  },
                                  shrinkWrap: true,
                                  data: snapshot.modules['moduleDesc'],
                                  customRender: {
                                    "table": (context, child) {
                                      return SingleChildScrollView(
                                        scrollDirection:
                                        Axis.horizontal,
                                        child: (context.tree
                                        as TableLayoutElement)
                                            .toWidget(context),
                                      );
                                    }
                                  },
                                  onLinkTap: (String? url,
                                      RenderContext context,
                                      Map<String, String> attributes,
                                      dom.Element? element) {
                                    Future<void> _launchInBrowser(
                                        Uri url) async {
                                      if (await launchUrl(
                                        url,
                                        mode: LaunchMode
                                            .externalApplication,
                                      )) {
                                        throw 'Could not launch $url';
                                      }
                                    }

                                    var linkUrl =
                                    url!.replaceAll(" ", "%20");
                                    _launchInBrowser(
                                        Uri.parse(linkUrl));
                                  },
                                  onImageTap: (String? url,
                                      RenderContext context,
                                      Map<String, String> attributes,
                                      dom.Element? element) {
                                    launch(url!);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "What you'II learn",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Html(
                                  style: {
                                    "ol": Style(
                                        margin: const EdgeInsets.all(5),
                                        textAlign: TextAlign.justify),
                                  },
                                  shrinkWrap: true,
                                  data: snapshot.modules['benefits'],
                                  customRender: {
                                    "table": (context, child) {
                                      return SingleChildScrollView(
                                        scrollDirection:
                                        Axis.horizontal,
                                        child: (context.tree
                                        as TableLayoutElement)
                                            .toWidget(context),
                                      );
                                    }
                                  },
                                  onLinkTap: (String? url,
                                      RenderContext context,
                                      Map<String, String> attributes,
                                      dom.Element? element) {
                                    Future<void> _launchInBrowser(
                                        Uri url) async {
                                      if (await launchUrl(
                                        url,
                                        mode: LaunchMode
                                            .externalApplication,
                                      )) {
                                        throw 'Could not launch $url';
                                      }
                                    }

                                    var linkUrl =
                                    url!.replaceAll(" ", "%20");
                                    _launchInBrowser(
                                        Uri.parse(linkUrl));
                                  },
                                  onImageTap: (String? url,
                                      RenderContext context,
                                      Map<String, String> attributes,
                                      dom.Element? element) {
                                    launch(url!);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                      ],
                    ),
                  ),
                  ResourcesScreen(
                    data: snapshot.modules,
                  ),
                  MyStudyMaterialScreen(
                      week: learning.myStudyMaterial.weeks != null &&
                          learning.myStudyMaterial.weeks!.isNotEmpty
                          ? learning.myStudyMaterial.weeks!.length
                          : 0,
                      isTeacher: true),
                  ActivitiesScreen(
                    data: snapshot.modules,
                  ),
                  DraftScreen(data: snapshot.modules),
                  AssignmentScreen(
                    moduleSlug: snapshot.modules['moduleSlug'],
                    isTeacher: user?.type == "Student" ? false : true,
                  ),
                  if (snapshot.institutionName == "School")
                    ViewHomeworkScreen(
                        moduleSlug: snapshot.modules['moduleSlug'],
                        moduleTitle: snapshot.modules['moduleTitle']),
                  if(snapshot.institutionName == "softwarica")
                    LecturerCollaborationScreen(moduleId: snapshot.modules["_id"].toString())
                ]),
          );
        });
  }
}
