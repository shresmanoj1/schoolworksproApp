import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/myrequest_request.dart';
import 'package:schoolworkspro_app/response/lecturer/lecturerticketddetail_response.dart';
import 'package:schoolworkspro_app/services/addresponserequest_service.dart';
import 'package:schoolworkspro_app/services/lecturer/ticket_service.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class LecturerRequestDetailScreen extends StatefulWidget {
  final id;
  const LecturerRequestDetailScreen({Key? key, this.id}) : super(key: key);

  @override
  _LecturerRequestDetailScreenState createState() =>
      _LecturerRequestDetailScreenState();
}

class _LecturerRequestDetailScreenState
    extends State<LecturerRequestDetailScreen> {
  late Stream<LecturerRequestdetailResponse> response_detail;

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  getData() async {
    response_detail = LecturerRequestService().getRefreshticketdetail(
        const Duration(milliseconds: 200), widget.id.toString());
  }

  final TextEditingController response_controller = new TextEditingController();
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage(ImageSource source) async {
    var selected =
        await ImagePicker().pickImage(source: source, imageQuality: 10);

    setState(() {
      if (selected != null) {
        _imageFile = PickedFile(selected.path);
      } else {
        print('No image selected.');
      }
    });
  }

  var alertStyle = AlertStyle(
    overlayColor: Colors.blue,
    animationType: AnimationType.fromBottom,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: const TextStyle(fontWeight: FontWeight.bold),
    animationDuration: const Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0),
      side: const BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: const TextStyle(
      color: Color.fromRGBO(91, 55, 185, 1.0),
    ),
  );
  Widget bottomSheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text(
            "choose photo",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: const Icon(Icons.camera, color: Colors.red),
                onPressed: () async {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context, rootNavigator: true).pop();
                },
                label: const Text("Camera"),
              ),
              TextButton.icon(
                icon: const Icon(Icons.image, color: Colors.green),
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context, rootNavigator: true).pop();
                },
                label: const Text("Gallery"),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     iconTheme: const IconThemeData(
      //       color: Colors.black, //change your color here
      //     ),
      //     elevation: 0.0,
      //     title: const Text("Request Detail",
      //         style: TextStyle(color: Colors.black)),
      //     backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: StreamBuilder<LecturerRequestdetailResponse>(
          stream: response_detail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var ticket = snapshot.data!.request;

              DateTime now = DateTime.parse(ticket['createdAt'].toString());

              now = now.add(const Duration(hours: 5, minutes: 45));

              var formattedTime = DateFormat('yMMMMd').format(now);
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    semanticContainer: true,
                    // clipBehavior: Clip.antiAliasWithSaveLayer,
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: const EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                                color: ticket['status'] == "Resolved"
                                    ? Colors.green
                                    : kPrimaryColor,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(30.0))),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(ticket['status'].toString(),
                                  style: const TextStyle(
                                      fontSize: 9, color: Colors.white)),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(ticket['topic'].toString()),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.map,
                                    size: 15,
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                  Text(ticket['ticketId']),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.timer,
                                    size: 15,
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                  Text(formattedTime),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.thermostat,
                                    size: 15,
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                  Text(ticket['severity']),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.list,
                                    size: 15,
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                  Text(ticket['subject'].toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            ticket['request']!,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ),
                        ticket['requestFile'] == null
                            ? const SizedBox(
                                height: 1,
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: ticket['requestFile'].length,
                                      itemBuilder: (context, l) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  _launchURL(
                                                      ticket['requestFile'][l]);
                                                },
                                                child: Text(
                                                  ticket['requestFile'][l],
                                                )),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: response_controller,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: 'Add a response',
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: kPrimaryColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Attach File (Optional)",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) => bottomSheet(context)));
                            },
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: Radius.circular(12),
                              padding: EdgeInsets.all(6),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                child: Container(
                                  height: 60,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Text('Upload Image'),
                                  ),
                                ),
                              ),
                            ),
                            // child: const ElevatedButton(
                            //     onPressed: null, child: Text("Choose File"))
                          ),
                        ),
                        _imageFile == null
                            ? const SizedBox(
                                height: 1,
                              )
                            : Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.file(
                                      File(
                                        _imageFile!.path,
                                      ),
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                  Positioned(
                                    top: -8,
                                    right: -2,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _imageFile = null;
                                        });
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.red,
                                          size: 30.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (response_controller.text.isEmpty) {
                                  Alert(
                                    context: context,
                                    style: alertStyle,
                                    type: AlertType.warning,
                                    title: "Response can't be empty",
                                    buttons: [
                                      DialogButton(
                                        child: const Text(
                                          "Ok",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        color: const Color.fromRGBO(
                                            91, 55, 185, 1.0),
                                        radius: BorderRadius.circular(10.0),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ).show();
                                } else if (_imageFile == null) {
                                  final datas = Addresponserequest(
                                      response: response_controller.text);
                                  final result = await Addresponseservice()
                                      .addresponse(datas, widget.id);
                                  if (result.success == true) {
                                    setState(() {
                                      response_controller.clear();
                                    });
                                    final snackBar = SnackBar(
                                      content: const Text(
                                          "Response added successfully"),
                                      backgroundColor: (Colors.black),
                                      action: SnackBarAction(
                                        label: 'dismiss',
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                        },
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    final snackBar = SnackBar(
                                      content:
                                          const Text("Unable to add response"),
                                      backgroundColor: (Colors.black),
                                      action: SnackBarAction(
                                        label: 'dismiss',
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                        },
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                } else {
                                  final result = await Addresponseservice()
                                      .addresponsewithimage(widget.id,
                                          response_controller.text, _imageFile);

                                  if (result.success == true) {
                                    setState(() {
                                      response_controller.clear();
                                      _imageFile = null;
                                    });
                                    final snackBar = SnackBar(
                                      content: Text("success"),
                                      backgroundColor: (Colors.black),
                                      action: SnackBarAction(
                                        label: 'dismiss',
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                        },
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    Navigator.pop(context);
                                    final snackBar = SnackBar(
                                      content: Text("error "),
                                      backgroundColor: (Colors.black),
                                      action: SnackBarAction(
                                        label: 'dismiss',
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                        },
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                }
                              },
                              child: const Text("Respond"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // ticket.requestResponse!.isEmpty
                  //     ? const Text("")
                  //     : Text(ticket.requestResponse![0].response!),
                  ticket['requestResponse'].isEmpty
                      ? const SizedBox(
                          height: 1,
                        )
                      : ListView.builder(
                          itemCount: ticket['requestResponse'].length,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemBuilder: (context, i) {
                            var nameInital = ticket['requestResponse'][i]
                                        ['postedBy']['firstname']![0]
                                    .toUpperCase() +
                                "" +
                                ticket['requestResponse'][i]['postedBy']
                                        ['lastname'][0]
                                    .toUpperCase();

                            DateTime replieddate = DateTime.parse(
                                ticket['requestResponse'][i]['createdAt']
                                    .toString());

                            replieddate = replieddate
                                .add(const Duration(hours: 5, minutes: 45));

                            // final date_now = DateTime.now();

                            // final diffrence =
                            //     daysBetween(replieddate, date_now);

                            var formattedreplydate =
                                DateFormat('yMMMMd').format(replieddate);

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      child: Text(
                                        nameInital,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    title: Text(
                                      ticket['requestResponse'][i]['response'],
                                    ),
                                    subtitle: Text(ticket['requestResponse'][i]
                                            ['postedBy']['firstname'] +
                                        " " +
                                        ticket['requestResponse'][i]['postedBy']
                                            ['lastname']),
                                    trailing: Text(
                                      formattedreplydate,
                                      style: const TextStyle(fontSize: 11),
                                    )),
                                ticket['requestResponse'][i]['responseFile'] !=
                                        null
                                    ? TextButton(
                                        onPressed: () {
                                          _launchURL(ticket['requestResponse']
                                                  [i]['responseFile']
                                              .toString());
                                        },
                                        child: Text(
                                          "Attachment: " +
                                              ticket['requestResponse'][i]
                                                      ['responseFile']
                                                  .toString(),
                                        ),
                                      )
                                    : const SizedBox(
                                        height: 1,
                                      ),
                                Divider(
                                  height: 20,
                                  thickness: 10,
                                  indent: 2,
                                  color: Colors.grey.shade200,
                                ),
                              ],
                            );
                          }),
                  const SizedBox(
                    height: 15,
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return const Center(
                child: SpinKitDualRing(
                  color: kPrimaryColor,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  _launchURL(String abc) async {
    String url = api_url2 + 'uploads/files/' + abc;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
