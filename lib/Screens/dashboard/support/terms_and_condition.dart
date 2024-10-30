import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

class Termsandcondition extends StatefulWidget {
  final data;
  const Termsandcondition({Key? key, this.data}) : super(key: key);

  @override
  _TermsandconditionState createState() => _TermsandconditionState();
}

class _TermsandconditionState extends State<Termsandcondition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Terms and Condition',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Html(
              data: widget.data,
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
                launch(url!);
              },
            ),
          ),
        ),
      ),
    );
  }
}
