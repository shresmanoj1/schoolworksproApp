import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/my_learning/learning_view_model.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/api_response_config.dart';
import '../../../constants/text_style.dart';

class MyStudyMaterialScreen extends StatefulWidget {
  final int? week;
  final bool isTeacher;
  const MyStudyMaterialScreen(
      {Key? key, required this.week, required this.isTeacher})
      : super(key: key);

  @override
  State<MyStudyMaterialScreen> createState() => _MyStudyMaterialScreenState();
}

class _MyStudyMaterialScreenState extends State<MyStudyMaterialScreen> {
  List<bool> _isExpandedList = <bool>[];

  @override
  void initState() {
    _isExpandedList = List.generate(widget.week ?? 0, (index) => false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LearningViewModel>(builder: (context, snapshot, child) {
      return Container(
        color: white,
        child: isLoading(snapshot.myStudyMaterialApiResponse)
            ? const Center(child: CupertinoActivityIndicator())
            : snapshot.myStudyMaterial.weeks == null ||
                    snapshot.myStudyMaterial.weeks!.isEmpty
                ? Image.asset("assets/images/no_content.PNG")
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.isTeacher
                              ? "Teaching Material"
                              : "Study Material",
                          style: p16.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      ...List.generate(snapshot.myStudyMaterial.weeks!.length,
                          (index) {
                        var datas = snapshot.myStudyMaterial.weeks![index];

                        return Column(
                          children: [
                            Theme(
                              data: ThemeData()
                                  .copyWith(dividerColor: Colors.transparent),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: grey_400)),
                                  child: ExpansionTile(
                                      trailing: _isExpandedList[index]
                                          ? const Icon(
                                              Icons.remove,
                                              color: grey_600,
                                            )
                                          : const Icon(
                                              Icons.add,
                                              color: grey_600,
                                            ),
                                      onExpansionChanged: (isExpanded) {
                                        setState(() {
                                          _isExpandedList[index] = isExpanded;
                                          for (int i = 0;
                                              i < _isExpandedList.length;
                                              i++) {
                                            if (i != index) {
                                              _isExpandedList[i] = false;
                                            }
                                          }
                                        });
                                      },
                                      maintainState: true,
                                      title: Text(
                                        "Week ${datas.week}",
                                        style:
                                            p15.copyWith(color: Colors.black),
                                      ),
                                      children: List.generate(
                                          datas.files!.length, (i) {
                                        var index = i + 1;
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Icon(
                                                        Icons
                                                            .play_arrow_outlined,
                                                        color: Colors.grey,
                                                        size: 20),
                                                    Expanded(
                                                      child: Text(
                                                          "$index   ${datas.files![i].filename}",
                                                          style: p14.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    ),
                                                  ],
                                                ),
                                                onTap: () {
                                                  String url =
                                                      "https://api.schoolworkspro.com/uploads/files/${datas.files![i].filename}";

                                                  _launchInBrowser(
                                                      Uri.parse(url));

                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //       builder: (context) =>
                                                  //       MyStudyMaterialDetailsScreen(filename: datas.files![i].filename,)),
                                                  // );
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      })),
                                ),
                              ),
                            )
                          ],
                        );
                      })
                    ],
                  ),
      );
    });
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
