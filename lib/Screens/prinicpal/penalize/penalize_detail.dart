import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/lecturer/penalize_request.dart';
import 'package:schoolworkspro_app/response/addproject_response.dart';
import 'package:schoolworkspro_app/response/lecturer/getdisciplinaryforstats_response.dart';
import 'package:schoolworkspro_app/services/lecturer/penalize_service.dart';
import 'package:schoolworkspro_app/services/lecturer/studentstats_service.dart';

class PenalizeDetail extends StatefulWidget {
  final data;
  const PenalizeDetail({Key? key, this.data}) : super(key: key);

  @override
  _PenalizeDetailState createState() => _PenalizeDetailState();
}

class _PenalizeDetailState extends State<PenalizeDetail> {
  Future<GetDisciplinaryForStatsResponse>? disciplinary_response;
  final _formKey = GlobalKey<FormState>();
  final _remarksController = new TextEditingController();
  bool penalizeVisibility = false;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    disciplinary_response = StudentStatsLecturerService()
        .getUsersDisciplinary(widget.data['username']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          widget.data['firstname'] + " " + widget.data['lastname'],
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            child: Visibility(
              visible: penalizeVisibility,
              child: Form(
                key: _formKey,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Remarks",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _remarksController,
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Request cant be empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Write Something...',
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green)),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ))),
                                onPressed: () {
                                  setState(() {
                                    penalizeVisibility = false;
                                  });
                                },
                                child: const Text('Cancel')),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.green),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ))),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      final data = PenalizeRequest(
                                          username: widget.data['username'],
                                          remarks: _remarksController.text);
                                      Addprojectresponse res =
                                          await Penalizeservice()
                                              .penalize(data);

                                      setState(() {
                                        isLoading = true;
                                      });
                                      if (res.success == true) {
                                        setState(() {
                                          _remarksController.clear();
                                          isLoading = true;
                                        });
                                        snackThis(
                                            duration: 2,
                                            behavior: SnackBarBehavior.floating,
                                            context: context,
                                            color: Colors.green,
                                            content:
                                                Text(res.message.toString()));

                                        setState(() {
                                          isLoading = false;
                                        });
                                      } else {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        snackThis(
                                            duration: 2,
                                            behavior: SnackBarBehavior.floating,
                                            context: context,
                                            color: Colors.red,
                                            content:
                                                Text(res.message.toString()));

                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    } catch (e) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      snackThis(
                                          duration: 2,
                                          behavior: SnackBarBehavior.floating,
                                          context: context,
                                          color: Colors.green,
                                          content: Text(e.toString()));

                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  }
                                },
                                child: const Text('Save')),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ))),
                    onPressed: () {
                      setState(() {
                        if (penalizeVisibility == true) {
                          setState(() {
                            penalizeVisibility = false;
                          });
                        } else if (penalizeVisibility == false) {
                          setState(() {
                            penalizeVisibility = true;
                          });
                        }
                      });
                    },
                    child: const Text('Penalize')),
              ),
            ],
          ),
          FutureBuilder<GetDisciplinaryForStatsResponse>(
            future: disciplinary_response,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.result!.isEmpty
                    ? Column(children: <Widget>[
                        Image.asset("assets/images/no_content.PNG"),
                        const Text(
                          "No offence committed",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                      ])
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: snapshot.data?.result?.length,
                        itemBuilder: (context, index) {
                          var datas = snapshot.data?.result?[index];
                          DateTime committed = DateTime.parse(datas['date']);

                          committed = committed
                              .add(const Duration(hours: 5, minutes: 45));

                          var formattedTime =
                              DateFormat('yMMMMd').format(committed);

                          return Card(
                            child: GFListTile(
                              title: Text(
                                "Offence Type: " + datas['level']['level'],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              icon: Text(formattedTime.toString()),
                              description: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Remarks:"),
                                  Text(datas['remarks'])
                                ],
                              ),
                            ),
                          );
                        },
                      );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return Center(
                  child: SpinKitDualRing(
                    color: kPrimaryColor,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
