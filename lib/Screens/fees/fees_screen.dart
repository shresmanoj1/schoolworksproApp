import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/fees/invoice/invoice_screen.dart';
import 'package:schoolworkspro_app/Screens/fees/payment_screen/payment_optionscreen.dart';
import 'package:schoolworkspro_app/Screens/fees/view_model/fees_viewmodel.dart';
import 'package:schoolworkspro_app/constants/colors.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/shimmer.dart';
import '../../config/api_response_config.dart';
import '../../response/login_response.dart';

class Feesscreen extends StatefulWidget {
  const Feesscreen({Key? key}) : super(key: key);

  @override
  _FeesscreenState createState() => _FeesscreenState();
}

class _FeesscreenState extends State<Feesscreen> {
  User? user;

  late FeesViewModel _provider;
  String selectedMenu = menubarfees.due;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<FeesViewModel>(context, listen: false);
    });
    super.initState();
    transactionStart();
  }

  transactionStart() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('_auth_');
    Map<String, dynamic> userMap = json.decode(userData!);
    User userD = User.fromJson(userMap);
    setState(() {
      user = userD;
    });

    try {
      _provider
          .getDueDateStartFuc(user?.institution.toString() ?? "")
          .then((_) {
        if (_provider.dueDateStartData != null) {
          if (_provider.dueDateStartData.success == true &&
              _provider.dueDateStartData.message == "i will get your data !") {
            _provider.getDueDateFinishFuc(user?.institution.toString() ?? "");

          }
        }
      });
    } catch (e) {
      print(e);
    }



  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeesViewModel>(builder: (context, snapshot, child) {
      return Scaffold(
          appBar: AppBar(
              centerTitle: false,
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    setState(() {
                      selectedMenu = value;
                      if (menubarfees.due == selectedMenu) {
                        snapshot
                            .getDueDateStartFuc(
                                user?.institution.toString() ?? "")
                            .then((_) {
                          if (snapshot.dueDateStartData.success == true &&
                              snapshot.dueDateStartData.message ==
                                  "i will get your data !") {
                            snapshot.getDueDateFinishFuc(
                                user?.institution.toString() ?? "");
                          }
                        });
                      } else if (menubarfees.transaction == selectedMenu) {
                        snapshot
                            .getTransactionDateStart(
                                user?.institution.toString() ?? "")
                            .then((_) {
                          if (snapshot.transactionDateStart.success == true &&
                              snapshot.transactionDateStart.message ==
                                  "i will get your data !") {
                            snapshot.getTransactionDateFinish(
                                user?.institution.toString() ?? "");
                          }
                        });
                      }
                    });

                    // if (value == menubarfees.due) {
                    //   setState(() {
                    //     due_screen = true;
                    //   });
                    // }
                    // else if (value == menubarfees.transaction) {
                    //   setState(() {
                    //     due_screen = false;
                    //     // duesList.clear();
                    //   });
                    //   final data = Institutionrequest(
                    //       institution: user?.institution.toString());
                    //
                    //   for (int i = 0; i < 3; i++) {
                    //     transaction_start =
                    //         FeeService().transactiondatastart(data);
                    //   }
                    //
                    //   setState(() {
                    //     isloading = true;
                    //   });
                    //   transaction_finish =
                    //       FeeService().transactiondatafinish(data);
                    //   setState(() {
                    //     isloading = false;
                    //   });
                    // }
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
                      color: white,
                    ),
                  ),
                ),
              ],
              title: const Text(
                'Fees',
                style:
                    const TextStyle(color: white, fontWeight: FontWeight.w800),
              ),
              elevation: 0.0,
              backgroundColor: logoTheme),
          body: ListView(
            children: [
              selectedMenu == null
                  ? noDataFees()
                  : selectedMenu == menubarfees.due
                      ? isLoading(snapshot.dueDateStartApiResponse) ||
                              isLoading(snapshot.dueDateFinishApiResponse)
                          ? const VerticalLoader()
                          :  snapshot.dueDateStartData.success == false ||
                  snapshot.dueDateFinish.data == null ||
                                  snapshot.dueDateFinish.data?.payments ==
                                      null ||
                                  snapshot.dueDateFinish.data!.payments!.isEmpty
                              ? noDataFees()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot
                                      .dueDateFinish.data?.payments?.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    var datas = snapshot
                                        .dueDateFinish.data?.payments?[index];
                                    try {
                                      if (calculateDue(
                                              datas['assign_amount'] ?? "0",
                                              datas['total_paid_amount'] ?? "0",
                                              datas['total_discount_amount'] ??
                                                  "0" ??
                                                  "0") >
                                          0) {
                                        return Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
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
                                                    datas['batch_name'] ?? "",
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
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10.0),
                                                      child: Text(datas[
                                                              'payment_type'] ??
                                                          ""),
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
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                      DataColumn(
                                                          label: Text(
                                                              'Paid Amount',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                      DataColumn(
                                                          label: Text('Due',
                                                              style: TextStyle(
                                                                  fontSize: 15,
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
                                                            builder: (context) {
                                                          dynamic totalPaid = double
                                                                  .parse(datas[
                                                                          'total_paid_amount'] ??
                                                                      "0") +
                                                              double.parse(datas[
                                                                      'total_discount_amount'] ??
                                                                  "0");
                                                          return Text(totalPaid
                                                              .toString());
                                                        })),
                                                        DataCell(Builder(
                                                            builder: (context) {
                                                          dynamic totalPaid = double
                                                                  .parse(datas[
                                                                          'total_paid_amount'] ??
                                                                      "0") +
                                                              double.parse(datas[
                                                                      'total_discount_amount'] ??
                                                                  "0");
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
                                                                builder: (context) =>
                                                                    PaymentOptionScreen(
                                                                        institution: user
                                                                            ?.institution
                                                                            .toString()),
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
                                  },
                                )
                      : selectedMenu == menubarfees.transaction
                          ? isLoading(snapshot
                                      .transactionDateStartApiResponse) ||
                                  isLoading(
                                      snapshot.transactionDateFinishApiResponse)
                              ? const VerticalLoader()
                              : snapshot.transactionDateStart.success ==
                                          false ||      snapshot.transactionDateFinish.data == null ||
                                      snapshot.transactionDateFinish.data!
                                              .payments ==
                                          null ||
                                      snapshot.transactionDateFinish.data!
                                          .payments!.isEmpty
                                  ? noDataFees()
                                  : ListView.builder(
                                      itemCount: snapshot.transactionDateFinish
                                          .data?.payments?.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        var payment = snapshot
                                            .transactionDateFinish
                                            .data
                                            ?.payments?[index];
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Invoicescreen(
                                                          datas: payment),
                                                ));
                                          },
                                          child: Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 15.0),
                                                      child: Wrap(
                                                        direction:
                                                            Axis.horizontal,
                                                        children: [
                                                          Text(
                                                            payment['payment_type'] ??
                                                                "",
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
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
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Builder(builder:
                                                              (context) {
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
                                                                      minutes:
                                                                          45));

                                                              var formattedTime =
                                                                  DateFormat(
                                                                          'yMMMMd')
                                                                      .format(
                                                                          now);
                                                              return Text(
                                                                "Payment date: " +
                                                                    formattedTime,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
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
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .check_circle,
                                                                color: Colors
                                                                    .green,
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 15.0),
                                                    child: Text(
                                                      payment['receipt_no'] ==
                                                              null
                                                          ? ""
                                                          : "Receipt no: " +
                                                              payment['receipt_no']
                                                                  .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: DataTable(
                                                      columns: const [
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
                                                            label: Text(
                                                                'Edu Tax',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))),
                                                        DataColumn(
                                                            label: Text(
                                                                'Discount',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))),
                                                      ],
                                                      rows: [
                                                        DataRow(cells: [
                                                          DataCell(Text(payment[
                                                                      'amount_paid'] !=
                                                                  null
                                                              ? payment[
                                                                  'amount_paid']
                                                              : "")),
                                                          DataCell(Text(
                                                              payment['edu_tax'] !=
                                                                      null
                                                                  ? payment[
                                                                      'edu_tax']
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
                          : noDataFees()

              // due_screen == true
              //     ?
              // FutureBuilder<GetFeesResponse>(
              //         future: due_finish,
              //         builder: (context, snapshot) {
              // if (snapshot.hasData) {
              //   return duesList.isEmpty || duesList == null
              //       ? Column(
              //           children: [
              //             Image.asset("assets/images/no_content.PNG"),
              //           ],
              //         )
              //       :

              // } else if (snapshot.hasError) {
              //   return Text('${snapshot.error}');
              // } else {
              //   return const Center(
              //     child: SpinKitDualRing(color: kPrimaryColor),
              //   );
              // }
              //   },
              // )

              // : FutureBuilder<GetFeesResponse>(
              //     future: transaction_finish,
              //     builder: (context, snapshot2) {
              //       if (snapshot2.hasData) {
              //         return snapshot2.data?.data?.payments != null
              //             ? ListView.builder(
              //                 itemCount:
              //                     snapshot2.data!.data!.payments!.length,
              //                 physics: const NeverScrollableScrollPhysics(),
              //                 shrinkWrap: true,
              //                 itemBuilder: (context, index) {
              //                   var payment =
              //                       snapshot2.data?.data?.payments?[index];
              //                   return InkWell(
              //                     onTap: () {
              //                       Navigator.push(
              //                           context,
              //                           MaterialPageRoute(
              //                             builder: (context) =>
              //                                 Invoicescreen(datas: payment),
              //                           ));
              //                     },
              //                     child: Card(
              //                       child: Padding(
              //                         padding: const EdgeInsets.symmetric(
              //                             vertical: 10.0),
              //                         child: Column(
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.start,
              //                           crossAxisAlignment:
              //                               CrossAxisAlignment.start,
              //                           children: [
              //                             Padding(
              //                                 padding:
              //                                     const EdgeInsets.symmetric(
              //                                         horizontal: 15.0),
              //                                 child: Wrap(
              //                                   direction: Axis.horizontal,
              //                                   children: [
              //                                     Text(
              //                                       payment['payment_type'],
              //                                       style: const TextStyle(
              //                                           fontSize: 16,
              //                                           fontWeight:
              //                                               FontWeight.bold),
              //                                     ),
              //                                     Text(
              //                                       payment['batch_name'] ==
              //                                               null
              //                                           ? ""
              //                                           : " (" +
              //                                               payment[
              //                                                   'batch_name'] +
              //                                               ")",
              //                                       style: const TextStyle(
              //                                           fontSize: 16,
              //                                           fontWeight:
              //                                               FontWeight.bold),
              //                                     ),
              //                                     Builder(builder: (context) {
              //                                       if (payment[
              //                                               'payment_date'] !=
              //                                           null) {
              //                                         DateTime now = DateTime
              //                                             .parse(payment[
              //                                                     'payment_date']
              //                                                 .toString());
              //
              //                                         now = now.add(
              //                                             const Duration(
              //                                                 hours: 5,
              //                                                 minutes: 45));
              //
              //                                         var formattedTime =
              //                                             DateFormat('yMMMMd')
              //                                                 .format(now);
              //                                         return Text(
              //                                           "Payment date: " +
              //                                               formattedTime,
              //                                           style: const TextStyle(
              //                                               fontSize: 16,
              //                                               fontWeight:
              //                                                   FontWeight
              //                                                       .bold),
              //                                         );
              //                                       } else {
              //                                         return Text("");
              //                                       }
              //                                     }),
              //                                     Row(
              //                                       mainAxisAlignment:
              //                                           MainAxisAlignment
              //                                               .spaceBetween,
              //                                       children: [
              //                                         Text(
              //                                           payment['payment_method'] ==
              //                                                   null
              //                                               ? ""
              //                                               : "Payment method: " +
              //                                                   payment[
              //                                                       'payment_method'],
              //                                           style: const TextStyle(
              //                                               fontSize: 16,
              //                                               fontWeight:
              //                                                   FontWeight
              //                                                       .bold),
              //                                         ),
              //                                         Icon(
              //                                           Icons.check_circle,
              //                                           color: Colors.green,
              //                                         )
              //                                       ],
              //                                     ),
              //                                   ],
              //                                 )),
              //                             Padding(
              //                               padding:
              //                                   const EdgeInsets.symmetric(
              //                                       horizontal: 15.0),
              //                               child: Text(
              //                                 payment['receipt_no'] == null
              //                                     ? ""
              //                                     : "Receipt no: " +
              //                                         payment['receipt_no']
              //                                             .toString(),
              //                                 style: TextStyle(
              //                                     fontWeight: FontWeight.bold,
              //                                     fontSize: 16),
              //                               ),
              //                             ),
              //                             Center(
              //                               child: DataTable(
              //                                 columns: const [
              //                                   DataColumn(
              //                                       label: Text('Paid Amount',
              //                                           style: TextStyle(
              //                                               fontSize: 15,
              //                                               fontWeight:
              //                                                   FontWeight
              //                                                       .bold))),
              //                                   DataColumn(
              //                                       label: Text('Edu Tax',
              //                                           style: TextStyle(
              //                                               fontSize: 15,
              //                                               fontWeight:
              //                                                   FontWeight
              //                                                       .bold))),
              //                                   DataColumn(
              //                                       label: Text('Discount',
              //                                           style: TextStyle(
              //                                               fontSize: 15,
              //                                               fontWeight:
              //                                                   FontWeight
              //                                                       .bold))),
              //                                 ],
              //                                 rows: [
              //                                   DataRow(cells: [
              //                                     DataCell(Text(payment[
              //                                                 'amount_paid'] !=
              //                                             null
              //                                         ? payment['amount_paid']
              //                                         : "")),
              //                                     DataCell(Text(
              //                                         payment['edu_tax'] !=
              //                                                 null
              //                                             ? payment['edu_tax']
              //                                             : "")),
              //                                     DataCell(Text(payment[
              //                                                 'referred_discount'] !=
              //                                             null
              //                                         ? payment[
              //                                             'referred_discount']
              //                                         : "")),
              //                                   ]),
              //                                 ],
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                   );
              //                 },
              //               )
              //             : Column(
              //                 children: [
              //                   Image.asset("assets/images/no_content.PNG"),
              //                 ],
              //               );
              //       } else if (snapshot2.hasError) {
              //         return Text('${snapshot2.error}');
              //       } else {
              //         return const Center(
              //           child: SpinKitDualRing(color: kPrimaryColor),
              //         );
              //       }
              //     },
              //   )
            ],
          ));
    });
    

  }

  Widget noDataFees(){
    return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: const [
              Text(
                "No Results Found",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w400),
              ),
              Text(
                "It seems we can't find any results",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
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


