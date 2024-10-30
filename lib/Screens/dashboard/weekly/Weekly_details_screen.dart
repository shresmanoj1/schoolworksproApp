import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/utils.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/api/repositories/Journal_repository.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;
import '../../../api/api.dart';
import '../../../config/api_response_config.dart';
import 'package:intl/intl.dart';

import '../../../constants/text_style.dart';
import '../../../helper/image_from_network.dart';
import '../../../request/comment_request.dart';
import '../../../response/authenticateduser_response.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class WeeklyDetails extends StatefulWidget {
  final String JournalSlug;
  const WeeklyDetails({Key? key, required this.JournalSlug}) : super(key: key);

  @override
  State<WeeklyDetails> createState() => _WeeklyDetailsState();
}

class _WeeklyDetailsState extends State<WeeklyDetails> {
  late CommonViewModel _provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CommonViewModel>(context, listen: false)
          .fetchweeklydetails(widget.JournalSlug);
    });
    getData();
    super.initState();
  }

  final TextEditingController commentcontroller = TextEditingController();
  User? user;

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommonViewModel>(builder: (context, common, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            common.weeklydetail.title.toString(),
            style: const TextStyle(
                fontWeight: FontWeight.w800, overflow: TextOverflow.ellipsis),
          ),
        ),
        body: isLoading(common.weeklyDetailsApiResponse)
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                              radius: 12,
                              backgroundColor:
                                  common.weeklydetail.author!.userImage == null
                                      ? Colors.grey
                                      : kWhite,
                              child:
                                  common.weeklydetail.author!.userImage != null
                                      ? ClipRect(
                                          // borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            '$api_url2/uploads/users/${common.weeklydetail.author!.userImage ?? ''}',
                                            width: 24,
                                            height: 24,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : ClipOval()),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${common.weeklydetail.author!.firstname} ${common.weeklydetail.author!.lastname} ",
                          ),
                          Spacer(),
                          const Icon(
                            Icons.watch_later_outlined,
                            color: logoTheme,
                          ),
                          const SizedBox(width: 5),
                          Builder(builder: (context) {
                            DateTime now = DateTime.parse(
                                common.weeklydetail.createdAt.toString()).add(Duration(hours: 5, minutes: 45));
                            // now =
                            //     now.add(const Duration(hours: 5, minutes: 45));
                            var formattedTime =
                                DateFormat('yMMMMd').format(now);
                            return Text(formattedTime);
                          }),
                        ],
                      ),
                      const Divider(
                        height: 25,
                        thickness: 3,
                        color: logoTheme,
                      ),
                      Html(
                        style: {"ol": Style(margin: const EdgeInsets.all(5))},
                        shrinkWrap: true,
                        data: common.weeklydetail.content,
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
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Comments",
                            style: p15.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "${common.weeklydetail.comments?.length} Comments",
                            style: p15.copyWith(
                                fontWeight: FontWeight.w700, color: logoTheme),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                await common
                                    .likeJournal(
                                        common.weeklydetail.journalSlug
                                            .toString(),
                                        context)
                                    .then((_) {
                                  common.fetchweeklydetails(widget.JournalSlug);
                                });
                              },
                              icon: common.weeklydetail.stars!
                                      .contains(user!.username)
                                  ? const Icon(
                                      Icons.thumb_up_alt,
                                      color: Colors.blue,
                                    )
                                  : const Icon(Icons.thumb_up_alt_outlined)),
                          Text(
                              "${common.weeklydetail.stars!.length.toString()} Likes"),
                        ],
                      ),
                      CustomTextField(
                          hintText: "Post a comment",
                          controller: commentcontroller,
                          hasBottomSpace: true),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () async {
                            if(commentcontroller.text.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please enter comment")));
                              return;
                            }else{
                              final data =
                              Commentrequest(comment: commentcontroller.text);
                              await common
                                  .addJournalComment(
                                  data,
                                  common.weeklydetail.journalSlug.toString(),
                                  context)
                                  .then((_) {
                                commentcontroller.clear();
                                common.fetchweeklydetails(widget.JournalSlug);
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 6),
                            decoration: BoxDecoration(
                              color: logoTheme,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "Post",
                              style: TextStyle(
                                  color: white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      common.weeklydetail.comments == null ||
                              common.weeklydetail.comments!.isEmpty
                          ? const SizedBox()
                          : Column(
                              children: [
                                ListView.builder(
                                  reverse: true,
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemCount:
                                        common.weeklydetail.comments?.length,
                                    itemBuilder: (context, i) {
                                      var data =
                                          common.weeklydetail.comments?[i];

                                      DateTime now = DateTime.parse(
                                          data!.createdAt.toString()).add(const Duration(
                                          hours: 5, minutes: 45));

                                      var formattedTime2 = DateFormat('yyyy/mm/dd').format(now);
                                      var nameInital =
                                          "${data.postedBy!.firstname![0].toUpperCase()}${data.postedBy!.lastname![0].toUpperCase()}";
                                      // _replycontrollers.add(
                                      //     TextEditingController());
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          ListTile(
                                              leading: data.postedBy!
                                                          .userImage !=
                                                      null
                                                  ? CircleAvatar(
                                                      backgroundImage: NetworkImage(
                                                          ImageFromNetwork
                                                              .fullImageUrl(
                                                                  'uploads/users/${data.postedBy?.userImage}')))
                                                  : CircleAvatar(
                                                      backgroundColor:
                                                          Colors.grey,
                                                      child: Text(
                                                        nameInital,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                              subtitle: Text(data.comment!),
                                              trailing: Text(DateFormat.yMd().format(now)),
                                              title: Text(
                                                  "${data.postedBy!.firstname} ${data.postedBy!.lastname}")),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20.0, horizontal: 10),
                                            child: Container(
                                              height: 3,
                                              width: double.infinity,
                                              color: grey_200,
                                            ),
                                          )
                                        ],
                                      );
                                    }),
                              ],
                            )
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
