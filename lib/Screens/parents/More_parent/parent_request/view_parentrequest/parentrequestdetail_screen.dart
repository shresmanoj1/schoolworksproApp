import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:schoolworkspro_app/Screens/parents/More_parent/parent_request/view_parentrequest/parent_request_view_model.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/myrequest_request.dart';
import 'package:schoolworkspro_app/response/parents/getparentticketdetail_response.dart';
import 'package:schoolworkspro_app/services/addresponserequest_service.dart';
import 'package:schoolworkspro_app/services/parents/getparentrequest_service.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../config/api_response_config.dart';
import '../../../../../constants/colors.dart';
import '../../../../request/addrequest_screen.dart';

class Parentrequestdetailscreen extends StatefulWidget {
  final String id;
  final bool isParent;
  const Parentrequestdetailscreen({Key? key, required this.id, this.isParent = false})
      : super(key: key);

  @override
  _ParentrequestdetailscreenState createState() =>
      _ParentrequestdetailscreenState();
}

class _ParentrequestdetailscreenState extends State<Parentrequestdetailscreen> {
  Future<Getparentticketdetailresponse>? detail_response;

  late ParentRequestViewModel _provider;

  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<ParentRequestViewModel>(context, listen: false);

      _provider.fetchRequestDetails(widget.id);
    });
    // detail_response = Getparentrequestservice()
    //     .getrefreshticketdetail(widget.id, const Duration(milliseconds: 2));
    super.initState();
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
    return Consumer<ParentRequestViewModel>(
        builder: (context, snapshot, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Request detail',
            style: TextStyle(color: white),
          ),
          elevation: 0.0,
          actions: isLoading(snapshot.parentRequestApiResponse) ||
                  snapshot.parentRequest.request == null
              ? []
              : snapshot.parentRequest.request?.status == "Resolved"
                  ? []
                  : widget.isParent == true ? [] : [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Addrequestscreen(
                                        showAppbar: true,
                                        data: snapshot.parentRequest.request,
                                        isUpdate: true,
                                        isFromRoutine: false,
                                      )));
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              // width: 80,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: Color(0xffD03579),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.edit_note,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Edit",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      ),
                    ],
          // iconTheme: const IconThemeData(color: Colors.black),
          // backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: isLoading(snapshot.parentRequestApiResponse)
              ? const VerticalLoader()
              : snapshot.parentRequest.request == null
                  ? Column(children: <Widget>[
                      Image.asset("assets/images/no_content.PNG"),
                    ])
                  : Builder(builder: (context) {
                      var ticket = snapshot.parentRequest.request;

                      DateTime now =
                          DateTime.parse(ticket!.createdAt.toString());

                      now = now.add(const Duration(hours: 5, minutes: 45));

                      var formattedTime = DateFormat('yMMMMd').format(now);
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Color(0xffB4B4B4)),
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 80,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            decoration: BoxDecoration(
                                                color: ticket.status ==
                                                        "Resolved"
                                                    ? Colors.green
                                                    : ticket.status == "Pending"
                                                        ? Color(0xff8D6708)
                                                        : kPrimaryColor,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(4.0))),
                                            child: Center(
                                              child: Text(ticket.status!,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: white,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ),
                                          ),
                                          Text(
                                            ticket.topic!,
                                            style: const TextStyle(
                                                color: black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: black,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  const Icon(
                                                    Icons.map,
                                                    size: 15,
                                                    color: white,
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                          ticket.ticketId!,
                                                          style: TextStyle(
                                                              color: white))),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Row(
                                                children: <Widget>[
                                                  const Icon(
                                                    Icons.timer,
                                                    size: 15,
                                                    color: Color(0xff676767),
                                                  ),
                                                  Text(formattedTime),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              Row(
                                                children: <Widget>[
                                                  const Icon(
                                                    Icons.thermostat,
                                                    size: 15,
                                                    color: Color(0xff676767),
                                                  ),
                                                  Text(
                                                    ticket.severity!,
                                                    style: TextStyle(
                                                        color: ticket
                                                                    .severity ==
                                                                "High"
                                                            ? Colors.red
                                                            : ticket.severity ==
                                                                    "Low"
                                                                ? Colors
                                                                    .yellowAccent
                                                                : logoTheme),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              Row(
                                                children: <Widget>[
                                                  const Icon(
                                                    Icons.list,
                                                    size: 15,
                                                    color: Color(0xff676767),
                                                  ),
                                                  Text(
                                                    ticket.subject!,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff676767)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Divider(color: black),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        ticket.request!,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                      ),
                                    ),
                                    ticket.subject == "Leave" &&
                                            ticket.leaves != null
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Divider(
                                                    color: Colors.blueAccent,
                                                    thickness: 3),
                                                const Text(
                                                  "Leave Details",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.calendar_month),
                                                    Row(
                                                      children: [
                                                        Text(DateFormat.yMMMEd()
                                                            .format(DateTime.parse(
                                                                    ticket.leaves![
                                                                        "startDate"]).toLocal()
                                                                )),
                                                        const Text(" - "),
                                                        Text(DateFormat.yMMMEd()
                                                            .format(DateTime.parse(
                                                                    ticket.leaves![
                                                                        "endDate"]).subtract(Duration(days: 1))
                                                            .toLocal()))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Container(
                                                  width: 80,
                                                  height: 30,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 5,
                                                      horizontal: 5),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          4.0))),
                                                  child: Center(
                                                    child: Text(
                                                        ticket.leaves["status"],
                                                        style: const TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                ticket.leaves["allDay"] == true
                                                    ? SizedBox()
                                                    : Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            "Modules/Subjects:",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 16),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Column(
                                                            children: [
                                                              ...List.generate(
                                                                  ticket
                                                                      .leaves[
                                                                          "routines"]
                                                                      .length,
                                                                  (index) {
                                                                return Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(ticket.leaves["routines"][index]
                                                                            [
                                                                            "title"]),
                                                                        const SizedBox(
                                                                          width:
                                                                              4,
                                                                        ),
                                                                        const Text(
                                                                            "@"),
                                                                        Text(ticket
                                                                            .leaves["routines"][index]["date"]
                                                                            .toString())
                                                                      ],
                                                                    )
                                                                  ],
                                                                );
                                                              }),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(),
                                    // ticket.status == "Resolved"
                                    //     ? SizedBox()
                                    //     :
                                    ticket.requestFile == null || ticket.requestFile!.isEmpty
                                        ? const SizedBox(
                                            height: 1,
                                          )
                                        : Builder(builder: (context) {
                                            print(
                                                "NOT NULL::${ticket.requestFile}");
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Attachments:",
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 16)),
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount: ticket
                                                        .requestFile!.length,
                                                    itemBuilder: (context, l) {
                                                      return Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          TextButton(
                                                              onPressed: () {
                                                                _launchURL(ticket
                                                                    .requestFile![l]);
                                                              },
                                                              child: Text(
                                                                ticket.requestFile![
                                                                    l],
                                                              )),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                  ]),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: response_controller,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: ((builder) =>
                                              bottomSheet(context)));
                                    },
                                    icon: const Icon(
                                      Icons.attach_file,
                                      color: black,
                                    )),
                                hintText: 'Add a response',
                                filled: true,
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: kPrimaryColor)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
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
                            const SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(logoTheme),
                                ),
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
                                        content: const Text(
                                            "Unable to add response"),
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
                                        .addresponsewithimage(
                                            widget.id,
                                            response_controller.text,
                                            _imageFile);

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
                                child: const Text(
                                  "Respond",
                                  style: TextStyle(color: white, fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // ticket.requestResponse!.isEmpty
                            //     ? const Text("")
                            //     : Text(ticket.requestResponse![0].response!),
                            ticket.requestResponse!.isEmpty
                                ? const SizedBox(
                                    height: 1,
                                  )
                                : ListView.builder(
                                    itemCount: ticket.requestResponse!.length,
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemBuilder: (context, i) {
                                      var nameInital = ticket
                                              .requestResponse![i]
                                              .postedBy!
                                              .firstname![0]
                                              .toUpperCase() +
                                          "" +
                                          ticket.requestResponse![i].postedBy!
                                              .lastname![0]
                                              .toUpperCase();

                                      DateTime replieddate = DateTime.parse(
                                          ticket.requestResponse![i].createdAt
                                              .toString());

                                      replieddate = replieddate.add(
                                          const Duration(
                                              hours: 5, minutes: 45));

                                      // final date_now = DateTime.now();

                                      // final diffrence =
                                      //     daysBetween(replieddate, date_now);

                                      var formattedreplydate =
                                          DateFormat('yMMMMd')
                                              .format(replieddate);

                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor: Colors.grey,
                                                child: Text(
                                                  nameInital,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              title: Text(
                                                ticket.requestResponse![i]
                                                    .response!,
                                              ),
                                              subtitle: Text(ticket
                                                      .requestResponse![i]
                                                      .postedBy!
                                                      .firstname! +
                                                  " " +
                                                  ticket.requestResponse![i]
                                                      .postedBy!.lastname!),
                                              trailing: Text(
                                                formattedreplydate,
                                                style: const TextStyle(
                                                    fontSize: 11),
                                              )),
                                          ticket.requestResponse![i]
                                                      .responseFile !=
                                                  null
                                              ? Align(
                                                  alignment: Alignment.center,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      _launchURL(ticket
                                                          .requestResponse![i]
                                                          .responseFile
                                                          .toString());
                                                    },
                                                    child: Text(
                                                      ticket.requestResponse![i]
                                                          .responseFile
                                                          .toString(),
                                                    ),
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
                        ),
                      );
                    }),
        ),
      );
    });
  }

  _launchURL(String abc) async {
    String url = api_url2 + '/uploads/files/' + abc;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
