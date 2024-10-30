// To parse this JSON data, do
//
//     final slideResponse = slideResponseFromJson(jsonString);

import 'dart:convert';

SlideResponse slideResponseFromJson(String str) =>
    SlideResponse.fromJson(json.decode(str));

String slideResponseToJson(SlideResponse data) => json.encode(data.toJson());

class SlideResponse {
  SlideResponse({
    this.success,
    this.count,
    this.files,
  });

  bool? success;
  int? count;
  List<FileElement>? files;

  factory SlideResponse.fromJson(Map<String, dynamic> json) => SlideResponse(
        success: json["success"],
        count: json["count"],
        files: List<FileElement>.from(
            json["files"].map((x) => FileElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "count": count,
        "files": List<dynamic>.from(files!.map((x) => x.toJson())),
      };
}

class FileElement {
  FileElement({
    this.originalname,
    this.filename,
  });

  String? originalname;
  String? filename;

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        originalname: json["originalname"],
        filename: json["filename"],
      );

  Map<String, dynamic> toJson() => {
        "originalname": originalname,
        "filename": filename,
      };
}
