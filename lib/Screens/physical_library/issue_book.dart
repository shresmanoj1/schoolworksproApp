import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/physical_library/library_view_model.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/request/issuebook_request.dart';
import 'package:schoolworkspro_app/response/addproject_response.dart';
import 'package:schoolworkspro_app/response/addrequest_response.dart';
import 'package:schoolworkspro_app/services/issuebook_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../../response/login_response.dart';

class IssueBook extends StatefulWidget {
  final data;
  const IssueBook({Key? key, this.data}) : super(key: key);

  @override
  _IssueBookState createState() => _IssueBookState();
}

class _IssueBookState extends State<IssueBook> {
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryViewModel>(
        builder: (context, libraryViewModel, child) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            title: const Text(
              "Confirm Request",
              style: TextStyle(color: white),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl:
                        "$api_url2/uploads/library/${widget.data['thumbnail']}",
                    placeholder: (context, url) =>
                        const Center(child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  Text(
                    widget.data['name'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Author: ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                          TextSpan(
                            text: widget.data['author'],
                            style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                        ]),
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Quantity: ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                          TextSpan(
                            text: widget.data['quantity'].toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 95,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              // Map<String, dynamic> datas = {
                              //   "book_slug": widget.data['slug'],
                              //   "username": user?.username.toString()
                              // };
                              final datas = Issuebookrequest(
                                  bookSlug: widget.data['slug'],
                                  username: user?.username.toString());
                              Addprojectresponse res = await IssueBookService()
                                  .createAlbum(widget.data['slug'],
                                      user!.username.toString());

                              if (res.success == true) {
                                libraryViewModel.fetchDigitalBooks();
                                libraryViewModel.fetchAllBooks();
                                Fluttertoast.showToast(
                                    msg: res.message.toString());
                              } else {
                                Fluttertoast.showToast(
                                    msg: res.message.toString());
                              }
                            } on Exception catch (e) {
                              Fluttertoast.showToast(msg: e.toString());
                              // TODO
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.pink),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ))),
                          child: const Text(
                            "Request",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 40,
                        width: 95,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ))),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      color: Colors.lightBlue.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Please, visit library to collect the book you requested',
                          style: TextStyle(color: Colors.blue),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ));
    });
  }
}
