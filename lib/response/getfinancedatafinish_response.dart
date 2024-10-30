// To parse this JSON data, do
//
//     final getfinancialdatafinish = getfinancialdatafinishFromJson(jsonString);

import 'dart:convert';

Getfinancialdatafinish getfinancialdatafinishFromJson(String str) => Getfinancialdatafinish.fromJson(json.decode(str));

String getfinancialdatafinishToJson(Getfinancialdatafinish data) => json.encode(data.toJson());

class Getfinancialdatafinish {
  Getfinancialdatafinish({
    this.success,
    this.data,
    this.message,
  });

  bool ? success;
  Data ? data;
  String ? message;

  factory Getfinancialdatafinish.fromJson(Map<String, dynamic> json) => Getfinancialdatafinish(
    success: json["success"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "message": message,
  };
}

class Data {
  Data({
    this.payments,
    this.studentDetail,
  });

  List<Payment> ? payments;
  StudentDetail ? studentDetail;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    payments: json["payments"] == null ? [] : List<Payment>.from(json["payments"].map((x) => Payment.fromJson(x))),
    studentDetail: json["studentDetail"] == null  ? null : StudentDetail.fromJson(json["studentDetail"]),
  );

  Map<String, dynamic> toJson() => {
    "payments": List<dynamic>.from(payments!.map((x) => x.toJson())),
    "studentDetail": studentDetail?.toJson(),
  };
}

class Payment {
  Payment({
    this.paymentId,
    this.receiptNo,
    this.amountPaid,
    this.paymentMethod,
    this.referredDiscount,
    this.paymentDate,
    this.referrer,
    this.remarks,
    this.semester,
    this.paymentType,
    this.feePaymentType,
    this.fullName,
    this.studentId,
    this.batchName,
    this.eduTax,
    this.receivedBy,
    this.receivedByFirstname,
    this.receivedByLastname,
  });

  int ? paymentId;
  int ? receiptNo;
  String  ? amountPaid;
  String ? paymentMethod;
  String ? referredDiscount;
  DateTime ? paymentDate;
  String ? referrer;
  String ? remarks;
  dynamic semester;
  String ? paymentType;
  String ? feePaymentType;
  String ? fullName;
  String ? studentId;
  String ? batchName;
  String ? eduTax;
  String ? receivedBy;
  String ? receivedByFirstname;
  String ? receivedByLastname;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    paymentId: json["payment_id"] ?? "",
    receiptNo: json["receipt_no"] ?? "",
    amountPaid: json["amount_paid"] ?? "",
    paymentMethod: json["payment_method"] ?? "",
    referredDiscount: json["referred_discount"] ?? "",
    paymentDate: DateTime.parse(json["payment_date"]),
    referrer: json["referrer"] ?? "",
    remarks: json["remarks"] ?? "",
    semester: json["semester"] ?? "",
    paymentType: json["payment_type"] ?? "",
    feePaymentType: json["feePayment_type"] ?? "",
    fullName:json["full_name"] ?? "",
    studentId: json["student_id"] ?? "",
    batchName: json["batch_name"] ?? "",
    eduTax: json["edu_tax"] ?? "",
    receivedBy: json["received_by"] ?? "",
    receivedByFirstname: json["received_by_firstname"] ?? "",
    receivedByLastname: json["received_by_lastname"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "payment_id": paymentId,
    "receipt_no": receiptNo,
    "amount_paid": amountPaid,
    "payment_method": paymentMethod,
    "referred_discount": referredDiscount,
    "payment_date": paymentDate,
    "referrer": referrer,
    "remarks": remarks,
    "semester": semester,
    "payment_type": paymentType,
    "feePayment_type": feePaymentType,
    "full_name": fullName,
    "student_id": studentId,
    "batch_name": batchName,
    "edu_tax": eduTax,
    "received_by": receivedBy,
    "received_by_firstname": receivedByFirstname,
    "received_by_lastname": receivedByLastname,
  };
}



class StudentDetail {
  StudentDetail({
    this.studentId,
    this.fullName,
    this.batchName,
    this.cuId,
  });

  String ? studentId;
  String ? fullName;
  String ? batchName;
  dynamic cuId;

  factory StudentDetail.fromJson(Map<String, dynamic> json) => StudentDetail(
    studentId: json["student_id"] ?? "",
    fullName: json["full_name"] ?? "",
    batchName: json["batch_name"] ?? "",
    cuId: json["cu_id"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "student_id": studentId,
    "full_name": fullName,
    "batch_name": batchName,
    "cu_id": cuId,
  };
}

