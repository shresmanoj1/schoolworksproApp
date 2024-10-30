// To parse this JSON data, do////     final jobDetailResponse = jobDetailResponseFromJson(jsonString);import 'dart:convert';JobDetailResponse jobDetailResponseFromJson(String str) => JobDetailResponse.fromJson(json.decode(str));String jobDetailResponseToJson(JobDetailResponse data) => json.encode(data.toJson());class JobDetailResponse {  JobDetailResponse({    this.success,    this.job,  });  bool? success;  Job? job;  factory JobDetailResponse.fromJson(Map<String, dynamic> json) => JobDetailResponse(    success: json["success"],    job: Job.fromJson(json["job"]),  );  Map<String, dynamic> toJson() => {    "success": success,    "job": job?.toJson(),  };}class Job {  Job({    this.id,    this.skills,    this.extraKeywords,    this.jobStatus,    this.isActive,    this.jobTitle,    this.jobCategory,    this.jobLevel,    this.openings,    this.employmentType,    this.location,    this.salary,    this.deadline,    this.education,    this.info,    this.description,    this.institution,    this.experience,    this.slug,    this.exam,    this.organization,    this.saved,    // this.myApplication,  });  String? id;  List<String>? skills;  List<String>? extraKeywords;  String? jobStatus;  bool? isActive;  String? jobTitle;  String? jobCategory;  String? jobLevel;  String? openings;  String? employmentType;  String? location;  Salary? salary;  DateTime? deadline;  String? education;  String? info;  String? description;  String? institution;  Experience? experience;  String? slug;  String? exam;  Organization? organization;  bool? saved;  // MyApplication? myApplication;  factory Job.fromJson(Map<String, dynamic> json) => Job(    id: json["_id"],    skills: List<String>.from(json["skills"].map((x) => x)),    extraKeywords: List<String>.from(json["extraKeywords"].map((x) => x)),    jobStatus: json["jobStatus"],    isActive: json["isActive"],    jobTitle: json["jobTitle"],    jobCategory: json["jobCategory"],    jobLevel: json["jobLevel"],    openings: json["openings"],    employmentType: json["employmentType"],    location: json["location"],    salary: Salary.fromJson(json["salary"]),    deadline: DateTime.parse(json["deadline"]),    education: json["education"],    info: json["info"],    description: json["description"],    institution: json["institution"],    experience: Experience.fromJson(json["experience"]),    slug: json["slug"],    exam: json["exam"],    organization: Organization.fromJson(json["organization"]),    saved: json["saved"],    // myApplication: MyApplication.fromJson(json["myApplication"]),  );  Map<String, dynamic> toJson() => {    "_id": id,    "skills": List<dynamic>.from(skills!.map((x) => x)),    "extraKeywords": List<dynamic>.from(extraKeywords!.map((x) => x)),    "jobStatus": jobStatus,    "isActive": isActive,    "jobTitle": jobTitle,    "jobCategory": jobCategory,    "jobLevel": jobLevel,    "openings": openings,    "employmentType": employmentType,    "location": location,    "salary": salary?.toJson(),    "deadline": deadline?.toIso8601String(),    "education": education,    "info": info,    "description": description,    "institution": institution,    "experience": experience?.toJson(),    "slug": slug,    "exam": exam,    "organization": organization?.toJson(),    "saved": saved,    // "myApplication": myApplication?.toJson(),  };}class Experience {  Experience({    this.value,    this.label,  });  int? value;  String? label;  factory Experience.fromJson(Map<String, dynamic> json) => Experience(    value: json["value"],    label: json["label"],  );  Map<String, dynamic> toJson() => {    "value": value,    "label": label,  };}class MyApplication {  MyApplication({    this.status,    this.id,    this.topic,    this.applicationId,    this.username,    this.institution,    this.coverLetter,    this.shareDashboard,    this.job,    this.response,    this.interview,  });  String? status;  String? id;  String? topic;  String? applicationId;  String? username;  String? institution;  String? coverLetter;  bool? shareDashboard;  String? job;  List<dynamic>? response;  List<dynamic>? interview;  factory MyApplication.fromJson(Map<String, dynamic> json) => MyApplication(    status: json["status"],    id: json["_id"],    topic: json["topic"],    applicationId: json["applicationId"],    username: json["username"],    institution: json["institution"],    coverLetter: json["coverLetter"],    shareDashboard: json["shareDashboard"],    job: json["job"],    response: List<dynamic>.from(json["response"].map((x) => x)),    interview: List<dynamic>.from(json["interview"].map((x) => x)),  );  Map<String, dynamic> toJson() => {    "status": status,    "_id": id,    "topic": topic,    "applicationId": applicationId,    "username": username,    "institution": institution,    "coverLetter": coverLetter,    "shareDashboard": shareDashboard,    "job": job,    "response": List<dynamic>.from(response!.map((x) => x)),    "interview": List<dynamic>.from(interview!.map((x) => x)),  };}class Organization {  Organization({    this.footerLogo,    this.image,    this.name,    this.address,  });  String? footerLogo;  String? image;  String? name;  String? address;  factory Organization.fromJson(Map<String, dynamic> json) => Organization(    footerLogo: json["footerLogo"],    image: json["image"],    name: json["name"],    address: json["address"],  );  Map<String, dynamic> toJson() => {    "footerLogo": footerLogo,    "image": image,    "name": name,    "address": address,  };}class Salary {  Salary({    this.value,    this.from,    this.upto,  });  String? value;  int? from;  dynamic? upto;  factory Salary.fromJson(Map<String, dynamic> json) => Salary(    value: json["value"],    from: json["from"],    upto: json["upto"],  );  Map<String, dynamic> toJson() => {    "value": value,    "from": from,    "upto": upto,  };}