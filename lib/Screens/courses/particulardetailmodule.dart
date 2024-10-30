import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/coursedetail_response.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

class Particulardetailmodule extends StatefulWidget {
  final CoursedetailResponse? data;
  final int? index;
  const Particulardetailmodule({Key? key, this.data, this.index})
      : super(key: key);

  @override
  _ParticulardetailmoduleState createState() => _ParticulardetailmoduleState();
}

class _ParticulardetailmoduleState extends State<Particulardetailmodule> {
  String? extension;

  @override
  void initState() {
    extension =
        widget.data!.course!.modules![widget.index!].imageUrl!.split(".").last;
    super.initState();
  }

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [

                    extension == "svg"
                        ? SvgPicture.network(
                            api_url2 +
                                '/uploads/modules/' +
                                widget.data!.course!.modules![widget.index!]
                                    .imageUrl!,
                            height: 200,
                            width: MediaQuery.of(context).size.width)
                        : Image.network(
                            api_url2 +
                                '/uploads/modules/' +
                                widget.data!.course!.modules![widget.index!]
                                    .imageUrl!,
                            height: 200,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width),

                    Positioned(
                      // The Positioned widget is used to position the text inside the Stack widget
                      top: 0,
                      left: 0,

                      child: Container(
                          // We use this Container to create a black box that wraps the white text so that the user can read the text even when the image is white
                          width: 80,
                          color: Colors.white,
                          child: Text(
                            widget.data!.course!.modules![widget.index!].year!
                                .toString(),
                            style: const TextStyle(color: Colors.black),
                          )),
                    ),

                    //       ElevatedButton(
                    // onPressed: null,
                    // child: Text(widget
                    //     .data!.course!.modules![widget.index!].year!)),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      widget.data!.course!.modules![widget.index!].moduleTitle!,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 5.0,
                    children: [
                      for (var data
                          in widget.data!.course!.modules![widget.index!].tags!)
                        data == "" ? Container() :
                        Chip(
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 5),
                          backgroundColor: Colors.grey,
                          label: Text(
                            data,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text("Module leader: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          widget.data!.course!.modules![widget.index!]
                                  .moduleLeader!.firstname! +
                              " " +
                              widget.data!.course!.modules![widget.index!]
                                  .moduleLeader!.lastname!,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Html(
                  style: {
                    "ol": Style(
                        margin: const EdgeInsets.all(5), textAlign: TextAlign.justify),
                  },
                  shrinkWrap: true,
                  data: widget.data!.course!.modules![widget.index!].moduleDesc!,
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

                ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    // Icon(Icons.timer),
                    Chip(
                      labelPadding: const EdgeInsets.all(2),
                      backgroundColor: Colors.blueAccent,
                      label: Row(
                        children: [
                          const Icon(
                            Icons.play_circle_outlined,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                                widget.data!.course!.modules![widget.index!]
                                        .lessons!.length
                                        .toString() +
                                    " lessons",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 70,
                )

                // Text(widget.moduleDes),
                // Text(widget.modulename),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
