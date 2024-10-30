// To parse this JSON data, do
//
//     final studentFilterLeaveResponse = studentFilterLeaveResponseFromJson(jsonString);

import 'dart:convert';

StudentFilterLeaveResponse studentFilterLeaveResponseFromJson(String str) => StudentFilterLeaveResponse.fromJson(json.decode(str));

String studentFilterLeaveResponseToJson(StudentFilterLeaveResponse data) => json.encode(data.toJson());

class StudentFilterLeaveResponse {
  StudentFilterLeaveResponse({
    this.success,
    this.count,
    this.leaves,
  });

  bool? success;
  num? count;
  List<Leaf>? leaves;

  factory StudentFilterLeaveResponse.fromJson(Map<String, dynamic> json) => StudentFilterLeaveResponse(
    success: json["success"],
    count: json["count"],
    leaves: List<Leaf>.from(json["leaves"].map((x) => Leaf.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "leaves": List<dynamic>.from(leaves!.map((x) => x.toJson())),
  };
}

class Leaf {
  Leaf({
    this.status,
    this.routines,
    this.isStudent,
    this.allDay,
    this.id,
    this.leaveTitle,
    this.content,
    this.leaveType,
    this.startDate,
    this.endDate,
    this.user,
    this.institution,
    this.createdAt,
    this.updatedAt,
    this.ticket,
    this.remarks,
  });

  String? status;
  List<Routine>? routines;
  bool? isStudent;
  bool? allDay;
  String? id;
  String? leaveTitle;
  String? content;
  String? leaveType;
  DateTime? startDate;
  DateTime? endDate;
  User? user;
  String? institution;
  DateTime? createdAt;
  DateTime? updatedAt;
  Ticket? ticket;
  String? remarks;

  factory Leaf.fromJson(Map<String, dynamic> json) => Leaf(
    status: json["status"],
    routines: List<Routine>.from(json["routines"].map((x) => Routine.fromJson(x))),
    isStudent: json["isStudent"],
    allDay: json["allDay"],
    id: json["_id"],
    leaveTitle: json["leaveTitle"],
    content: json["content"],
    leaveType: json["leaveType"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    user: User.fromJson(json["user"]),
    institution: json["institution"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    ticket: Ticket.fromJson(json["ticket"]),
    remarks: json["remarks"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "routines": List<dynamic>.from(routines!.map((x) => x.toJson())),
    "isStudent": isStudent,
    "allDay": allDay,
    "_id": id,
    "leaveTitle": leaveTitle,
    "content": content,
    "leaveType": leaveType,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "user": user?.toJson(),
    "institution": institution,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "ticket": ticket?.toJson(),
    "remarks": remarks,
  };
}

class Routine {
  Routine({
    this.moduleSlug,
    this.title,
    this.id,
    this.date,
    this.classType,
  });

  String? moduleSlug;
  String? title;
  String? id;
  DateTime? date;
  String? classType;

  factory Routine.fromJson(Map<String, dynamic> json) => Routine(
    moduleSlug: json["moduleSlug"],
    title: json["title"],
    id: json["id"],
    date: DateTime.parse(json["date"]),
    classType: json["classType"],
  );

  Map<String, dynamic> toJson() => {
    "moduleSlug": moduleSlug,
    "title": title,
    "id": id,
    "date": date?.toIso8601String(),
    "classType": classType,
  };
}

class Ticket {
  Ticket({
    this.status,
    this.requestFile,
    this.requestResponse,
    this.id,
    this.request,
    this.severity,
    this.topic,
    this.subject,
    this.postedBy,
    this.assignedTo,
    this.assignedDate,
    this.ticketId,
    this.institution,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? status;
  List<dynamic>? requestFile;
  List<dynamic>? requestResponse;
  String? id;
  String? request;
  String? severity;
  String? topic;
  String? subject;
  String? postedBy;
  String? assignedTo;
  DateTime? assignedDate;
  String? ticketId;
  String? institution;
  DateTime? createdAt;
  DateTime? updatedAt;
  num? v;

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
    status: json["status"],
    requestFile: List<dynamic>.from(json["requestFile"].map((x) => x)),
    requestResponse: List<dynamic>.from(json["requestResponse"].map((x) => x)),
    id: json["_id"],
    request: json["request"],
    severity: json["severity"],
    topic: json["topic"],
    subject: json["subject"],
    postedBy: json["postedBy"],
    assignedTo: json["assignedTo"],
    assignedDate: DateTime.parse(json["assignedDate"]),
    ticketId: json["ticketId"],
    institution: json["institution"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "requestFile": List<dynamic>.from(requestFile!.map((x) => x)),
    "requestResponse": List<dynamic>.from(requestResponse!.map((x) => x)),
    "_id": id,
    "request": request,
    "severity": severity,
    "topic": topic,
    "subject": subject,
    "postedBy": postedBy,
    "assignedTo": assignedTo,
    "assignedDate": assignedDate?.toIso8601String(),
    "ticketId": ticketId,
    "institution": institution,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class User {
  User({
    this.type,
    this.firstname,
    this.lastname,
    this.contact,
    this.parentsContact,
    this.batch,
    this.username,
    this.userImage,
  });

  String? type;
  String? firstname;
  String? lastname;
  String? contact;
  String? parentsContact;
  String? batch;
  String? username;
  String? userImage;

  factory User.fromJson(Map<String, dynamic> json) => User(
    type: json["type"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    contact: json["contact"],
    parentsContact: json["parentsContact"],
    batch: json["batch"],
    username: json["username"],
    userImage: json["userImage"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "firstname": firstname,
    "lastname": lastname,
    "contact": contact,
    "parentsContact": parentsContact,
    "batch": batch,
    "username": username,
    "userImage": userImage,
  };
}
