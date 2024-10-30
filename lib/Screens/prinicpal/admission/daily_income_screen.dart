import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/extension/sizebox_ex.dart';
import '../../../config/api_response_config.dart';
import '../../../response/payment_details_response.dart';
import 'package:intl/intl.dart';
import '../principal_common_view_model.dart';

class DailyIncomeScreen extends StatefulWidget {
  const DailyIncomeScreen({Key? key}) : super(key: key);

  @override
  State<DailyIncomeScreen> createState() => _DailyIncomeScreenState();
}

class _DailyIncomeScreenState extends State<DailyIncomeScreen> {
  late PrinicpalCommonViewModel _provider;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<PrinicpalCommonViewModel>(context, listen: false);
      _fetchDailyIncome(_provider);
    });
  }

  Future<void> _fetchDailyIncome(PrinicpalCommonViewModel commonVM) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      final dataReq = jsonEncode({
        "date": formattedDate,
      });
      commonVM.fetchDailyIncome(dataReq);
    } catch (error) {
      print('Error fetching digital diary data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PrinicpalCommonViewModel>(
        builder: (context, principalVM, child) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Daily Income'),
          ),
          body: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: DateTimePicker(
                  type: DateTimePickerType.date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  initialDate: selectedDate,
                  decoration: datePickerDecoration(),
                  initialValue: DateFormat('yyyy-MM-dd').format(selectedDate),
                  dateLabelText: 'Date',
                  timePickerEntryModeInput: true,
                  onChanged: (val) {
                    setState(() {
                      DateTime originalDate = DateTime.parse(val);

                      // String formattedDate =
                      //     DateFormat('yyyy-MM-dd').format(originalDate);

                      final formattedDate =
                          DateFormat('yyyy-MM-dd').format(originalDate);
                      final dataReq = jsonEncode({
                        "date": formattedDate,
                      });
                      principalVM.fetchDailyIncome(dataReq);

                      // _fetchDailyIncome(principalVM);
                    });
                  },
                ),
              ),
              if (isLoading(principalVM.dailyIncomeApiResponse))
                const Center(child: CupertinoActivityIndicator())
              else if (isError(principalVM.dailyIncomeApiResponse))
                Center(
                  child: Image.asset("assets/images/no_content.PNG"),
                )
              else if (principalVM.dailyIncome.data?.incomes == null ||
                  principalVM.dailyIncome.data!.incomes!.isEmpty)
                Center(
                  child: Image.asset("assets/images/no_content.PNG"),
                )
              else
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            const Text(
                              "Total Number : ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${principalVM.dailyIncome.data?.incomes?.length ?? 0}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            const Text(
                              "Total Amount : ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Builder(builder: (context) {
                              int totalAmount = 0;
                              try {
                                for (int i = 0;
                                    i <
                                        principalVM
                                            .dailyIncome.data!.incomes!.length;
                                    i++) {
                                  totalAmount += int.parse(principalVM
                                      .dailyIncome
                                      .data!
                                      .incomes![i]
                                      .amountPaid!);
                                }
                              } catch (e) {}

                              return Text(
                                "${totalAmount ?? 0}",
                                style: const TextStyle(fontSize: 16),
                              );
                            }),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount:
                            principalVM.dailyIncome.data?.incomes?.length,
                        itemBuilder: (context, index) {
                          final incomes =
                              principalVM.dailyIncome.data?.incomes?[index];
                          return IncomeCard(income: incomes ?? IncomeRes());
                        },
                      ),
                    ],
                  ),
                )
            ],
          ));
    });
  }

  InputDecoration datePickerDecoration() {
    return const InputDecoration(
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      errorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    );
  }
}

class IncomeCard extends StatefulWidget {
  final IncomeRes income;

  const IncomeCard({Key? key, required this.income}) : super(key: key);

  @override
  _IncomeCardState createState() => _IncomeCardState();
}

class _IncomeCardState extends State<IncomeCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildRow(
              icon: Icons.receipt,
              label: 'Receipt No:',
              value: widget.income.receiptNo.toString(),
            ),
            _buildRow(
              icon: Icons.person,
              label: 'Full Name:',
              value: widget.income.fullName.toString(),
            ),
            _buildRow(
              icon: Icons.attach_money,
              label: 'Amount Paid:',
              value: 'Rs.${widget.income.amountPaid}',
            ),
            if (isExpanded) ...[
              _buildRow(
                icon: Icons.date_range,
                label: 'Payment Date:',
                value: '${widget.income.paymentDate}'.split(' ')[0],
              ),
              _buildRow(
                icon: Icons.category,
                label: 'Payment Type:',
                value: widget.income.paymentType.toString(),
              ),
              _buildRow(
                icon: Icons.payment,
                label: 'Payment Method:',
                value: widget.income.paymentMethod.toString(),
              ),
              if (widget.income.bankName != null)
                _buildRow(
                  icon: Icons.account_balance,
                  label: 'Bank Name:',
                  value: widget.income.bankName!,
                ),
              if (widget.income.transactionNo != null)
                _buildRow(
                  icon: Icons.confirmation_number,
                  label: 'Transaction No:',
                  value: widget.income.transactionNo!,
                ),
              _buildRow(
                icon: Icons.account_balance_wallet,
                label: 'Education Tax:',
                value: '\$${widget.income.eduTax.toString()}',
              ),
              _buildRow(
                icon: Icons.school,
                label: 'Student ID:',
                value: widget.income.studentId.toString(),
              ),
              _buildRow(
                icon: Icons.class_,
                label: 'Batch Name:',
                value: widget.income.batchName.toString(),
              ),
            ],
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Icon(isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
      {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: <Widget>[
          Icon(icon, color: Colors.blue),
          10.sW,
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          5.sW,
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
