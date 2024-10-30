import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/news%20and%20announcement/announcement_view_model.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/notice/add_noticeprincipal.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/notice/edit_noticeprincipal.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/api/repositories/principal/markread_repo.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/routes/route_generator.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewMynoticePrincipal extends StatefulWidget {
  const ViewMynoticePrincipal({Key? key}) : super(key: key);

  @override
  _ViewMynoticePrincipalState createState() => _ViewMynoticePrincipalState();
}

class _ViewMynoticePrincipalState extends State<ViewMynoticePrincipal> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AnnouncementViewModel>(
        create: (_) => AnnouncementViewModel(), child: Mynoticeprincipalbody());
  }
}

class Mynoticeprincipalbody extends StatefulWidget {
  const Mynoticeprincipalbody({Key? key}) : super(key: key);

  @override
  _MynoticeprincipalbodyState createState() => _MynoticeprincipalbodyState();
}

class _MynoticeprincipalbodyState extends State<Mynoticeprincipalbody> {

  late AnnouncementViewModel _announcementViewModel;
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _announcementViewModel = Provider.of<AnnouncementViewModel>(context, listen: false);
      _announcementViewModel.fetchAllAdminNotice();

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.green,
            onPressed: () {
              Navigator.push(
                      context,
                      PageTransition(
                          child: const AddNoticePrincipalScreen(),
                          type: PageTransitionType.leftToRight))
                  .then((value) => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => super.widget,
                      )));
            },
            icon: const Icon(Icons.add),
            label: const Text("Add notice")),
        appBar: AppBar(
          elevation: 0.0,
          title: const Text(
            "Notices",
          ),
        ),
        body: Consumer2<AnnouncementViewModel, CommonViewModel>(
            builder: (context, data, common, child) {
            return isLoading(data.adminAllApiResponse)
                ? const Center(child: CupertinoActivityIndicator())
                : data.adminNotices.isEmpty
                    ? Column(
                        children: [Image.asset("assets/images/no_content.PNG")],
                      )
                    : ListView(
                        children: [
                          ...List.generate(
                              data.adminNotices.length,
                              (index) => Builder(builder: (context) {
                                    var notice = data.adminNotices[index];
                                    var nameInital = notice['postedBy']['firstname']
                                                [0]
                                            .toUpperCase() +
                                        "" +
                                        notice['postedBy']['lastname'][0]
                                            .toUpperCase();
                                    return InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: ((builder) =>
                                              bottomSheet(notice, data, common)),
                                        );
                                      },
                                      child: Card(
                                        clipBehavior: Clip.antiAlias,
                                        margin: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              leading: notice['postedBy']
                                                          ['userImage'] !=
                                                      null
                                                  ? CircleAvatar(
                                                      backgroundImage: NetworkImage(
                                                          '$api_url2/uploads/users/' +
                                                              notice['postedBy']
                                                                  ['userImage']))
                                                  : CircleAvatar(
                                                      backgroundColor:
                                                          Colors.pinkAccent,
                                                      child: Text(
                                                        nameInital,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                              title: Text(
                                                notice['noticeTitle'],
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              subtitle: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(notice['postedBy']
                                                          ['firstname'] +
                                                      " " +
                                                      notice['postedBy']
                                                          ['lastname']),
                                                  Text("Type: " + notice['type'])
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: ReadMoreText(
                                                notice['noticeContent'],
                                                style: TextStyle(
                                                  color:
                                                      Colors.black.withOpacity(0.8),
                                                ),
                                                trimLines: 3,
                                                // colorClickableText: Colors.blueAccent,
                                                trimMode: TrimMode.Line,
                                                trimCollapsedText: ' Read more',
                                                trimExpandedText: ' Less',
                                              ),
                                            ),
                                            notice['filename'] == null
                                                ? const SizedBox.shrink()
                                                : TextButton(
                                                    child: Text(
                                                      notice['filename'],
                                                      style: const TextStyle(
                                                          color: Colors.blue),
                                                    ),
                                                    onPressed: () {
                                                      _launchURL(
                                                          notice['filename']);
                                                      // html.window
                                                      //     .open('www.facebook.com', "filename");
                                                    },
                                                  ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }))
                        ],
                      );
          }
        ),
      );

  }

  Widget bottomSheet(
      dynamic data, AnnouncementViewModel value, CommonViewModel common) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      height: 190.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Edit"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                      context,
                      PageTransition(
                          child: EditNoticePrincipalScreen(data: data),
                          type: PageTransitionType.leftToRight))
                  .then((value) => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => super.widget,
                      )));
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text("Delete"),
            onTap: () async {
              final res = await Markreadrepo().deletemynotice(data['_id']);
              if (res.success == true) {
                RouteGenerator.goBack();
                value.fetchAllAdminNotice();
                Fluttertoast.showToast(msg: res.message.toString());
              } else {
                Fluttertoast.showToast(msg: res.message.toString());
              }
            },
          ),
        ],
      ),
    );
  }

  _launchURL(String abc) async {
    String url = '$api_url2/uploads/files/$abc';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
