import 'dart:convert';String addEventRequestToJson(AddEventRequest data) =>    json.encode(data.toJson());class AddEventRequest {  AddEventRequest({    this.endDate,    this.eventType,    this.eventTitle,    this.isPublic,    this.detail,    this.isRegistrable,    this.passedOut,    this.startDate,    // this.moduleSlug  });  String? endDate;  String? startDate;  String? eventType;  String? eventTitle;  bool? isPublic;  String? detail;  bool? isRegistrable;  bool? passedOut;  // String? moduleSlug;  Map<String, dynamic> toJson() => {    "endDate": endDate,    "startDate": startDate,    "eventType": eventType,    "eventTitle": eventTitle,    "isPublic": isPublic,    "detail":detail,    "isRegistrable":isRegistrable,    "passedOut":passedOut,    // "moduleSlug":moduleSlug  };}