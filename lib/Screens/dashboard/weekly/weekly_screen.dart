import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/dashboard/weekly/single_journal_card.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/components/nointernet_widget.dart';
import 'package:schoolworkspro_app/constants/colors.dart';

import '../../../components/internetcheck.dart';
import '../../../config/api_response_config.dart';
import '../../../response/verifiedJournal_response.dart';
import 'Weekly_details_screen.dart';

class Weekly extends StatefulWidget {
  Weekly({Key? key}) : super(key: key);

  @override
  State<Weekly> createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<Weekly> {
  bool connected = true;
  late CommonViewModel common;
  List<Journal> _verifiedJournal = <Journal>[];
  List<Journal> _verifiedDisplay = <Journal>[];

  TextEditingController _searchVerifiedJournalController =
      TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      common = Provider.of<CommonViewModel>(context, listen: false);
      // common.getVerifiedJournal();
      fetchVerifyJournal();
    });
    checkInternet();
    super.initState();
  }

  fetchVerifyJournal() async {
    _verifiedJournal.clear();
    _verifiedDisplay.clear();

    await common.getVerifiedJournal();
    for (int i = 0; i < common.verifiedJournal.length; i++) {
      setState(() {
        _verifiedJournal.add(common.verifiedJournal[i]);
        _verifiedDisplay = _verifiedJournal;
      });
    }
  }

  checkInternet() async {
    internetCheck().then((value) {
      if (value) {
        setState(() {
          connected = true;
        });
      } else {
        setState(() {
          connected = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: logoTheme,
        title: const Text(
          "Weekly Journals",
          style: TextStyle(color: kWhite, fontWeight: FontWeight.w800),
        ),
      ),
      body: connected == false
          ? const NoInternetWidget()
          : Consumer<CommonViewModel>(builder: (context, common, child) {
              return
                  isLoading(common.verifiedJournalApiResponse)
                    ? const Center(
                    child: CupertinoActivityIndicator(),
                  )
                    : isError(common.verifiedJournalApiResponse)
                        ? const Center(child: Text("An error occured"))
                        : isComplete(common.verifiedJournalApiResponse)
                            ?
                  SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: const BorderSide(color: grey_200),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Text(
                              "schoolworkspro.com weekly is a place to express yourself, discover yourself, and bond over the stuff you love. It's where your interests connect you with your people."),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          side: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        child: ListTile(
                          trailing: const Icon(Icons.search),
                          title: TextField(
                            controller: _searchVerifiedJournalController,
                            decoration: const InputDecoration(
                              hintText: 'Journal Title',
                              border: InputBorder.none,
                            ),
                            onChanged: (text) {
                              text = text.toLowerCase();
                              List<Journal> filterVerifiedJournalList =
                                  _verifiedJournal.where((verifyJournal) {
                                var verifyitem =
                                    verifyJournal.title!.toLowerCase();
                                return verifyitem.contains(text);
                              }).toList();

                              print(
                                  'Filterned: ${filterVerifiedJournalList.map((verifyJournal) => verifyJournal.title).toList()}');

                              setState(() {
                                _verifiedDisplay = filterVerifiedJournalList;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _verifiedDisplay.length,
                      itemBuilder: (BuildContext context, int index) {
                        print("Building journal card $index");
                        var weekly = _verifiedDisplay[index];
                        var userextension = _verifiedDisplay[index]
                            .author
                            ?.userImage
                            ?.split(".")
                            .last;
                        return Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: SingleJournalCard(
                            userextension: userextension.toString(),
                            weekly: weekly,
                            onTap: () {
                              Navigator.of(context).pushNamed('/weeklyDetails', arguments: weekly.journalSlug);

                            },
                          ),
                        );
                      },
                    ),
                    if (_verifiedDisplay.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "No results",
                          style: TextStyle(color: kBlack),
                        ),
                      )
                  ],
                ),
              ): Container();
            }),
    );
  }
}
