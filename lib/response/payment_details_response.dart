// To parse this JSON data, do
//
//     final paymentDetailsResponse = paymentDetailsResponseFromJson(jsonString);

import 'dart:convert';

PaymentDetailsResponse paymentDetailsResponseFromJson(String str) => PaymentDetailsResponse.fromJson(json.decode(str));

String paymentDetailsResponseToJson(PaymentDetailsResponse data) => json.encode(data.toJson());

class PaymentDetailsResponse {
  Data? data;

  PaymentDetailsResponse({
    this.data,
  });

  factory PaymentDetailsResponse.fromJson(Map<String, dynamic> json) => PaymentDetailsResponse(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class Data {
  bool? success;
  List<IncomeRes>? incomes;

  Data({
    this.success,
    this.incomes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    success: json["success"],
    incomes: List<IncomeRes>.from(json["incomes"].map((x) => IncomeRes.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "incomes": List<dynamic>.from(incomes!.map((x) => x.toJson())),
  };
}

class IncomeRes {
  String? receiptNo;
  String? amountPaid;
  String? paymentMethod;
  DateTime? paymentDate;
  String? paymentType;
  dynamic bankName;
  dynamic transactionNo;
  String? fullName;
  String? studentId;
  String? batchName;
  String? eduTax;

  IncomeRes({
    this.receiptNo,
    this.amountPaid,
    this.paymentMethod,
    this.paymentDate,
    this.paymentType,
    this.bankName,
    this.transactionNo,
    this.fullName,
    this.studentId,
    this.batchName,
    this.eduTax,
  });

  factory IncomeRes.fromJson(Map<String, dynamic> json) => IncomeRes(
    receiptNo: json["receipt_no"],
    amountPaid: json["amount_paid"],
    paymentMethod: json["payment_method"],
    paymentDate: DateTime.parse(json["payment_date"]),
    paymentType: json["payment_type"],
    bankName: json["bank_name"],
    transactionNo: json["transaction_no"],
    fullName: json["full_name"],
    studentId: json["student_id"],
    batchName: json["batch_name"],
    eduTax: json["edu_tax"],
  );

  Map<String, dynamic> toJson() => {
    "receipt_no": receiptNo,
    "amount_paid": amountPaid,
    "payment_method": paymentMethod,
    "payment_date": paymentDate?.toIso8601String(),
    "payment_type": paymentType,
    "bank_name": bankName,
    "transaction_no": transactionNo,
    "full_name": fullName,
    "student_id": studentId,
    "batch_name": batchName,
    "edu_tax": eduTax,
  };
}
