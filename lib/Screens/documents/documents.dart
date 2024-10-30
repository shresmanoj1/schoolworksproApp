import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:schoolworkspro_app/Screens/documents/view_document_photo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/components/internetcheck.dart';
import 'package:schoolworkspro_app/components/nointernet_widget.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:schoolworkspro_app/services/document_service.dart';

import '../../response/authenticateduser_response.dart';
import '../../response/document_response.dart';

class Documentscreen extends StatefulWidget {
  const Documentscreen({Key? key}) : super(key: key);

  @override
  _DocumentscreenState createState() => _DocumentscreenState();
}

class _DocumentscreenState extends State<Documentscreen> {
  late bool connected = false;
  late User user;
  late List<String> allDocumentType;

  @override
  void initState() {
    super.initState();
    allDocumentType = [];
    getUser();
    checkInternet();
  }

  void checkInternet() async {
    internetCheck().then((value) {
      setState(() {
        connected = value;
      });
    });
  }

  void getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    setState(() {
      user = User.fromJson(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentService>(builder: (context, provider, child) {
      provider.getDocuments(context);
      if (provider.data == null) {
        provider.getDocuments(context);
        return const Scaffold(body: Center(child: CupertinoActivityIndicator()));
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Documents",
            style: TextStyle(color: kWhite, fontWeight: FontWeight.w800),
          ),
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: kWhite, //change your color here
          ),
          backgroundColor: const Color(0xff004D96),
        ),
        floatingActionButton: connected
            ? SpeedDial(
                icon: Icons.add,
                foregroundColor: kWhite,
                backgroundColor: const Color(0xff004D96),
                curve: Curves.fastLinearToSlowEaseIn,
                closeManually: false,
                children: user.institution == "School"
                    ? documentTypes
                        .where((documentType) =>
                            documentType.label == "Medical History")
                        .map((documentType) => SpeedDialChild(
                              child: Icon(documentType.icon, color: kWhite),
                              backgroundColor: documentType.backgroundColor,
                              label: documentType.label,
                              onTap: () => Navigator.pushNamed(
                                  context, "/slccertificate",
                                  arguments: documentType.type),
                            ))
                        .toList()
                    : documentTypes
                        .where((documentType) =>
                            !allDocumentType.contains(documentType.label))
                        .map((documentType) => SpeedDialChild(
                              child: Icon(documentType.icon, color: kWhite),
                              backgroundColor: documentType.backgroundColor,
                              label: documentType.label,
                              onTap: () => Navigator.pushNamed(
                                  context, "/slccertificate",
                                  arguments: documentType.type),
                            ))
                        .toList(),
              )
            : null,
        body: connected
            ? provider.data == null || provider.data!.documents == null || provider.data!.documents!.isEmpty
                ? const Center(child: NoDocumentsWidget())
                : ListView.builder(
                    itemCount: provider.data!.documents!.length,
                    itemBuilder: (context, i) {
                      var datas = provider.data!.documents![i];
                      if (!allDocumentType.contains(datas.docType!)) {
                        allDocumentType.add(datas.docType!);
                      }
                      print("ALL DOCUMENTS::::${allDocumentType}");
                      return buildDocumentCard(datas);
                    },
                  )
            : const NoInternetWidget(),
      );
    });
  }

  Widget buildDocumentCard(Document datas) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 199,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 10),
                child: Text(
                  datas.docType ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              datas.docName == null
                  ? const Text("")
                  : Builder(
                      builder: (context) {
                        bool imageType = datas.docName!.contains("/uploads");
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) {
                                  return ViewFullScreenStudentDocument(
                                    imageIndex: 0,
                                    heroTitle: "image0",
                                    document: datas.docName.toString(),
                                  );
                                },
                                fullscreenDialog: true,
                              ),
                            );
                          },
                          child: Image.network(
                            imageType
                                ? "$api_url2/${datas.docName!}"
                                : "$api_url2/uploads/docs/${datas.docName!}",
                            fit: BoxFit.contain,
                            height: 104,
                            width: double.infinity,
                          ),
                        );
                      },
                    ),
              const SizedBox(height: 5),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/slccertificate',
                      arguments: datas.docType);
                },
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ),
                    color: Color(0xff004D96),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: const Center(
                    child: Text(
                      "Update",
                      style: TextStyle(
                        color: kWhite,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<DocumentType> documentTypes = [
    DocumentType(
      label: "Citizenship",
      icon: Icons.document_scanner,
      backgroundColor: const Color(0xff004D96),
      type: "Citizenship",
    ),
    DocumentType(
      label: "SEE/SLC Marksheet",
      icon: Icons.document_scanner,
      backgroundColor: const Color(0xff004D96),
      type: "SEE/SLC Marksheet",
    ),
    DocumentType(
      label: "School Character Certificate",
      icon: Icons.document_scanner,
      backgroundColor: const Color(0xff004D96),
      type: "School Character Certificate",
    ),
    DocumentType(
      label: "HSEB Transcript",
      icon: Icons.document_scanner,
      backgroundColor: kPrimaryColor,
      type: "HSEB Transcript",
    ),
    DocumentType(
      label: "HSEB character Certificate",
      icon: Icons.document_scanner,
      backgroundColor: kPrimaryColor,
      type: "HSEB Character Certificate",
    ),
    DocumentType(
      label: "Medical History",
      icon: Icons.document_scanner,
      backgroundColor: kPrimaryColor,
      type: "Medical History",
    ),
    DocumentType(
      label: "Undergraduate Transcript",
      icon: Icons.document_scanner,
      backgroundColor: kPrimaryColor,
      type: "Undergraduate Transcript",
    ),
    DocumentType(
      label: "Undergraduate Certificate",
      icon: Icons.document_scanner,
      backgroundColor: kPrimaryColor,
      type: "Undergraduate Certificate",
    ),
  ];
}

class NoDocumentsWidget extends StatelessWidget {
  const NoDocumentsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Image.asset("assets/images/no_content.PNG"),
        const Text(
          "No documents submitted",
          style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        const Text(
          "Please submit required documents",
          style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ],
    );
  }
}

class DocumentType {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final String type;

  DocumentType({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.type,
  });
}
