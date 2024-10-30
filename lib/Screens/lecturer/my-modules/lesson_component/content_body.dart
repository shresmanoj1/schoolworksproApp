import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:schoolworkspro_app/Screens/lecturer/my-modules/lessoncontent_manipulate.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/lesson_response.dart';
import 'package:schoolworkspro_app/response/lessoncontent_response.dart';
import 'package:schoolworkspro_app/services/lessoncontent_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentBody extends StatefulWidget {
  final moduleSlug;
  String moduelTitle;
  final LessonresponseLesson? data;
  final index;
   ContentBody({Key? key, this.moduleSlug, this.data, this.index, required this.moduelTitle})
      : super(key: key);

  @override
  _ContentBodyState createState() => _ContentBodyState();
}

class _ContentBodyState extends State<ContentBody> {
  Future<Lessoncontentresponse>? lessoncontent_response;

  @override
  void initState() {
    // TODO: implement initState
    getContent();
    super.initState();
  }

  getContent() async {
    lessoncontent_response = Lessoncontentservice()
        .getLessoncontent(widget.data!.lessons![widget.index].lessonSlug!);

    final da = await Lessoncontentservice()
        .getLessoncontent(widget.data!.lessons![widget.index].lessonSlug!);
    print(jsonEncode(da.lesson));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        FutureBuilder<Lessoncontentresponse>(
            future: lessoncontent_response,
            builder: (context, snapshot) {
              print(snapshot.data);
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                            icon:Icon(Icons.edit),
                            style: ElevatedButton.styleFrom(primary:Colors.orange),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        LessonContentManipulate(
                                          lesson_slug: snapshot
                                              .data?.lesson?.lessonSlug
                                              .toString(),
                                          week: snapshot.data?.lesson?.week
                                              .toString(),
                                          module: widget.moduleSlug,
                                          update: true,
                                          content:
                                          snapshot.data?.lesson?.lessonContents,
                                          title: snapshot.data?.lesson?.lessonTitle
                                              .toString(),
                                          moduleTitle : widget.moduelTitle,
                                        ),
                                  ))
                              ;
                            },
                            label: Text("Edit")),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        child: Html(
                          style: {"ol": Style(margin: const EdgeInsets.all(5))},
                          shrinkWrap: true,
                          data: snapshot.data!.lesson!.lessonContents,
                          customRender: {
                            "table": (context, child) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: (context.tree as TableLayoutElement).toWidget(context),
                              );
                            }
                          },
                          onLinkTap: (String? url,
                              RenderContext context,
                              Map<String, String> attributes,
                              dom.Element? element) {
                            Future<void> _launchInBrowser(Uri url) async {
                              if (await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              )) {
                                throw 'Could not launch $url';
                              }
                            }
                            var linkUrl = url!.replaceAll(" ", "%20");
                            _launchInBrowser(Uri.parse(linkUrl));
                          },
                          onImageTap: (String? url,
                              RenderContext context,
                              Map<String, String> attributes,
                              dom.Element? element) {
                            // print(url!);
                            //open image in webview, or launch image in browser, or any other logic here
                            launch(url!);
                          },
                        ),
                      ),
                    ),

                  ],
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return const Center(
                  child: CupertinoActivityIndicator()
                );
              }
            })
      ],
    );
  }
}