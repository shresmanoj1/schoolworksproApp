import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/lecturer/lecturer_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/components/overview.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/view_student/view_students.dart';
import 'package:schoolworkspro_app/components/internetcheck.dart';
import 'package:schoolworkspro_app/components/nointernet_widget.dart';
import 'package:schoolworkspro_app/response/lecturer/findbyemail_response.dart';
import 'package:schoolworkspro_app/response/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolworkspro_app/response/lecturer/lecturer_course_with_module_response.dart';
import '../../../api/api.dart';
import '../../../components/shimmer.dart';
import '../../../config/api_response_config.dart';
import '../../../constants/colors.dart';

class Mymodulelecturer extends StatefulWidget {
  const Mymodulelecturer({Key? key}) : super(key: key);

  @override
  _MymodulelecturerState createState() => _MymodulelecturerState();
}

class _MymodulelecturerState extends State<Mymodulelecturer> {
  late User user;
  TextEditingController _searchController = TextEditingController();
  List<Module> _list = [];
  List<Module> _listForDisplay = [];
  List<String> courseNameList = [];
  String courseCount = "";

  @override
  void initState() {
    super.initState();
    getData();
    checkInternet();
  }

  Future<void> getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }

  void checkInternet() async {
    bool isConnected = await internetCheck();
    setState(() {
      connected = isConnected;
    });
    if (isConnected) {
      fetchCourseWithModules();
    }
  }

  bool connected = true;

  Future<void> fetchCourseWithModules() async {
    final lecturerState =
        Provider.of<LecturerCommonViewModel>(context, listen: false);
    handleRefresh(lecturerState);
  }

  Future<void> handleRefresh(LecturerCommonViewModel lecturerState) async {
    try {
      _list.clear();
      _listForDisplay.clear();
      courseNameList.clear();
      courseNameList.add("All");
      if (lecturerState.courseWithModule.data?.course != null ||
          lecturerState.courseWithModule.data!.course!.isNotEmpty) {
        for (var courseData in lecturerState.courseWithModule.data!.course!) {
          if (courseData.modules != null) {
            _list.addAll(courseData.modules!);
          }
          if (courseData.courseName != null &&
              !courseNameList.contains(courseData.courseName.toString())) {
            courseNameList.add(courseData.courseName.toString());
          }
        }
        setState(() {
          _listForDisplay = _list;
        });
      }
    } catch (error) {
      _listForDisplay = [];
      courseNameList = [];
      print("Error occurred: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LecturerCommonViewModel>(
        builder: (context, lecturerState, child) {
      return Scaffold(
          body: connected == false
              ? const NoInternetWidget()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: InkWell(
                                child: TextField(
                                  controller: _searchController,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: const InputDecoration(
                                    fillColor: white,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    alignLabelWithHint: true,
                                    // border: InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: grey_400,
                                    )),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: grey_400)),
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: grey_400)),
                                    hintText: "Search By Title",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    suffixIcon: Icon(
                                      Icons.search,
                                      color: black,
                                    ),
                                  ),
                                  onSubmitted: (value) {},
                                  onChanged: (text) {
                                    setState(() {
                                      _listForDisplay = _list.where((list) {
                                        var itemName =
                                            list.moduleTitle?.toLowerCase();
                                        return itemName!.contains(text);
                                      }).toList();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: DropdownSearch<String>(
                        dropdownSearchDecoration: const InputDecoration(
                          fillColor: white,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          alignLabelWithHint: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: grey_400,
                          )),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: grey_400)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: grey_400)),
                          hintText: "Sort By Course Name",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        showSearchBox: true,
                        maxHeight: MediaQuery.of(context).size.height / 1.7,
                        items: courseNameList.map<String>((pt) {
                          return pt.toString();
                        }).toList(),
                        mode: Mode.BOTTOM_SHEET,
                        onChanged: (newVal) {
                          if (newVal == "All") {
                            setState(() {
                              _listForDisplay = _list;
                              courseCount = _listForDisplay.length.toString();
                            });
                          } else {
                            var courseList =
                                lecturerState.courseWithModule.data!.course!;
                            var course = courseList.firstWhere(
                              (course) => course.courseName == newVal,
                            );

                            setState(() {
                              courseCount = course.modules!.length.toString();
                              _listForDisplay = course.modules ?? [];
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    courseCount == ""
                        ? Container()
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "(${courseCount.toString()} Subject/Modules)",
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                    Expanded(
                      child: isLoading(
                              lecturerState.courseWithModuleApiResponse)
                          ? const MultipleVerticalLoader()
                          : isComplete(
                                  lecturerState.courseWithModuleApiResponse)
                              ? RefreshIndicator(
                                  onRefresh: () async {
                                    await lecturerState.fetchCourseWithModules(
                                        user.email.toString());
                                    await handleRefresh(lecturerState);
                                  },
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      return _listItem(index, lecturerState);
                                    },
                                    itemCount: _listForDisplay.length,
                                  ),
                                )
                              : const Center(child: Text("No Module Found")),
                    )
                  ],
                ));
    });
  }

  _listItem(index, LecturerCommonViewModel lecturerState) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ) // changes position of shadow
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                _listForDisplay[index].moduleTitle.toString(),
                // ['moduleTitle'],
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 3,
                    child: _listForDisplay[index].imageUrl?.split(".").last ==
                            "svg"
                        ? SvgPicture.network(
                            '$api_url2/uploads/modules/${_listForDisplay[index].imageUrl}')
                        : Image.network(
                            '$api_url2/uploads/modules/${_listForDisplay[index].imageUrl}'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewStudents(
                                        module_slug:
                                            _listForDisplay[index].moduleSlug,
                                        module_title:
                                            _listForDisplay[index].moduleSlug,
                                      )),
                            );
                          },
                          child: Container(
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color(0xffCF407F),
                            ),
                            child: const Center(
                                child: Text(
                              'View Student',
                              style: TextStyle(color: white, fontSize: 15),
                            )),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OverViewScreen(
                                        tabIndex: lecturerState.tabIndex,
                                        modulSlug:
                                            _listForDisplay[index].moduleSlug.toString(),
                                      )),
                            );
                          },
                          child: Container(
                            height: 40,
                            decoration: const BoxDecoration(
                              color: logoTheme,
                            ),
                            child: const Center(
                                child: Text(
                              'Go to Module',
                              style: TextStyle(color: white, fontSize: 15),
                            )),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
