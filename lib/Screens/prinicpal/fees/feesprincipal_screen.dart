import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:schoolworkspro_app/Screens/fees/invoice/invoice_screen.dart';
import 'package:schoolworkspro_app/Screens/fees/payment_screen/payment_optionscreen.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/request/parent/getfeesparent_request.dart';
import 'package:schoolworkspro_app/response/addproject_response.dart';
import 'package:schoolworkspro_app/response/parents/getchildren_response.dart';
import 'package:schoolworkspro_app/response/parents/getfessparent_response.dart';
import 'package:intl/intl.dart';
import 'package:schoolworkspro_app/services/fees_service.dart';
import 'package:schoolworkspro_app/services/parents/getfeesparent_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../response/login_response.dart';
import '../../../helper/custom_loader.dart';

class FeePrincipalScreen extends StatefulWidget {
  final data;

  const FeePrincipalScreen({Key? key, this.data}) : super(key: key);

  @override
  _FeePrincipalScreenState createState() => _FeePrincipalScreenState();
}

class _FeePrincipalScreenState extends State<FeePrincipalScreen> {
  Future<Addprojectresponse>? transaction_start;
  Future<GetFeesResponse>? transaction_finish;
  Future<Addprojectresponse>? due_start;
  Future<GetFeesResponse>? due_finish;
  double total = 0;
  double discount = 0;
  double tax = 0;
  bool nodata = false;
  User? user;
  bool isloading = false;
  bool due_screen = true;
  List<dynamic> duesList = <dynamic>[];
  int duesCount = 0;
  bool isDue = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transactionStart();
    // financialDataStart();
    // financialDataFinish();
  }

  transactionStart() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });

    if (widget.data['institution'] == "softwarica") {
      final data = GetFeesForParentsRequest(
        studentId: widget.data['username'],
        institution: widget.data['institution'],
      );

      due_start = ParentFeeService().duedatastart(data);

      due_finish = ParentFeeService().duedatafinish(data);

      final checkData = await ParentFeeService().duedatafinish(data);
      if (checkData.data?.payments != null) {
        for (int i = 0; i < checkData.data!.payments!.length; i++) {
          if (calculateDue(
                  checkData.data?.payments?[i]['assign_amount'] ?? "0",
                  checkData.data?.payments?[i]['total_paid_amount'] ?? "0",
                  checkData.data?.payments?[i]['total_discount_amount'] ??
                      "0") >
              0) {
            setState(() {
              duesList.add(checkData.data?.payments?[i]);
            });
          } else {
            print('no due');
          }
        }
      }
    } else {
      final data = GetFeesForParentsRequest(
        studentId: widget.data['email'],
        institution: widget.data['institution'],
      );

      due_start = ParentFeeService().duedatastart(data);
      due_finish = ParentFeeService().duedatafinish(data);
      final checkData = await ParentFeeService().duedatafinish(data);
      if (checkData.data?.payments != null) {
        for (int i = 0; i < checkData.data!.payments!.length; i++) {
          if (calculateDue(
                  checkData.data?.payments?[i]['assign_amount'] ?? 0,
                  checkData.data?.payments?[i]['total_paid_amount'] ?? "0",
                  checkData.data?.payments?[i]['total_discount_amount'] ??
                      "0") >
              0) {
            setState(() {
              duesList.add(checkData.data?.payments?[i]);
            });
          } else {
            print('no due');
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isloading == true ) {
      customLoadStart();
    } else {
      customLoadStop();
    }
    return Scaffold(
        appBar: AppBar(
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == menubarfees.due) {
                    setState(() {
                      due_screen = true;
                    });
                  } else if (value == menubarfees.transaction) {
                    setState(() {
                      due_screen = false;
                      // duesList.clear();
                    });

                    if (widget.data['institution'] ==
                        "softwarica") {
                      final data = GetFeesForParentsRequest(
                        studentId: widget.data['username'],
                        institution: widget.data['institution'],
                      );

                      for (int i = 0; i < 3; i++) {
                        transaction_start =
                            ParentFeeService().transactiondatastart(data);
                      }
                      transaction_finish =
                          ParentFeeService().transactiondatafinish(data);
                    } else {
                      final data = GetFeesForParentsRequest(
                        studentId: widget.data['email'],
                        institution: widget.data['institution'],
                      );

                      for (int i = 0; i < 3; i++) {
                        transaction_start =
                            ParentFeeService().transactiondatastart(data);
                      }
                      transaction_finish =
                          ParentFeeService().transactiondatafinish(data);
                    }

                    setState(() {
                      isloading = true;
                    });

                    setState(() {
                      isloading = false;
                    });
                  }
                },
                itemBuilder: (BuildContext context) {
                  return menubarfees.settings.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
                icon: const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(
                    Icons.filter_alt,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
            title: const Text(
              'Fees',
              style: TextStyle(color: Colors.black),
            ),
            elevation: 0.0,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            backgroundColor: Colors.white),
        body: ListView(
          children: [
            due_screen == true
                ? FutureBuilder<GetFeesResponse>(
                    future: due_finish,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return duesList.isEmpty || duesList == null
                            ? Column(
                                children: [
                                  Image.asset("assets/images/no_content.PNG"),
                                ],
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    snapshot.data?.data?.payments?.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  // print("checkpoint:"+jsonEncode(duesList));

                                  if (snapshot.data != null) {
                                    if (snapshot.data!.data!.payments != null) {
                                      var datas =
                                          snapshot.data?.data?.payments?[index];
                                      try {
                                        if (calculateDue(
                                                datas['assign_amount'] ?? '0',
                                                datas['total_paid_amount'] ??
                                                    "0",
                                                datas['total_discount_amount'] ??
                                                    "0") >
                                            0) {
                                          // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                                          //   setState(() {
                                          //     duesList.add(datas);
                                          //     print("checkpointtttt"+ jsonEncode(duesList));
                                          //   });
                                          //
                                          // });

                                          return Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10.0),
                                                    child: Text(
                                                      datas['batch_name']
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    10.0),
                                                        child: Text(datas[
                                                                'payment_type']
                                                            .toString()),
                                                      ),
                                                      const Icon(
                                                        Icons.dangerous,
                                                        color: Colors.red,
                                                      )
                                                    ],
                                                  ),
                                                  Center(
                                                    child: DataTable(
                                                      columns: const [
                                                        DataColumn(
                                                            label: Text('Cr',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))),
                                                        DataColumn(
                                                            label: Text(
                                                                'Paid Amount',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))),
                                                        DataColumn(
                                                            label: Text('Due',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))),
                                                      ],
                                                      rows: [
                                                        DataRow(cells: [
                                                          DataCell(Text(datas[
                                                                  'assign_amount'] ??
                                                              "0")),
                                                          DataCell(Builder(
                                                              builder:
                                                                  (context) {
                                                            dynamic totalPaid = double
                                                                    .parse(datas[
                                                                            'total_paid_amount'] ??
                                                                        '0') +
                                                                double.parse(
                                                                    datas['total_discount_amount'] ??
                                                                        '0');
                                                            return Text(totalPaid
                                                                .toString());
                                                          })),
                                                          DataCell(Builder(
                                                              builder:
                                                                  (context) {
                                                            dynamic totalPaid = double
                                                                    .parse(datas[
                                                                            'total_paid_amount'] ??
                                                                        '0') +
                                                                double.parse(
                                                                    datas['total_discount_amount'] ??
                                                                        '0');
                                                            double dues = double
                                                                    .parse(datas[
                                                                            'assign_amount'] ??
                                                                        "0") -
                                                                totalPaid;
                                                            return Text(dues
                                                                .toStringAsFixed(
                                                                    2));
                                                          })),
                                                        ]),
                                                      ],
                                                    ),
                                                  ),
                                                  ButtonBar(
                                                    children: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => PaymentOptionScreen(
                                                                      institution: widget.data
                                                                          ['institution']
                                                                          ),
                                                                ));
                                                          },
                                                          child: const Text(
                                                              'Pay now'))
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      } on Exception catch (e) {
                                        // TODO
                                        return Text(e.toString());
                                      }
                                    }
                                  }

                                  return SizedBox();
                                  // return datas['total_paid_amount'] == null ||
                                  //         datas['total_discount_amount'] == null ||
                                  //         datas['assign_amount'] == null
                                  //     ? const Text("0")
                                  //     : Text(calculateDue(
                                  //             datas['assign_amount'],
                                  //             datas['total_paid_amount'],
                                  //             datas['total_discount_amount'])
                                  //         .toString());
                                },
                              );
                        // for(int i =0;i< snapshot.data!.data!.payments!.length;i++){
                        //   if(calculateDue(
                        //       snapshot.data!.data!.payments![i]['assign_amount'],
                        //       snapshot.data!.data!.payments![i]['total_paid_amount'],
                        //       snapshot.data!.data!.payments![i]['total_discount_amount']) >
                        //       0){
                        //     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                        //
                        //         duesCount = duesCount + 1;
                        //
                        //     });
                        //
                        //   }
                        //
                        // }

                        // print("the dues count is:" + duesCount.toString());

                        // : Builder(builder: (context) {
                        //     try {
                        //       return Column(
                        //         children: [
                        //           Container(
                        //             width: double.infinity,
                        //             color: Colors.grey.shade100,
                        //             child: Padding(
                        //               padding: const EdgeInsets.all(8.0),
                        //               child: Column(
                        //                 mainAxisAlignment: MainAxisAlignment.start,
                        //                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                 children: [
                        //                   Text(
                        //                     "Full name: " +
                        //                         snapshot.data?.data
                        //                             ?.studentDetail['full_name'],
                        //                     style: const TextStyle(
                        //                         fontWeight: FontWeight.bold,
                        //                         fontSize: 17),
                        //                   ),
                        //                   Text(
                        //                     "Batch: " +
                        //                         snapshot.data?.data
                        //                             ?.studentDetail['batch_name'],
                        //                     style: const TextStyle(
                        //                         fontWeight: FontWeight.bold,
                        //                         fontSize: 15),
                        //                   ),
                        //                   Text(
                        //                     "Student Id: " +
                        //                         snapshot.data?.data
                        //                             ?.studentDetail['student_id'],
                        //                     style: const TextStyle(
                        //                         fontWeight: FontWeight.bold,
                        //                         fontSize: 14),
                        //                   ),
                        //                   Text(
                        //                     "Total: " + total.toString(),
                        //                     style: const TextStyle(
                        //                         fontWeight: FontWeight.bold,
                        //                         fontSize: 14),
                        //                   ),
                        //                   Text(
                        //                     "Edu Tax: " + tax.toString(),
                        //                     style: const TextStyle(
                        //                         fontWeight: FontWeight.bold,
                        //                         fontSize: 14),
                        //                   ),
                        //                   Text(
                        //                     "Discount: " + discount.toString(),
                        //                     style: const TextStyle(
                        //                         fontWeight: FontWeight.bold,
                        //                         fontSize: 14),
                        //                   ),
                        //                   Text(
                        //                     "Total Paid Amount: " +
                        //                         '${(total + discount + tax).toString()}',
                        //                     style: const TextStyle(
                        //                         fontWeight: FontWeight.bold,
                        //                         fontSize: 14),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //           Expanded(
                        //             child: SingleChildScrollView(
                        //               child: ListView.builder(
                        //                 shrinkWrap: true,
                        //                 physics: ScrollPhysics(),
                        //                 itemCount:
                        //                     snapshot.data?.data?.payments?.length,
                        //                 itemBuilder: (context, index) {
                        //                   var datas =
                        //                       snapshot.data?.data?.payments?[index];
                        //                   DateTime start = DateTime.parse(
                        //                       datas['payment_date'].toString());
                        //
                        //                   start = start.add(
                        //                       const Duration(hours: 5, minutes: 45));
                        //
                        //                   var formattedTime =
                        //                       DateFormat('MMMM d yyyy').format(start);
                        //                   return GFListTile(
                        //                     avatar: Text((index + 1).toString()),
                        //                     title: Text(
                        //                       datas['feePayment_type'].toString() +
                        //                           " " +
                        //                           "(${datas['batch_name']})",
                        //                       style: TextStyle(
                        //                           fontSize: 16,
                        //                           fontWeight: FontWeight.bold),
                        //                     ),
                        //                     subTitle: Text("Receipt number: " +
                        //                             datas['receipt_no'].toString() ??
                        //                         ""),
                        //                     description: Column(
                        //                       mainAxisAlignment:
                        //                           MainAxisAlignment.start,
                        //                       crossAxisAlignment:
                        //                           CrossAxisAlignment.start,
                        //                       children: [
                        //                         Text("Amount paid: " +
                        //                             datas['amount_paid'].toString()),
                        //                         Text("Edu. Tax: " +
                        //                             datas['edu_tax'].toString()),
                        //                         Text("Discount: " +
                        //                             datas['referred_discount']
                        //                                 .toString()),
                        //                         Text("Date: " +
                        //                             formattedTime.toString()),
                        //                       ],
                        //                     ),
                        //                   );
                        //                 },
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       );
                        //     } on Exception catch (e) {
                        //       // TODO
                        //       return Text(e.toString());
                        //     }
                        //   });
                        // return Text(snapshot.data?.data?.studentDetail['full_name']);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else {
                        return const Center(
                          child: SpinKitDualRing(color: kPrimaryColor),
                        );
                      }
                    },
                  )
                : FutureBuilder<GetFeesResponse>(
                    future: transaction_finish,
                    builder: (context, snapshot2) {
                      if (snapshot2.hasData) {
                        return snapshot2.data?.data?.payments != null
                            ? ListView.builder(
                                itemCount:
                                    snapshot2.data!.data!.payments!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var payment =
                                      snapshot2.data?.data?.payments?[index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Invoicescreen(datas: payment),
                                          ));
                                    },
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child: Wrap(
                                                  direction: Axis.horizontal,
                                                  children: [
                                                    Text(
                                                      payment['payment_type'],
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      payment['batch_name'] ==
                                                              null
                                                          ? ""
                                                          : " (" +
                                                              payment[
                                                                  'batch_name'] +
                                                              ")",
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Builder(builder: (context) {
                                                      if (payment[
                                                              'payment_date'] !=
                                                          null) {
                                                        DateTime now = DateTime
                                                            .parse(payment[
                                                                    'payment_date']
                                                                .toString());

                                                        now = now.add(
                                                            const Duration(
                                                                hours: 5,
                                                                minutes: 45));

                                                        var formattedTime =
                                                            DateFormat('yMMMMd')
                                                                .format(now);
                                                        return Text(
                                                          "Payment date: " +
                                                              formattedTime,
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        );
                                                      } else {
                                                        return Text("");
                                                      }
                                                    }),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          payment['payment_method'] ==
                                                                  null
                                                              ? ""
                                                              : "Payment method: " +
                                                                  payment[
                                                                      'payment_method'],
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Icon(
                                                          Icons.check_circle,
                                                          color: Colors.green,
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15.0),
                                              child: Text(
                                                payment['receipt_no'] == null
                                                    ? ""
                                                    : "Receipt no: " +
                                                        payment['receipt_no']
                                                            .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Center(
                                              child: DataTable(
                                                columns: const [
                                                  DataColumn(
                                                      label: Text('Paid Amount',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))),
                                                  DataColumn(
                                                      label: Text('Edu Tax',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))),
                                                  DataColumn(
                                                      label: Text('Discount',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))),
                                                ],
                                                rows: [
                                                  DataRow(cells: [
                                                    DataCell(Text(payment[
                                                                'amount_paid'] !=
                                                            null
                                                        ? payment['amount_paid']
                                                        : "")),
                                                    DataCell(Text(
                                                        payment['edu_tax'] !=
                                                                null
                                                            ? payment['edu_tax']
                                                            : "")),
                                                    DataCell(Text(payment[
                                                                'referred_discount'] !=
                                                            null
                                                        ? payment[
                                                            'referred_discount']
                                                        : "")),
                                                  ]),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Column(
                                children: [
                                  Image.asset("assets/images/no_content.PNG"),
                                ],
                              );
                      } else if (snapshot2.hasError) {
                        return Text('${snapshot2.error}');
                      } else {
                        return const Center(
                          child: SpinKitDualRing(color: kPrimaryColor),
                        );
                      }
                    },
                  )
          ],
        ));
  }

  dynamic calculateDue(
      dynamic assignAmount, dynamic paidAmount, dynamic discountAmount) {
    try {
      double totalPaid =
          double.parse(paidAmount) + double.parse(discountAmount);
      var due = double.parse(assignAmount) - totalPaid;

      return due;
    } on Exception catch (e) {
      return "0";
      // TODO
    }
  }
}

class menubarfees {
  static const String transaction = "Transactions";
  static const String due = "Due";

  static const List<String> settings = <String>[transaction, due];
}
