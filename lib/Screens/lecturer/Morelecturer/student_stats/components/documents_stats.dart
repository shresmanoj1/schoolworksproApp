import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/components/shimmer.dart';
import 'package:schoolworkspro_app/request/lecturer/stats_request.dart';
import 'package:schoolworkspro_app/response/lecturer/getdocument_stats_response.dart';
import 'package:schoolworkspro_app/services/lecturer/studentstats_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../response/login_response.dart';

class DocumentStats extends StatefulWidget {
  final data;
  const DocumentStats({Key? key, this.data}) : super(key: key);

  @override
  _DocumentStatsState createState() => _DocumentStatsState();
}

class _DocumentStatsState extends State<DocumentStats> {
  Future<GetDocumentForStatsResponse>? document_response;

  @override
  void initState() {
    // TODO: implement initState

    getData();
    super.initState();
  }

  getData() async {
    final username = StudentStatsRequest(username: widget.data['username']);
    document_response =
        StudentStatsLecturerService().getUserDocuments(username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          "Documents",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<GetDocumentForStatsResponse>(
            future: document_response,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.documents!.isEmpty
                    ? Column(children: <Widget>[
                        Image.asset("assets/images/no_content.PNG"),
                        const Text(
                          "No document submitted",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                      ])
                    : ListView.builder(
                        itemCount: snapshot.data?.documents?.length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          var datas = snapshot.data?.documents?[index];
                          return Card(
                            clipBehavior: Clip.antiAlias,
                            margin: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                datas['docType'] == null
                                    ? const Text("")
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          datas['docType'],
                                          style: (const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                Image.network(api_url2 +
                                    "/uploads/docs/" +
                                    datas['docName']),
                                const SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          );
                        },
                      );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return VerticalLoader();
              }
            },
          ),
        ),
      ),
    );
  }
}
