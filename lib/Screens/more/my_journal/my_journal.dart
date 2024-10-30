import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/more/my_journal/add_journal.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants/colors.dart';

import '../../../api/repositories/Journal_repository.dart';
import '../../../response/fetchjournal_response.dart';

class MyJournal extends StatefulWidget {
  const MyJournal({Key? key}) : super(key: key);

  @override
  _MyJournalState createState() => _MyJournalState();
}

class _MyJournalState extends State<MyJournal> {
  late CommonViewModel common;
  bool isloading = false;
  List<GetJournal> _listJournal = <GetJournal>[];
  List<GetJournal> _JournalListDisplay = <GetJournal>[];

  TextEditingController _searchJournalController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      common = Provider.of<CommonViewModel>(context, listen: false);
      common.fetchmyJourney().then((value) => fetchData());
    });

    super.initState();
  }

  @override
  void dispose() {
    _searchJournalController.dispose();
    super.dispose();
  }

  fetchData() {
    _listJournal.clear();
    _JournalListDisplay.clear();

    for (int i = 0; i < common.journal.length; i++) {
      setState(() {
        _listJournal.add(common.journal[i]);
        _JournalListDisplay = _listJournal;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: logoTheme,
        title: const Text(
          "Journals",
          style: TextStyle(color: kWhite, fontWeight: FontWeight.w800),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: const AddJournal(
                      content: "", intro: "", title: "", slug: ""),
                  type: PageTransitionType.rightToLeft,
                ),
              ).then((value) {
                fetchData();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffD03579),
                  borderRadius: BorderRadius.circular(3),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: const [
                    Icon(Icons.add),
                    SizedBox(width: 3),
                    Text(
                      "Add Journal",
                      style: TextStyle(
                        color: kWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      body: Consumer<CommonViewModel>(
        builder: (context, common, child) {
          return isLoading(common.journalApiResponse)
              ? const Center(child: CupertinoActivityIndicator())
              : isError(common.journalApiResponse)
                  ? const Center(child: Text('An error occurred'))
                  : isComplete(common.journalApiResponse)
                      ? buildJournalList()
                      : Center(
                          child: Image.asset("assets/images/no_content.PNG"),
                        );
        },
      ),
    );
  }

  Widget buildJournalList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Column(children: [
        TextField(
          controller: _searchJournalController,
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              hintText: 'Journal Title',
              filled: true,
              fillColor: white,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              )),
          onChanged: (text) {
            text = text.toLowerCase();
            List<GetJournal> filteredList = _listJournal.where((journal) {
              var itemName = journal.title!.toLowerCase();
              return itemName.contains(text);
            }).toList();

            setState(() {
              _JournalListDisplay = filteredList;
            });
          },
        ),
        const SizedBox(height: 10),
        ListView.builder(
            itemCount: _JournalListDisplay.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              GetJournal journaldatas = _JournalListDisplay[index];
              DateTime date =
                  DateTime.parse(journaldatas.createdAt!.toString());
              String formattedDate = DateFormat('yMMMMd').format(date);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: RichText(
                          text: TextSpan(
                            text: 'Title: ',
                            style: const TextStyle(
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text: journaldatas.title ?? '',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: RichText(
                          text: TextSpan(
                            text: 'Date: ',
                            style: const TextStyle(
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text: formattedDate,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: RichText(
                          text: TextSpan(
                            text: 'Status: ',
                            style: const TextStyle(
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text: journaldatas.verified == false
                                      ? "Draft"
                                      : "Public",
                                  style: TextStyle(
                                      color: journaldatas.verified == false
                                          ? Colors.red
                                          : Colors.green,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              Navigator.push(
                                      context,
                                      PageTransition(
                                          child: AddJournal(
                                              title: journaldatas.title,
                                              intro: journaldatas.intro,
                                              slug: journaldatas.journalSlug,
                                              content: journaldatas.content,
                                              previewImage:
                                                  journaldatas.previewImage),
                                          type: PageTransitionType.rightToLeft))
                                  .then((value) {
                                fetchData();
                              });
                            },
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: logoTheme,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.edit_note_rounded,
                                      size: 20,
                                      color: white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('Edit',
                                        style: TextStyle(
                                            color: white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14)),
                                  ],
                                )),
                          )),
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              showAlertDialog(
                                  context, journaldatas.journalSlug!);
                            },
                            child: Container(
                                color: const Color(0xffE80000),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.delete_outline,
                                        size: 20, color: white),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                          color: white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ],
                                )),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
      ]),
    );
  }

  void onSearchTextChanged(String text) {
    text = text.toLowerCase();
    List<GetJournal> filteredList = _listJournal.where((journal) {
      var itemName = journal.title!.toLowerCase();
      return itemName.contains(text);
    }).toList();

    setState(() {
      _JournalListDisplay = filteredList;
    });
  }

  showAlertDialog(BuildContext context, String slug) {
    Widget okButton = TextButton(
      child: const Text(
        "Yes, Delete this Journal",
        style: TextStyle(color: kRed, fontWeight: FontWeight.w800),
      ),
      onPressed: () async {
        try {
          final res = await JournalRepository().deleteJournal(slug.toString());
          if (res.success == true) {
            fetchData();
            setState(() {
              isloading = true;
            });

            common.fetchmyJourney();
            fetchData();

            snackThis(
                context: context,
                color: Colors.green,
                content: Text(res.message.toString()));
            setState(() {
              isloading = false;
            });
            Navigator.of(context).pop();
          } else {
            setState(() {
              isloading = true;
            });
            snackThis(
                context: context,
                color: Colors.red,
                content: Text(res.message.toString()));
            setState(() {
              isloading = false;
            });
            Navigator.of(context).pop();
          }
        } on Exception catch (e) {
          setState(() {
            isloading = true;
          });
          snackThis(
              context: context, color: Colors.red, content: Text(e.toString()));
          setState(() {
            isloading = false;
          });
          Navigator.of(context).pop();
        }
      },
    );

    Widget cancelButton = ElevatedButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Delete Journal"),
      content: const Text(
          "Are you sure you want to delete this journal? This action cannot be undone!"),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
