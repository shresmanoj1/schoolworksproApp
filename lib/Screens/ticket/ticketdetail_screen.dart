import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/ticketresponse_response.dart';
import 'package:schoolworkspro_app/response/viewticketresponse.dart';
import 'package:schoolworkspro_app/services/addticketresponse_service.dart';
import 'package:schoolworkspro_app/services/viewticket_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';

class Ticketdetail extends StatefulWidget {
  final int? index;
  const Ticketdetail({Key? key, this.index}) : super(key: key);

  @override
  _TicketdetailState createState() => _TicketdetailState();
}

class _TicketdetailState extends State<Ticketdetail> {
  final TextEditingController response_controller = TextEditingController();
  Stream<Viewticketresponse>? ticketresponse;
  PickedFile? _imageFile;

  @override
  void initState() {
    // TODO: implement initState
    ticketresponse =
        Viewticketservice().getrefreshticket(const Duration(seconds: 1));
    super.initState();
  }

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
      appBar: AppBar(
          title: const Text(
            "Ticket details",
            style: TextStyle(color: white),
          ),
          elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<Viewticketresponse>(
          stream: ticketresponse,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!.tickets![widget.index!];
              return Column(
                children: [
                  Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                          
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: const EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                    color: data.status == "Approved"
                                        ? Colors.green
                                        : kPrimaryColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4.0))),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(data.status!,
                                      style: const TextStyle(
                                          fontSize: 9, color: Colors.white)),
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(data.topic!),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                        color: black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0))
                                    ),
                                    child: Text(data.ticketId!, style: const TextStyle(color: white, fontSize: 12),),
                                  ),
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.list,
                                            size: 15,
                                            color: Colors.grey.withOpacity(0.5),
                                          ),
                                          Text(data.subject!),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Builder(
                                        builder: (context) {
                                          DateTime now = DateTime.parse(data.createdAt.toString());

                                          now = now.add(const Duration(hours: 5, minutes: 45));

                                          var formattedTime = DateFormat('yMMMMd').format(now);
                                          return Row(
                                            children: <Widget>[
                                              const Icon(
                                                Icons.event,
                                                size: 15,
                                                color: Colors.grey,
                                              ),
                                              Text(
                                                formattedTime,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ],
                                          );
                                        }
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          const Icon(
                                            Icons.timelapse,
                                            size: 15,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            DateFormat.jm()
                                                .format(data.createdAt!),
                                            style: const TextStyle(
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Divider(
                                  color: black
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                data.request!,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    color: black,
                                    fontSize: 16
                                ),
                              ),
                            ),
                          ],),
                        ),
                        // widget.data!.tickets![widget.index!].ticketResponse
                        // widget.data!.tickets![widget.index!].ticketResponse == null
                        //     ? const SizedBox(
                        //         height: 1,
                        //       )
                        //     : Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: Row(
                        //           children: [
                        //             const Icon(Icons.attachment),
                        //             const Text("Attachment"),
                        //             TextButton(
                        //                 onPressed: () {
                        //                   _launchURL(widget.data!
                        //                       .tickets![widget.index!].responseFile!);
                        //                 },
                        //                 child: Text(
                        //                   widget.data!.tickets![widget.index!]
                        //                       .responseFile!,
                        //                 )),
                        //           ],
                        //         ),
                        //       ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: response_controller,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Add a response',
                            filled: true,
                            suffixIcon: IconButton(onPressed: (){
                              showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) =>
                                      bottomSheet(context)));

                            }, icon: Icon(Icons.attach_file)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green)),
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always,
                          ),
                        ),
                        // Row(
                        //   children: [
                        //     const Padding(
                        //       padding: EdgeInsets.all(8.0),
                        //       child: Text(
                        //         "Attach File (Optional)",
                        //         style: TextStyle(fontWeight: FontWeight.bold),
                        //       ),
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: GestureDetector(
                        //           onTap: () {
                        //             showModalBottomSheet(
                        //                 context: context,
                        //                 builder: ((builder) =>
                        //                     bottomSheet(context)));
                        //           },
                        //           child: const ElevatedButton(
                        //               onPressed: null,
                        //               child: Text("Choose File"))),
                        //     ),
                        //   ],
                        // ),

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
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(logoTheme),
                                  ),
                              onPressed: () async {
                                // final ticketresponse = await Addticketservice()
                                //     .addmyticketresponsewithimage(data.id!,
                                //         response_controller.text, _imageFile);

                                // if (ticketresponse.success == true) {
                                //   Fluttertoast.showToast(msg: "success");
                                // } else {
                                //   Fluttertoast.showToast(
                                //       msg: "error while adding response");
                                // }
                                if (_imageFile == null) {
                                  final result = await Addticketservice()
                                      .addmyticketresponsewithoutimage(
                                          data.id!, response_controller.text);
                                  if (result.success == true) {
                                    setState(() {
                                      response_controller.clear();
                                    });
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                super.widget));
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
                                    // Navigator.pop(context);
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
                                } else {
                                  final result = await Addticketservice()
                                      .addmyticketresponsewithimage(data.id!,
                                          response_controller.text, _imageFile);
                                  if (result.success == true) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                super.widget));
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
                                    // Navigator.pop(context);
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
                  ListView.builder(
                      itemCount: data.ticketResponse!.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, i) {
                        var nameInital = data
                                .ticketResponse![i].postedBy!.firstname![0]
                                .toUpperCase() +
                            "" +
                            data.ticketResponse![i].postedBy!.lastname![0]
                                .toUpperCase();

                        DateTime replieddate = DateTime.parse(
                            data.ticketResponse![i].createdAt.toString());

                        replieddate = replieddate
                            .add(const Duration(hours: 5, minutes: 45));
                        var formattedreplydate =
                            DateFormat('yMMMMd').format(replieddate);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Text(
                                  nameInital,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data.ticketResponse![i].response!),
                                  data.ticketResponse![i].responseFile == null
                                      ? const SizedBox(
                                          height: 1,
                                        )
                                      : TextButton(
                                          onPressed: () {
                                            _launchURL(data.ticketResponse![i]
                                                .responseFile!);
                                          },
                                          child: Text("Attachment: " +
                                              data.ticketResponse![i]
                                                  .responseFile!),
                                        ),
                                ],
                              ),
                              subtitle: Text(data
                                      .ticketResponse![i].postedBy!.firstname! +
                                  " " +
                                  data.ticketResponse![i].postedBy!.lastname!),
                              trailing: Text(
                                formattedreplydate,
                                style: const TextStyle(fontSize: 11),
                              )),
                        );
                      }),
                  const SizedBox(
                    height: 15,
                  )
                ],
              );
            } else {
              return const Center(
                  child: CupertinoActivityIndicator()
              //     SpinKitDualRing(
              //   color: kPrimaryColor,
              // )
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
