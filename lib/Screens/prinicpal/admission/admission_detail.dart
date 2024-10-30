import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/admission/edit_advisor_referral_screen.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/advisor/assign_to_screen.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/advisor/confirm_admission_screen.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/advisor/referral_details_screen.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/principal_common_view_model.dart';
import 'package:schoolworkspro_app/api/repositories/principal/advisor_repo.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/principal/getadvisors_response.dart';

import '../../lecturer/admission/lecturer_advisor_view_model.dart';

class AdvisorDetailScreen extends StatefulWidget {
  final Advisor value;
  const AdvisorDetailScreen({Key? key, required this.value}) : super(key: key);

  @override
  _AdvisorDetailScreenState createState() => _AdvisorDetailScreenState();
}

class _AdvisorDetailScreenState extends State<AdvisorDetailScreen> {
  final TextEditingController discount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer2<PrinicpalCommonViewModel, CommonViewModel>(
        builder: (context, value, common, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            "${widget.value.firstName} ${widget.value.lastName}",
            style: const TextStyle(color: Colors.black),
          ),
        ),
        body: ListView(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Chip(
                      backgroundColor: widget.value.admission == "Admitted"
                          ? Colors.green
                          : Colors.orange,
                      label: Text(
                        widget.value.admission.toString(),
                        style: const TextStyle(color: Colors.white),
                      )),
                )),
            ListTile(
              title: Builder(builder: (context) {
                var name = "${widget.value.firstName} ${widget.value.lastName}";
                return RichText(
                  text: TextSpan(
                    text: 'Name: ',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                        text: name,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                );
              }),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Email: ',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.value.email ?? "",
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'course: ',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.value.course.toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Contact: ',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.value.contact.toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Grade/Percentage: ',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.value.percentage.toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(
                      label: Text('Referrals',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Feedback',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Followed by',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold))),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text(widget.value.referral == null
                        ? "n/a"
                        : widget.value.referral.toString())),
                    DataCell(Text(widget.value.feedbacks == null
                        ? "n/a"
                        : widget.value.feedbacks.toString())),
                    DataCell(Text(widget.value.followedUpBy == null
                        ? "n/a"
                        : widget.value.followedUpBy.toString())),
                  ]),
                ],
              ),
            ),
            value.hasPermission(["add_edit_advisor"])
                ? ButtonBar(
                    children: [
                      // widget.value.admission == "Admitted"
                      //     ? const SizedBox()
                      //     : ElevatedButton.icon(
                      //         onPressed: () {
                      //           Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (BuildContext context) =>
                      //                       ConfirmAdmission(
                      //                         id: widget.value.id,
                      //                       )));
                      //         },
                      //         icon: const Icon(
                      //           Icons.check,
                      //         ),
                      //         label: const Text("Admit Student"),
                      //       ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ReferralDetails(
                                        id: widget.value.id.toString(),
                                        feedback: widget.value.feedbacks,
                                        discount: widget.value.discount,
                                        referral: widget.value.referral,
                                        followedBy: widget.value.followedUpBy,
                                        admission: widget.value.admission,
                                      )));
                        },
                        icon: const Icon(
                          Icons.people_outline_sharp,
                        ),
                        label: const Text("Follow up"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AssignToScreen(
                                        id: widget.value.id,
                                      )));
                        },
                        icon: const Icon(
                          Icons.person_add,
                        ),
                        label: const Text("Assign Staff"),
                      ),
                      value.hasPermission(["edit_advisor_referral"])
                          ? ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            EditAdvisorReferral(
                                              id: widget.value.id.toString(),
                                              advisorObj: widget.value,
                                            )));
                              },
                              icon: const Icon(
                                Icons.people_outline_sharp,
                              ),
                              label: const Text("Referral"),
                            )
                          : const SizedBox(),
                      widget.value.score == null
                          ? const SizedBox()
                          : ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      actionsPadding: EdgeInsets.zero,
                                      insetPadding: EdgeInsets.zero,
                                      title: Text(
                                        'Quiz Result',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      content: Container(
                                        height: 60,
                                        child: Column(
                                          children: [
                                            Text('Obtained Marks',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18)),
                                            Text(
                                                "${widget.value.score!.obtainedScore.toString()} out of ${widget.value.score!.totalScore.toString()} "),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: const Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.quiz_outlined,
                              ),
                              label: Text("Quiz"),
                            ),
                    ],
                  )
                : const SizedBox()
          ],
        ),
      );
    });
  }
}