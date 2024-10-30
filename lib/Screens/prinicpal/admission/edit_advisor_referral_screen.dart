import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schoolworkspro_app/api/repositories/principal/advisor_repo.dart';
import 'package:schoolworkspro_app/request/referral_details_request.dart';
import 'package:schoolworkspro_app/response/principal/getadvisors_response.dart';

class EditAdvisorReferral extends StatefulWidget {
  final String id;
  final Advisor advisorObj;
  const EditAdvisorReferral(
      {Key? key, required this.id, required this.advisorObj})
      : super(key: key);
  @override
  _EditAdvisorReferralState createState() => _EditAdvisorReferralState();
}

class _EditAdvisorReferralState extends State<EditAdvisorReferral> {
  TextEditingController referralController = TextEditingController();

  @override
  void initState() {
    if (widget.advisorObj.referral != null) {
      referralController.text = widget.advisorObj.referral.toString();
    }
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Edit Referral",
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
                      const Text('Referral *'),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: referralController,
                        maxLines: 1,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (String? value) {
                          if (widget.advisorObj.referral != null) {
                            if (value == null) {
                              // Must make a selection
                              return 'Please enter referral';
                            }
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          // filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState != null &&
                                    _formKey.currentState!.validate()) {
                                  final request = ReferralDetailsRequest(
                                    referral: referralController.text,
                                  );

                                  print(request);
                                  final ress = await AdvisorRepository()
                                      .postReferralDetails(request, widget.id);
                                  if (ress.success == true) {
                                    Fluttertoast.showToast(msg: "submitted");
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
                  ))
            ]),
          ),
        ));
  }
}
