import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/request/request_view_model.dart';

import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';

class RequestLetterScreen extends StatefulWidget {
  const RequestLetterScreen({Key? key}) : super(key: key);

  @override
  _RequestLetterScreenState createState() => _RequestLetterScreenState();
}

class _RequestLetterScreenState extends State<RequestLetterScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RequestViewModel>(builder: (context, snapshot, child) {
      return Scaffold(
          body: isLoading(snapshot.requestLetterApiResponse)
              ? VerticalLoader()
              : snapshot.requestLetter.letters!.isEmpty
                  ? Column(children: <Widget>[
                      Image.asset("assets/images/no_content.PNG"),
                      const Text(
                        "No request available",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                      // const Text('Click on "+" above to add request',
                      //     style: TextStyle(
                      //         color: Colors.red,
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 18.0))
                    ])
                  : ListView.builder(
                      itemCount: snapshot.requestLetter.letters!.length,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      itemBuilder: (context, index) {
                        var ticket = snapshot.requestLetter.letters![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.grey)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                decoration: BoxDecoration(
                                    color: ticket.issued == true
                                        ? Colors.green
                                        : Color(0xff8D6708),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4.0)), ),
                                child: Text(
                                    ticket.issued == true ? "Issued" : "Pending",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white)),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Html(
                                    data: ticket.content,
                                    style: {
                                      "body": Style(
                                        fontSize: FontSize(16.0),
                                        fontWeight: FontWeight.bold,
                                        margin: EdgeInsets.zero, padding: EdgeInsets.zero,
                                      ),
                                    },
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
                                  Text(
                                    DateFormat.yMMMEd()
                                        .format(ticket.createdAt!)
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 14, color: Color(0xff676767)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })

          //     } else {
          //       return const Center(
          //           child: SpinKitDualRing(
          //         color: kPrimaryColor,
          //       ));
          //     }
          //   },
          // ),
          );
    });
  }

  // _launchURL(String abc) async {
  //   String url = 'https://api-campus.softwarica.edu.np/uploads/files/' + abc;
  //   if (await canLaunch(url)) {
  //     // print(url);
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
}
