import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:schoolworkspro_app/response/lecturer/lecturermoduledetail_response.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

class AboutmoduleLecturer extends StatefulWidget {
  LecturerModuleDetailResponse? module_response;
  AboutmoduleLecturer({Key? key, this.module_response}) : super(key: key);

  @override
  State<AboutmoduleLecturer> createState() => _AboutmoduleLecturerState();
}

class _AboutmoduleLecturerState extends State<AboutmoduleLecturer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            backgroundColor: Colors.white),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                // Text(widget.module_response!.module.benefits!),
                Container(
                  width: double.infinity,
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Module overview",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Html(
                            style: {
                              "ol": Style(
                                  margin:
                                  const EdgeInsets.all(5))
                            },
                            shrinkWrap: true,
                            data: widget.module_response!.module['moduleDesc'].toString(),
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
                      ],
                    ),
                  ),
                ),

                Container(
                  width: double.infinity,
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Learning outcome",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                                "By the end of the module, you will be able to ...",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Html(
                            style: {
                              "ol": Style(
                                  margin:
                                  const EdgeInsets.all(5))
                            },
                            shrinkWrap: true,
                            customRender: {
                              "table": (context, child) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: (context.tree as TableLayoutElement).toWidget(context),
                                );
                              }
                            },
                            data:  widget.module_response!.module['benefits'].toString(),
                            onLinkTap: (String? url,
                                RenderContext context,
                                Map<String, String> attributes,
                                dom.Element? element) {
                              var linkUrl = url!.replaceAll(" ", "%20");
                              launch(linkUrl);
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
