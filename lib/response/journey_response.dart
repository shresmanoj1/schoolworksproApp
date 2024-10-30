// To parse this JSON data, do
//
//     final journeyresponse = journeyresponseFromJson(jsonString);

import 'dart:convert';

Journeyresponse journeyresponseFromJson(String str) => Journeyresponse.fromJson(json.decode(str));

String journeyresponseToJson(Journeyresponse data) => json.encode(data.toJson());

class Journeyresponse {
    Journeyresponse({
        this.success,
        this.allData,
        this.user,
    });

    bool ? success;
    List<AllDatum> ? allData;
    JUser ? user;

    factory Journeyresponse.fromJson(Map<String, dynamic> json) => Journeyresponse(
        success: json["success"],
        allData: List<AllDatum>.from(json["allData"].map((x) => AllDatum.fromJson(x))),
        user: JUser.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "allData": List<dynamic>.from(allData!.map((x) => x.toJson())),
        "user": user!.toJson(),
    };
}

class AllDatum {
    AllDatum({
        this.academicDetails,
        this.institution,
        this.marks,
        this.modules,
        this.projects,
    });

    AcademicDetails ? academicDetails;
    Institution ? institution;
    List<dynamic> ? marks;
    List<Module> ? modules;
    List<Project> ? projects;

    factory AllDatum.fromJson(Map<String, dynamic> json) => AllDatum(
        academicDetails: AcademicDetails.fromJson(json["academicDetails"]),
        institution: Institution.fromJson(json["institution"]),
        marks: List<dynamic>.from(json["marks"].map((x) => x)),
        modules: List<Module>.from(json["modules"].map((x) => Module.fromJson(x))),
        projects: List<Project>.from(json["projects"].map((x) => Project.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "academicDetails": academicDetails!.toJson(),
        "institution": institution!.toJson(),
        "marks": List<dynamic>.from(marks!.map((x) => x)),
        "modules": List<dynamic>.from(modules!.map((x) => x.toJson())),
        "projects": List<dynamic>.from(projects!.map((x) => x.toJson())),
    };
}

class AcademicDetails {
    AcademicDetails({
        this.username,
        this.batch,
        this.course,
        this.createdAt,
    });

    String ? username;
    String ? batch;
    String ? course;
    DateTime ? createdAt;

    factory AcademicDetails.fromJson(Map<String, dynamic> json) => AcademicDetails(
        username: json["username"],
        batch: json["batch"],
        course: json["course"],
        createdAt: DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "batch": batch,
        "course": course,
        "createdAt": createdAt!.toIso8601String(),
    };
}

class Institution {
    Institution({
        this.name,
        this.address,
        this.contact,
        this.email,
        this.footerLogo,
    });

    String ? name;
    String ? address;
    String ? contact;
    String ? email;
    String ? footerLogo;

    factory Institution.fromJson(Map<String, dynamic> json) => Institution(
        name: json["name"],
        address: json["address"],
        contact: json["contact"],
        email: json["email"],
        footerLogo: json["footerLogo"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "contact": contact,
        "email": email,
        "footerLogo": footerLogo,
    };
}

class Module {
    Module({
        this.moduleTitle,
        this.attendance,
        this.progress,
    });

    String ? moduleTitle;
    dynamic attendance;
    int  ? progress;

    factory Module.fromJson(Map<String, dynamic> json) => Module(
        moduleTitle: json["moduleTitle"],
        attendance: json["attendance"],
        progress: json["progress"],
    );

    Map<String, dynamic> toJson() => {
        "moduleTitle": moduleTitle,
        "attendance": attendance,
        "progress": progress,
    };
}

class Project {
    Project({
        this.id,
        this.title,
        this.link,
    });

    String  ?id;
    String ? title;
    String ? link;

    factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json["_id"],
        title: json["title"],
        link: json["link"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "link": link,
    };
}

class JUser {
    JUser({
        this.firstname,
        this.lastname,
        this.userImage,
        this.email,
        this.contact,
        this.isPublic,
    });

    String ? firstname;
    String  ?lastname;
    String ? userImage;
    String ? email;
    String ? contact;
    bool ? isPublic;

    factory JUser.fromJson(Map<String, dynamic> json) => JUser(
        firstname: json["firstname"],
        lastname: json["lastname"],
        userImage: json["userImage"],
        email: json["email"],
        contact: json["contact"],
        isPublic: json["isPublic"],
    );

    Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "userImage": userImage,
        "email": email,
        "contact": contact,
        "isPublic": isPublic,
    };
}
