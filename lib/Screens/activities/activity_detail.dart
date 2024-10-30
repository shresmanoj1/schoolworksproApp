import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;

class Activitydetail extends StatefulWidget {
  final data;
  final date;
  const Activitydetail({Key? key, this.data, this.date}) : super(key: key);

  @override
  _ActivitydetailState createState() => _ActivitydetailState();
}

class _ActivitydetailState extends State<Activitydetail> {
  @override
  void initState() {
    // TODO: implement initState
    DateTime duedate = DateTime.parse(widget.date.toString());

    DateTime now = DateTime.now();

    duedate = duedate.add(const Duration(hours: 5, minutes: 45));

    var formattedTime2 = DateFormat('yMMMMd').format(duedate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime duedate = DateTime.parse(widget.date.toString());

    DateTime now = DateTime.now();

    duedate = duedate.add(const Duration(hours: 5, minutes: 45));

    var formattedTime2 =
        DateFormat('EEEE, dd MMM, yyyy hh:mm a').format(duedate);
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          title: Text(
            formattedTime2,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Html(
                style: {
                  "ol": Style(margin: const EdgeInsets.all(5)),
                  "p": Style(margin: const EdgeInsets.all(3)),
                  "h1": Style(margin: const EdgeInsets.all(3)),
                  "table": Style(margin: const EdgeInsets.all(3)),
                  "tr": Style(margin: const EdgeInsets.all(3)),
                  "td": Style(margin: const EdgeInsets.all(3)),
                },
                shrinkWrap: true,
                data: widget.data,
                customRender: {
                  "table": (context, child) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: (context.tree as TableLayoutElement).toWidget(context),
                    );
                  }
                },
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
              ),
              Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: kPrimaryColor),
                  child: Column(
                    children: [
                      Text("This assessment is Due on:  " + formattedTime2,
                          style: const TextStyle(color: Colors.white)),
                      const Text(
                        "login to www.schoolworkspro.com for submission",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
