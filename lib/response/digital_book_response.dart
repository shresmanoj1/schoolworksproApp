// // To parse this JSON data, do
// //
// //     final digitalBookResponse = digitalBookResponseFromJson(jsonString);
//
// import 'dart:convert';
//
// DigitalBookResponse digitalBookResponseFromJson(String str) => DigitalBookResponse.fromJson(json.decode(str));
//
// String digitalBookResponseToJson(DigitalBookResponse data) => json.encode(data.toJson());
//
// class DigitalBookResponse {
//   DigitalBookResponse({
//     this.success,
//     this.count,
//     this.books,
//   });
//
//   bool ? success;
//   int ? count;
//   List<dynamic> ? books;
//
//   factory DigitalBookResponse.fromJson(Map<String, dynamic> json) => DigitalBookResponse(
//     success: json["success"],
//     count: json["count"],
//     books: List<dynamic>.from(json["books"].map((x) => on(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "count": count,
//     "books": List<dynamic>.from(books!.map((x) => x.toJson())),
//   };
// }
//
// class Book {
//   Book({
//     this.id,
//     this.softDelete,
//     this.institution,
//     this.name,
//     this.slug,
//     this.size,
//     this.file,
//     this.category,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//   });
//
//   String ? id;
//   bool ? softDelete;
//   List<dynamic> ? institution;
//   String ? name;
//   String ? slug;
//   String ? size;
//   String ? file;
//   Category ? category;
//   DateTime ? createdAt;
//   DateTime ? updatedAt;
//   int ? v;
//
//   factory Book.fromJson(Map<String, dynamic> json) => Book(
//     id: json["_id"],
//     softDelete: json["soft_delete"],
//     institution: List<dynamic>.from(json["institution"].map((x) => x)),
//     name: json["name"],
//     slug: json["slug"],
//     size: json["size"],
//     file: json["file"],
//     category: Category.fromJson(json["category"]),
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//     v: json["__v"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "soft_delete": softDelete,
//     "institution": List<dynamic>.from(institution!.map((x) => x)),
//     "name": name,
//     "slug": slug,
//     "size": size,
//     "file": file,
//     "category": category?.toJson(),
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//     "__v": v,
//   };
// }
//
// class Category {
//   Category({
//     this.id,
//     this.institution,
//     this.softDelete,
//     this.name,
//     this.slug,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//   });
//
//   String ? id;
//   List<dynamic> ? institution;
//   bool ? softDelete;
//   String ? name;
//   String ? slug;
//   DateTime ? createdAt;
//   DateTime ? updatedAt;
//   int ? v;
//
//   factory Category.fromJson(Map<String, dynamic> json) => Category(
//     id: json["_id"],
//     institution: List<dynamic>.from(json["institution"].map((x) => x)),
//     softDelete: json["soft_delete"],
//     name: json["name"],
//     slug: json["slug"],
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//     v: json["__v"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "institution": List<dynamic>.from(institution!.map((x) => x)),
//     "soft_delete": softDelete,
//     "name": name,
//     "slug": slug,
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//     "__v": v,
//   };
// }
