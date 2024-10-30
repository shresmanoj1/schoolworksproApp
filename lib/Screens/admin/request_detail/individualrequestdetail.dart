import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/admin/admin_requestdetailsresponse.dart';
import 'package:schoolworkspro_app/services/admin/getassignedrequest_service.dart';
import 'package:schoolworkspro_app/services/admin/responserequest_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helper/custom_loader.dart';

class IndividualRequestDetail extends StatefulWidget {
  final id;
  const IndividualRequestDetail({Key? key, this.id}) : super(key: key);

  @override
  _IndividualRequestDetailState createState() =>
      _IndividualRequestDetailState();
}

class _IndividualRequestDetailState extends State<IndividualRequestDetail> {
  Future<AdminRequestDetailResponse>? request_response;
  bool isloading = false;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }



  PickedFile? _imageFile;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController request_controller = new TextEditingController();

  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage(ImageSource source) async {
    var selected =
    await ImagePicker().pickImage(source: source, imageQuality: 10);

    setState(() {
      if (selected != null) {
        _imageFile = PickedFile(selected.path);
      } else {
        Fluttertoast.showToast(msg: 'No image selected');
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
    if (isloading == true) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          "Ticket detail",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: ChangeNotifierProvider<AssignedRequestService>(
            create: (context) => AssignedRequestService(),
            child: Consumer<AssignedRequestService>(
                builder: (context, provider, child) {
                  provider.ticketdetails(context, widget.id);
                  if (provider.data2?.request == null) {
                    provider.ticketdetails(context, widget.id);
                    return const Center(child: CupertinoActivityIndicator()
                      //     SpinKitDualRing(
                      //   color: kPrimaryColor,
                      // )
                    );
                  }
                  var datas = provider.data2!.request;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              datas['topic'],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          datas["leaves"] == null ||
                              datas["leaves"]["startDate"] == null
                              ? const SizedBox()
                              : Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "From",
                                      // style: TextStyle(
                                      //     fontWeight: FontWeight.bold,
                                      //     fontSize: 16),
                                    ),
                                    Text(
                                      DateFormat.yMMMEd().format(
                                          DateTime.parse(datas["leaves"]
                                          ["startDate"])
                                              .toLocal()),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "To",
                                      // style: TextStyle(
                                      //     fontWeight: FontWeight.bold,
                                      //     fontSize: 16),
                                    ),
                                    Text(DateFormat.yMMMEd().format(
                                        DateTime.parse(
                                            datas["leaves"]["endDate"])
                                            .subtract(Duration(days: 1))
                                            .toLocal())),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text('Assigned To'),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    CircleAvatar(
                                        radius: 15.0,
                                        backgroundColor: Colors.grey,
                                        child: Text(
                                          datas['assignedTo']['firstname'][0]
                                              .toUpperCase() +
                                              "" +
                                              datas['assignedTo']['lastname'][0]
                                                  .toUpperCase(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Requested By'),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    CircleAvatar(
                                        radius: 15.0,
                                        backgroundColor: Colors.pinkAccent,
                                        child: Text(
                                          datas['postedBy']['firstname'][0]
                                              .toUpperCase() +
                                              "" +
                                              datas['postedBy']['lastname'][0]
                                                  .toUpperCase(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(datas['assignedTo']['firstname'] +
                                        " " +
                                        datas['assignedTo']['lastname'])
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(datas['postedBy']['firstname'] +
                                        " " +
                                        datas['postedBy']['lastname']),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.flag),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Request",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                  child: Chip(
                                    backgroundColor: Colors.black,
                                    label: Text(
                                      datas['ticketId'],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ))
                            ],
                          ),
                          Text(
                            datas['request'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: const [
                              Icon(Icons.attach_file),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Attachment:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          datas['requestFile'] == null ||
                              datas['requestFile'].isEmpty
                              ? SizedBox()
                              : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: datas['requestFile'].length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                  onTap: () async {
                                    String url = '$api_url2/uploads/files/' +
                                        datas['requestFile'][index];
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Text(
                                    datas['requestFile'][index],
                                    style:
                                    const TextStyle(color: Colors.blue),
                                  ));
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: const [
                              Icon(Icons.comment_outlined),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Comments:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const ScrollPhysics(),
                              itemCount: datas['requestResponse'].length,
                              itemBuilder: (context, i) {
                                var commentData = datas['requestResponse'][i];

                                DateTime now = DateTime.parse(
                                    commentData['createdAt'].toString());

                                now =
                                    now.add(const Duration(hours: 5, minutes: 45));

                                var formattedTime2 =
                                DateFormat('MMMM d, y').format(now);
                                var nameInital = commentData['postedBy']
                                ['firstname'][0]
                                    .toUpperCase() +
                                    "" +
                                    commentData['postedBy']['lastname'][0]
                                        .toUpperCase();

                                return ListTile(
                                    leading: commentData['postedBy']['userImage'] !=
                                        null
                                        ? CircleAvatar(
                                        backgroundImage: NetworkImage(api_url2 +
                                            '/uploads/users/' +
                                            commentData['postedBy']
                                            ['userImage']))
                                        : CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      child: Text(
                                        nameInital,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(commentData['response']),
                                        commentData['responseFile'] == null ||
                                            commentData['responseFile'].isEmpty
                                            ? const SizedBox()
                                            : GestureDetector(
                                          onTap: () async {
                                            String url = api_url2 +
                                                '/uploads/files/' +
                                                commentData['responseFile'];
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          },
                                          child: Text(
                                            commentData['responseFile'],
                                            style: const TextStyle(
                                                color: Colors.blue),
                                          ),
                                        )
                                      ],
                                    ),
                                    trailing: Text(formattedTime2),
                                    title: Text(commentData['postedBy']
                                    ['firstname'] +
                                        " " +
                                        commentData['postedBy']['lastname']));
                              }),
                          Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      controller: request_controller,
                                      keyboardType: TextInputType.text,
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          return 'Request cant be empty';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        hintText: 'Response',
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.grey)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.green)),
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    icon: Icon(Icons.attach_file),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: ((builder) =>
                                              bottomSheet(context)));
                                    },
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 15.0, top: 15.0),
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
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 15.0, top: 15.0),
                                child: SizedBox(
                                  height: 40,
                                  width: 95,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        if (_imageFile != null) {
                                          setState(() {
                                            isloading = true;
                                          });
                                          try {
                                            setState(() {
                                              isloading = true;
                                            });
                                            final response =
                                            await AdminRespondResponseService()
                                                .respondwithImage(
                                                datas['_id'],
                                                request_controller.text,
                                                _imageFile!);
                                            if (response.success == true) {
                                              setState(() {
                                                isloading = true;
                                              });
                                              snackThis(
                                                  content: const Text(
                                                      "Response added successfully"),
                                                  color: Colors.green,
                                                  behavior: SnackBarBehavior.fixed,
                                                  duration: 2,
                                                  context: context);

                                              setState(() {
                                                request_controller.clear();
                                                _imageFile = null;
                                                isloading = false;
                                              });
                                            } else {
                                              setState(() {
                                                isloading = true;
                                              });
                                              snackThis(
                                                  content: const Text(
                                                      "Failed to post response"),
                                                  color: Colors.red,
                                                  behavior: SnackBarBehavior.fixed,
                                                  duration: 2,
                                                  context: context);
                                              setState(() {
                                                isloading = false;
                                              });
                                            }
                                          } on Exception catch (e) {
                                            setState(() {
                                              isloading = true;
                                            });
                                            snackThis(
                                                content: Text(e.toString()),
                                                color: Colors.red,
                                                behavior: SnackBarBehavior.fixed,
                                                duration: 2,
                                                context: context);
                                            // Fluttertoast.showToast(msg: e.toString());
                                            setState(() {
                                              isloading = false;
                                            });
                                            // TODO
                                          }
                                        } else {
                                          try {
                                            setState(() {
                                              isloading = true;
                                            });
                                            final response =
                                            await AdminRespondResponseService()
                                                .respondwithoutImage(
                                              datas['_id'],
                                              request_controller.text,
                                            );
                                            if (response.success == true) {
                                              setState(() {
                                                isloading = true;
                                              });
                                              snackThis(
                                                  content: const Text(
                                                      "Response added successfully"),
                                                  color: Colors.green,
                                                  behavior: SnackBarBehavior.fixed,
                                                  duration: 2,
                                                  context: context);

                                              setState(() {
                                                request_controller.clear();
                                                _imageFile = null;
                                                isloading = false;
                                              });
                                            } else {
                                              setState(() {
                                                isloading = true;
                                              });
                                              snackThis(
                                                  content: const Text(
                                                      "Failed to post response"),
                                                  color: Colors.red,
                                                  behavior: SnackBarBehavior.fixed,
                                                  duration: 2,
                                                  context: context);

                                              setState(() {
                                                isloading = false;
                                              });
                                            }
                                          } on Exception catch (e) {
                                            setState(() {
                                              isloading = true;
                                            });
                                            snackThis(
                                                content: Text(e.toString()),
                                                color: Colors.red,
                                                behavior: SnackBarBehavior.fixed,
                                                duration: 2,
                                                context: context);
                                            setState(() {
                                              isloading = false;
                                            });
                                            // TODO
                                          }
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
                                      "Reply",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 150,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                })),
      ),
    );
  }
}

