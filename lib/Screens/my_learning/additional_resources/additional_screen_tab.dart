import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/my_learning/additional_resources/additional_resources_view_model.dart';
import 'package:schoolworkspro_app/Screens/my_learning/learning_view_model.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/text_style.dart';
import 'books_screen.dart';

class AdditionalScreenTab extends StatefulWidget {
  String? lessonSlug;
  AdditionalScreenTab({Key? key, this.lessonSlug}) : super(key: key);

  @override
  State<AdditionalScreenTab> createState() => _AdditionalScreenTabState();
}

class _AdditionalScreenTabState extends State<AdditionalScreenTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Consumer<AdditionalResourcesViewModel>(
          builder: (context, snapshot, child) {
        return Column(
          children: [
            TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: white,
                isScrollable: true,
                padding: const EdgeInsets.all(8),
                indicatorPadding: const EdgeInsets.all(8),
                labelPadding: const EdgeInsets.all(5),
                indicator: const BoxDecoration(color: Colors.transparent),
                // labelStyle: p15.copyWith(fontWeight: FontWeight.w800),
                unselectedLabelColor: logoTheme,
                unselectedLabelStyle: p15.copyWith(color: logoTheme),
                onTap: (int value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
                labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                tabs: [
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          color: selectedIndex == 0 ? logoTheme : grey_200,
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Youtube"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          color: selectedIndex == 1 ? logoTheme : grey_200,
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Reference Link"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          color: selectedIndex == 2 ? logoTheme : grey_200,
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Books"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          color: selectedIndex == 3 ? logoTheme : grey_200,
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Slides"),
                      ),
                    ),
                  ),
                ]),
            Expanded(
                child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                ListView.builder(
                  itemCount: snapshot.youtube.length,
                  itemBuilder: (BuildContext context, int index) {
                    var datas = snapshot.youtube[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GFListTile(
                        color: white,
                        onTap: () {
                          launch(snapshot.youtube[index].link.toString());
                        },
                        avatar: Stack(
                          children: [
                            CachedNetworkImage(
                              fit: BoxFit.cover,
                              height: 80,
                              width: 150,
                              imageUrl: datas.image.toString(),
                              placeholder: (context, url) => Container(
                                  child: const Center(
                                      child: CupertinoActivityIndicator())),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            Positioned(
                              child: Container(
                                  decoration:
                                      const BoxDecoration(color: Colors.red),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      datas.time.toString(),
                                      style: p13.copyWith(color: white),
                                    ),
                                  )),
                            )
                          ],
                        ),
                        title: Text(
                          datas.title.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: p13.copyWith(color: Colors.blue),
                        ),
                        subTitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              datas.date.toString(),
                              style: p13.copyWith(
                                  color: Colors.blue, fontSize: 12),
                            ),
                            Text(
                              datas.views.toString(),
                              style: p13.copyWith(
                                  color: Colors.blue, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                    // return Card(
                    //     elevation: 2.0,
                    //     clipBehavior: Clip.antiAlias,
                    //     child: Padding(
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: 10, vertical: 10),
                    //         child: Column(
                    //           crossAxisAlignment:
                    //           CrossAxisAlignment.start,
                    //           children: [
                    //             InkWell(onTap: (){
                    //               launch(
                    //                   snapshot
                    //                       .youtube[index].link.toString());
                    //             }, child: Image.network(snapshot
                    //                 .youtube[index].image!)),
                    //             Row(
                    //               mainAxisAlignment:
                    //               MainAxisAlignment
                    //                   .spaceBetween,
                    //               children: [
                    //                 Text(snapshot
                    //                     .youtube[index].date
                    //                     .toString()),
                    //                 Text(snapshot
                    //                     .youtube[index].views
                    //                     .toString()),
                    //               ],
                    //             ),
                    //             SizedBox(height: 5,),
                    //             InkWell(onTap: (){
                    //               launch(
                    //                   snapshot
                    //                       .youtube[index].link.toString());
                    //             }, child: Text(
                    //               snapshot
                    //                   .youtube[index].title
                    //                   .toString(),
                    //               style: TextStyle(
                    //                 fontSize: 16,
                    //               ),
                    //             )),
                    //             // Text(snapshot
                    //             //     .youtube[index].link
                    //             //     .toString()),
                    //             SizedBox(height: 5,),
                    //           ],
                    //         )));
                  },
                ),
                ListView.builder(
                  itemCount: snapshot.links.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10.0),
                      child: InkWell(
                        onTap: () {
                          launch(snapshot.links[index].link.toString());
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: grey_400)),
                            clipBehavior: Clip.antiAlias,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: RichText(
                                text: TextSpan(
                                    text: "${index + 1}.",
                                    style: p15.copyWith(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: snapshot.links[index].title
                                            .toString(),
                                        style:
                                            p14.copyWith(color: Colors.black),
                                      ),
                                    ]),
                              ),
                            )),
                      ),
                    );
                  },
                ),
                BookScreen(lessonSlug: widget.lessonSlug),
                ListView.builder(
                    itemCount: snapshot.slides.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var datas = snapshot.slides[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: grey_400),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                onTap: () {
                                  launch(
                                      "https://docs.google.com/viewerng/viewer?url=https://api.schoolworkspro.com/uploads/files/${datas.filename}");
                                },
                                title: Text(datas.filename ?? ""),
                                trailing: const Icon(
                                  Icons.launch,
                                  color: Colors.blue,
                                ),
                              )),
                        ),
                      );
                    }),
              ],
            ))
          ],
        );
      }),
    );
  }
}
