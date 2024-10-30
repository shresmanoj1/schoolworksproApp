import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/stats_common_view_model.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/api/repositories/disciplinary_repo.dart';
import 'package:schoolworkspro_app/common_view_model.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/disciplinary_request.dart';
import 'package:schoolworkspro_app/response/common_response.dart';
import 'package:schoolworkspro_app/response/disciplinary_response.dart';
import 'package:schoolworkspro_app/response/principal/editact_response.dart';

class EditActScreen extends StatefulWidget {
  Result? data;
  EditActScreen({Key? key, this.data}) : super(key: key);

  @override
  _EditActScreenState createState() => _EditActScreenState();
}

class _EditActScreenState extends State<EditActScreen> {
  final TextEditingController level = new TextEditingController();
  final TextEditingController count = new TextEditingController();
  final TextEditingController miscounduct = new TextEditingController();
  final TextEditingController action = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    level.text = widget.data!.level.toString();
    count.text = widget.data!.count.toString();
    miscounduct.text = widget.data!.misconduct.toString();
    action.text = widget.data!.action.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Edit",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Consumer2<CommonViewModel, StatsCommonViewModel>(
          builder: (context, common, stats, child) {
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Level",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: level,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Level 1',
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Offence Count",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: count,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'e.g. 1',
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Act of misconduct",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: miscounduct,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'End each miscounduct with a ";',
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Action",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: action,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'End each miscounduct with a ";',
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                      child: SizedBox(
                        height: 40,
                        width: 95,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ))),
                          onPressed: () {
                            // Navigator.pop(context);
                          },
                          child: const Text("Cancel",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                      child: SizedBox(
                        height: 40,
                        width: 95,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (level.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Field can't be empty");
                            } else if (count.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Field can't be empty");
                            } else if (miscounduct.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Field can't be empty");
                            } else if (action.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Field can't be empty");
                            } else {
                              try {
                                final request = DisciplinaryRequest(
                                  action: action.text,
                                  count: count.text,
                                  level: level.text,
                                  misconduct: miscounduct.text,
                                );
                                EditActResponse res = await DisciplinaryRepo()
                                    .editAct(widget.data!.id.toString());
                                common.setLoading(true);
                                if (res.success == true) {
                                  Navigator.pop(context);
                                  snackThis(
                                      context: context,
                                      content: Text(res.message.toString()),
                                      color: Colors.green,
                                      duration: 1,
                                      behavior: SnackBarBehavior.floating);

                                  stats.fetchAllAct();

                                  common.setLoading(false);
                                } else {
                                  common.setLoading(true);
                                  snackThis(
                                      context: context,
                                      content: Text(res.message.toString()),
                                      color: Colors.red,
                                      duration: 1,
                                      behavior: SnackBarBehavior.floating);
                                  common.setLoading(false);
                                }
                                common.setLoading(false);
                              } catch (e) {
                                snackThis(
                                    context: context,
                                    content: Text("Failed to add"),
                                    color: Colors.red,
                                    duration: 1,
                                    behavior: SnackBarBehavior.floating);
                                common.setLoading(false);
                              }
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ))),
                          child: const Text(
                            "Update",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
