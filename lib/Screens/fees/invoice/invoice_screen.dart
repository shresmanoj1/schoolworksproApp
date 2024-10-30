import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/institutiondetail_response.dart';
import 'package:schoolworkspro_app/services/institution_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
import '../../../response/login_response.dart';

class Invoicescreen extends StatefulWidget {
  final datas;
  const Invoicescreen({Key? key, this.datas}) : super(key: key);

  @override
  _InvoicescreenState createState() => _InvoicescreenState();
}

class _InvoicescreenState extends State<Invoicescreen> {
  Future<InstitutionDetailForIdResponse>? institution_response;
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    institution_response = InstitutionService().getInstitutionDetail();
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
    return Scaffold(
      appBar: AppBar(
        // actions: [
        //
        // ],
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<InstitutionDetailForIdResponse>(
        future: institution_response,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var datas = snapshot.data?.institution;
            return ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Receipt",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    Text(
                      datas['name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      datas['address'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      datas['contact'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Name of student: ',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' ${user?.firstname.toString()}',
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.dotted,
                                )),
                            TextSpan(
                                text: ' ${user?.lastname.toString()}',
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.dotted,
                                )),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Batch: ',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' ${user?.batch.toString()}',
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.dotted,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Enrolled in: ',
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' ${user?.course.toString()}',
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.dotted,
                              fontSize: 14,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Builder(builder: (context) {
                  DateTime start = DateTime.parse(widget.datas["payment_date"]);

                  start = start.add(const Duration(hours: 5, minutes: 45));

                  var formattedTime = DateFormat('yMMMMd').format(start);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                        text: 'Date of payment: ',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: formattedTime,
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.dotted,
                                fontSize: 14,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Receipt no: ',
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.datas['receipt_no'].toString(),
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.dotted,
                              fontSize: 14,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),

                Center(
                  child: DataTable(
                    columns: const [
                      DataColumn(
                          label: Text('Particulars',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold))),

                      DataColumn(
                          label: Text('Paid Amount',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold))),
                      // DataColumn(
                      //     label: Text('Edu Tax',
                      //         style: TextStyle(
                      //             fontSize: 15,
                      //             fontWeight:
                      //             FontWeight
                      //                 .bold))),
                      // DataColumn(
                      //     label: Text('Discount',
                      //         style: TextStyle(
                      //             fontSize: 15,
                      //             fontWeight:
                      //             FontWeight
                      //                 .bold))),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Wrap(
                            children: [
                              Text(widget.datas['feePayment_type'] != null
                                  ? widget.datas['feePayment_type']
                                  : ""),
                              Text(
                                widget.datas['batch_name'] == null
                                    ? ""
                                    : " (" + widget.datas['batch_name'] + ")",
                              ),
                            ],
                          ),
                        )),
                        DataCell(Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Text(widget.datas['amount_paid'] != null
                              ? widget.datas['amount_paid']
                              : ""),
                        )),
                      ]),
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Edu Tax: ',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.datas['edu_tax'] != null
                                    ? widget.datas['edu_tax']
                                    : "",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Discount: ',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.datas['referred_discount'] != null
                                    ? widget.datas['referred_discount']
                                    : "",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Payment method: ',
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.datas['payment_method'].toString(),
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Recieved by: ',
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              widget.datas['received_by_firstname'].toString(),
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                        const TextSpan(
                          text: " ",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        TextSpan(
                          text: widget.datas['received_by_lastname'].toString(),
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Powered by",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                        height: 50,
                        width: 120,
                        child: Image.asset('assets/images/logo.png'))
                  ],
                ),
                // ButtonBar(
                //   children: [
                //     FlatButton.icon(
                //       shape: RoundedRectangleBorder(
                //           borderRadius: new BorderRadius.circular(18.0),
                //           side: BorderSide(color: Colors.green)),
                //       color: Colors.green,
                //       label: Text("Save as Pdf"),
                //       icon: Icon(Icons.save),
                //       onPressed: () {
                //         exportToPdf(widget.datas, datas);
                //       },
                //     )
                //
                //     // IconButton(
                //     //     onPressed: () => exportToPdf(),
                //     //     icon: const Icon(
                //     //       Icons.save,
                //     //       color: Colors.black,
                //     //     )),
                //   ],
                // )
                // Container(
                //   child: ,
                // ),
                // Container(
                //   child: Image.network(
                //     api_url2 +
                //         'uploads/' +
                //         datas['footerLogo'],
                //     width: double.infinity,
                //     height: 100,
                //   ),
                // ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const Center(
              child: CupertinoActivityIndicator()
              // SpinKitDualRing(color: kPrimaryColor),
            );
          }
        },
      ),
    );
  }

  Future<void> exportToPdf(dynamic financeData, dynamic institutionData) async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    // final pdf = pw.Document();

    PdfGrid grid = PdfGrid();
    //
    grid.columns.add(count: 3);
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Particulars';
    header.cells[1].value = 'Batch name';
    header.cells[2].value = 'Amount paid';

    PdfGridRow row = grid.rows.add();

    row.cells[0].value = financeData['feePayment_type'] != null
        ? financeData['feePayment_type']
        : "";
    row.cells[1].value =
        financeData['batch_name'] != null ? financeData['batch_name'] : "";
    row.cells[2].value =
        financeData['amount_paid'] != null ? financeData['amount_paid'] : "";

    grid.draw(page: page, bounds: const Rect.fromLTRB(0, 300, 0, 0));

    page.graphics.drawString("Receipt",
        PdfStandardFont(PdfFontFamily.helvetica, 24, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(220, 20, 0, 0));

    page.graphics.drawString(institutionData['name'],
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(90, 50, 0, 0));
    page.graphics.drawString(institutionData['address'],
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(120, 70, 0, 0));
    page.graphics.drawString(institutionData['contact'],
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(160, 90, 0, 0));

    page.graphics.drawString('Name of Student: ${financeData["full_name"]}',
        PdfStandardFont(PdfFontFamily.helvetica, 15),
        bounds: const Rect.fromLTWH(0, 150, 0, 0));
    page.graphics.drawString('Enrolled in: ${user?.course.toString()}',
        PdfStandardFont(PdfFontFamily.helvetica, 15),
        bounds: const Rect.fromLTWH(0, 170, 0, 0));
    page.graphics.drawString(
        'Date of payment: ${DateFormat('yMMMMd').format(DateTime.parse(financeData["payment_date"]).add(const Duration(hours: 4, minutes: 45)))}',
        PdfStandardFont(PdfFontFamily.helvetica, 15),
        bounds: const Rect.fromLTWH(0, 190, 0, 0));
    page.graphics.drawString('Receipt no: ${financeData["receipt_no"]}',
        PdfStandardFont(PdfFontFamily.helvetica, 15),
        bounds: const Rect.fromLTWH(0, 210, 0, 0));

    page.graphics.drawString('Batch: ${user?.batch.toString()}',
        PdfStandardFont(PdfFontFamily.helvetica, 15),
        bounds: const Rect.fromLTWH(300, 150, 0, 0));

    page.graphics.drawString('Payment method: ${financeData['payment_method']}',
        PdfStandardFont(PdfFontFamily.helvetica, 15),
        bounds: const Rect.fromLTWH(10, 450, 0, 0));
    page.graphics.drawString(
        'Received by: ${financeData['received_by_firstname'] != null ? financeData['received_by_firstname'] : ""}',
        PdfStandardFont(PdfFontFamily.helvetica, 15),
        bounds: const Rect.fromLTWH(10, 470, 0, 0));

    page.graphics.drawString(
        'Edu Tax: ${financeData['edu_tax'] != null ? financeData['edu_tax'] : ""}',
        PdfStandardFont(PdfFontFamily.helvetica, 15),
        bounds: const Rect.fromLTWH(420, 450, 0, 0));
    page.graphics.drawString(
        'Discount: ${financeData['referred_discount'] != null ? financeData['referred_discount'] : ""}',
        PdfStandardFont(PdfFontFamily.helvetica, 15),
        bounds: const Rect.fromLTWH(420, 470, 0, 0));

    page.graphics.drawString(
        'Powered by',
        PdfStandardFont(PdfFontFamily.helvetica, 20,style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(210, 580, 0, 0));

    page.graphics.drawString(
        'schoolworkspro.com',
        PdfStandardFont(PdfFontFamily.helvetica, 20,style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(165, 600, 0, 0));

    List<int> bytes = await document.save();
    document.dispose();

    DateTime now = DateTime.parse(DateTime.now().toString());

    // now = now.add(const Duration(hours: 5, minutes: 45));
    // var format = DateFormat('dd-MM').format(now);
    // saveAndLaunchFile(bytes, '${format}Invoice.pdf');
  }
}
