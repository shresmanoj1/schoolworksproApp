import 'dart:convert';import 'package:cached_network_image/cached_network_image.dart';import 'package:flutter/material.dart';import 'package:provider/provider.dart';import 'package:schoolworkspro_app/Screens/student/careers/career_view_model.dart';import 'package:schoolworkspro_app/components/shimmer.dart';import '../../../api/api.dart';import '../../../config/api_response_config.dart';import '../../../constants/colors.dart';import '../../../response/all_job_response.dart';class CurrentOpeningScreen extends StatefulWidget {  const CurrentOpeningScreen({Key? key}) : super(key: key);  @override  State<CurrentOpeningScreen> createState() =>      _CurrentOpeningScreenState();}class _CurrentOpeningScreenState extends State<CurrentOpeningScreen> {  late CareerViewModel _provider;  TextEditingController searchJobController = TextEditingController();  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();  @override  void initState() {    _provider = Provider.of<CareerViewModel>(context, listen: false);    refreshPage(provider: _provider);    super.initState();  }  Future<void> refreshPage(      {required CareerViewModel provider}) async {    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {      provider.fetchAllJob("1", {});    });  }  bool savedJob = false;  // bool partTime = false;  // bool fullTime = false;  // bool flexible = false;  //  // bool highSchool = false;  // bool vocationalCourse = false;  // bool bachelorDegree = false;  // bool masterDegree = false;  //  // bool experience = false;  List<String> jobTypeList = [];  List<String> educationList = [];  List<String> experienceList = [];  // List selectedIndexes = [];  Map<String, int> experienceObj = {};  List checkListItems = [    {      "id": 0,      "value": false,      "title": "Under 1 Year",    },    {      "id": 1,      "value": false,      "title": "1-2 Year",    },    {      "id": 2,      "value": false,      "title": "2-6 Year",    },    {      "id": 3,      "value": false,      "title": "Over 6 Year",    },  ];  List jobTypeItems = [    {"value": "Part-Time", "title": "Part Time", "select": false},    {"value": "Full-Time", "title": "Full Time", "select": false},    {"value": "Flexible-Time", "title": "Flexible", "select": false},  ];  List educationItems = [    {"value": "high-school", "title": "High School", "select": false},    {      "value": "vocational",      "title": "Vocational Course",      "select": false    },    {      "value": "bachelors",      "title": "Bachelor's Degree",      "select": false    },    {"value": "masters", "title": "Master's Degree", "select": false},  ];  @override  Widget build(BuildContext context) {    return Consumer<CareerViewModel>(        builder: (context, career, child) {      return Scaffold(          key: _scaffoldKey,          drawer: Drawer(            child: ListView(              padding: EdgeInsets.zero,              children: [                ListTile(                  title: const Text(                    'Filters',                    style: TextStyle(                        fontSize: 18, fontWeight: FontWeight.w600),                  ),                  trailing: InkWell(                      onTap: () {                        Navigator.pop(context);                      },                      child: const Icon(Icons.close)),                ),                Row(                  children: [                    Checkbox(                      value: savedJob,                      onChanged: (value) {                        setState(() {                          savedJob = value!;                          if (value) {                            career.fetchAllJob(                                "1", {"showSaved": savedJob});                          } else if (!value) {                            career.fetchAllJob("1", {});                          }                        });                      },                    ),                    const Text("Show Saved Jobs")                  ],                ),                ExpansionTile(                  maintainState: true,                  textColor: Colors.black,                  leading: const Icon(                    Icons.work,                  ),                  trailing: const Icon(                    Icons.keyboard_arrow_down,                    color: Colors.black,                  ),                  title: const Text(                    'Job Type',                    style: TextStyle(                        color: Colors.black,                        fontWeight: FontWeight.bold,                        fontSize: 16),                  ),                  children: [                    ...List.generate(                      jobTypeItems.length,                      (index) => CheckboxListTile(                        controlAffinity:                            ListTileControlAffinity.leading,                        contentPadding: EdgeInsets.zero,                        dense: true,                        title: Text(                          jobTypeItems[index]["title"],                          style: const TextStyle(                            fontSize: 16.0,                            color: Colors.black,                          ),                        ),                        value: jobTypeItems[index]["select"],                        onChanged: (value) {                          setState(() {                            jobTypeItems[index]["select"] = value;                            if (jobTypeItems[index]["select"]) {                              jobTypeList                                  .add(jobTypeItems[index]["value"]);                            } else if (!jobTypeItems[index]                                ["select"]) {                              jobTypeList.remove(                                  jobTypeItems[index]["value"]);                            }                          });                        },                      ),                    ),                  ],                ),                ExpansionTile(                  maintainState: true,                  textColor: Colors.black,                  leading: const Icon(                    Icons.star,                  ),                  trailing: const Icon(                    Icons.keyboard_arrow_down,                    color: Colors.black,                  ),                  title: const Text(                    'Experience',                    style: TextStyle(                        color: Colors.black,                        fontWeight: FontWeight.bold,                        fontSize: 16),                  ),                  children: [                    ...List.generate(                      checkListItems.length,                      (index) => CheckboxListTile(                        controlAffinity:                            ListTileControlAffinity.leading,                        contentPadding: EdgeInsets.zero,                        dense: true,                        title: Text(                          checkListItems[index]["title"],                          style: const TextStyle(                            fontSize: 16.0,                            color: Colors.black,                          ),                        ),                        value: checkListItems[index]["value"],                        onChanged: (value) {                          setState(() {                            for (var element in checkListItems) {                              element["value"] = false;                            }                            checkListItems[index]["value"] = value;                            if (checkListItems[index]["id"] == 3) {                              experienceObj = {'greaterThanEqual': 6};                            } else if (checkListItems[index]["id"] ==                                2) {                              experienceObj = {                                'greaterThanEqual': 2,                                'lessThanEqual': 6                              };                            } else if (checkListItems[index]["id"] ==                                1) {                              experienceObj = {                                'greaterThanEqual': 1,                                'lessThanEqual': 2                              };                            } else if (checkListItems[index]["id"] ==                                0) {                              experienceObj = {                                'greaterThanEqual': 0,                                'lessThanEqual': 1                              };                            }                          });                        },                      ),                    ),                  ],                ),                ExpansionTile(                  maintainState: true,                  textColor: Colors.black,                  leading: const Icon(                    Icons.school,                  ),                  trailing: const Icon(                    Icons.keyboard_arrow_down,                    color: Colors.black,                  ),                  title: const Text(                    'Education',                    style: TextStyle(                        color: Colors.black,                        fontWeight: FontWeight.bold,                        fontSize: 16),                  ),                  children: [                    ...List.generate(                      educationItems.length,                      (index) => CheckboxListTile(                        controlAffinity:                            ListTileControlAffinity.leading,                        contentPadding: EdgeInsets.zero,                        dense: true,                        title: Text(                          educationItems[index]["title"],                          style: const TextStyle(                            fontSize: 16.0,                            color: Colors.black,                          ),                        ),                        value: educationItems[index]["select"],                        onChanged: (value) {                          setState(() {                            educationItems[index]["select"] = value;                            if (educationItems[index]["select"]) {                              educationList.add(                                  educationItems[index]["value"]);                            } else if (!educationItems[index]                                ["select"]) {                              educationList.remove(                                  educationItems[index]["value"]);                            }                          });                        },                      ),                    ),                  ],                ),                const SizedBox(                  height: 10,                ),                Row(                  mainAxisAlignment: MainAxisAlignment.center,                  children: [                    InkWell(                        onTap: () {                          career.fetchAllJob("1", {                            "jobType": jobTypeList,                            "experience": experienceObj,                            "education": educationList                          });                          // experienceObj = {};                        },                        child: Container(                          width: 80,                          padding: const EdgeInsets.symmetric(                              vertical: 10, horizontal: 10),                          decoration: BoxDecoration(                              color: Colors.blueAccent,                              borderRadius: BorderRadius.circular(5)),                          child: const Center(                              child: Text(                            "Apply",                            style: TextStyle(color: Colors.white),                          )),                        )),                    const SizedBox(                      width: 10,                    ),                    InkWell(                        onTap: () {                          setState(() {                            for (var element in jobTypeItems) {                              element["select"] = false;                            }                            for (var element in educationItems) {                              element["select"] = false;                            }                            for (var element in checkListItems) {                              element["value"] = false;                            }                            jobTypeList.clear();                            educationList.clear();                            experienceObj = {};                          });                        },                        child: Container(                          width: 80,                          padding: const EdgeInsets.symmetric(                              vertical: 10, horizontal: 10),                          decoration: BoxDecoration(                              color: Colors.redAccent,                              borderRadius: BorderRadius.circular(5)),                          child: const Center(                              child: Text(                            "Clear",                            style: TextStyle(color: Colors.white),                          )),                        )),                    const  SizedBox(                      height: 20,                    ),                  ],                ),                const SizedBox(                  height: 50,                ),              ],            ),          ),          body: RefreshIndicator(            onRefresh: () => refreshPage(provider: career),            child: ListView(              shrinkWrap: true,              padding: const EdgeInsets.symmetric(                  horizontal: 10, vertical: 10),              children: [                const SizedBox(                  height: 5,                ),                Row(                  children: [                    Flexible(                        child: Container(                      height: 45,                      decoration: BoxDecoration(                        color: Colors.grey[100],                        borderRadius: BorderRadius.circular(4),                      ),                      child: InkWell(                        child: TextField(                          controller: searchJobController,                          textAlignVertical: TextAlignVertical.center,                          decoration: const InputDecoration(                            fillColor: white,                            contentPadding:                                EdgeInsets.symmetric(vertical: 5),                            alignLabelWithHint: true,                            // border: InputBorder.none,                            enabledBorder: OutlineInputBorder(                                borderSide: BorderSide(color: grey_400, )),                            focusedBorder: OutlineInputBorder(                                borderSide: BorderSide(color: grey_400)),                           border: OutlineInputBorder(                                borderSide: BorderSide(color: grey_400)),                            hintText: "Search by job title",                            hintStyle: TextStyle(color: Colors.grey),                            prefixIcon: Icon(                              Icons.search,                              color: Colors.grey,                            ),                          ),                          onSubmitted: (value) {                            career.fetchAllJob(                                "1", {"jobTitle": value});                          },                        ),                      ),                    )),                    const SizedBox(                      width: 5,                    ),                    InkWell(                      onTap: () {                        print("DRAWER::::");                        // Scaffold.of(context).openDrawer();                        _scaffoldKey.currentState!.openDrawer();                      },                      child: Container(                          padding: const EdgeInsets.symmetric(                              horizontal: 10, vertical: 10),                          decoration: BoxDecoration(                            borderRadius: BorderRadius.circular(5),                            color: logoTheme,                          ),                          child: const Icon(                            Icons.filter_alt,                            color: Colors.white,                          )),                    )                  ],                ),                const SizedBox(                  height: 10,                ),                isLoading(career.allJobApiResponse)                    ? const VerticalLoader()                    : career.allJobs.allJobs == null ||                            career.allJobs.allJobs!.isEmpty                        ? Column(                            children: [                              Image.asset(                                  "assets/images/no_job_opening.png"),                            ],                          )                        : ListView.builder(                            physics: const ScrollPhysics(),                            shrinkWrap: true,                            itemCount: career.allJobs.allJobs!.length,                            itemBuilder: (context, index) {                              return _buildJobCard(                                  career.allJobs.allJobs![index]);                            }),              ],            ),          ));    });  }  Widget _buildJobCard(AllJob value) {    return Padding(      padding: const EdgeInsets.symmetric(vertical: 3),      child: InkWell(          onTap: () {            Navigator.of(context).pushNamed('/jobDetailScreen',                arguments: value.slug.toString());          },          child: Card(            elevation: 3,            child: Column(              crossAxisAlignment: CrossAxisAlignment.start,              children: [                Container(                  padding: const EdgeInsets.symmetric(                      horizontal: 5, vertical: 10),                  height: 91,                  decoration: BoxDecoration(                      borderRadius: BorderRadius.circular(6)),                  child: Row(                    mainAxisAlignment: MainAxisAlignment.start,                    crossAxisAlignment: CrossAxisAlignment.start,                    children: [                      Container(                          decoration: BoxDecoration(                            border: Border.all(color: Colors.grey),                            borderRadius: BorderRadius.circular(6),                          ),                          child: ClipRRect(                              borderRadius: BorderRadius.circular(10),                              child: CachedNetworkImage(                                  fit: BoxFit.contain,                                  imageUrl:                                      "$api_url2/uploads/institutions/${value.organization!                                              .footerLogo}",                                  height: 70,                                  width: 70,                                  placeholder: (context, url) =>                                      const Center(                                          child:                                              CircularProgressIndicator()),                                  errorWidget:                                      (context, url, error) =>                                          const Icon(Icons.error)))),                      const SizedBox(                        width: 5,                      ),                      Column(                        mainAxisAlignment: MainAxisAlignment.start,                        crossAxisAlignment: CrossAxisAlignment.start,                        children: [                          Expanded(                              child: Text(                            value.jobTitle.toString(),                            style: const TextStyle(                                fontWeight: FontWeight.bold,                                fontSize: 16,                                color: Color(0xff001DB4)),                          )),                          Expanded(                            child: Text(                              value.organization!.name.toString(),                              style: const TextStyle(                                fontWeight: FontWeight.bold,                                fontSize: 14,                              ),                              maxLines: 2,                            ),                          ),                          Expanded(                            child: Text(                              value.organization!.address.toString(),                            ),                          ),                        ],                      ),                    ],                  ),                ),                const Divider(),                Padding(                  padding: const EdgeInsets.symmetric(                      vertical: 0, horizontal: 5),                  child: Text(                    value.info.toString(),                    maxLines: 2,                    overflow: TextOverflow.ellipsis,                    style: const TextStyle(color: Colors.grey),                  ),                ),                Row(                  children: [                    _buildJobType(value.employmentType.toString()),                    _buildJobType(value.jobLevel.toString())                  ],                ),              ],            ),          )),    );  }  Widget _buildJobType(String title) {    return Padding(      padding:          const EdgeInsets.symmetric(horizontal: 5, vertical: 10),      child: Container(        decoration: const BoxDecoration(          color: Colors.red,          borderRadius: BorderRadius.all(            Radius.circular(6),          ),        ),        child: Padding(          padding: const EdgeInsets.symmetric(            horizontal: 6,            vertical: 2,          ),          child: Text(            title.toString(),            style: const TextStyle(                fontWeight: FontWeight.bold,                fontSize: 14,                color: Colors.white),          ),        ),      ),    );  }}