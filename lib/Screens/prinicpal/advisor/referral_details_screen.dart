import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/api/repositories/principal/advisor_repo.dart';
import 'package:schoolworkspro_app/request/referral_details_request.dart';

import '../../lecturer/admission/lecturer_advisor_view_model.dart';
import '../principal_common_view_model.dart';

class ReferralDetails extends StatefulWidget {
  final String id;
  String? referral;
  String? followedBy;
  String? feedback;
  int? discount;
  String? admission;
  ReferralDetails(
      {Key? key,
      required this.id,
      required this.followedBy,
      required this.feedback,
      required this.discount,
      required this.admission,
      required this.referral})
      : super(key: key);
  @override
  _ReferralDetailsState createState() => _ReferralDetailsState();
}

class _ReferralDetailsState extends State<ReferralDetails> {
  TextEditingController feedbackController = TextEditingController();
  TextEditingController referralController = TextEditingController();
  TextEditingController assignDiscountController = TextEditingController();
  TextEditingController followedByController = TextEditingController();

  String? dropdownValue;
  @override
  void initState() {
    if (widget.feedback != null) {
      feedbackController.text = widget.feedback.toString();
    }

    if (widget.referral != null) {
      referralController.text = widget.referral.toString();
    }

    if (widget.discount != null) {
      assignDiscountController.text = widget.discount.toString();
    }

    if (widget.followedBy != null) {
      followedByController.text = widget.followedBy.toString();
    }

    if (widget.admission != null) {
      dropdownValue = widget.admission;
    }

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer2<LecturerAdvisorViewModel, PrinicpalCommonViewModel>(
        builder: (context, state, principalState, child) {
      return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Follow Up",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomScrollView(slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.referral != null
                          ? const SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Referral *'),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: referralController,
                                  maxLines: 1,
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: (String? value) {
                                    if (widget.referral != null) {
                                      if (value == null || value == '') {
                                        // Must make a selection
                                        return 'Please enter referral';
                                      }
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    // filled: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                  ),
                                ),
                              ],
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Followed By *'),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: followedByController,
                        keyboardType: TextInputType.text,
                        validator: (String? value) {
                          if (value == null || value == '') {
                            return 'Please enter followed by';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Feedback *'),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: feedbackController,
                        keyboardType: TextInputType.text,
                        validator: (String? value) {
                          if (value == null || value == '') {
                            return 'Please enter feedback';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Assign discount *'),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: assignDiscountController,
                        keyboardType: TextInputType.number,
                        validator: (String? value) {
                          if (value == null || value == '') {
                            return 'Please enter assign discount';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Admission *'),
                      const SizedBox(
                        height: 5,
                      ),
                      DropdownSearch<String>(
                        items: const [
                          "Admitted",
                          "Not Admitted",
                          "Likely",
                          "Waiting For Enrollment",
                          "Suspended",
                          "Not Enrolled"
                        ],
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'Must select admission';
                          }
                          return null;
                        },
                        selectedItem: dropdownValue,
                        dropdownSearchDecoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          hintText: 'Select Admission',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        onChanged: (value) {
                          dropdownValue = value as String;
                        },
                        // selectedItem: "Admitted",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState != null &&
                                    _formKey.currentState!.validate()) {
                                  final request = ReferralDetailsRequest(
                                    referral:
                                        referralController.text.toString(),
                                    feedbacks:
                                        feedbackController.text.toString(),
                                    discount: assignDiscountController.text
                                        .toString(),
                                    followedUpBy:
                                        followedByController.text.toString(),
                                    admission: dropdownValue.toString(),
                                  );

                                  final ress = await AdvisorRepository()
                                      .postReferralDetails(request, widget.id);
                                  if (ress.success == true) {
                                    state.fetchAssigned();
                                    principalState.fetchadvisor();
                                    Fluttertoast.showToast(msg: "submitted");
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  } else {
                                    Fluttertoast.showToast(msg: "Error");
                                  }
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue),
                              ),
                              child: const Text('Update')),
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            ),
          ));
    });
  }
}
