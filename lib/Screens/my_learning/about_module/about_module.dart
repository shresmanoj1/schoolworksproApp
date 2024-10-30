import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../constants/colors.dart';
import 'package:html/dom.dart' as dom;

class AboutModule extends StatefulWidget {
  String desc;
  String url;
  String benefits;
  AboutModule(
      {Key? key, required this.url, required this.desc, required this.benefits})
      : super(key: key);

  @override
  State<AboutModule> createState() => _AboutModuleState();
}

class _AboutModuleState extends State<AboutModule> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url).toString(),
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      children: [
        const SizedBox(
          height: 20,
        ),
        YoutubePlayer(
          controller: _controller,
          width: double.infinity,
          progressColors: ProgressBarColors(
              backgroundColor: logoTheme, bufferedColor: logoTheme),
          showVideoProgressIndicator: true,
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Colors.grey)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Module overview",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Builder(builder: (context) {
                  print(widget.desc);
                  return Html(
                    style: {
                      "ol": Style(margin: const EdgeInsets.all(5)),
                      "table": Style(
                        backgroundColor:
                            const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                      ),
                      "th": Style(
                        padding: EdgeInsets.all(6),
                        backgroundColor: Colors.grey,
                      ),
                      "td": Style(
                        padding: EdgeInsets.all(6),
                        border: const Border(
                            bottom: BorderSide(color: Colors.grey)),
                      ),
                      'h5': Style(
                          maxLines: 2, textOverflow: TextOverflow.ellipsis),
                      'flutter': Style(
                        display: Display.BLOCK,
                        fontSize: FontSize(5),
                      ),
                      ".second-table": Style(
                        backgroundColor: Colors.transparent,
                      ),
                      ".second-table tr td:first-child": Style(
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.end,
                      ),
                    },
                    shrinkWrap: true,
                    // customRender: {
                    //   "table": (context, child) {
                    //     return SingleChildScrollView(
                    //       scrollDirection: Axis.horizontal,
                    //       child: (context.tree as TableLayoutElement)
                    //           .toWidget(context),
                    //     );
                    //   },
                    // },
                    data: widget.desc.toString(),
                    // data: htmlData,
                    onLinkTap: (String? url, RenderContext context,
                        Map<String, String> attributes, dom.Element? element) {
                      var linkUrl = url!.replaceAll(" ", "%20");
                      launch(linkUrl);
                    },
                    onImageTap: (String? url, RenderContext context,
                        Map<String, String> attributes, dom.Element? element) {
                      // print(url!);
                      //open image in webview, or launch image in browser, or any other logic here
                      launch(url!);
                    },
                  );
                }),
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
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Colors.grey)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Learning outcome",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Html(
                  style: {
                    "ol": Style(margin: const EdgeInsets.all(5)),
                    "table": Style(
                      // border: Border.all(color: Colors.grey),
                      // backgroundColor:
                      // const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                    ),
                    "th": Style(
                      padding: EdgeInsets.all(6),
                      backgroundColor: Colors.grey,
                    ),
                    "td": Style(
                      padding: EdgeInsets.all(6),
                      border:
                       Border.all(color: Colors.grey),
                    ),
                  },
                  shrinkWrap: true,
                  data: widget.benefits,
                  customRender: {
                    "table": (context, child) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: (context.tree as TableLayoutElement)
                            .toWidget(context),
                      );
                    }
                  },
                  onLinkTap: (String? url, RenderContext context,
                      Map<String, String> attributes, dom.Element? element) {
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
                  onImageTap: (String? url, RenderContext context,
                      Map<String, String> attributes, dom.Element? element) {
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
    );
  }
}


