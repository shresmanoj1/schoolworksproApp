import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

import '../../../api/repositories/lecturer/assessment_repository.dart';
import '../../../helper/custom_loader.dart';
import '../../widgets/snack_bar.dart';

class SubmissionFeedbackScreen extends StatefulWidget {
  final data;
  final feedback;
  final id;
  const SubmissionFeedbackScreen({Key? key, this.data, this.feedback, this.id})
      : super(key: key);

  @override
  _SubmissionFeedbackScreenState createState() =>
      _SubmissionFeedbackScreenState();
}

class _SubmissionFeedbackScreenState extends State<SubmissionFeedbackScreen> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  bool isloading = false;

  final feedbackcontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (isloading == true) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          "Submission Feedback",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        children: [
          Html(data: widget.data,
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
            },),
          const SizedBox(height: 5,),
          const Divider(color: Colors.blueAccent, thickness: 3, height: 20,),
          const SizedBox(height: 5,),
          const Text(
            "Feedback",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10,),
          widget.feedback == null
              ? const SizedBox() :  Container(
            width: double
                .infinity,
            padding:
            const EdgeInsets.all(
                8.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: Color(0xffc8e6c9)),
            child:  Text(widget.feedback.toString())
          ),
          SizedBox(height: 20,),
          // Divider(color: Colors.blueAccent, thickness: 3, height: 20,),
          TextFormField(
            controller: feedbackcontroller,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Enter feedback',
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryColor)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  // style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: ()  async {
                    setState(() {
                      isloading = true;
                    });
                    try {
                      final res = await AssessmentStatsRepository().addFeedback(feedbackcontroller.text, widget.id);
                      setState(() {
                        isloading = true;
                      });
                      if (res.success == true) {
                        setState(() {
                          isloading = false;
                        });
                        Navigator.of(context).pop();
                        snackThis(
                            context: context,
                            color: Colors.green,
                            duration: 2,
                            content: Text(res.message.toString()));
                      } else {
                        setState(() {
                          isloading = false;
                        });
                        snackThis(
                            context: context,
                            color: Colors.red,
                            duration: 2,
                            content: Text(res.message.toString()));
                      }
                    } on Exception catch (e) {
                      setState(() {
                        isloading = false;
                      });
                      snackThis(
                          context: context,
                          color: Colors.red,
                          duration: 2,
                          content: Text(e.toString()));

                    }
                  },
                  child: const Text('Submit')),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 50,
            width: double.infinity,
            color: Colors.orange.shade100,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: RichText(
                  softWrap: true,
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                      TextSpan(
                          text:
                              " The submitted feedback will update \n the current feedback! ",
                          style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }
}
