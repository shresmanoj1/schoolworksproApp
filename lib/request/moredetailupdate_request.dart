// import 'package:flutter/foundation.dart';

class MoredetailUpdateRequest {
  final String? contact;
  final String? address;
  final String? bank_account;
  final String? maritalStatus;
  final String? pan_number;
  final String? pf_number;
  final String? signature;

  MoredetailUpdateRequest({
    this.contact,
    this.address,
    this.bank_account,
    this.maritalStatus,
    this.pan_number,
    this.pf_number,
    this.signature
  });

  Map<String, dynamic> toJson() {
    return {
      "contact": contact,
      "address": address,
      "bank_account":bank_account,
      "maritalStatus":maritalStatus,
      "pan_number":pan_number,
      "pf_number":pf_number,
      "signature":signature
    };
  }
}
