// To parse this JSON data, do
//
//     final routineresponse = routineresponseFromJson(jsonString);

import 'dart:convert';

Routineresponse routineresponseFromJson(String str) => Routineresponse.fromJson(json.decode(str));

String routineresponseToJson(Routineresponse data) => json.encode(data.toJson());

class Routineresponse {
    Routineresponse({
        this.success,
        this.routines,
    });

    bool ? success;
    List<dynamic> ? routines;

    factory Routineresponse.fromJson(Map<String, dynamic> json) => Routineresponse(
        success: json["success"],
        routines: List<dynamic>.from(json["routines"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "routines": List<dynamic>.from(routines!.map((x) => x)),
    };
}

class Routine {
    Routine({
        this.id,
        this.title,
        this.batch,
        this.lecturer,
        this.block,
        this.classRoom,
        this.classLink,
        this.start,
        this.end,
    });

    String ? id;
    String ? title;
    String ? batch;
    Lecturer ? lecturer;
    String ? block;
    String ? classRoom;
    String ? classLink;
    DateTime ? start;
    DateTime  ? end;

    factory Routine.fromJson(Map<String, dynamic> json) => Routine(
        id: json["_id"],
        title: json["title"],
        batch: json["batch"],
        lecturer: Lecturer.fromJson(json["lecturer"]),
        block: json["block"],
        classRoom: json["classRoom"],
        classLink: json["classLink"],
        start: DateTime.parse(json["start"]),
        end: DateTime.parse(json["end"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "batch": batch,
        "lecturer": lecturer!.toJson(),
        "block": block,
        "classRoom": classRoom,
        "classLink": classLink,
        "start": start!.toIso8601String(),
        "end": end!.toIso8601String(),
    };
}

class Lecturer {
    Lecturer({
        this.firstname,
        this.lastname,
        this.email,
    });

    String ? firstname;
    String ? lastname;
    String ? email;

    factory Lecturer.fromJson(Map<String, dynamic> json) => Lecturer(
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
    };
}

class EnumValues<T> {
    Map<String, T> ? map;
    Map<T, String> ? reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap ??= map!.map((k, v) =>  MapEntry(v, k));
        return reverseMap!;
    }
}
