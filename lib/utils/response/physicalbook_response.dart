// To parse this JSON data, do
//
//     final physicalbookresponse = physicalbookresponseFromJson(jsonString);

import 'dart:convert';

Physicalbookresponse physicalbookresponseFromJson(String str) =>
    Physicalbookresponse.fromJson(json.decode(str));

String physicalbookresponseToJson(Physicalbookresponse data) =>
    json.encode(data.toJson());

class Physicalbookresponse {
  Physicalbookresponse({
    this.success,
    this.books,
  });

  bool? success;
  List<dynamic>? books;

  factory Physicalbookresponse.fromJson(Map<String, dynamic> json) =>
      Physicalbookresponse(
        success: json["success"],
        books: List<dynamic>.from(json["books"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "books": List<dynamic>.from(books!.map((x) => x.toJson())),
      };
}

// class Book {
//   Book({
//     this.id,
//     this.thumbnail,
//     this.isAvailable,
//     this.name,
//     this.author,
//     this.slug,
//     this.publishedYear,
//     this.edition,
//     this.category,
//     this.intro,
//     this.isbn,
//     this.price,
//     this.quantity,
//     this.institution,
//     this.createdAt,
//   });
//
//   String id;
//   String thumbnail;
//   bool isAvailable;
//   String name;
//   String author;
//   String slug;
//   String publishedYear;
//   String edition;
//   Category category;
//   String intro;
//   String isbn;
//   int price;
//   int quantity;
//   Institution institution;
//   DateTime createdAt;
//
//   factory Book.fromJson(Map<String, dynamic> json) => Book(
//     id: json["_id"],
//     thumbnail: json["thumbnail"],
//     isAvailable: json["is_available"],
//     name: json["name"],
//     author: json["author"],
//     slug: json["slug"],
//     publishedYear: json["published_year"],
//     edition: json["edition"],
//     category: json["category"] == null ? null : Category.fromJson(json["category"]),
//     intro: json["intro"],
//     isbn: json["isbn"],
//     price: json["price"],
//     quantity: json["quantity"],
//     institution: institutionValues.map[json["institution"]],
//     createdAt: DateTime.parse(json["createdAt"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "thumbnail": thumbnail,
//     "is_available": isAvailable,
//     "name": name,
//     "author": author,
//     "slug": slug,
//     "published_year": publishedYear,
//     "edition": edition,
//     "category": category == null ? null : category.toJson(),
//     "intro": intro,
//     "isbn": isbn,
//     "price": price,
//     "quantity": quantity,
//     "institution": institutionValues.reverse[institution],
//     "createdAt": createdAt.toIso8601String(),
//   };
// }
//
// class Category {
//   Category({
//     this.id,
//     this.createdAt,
//     this.institution,
//     this.name,
//     this.slug,
//     this.softDelete,
//   });
//
//   Id id;
//   DateTime createdAt;
//   List<Institution> institution;
//   Name name;
//   Slug slug;
//   bool softDelete;
//
//   factory Category.fromJson(Map<String, dynamic> json) => Category(
//     id: idValues.map[json["_id"]],
//     createdAt: DateTime.parse(json["createdAt"]),
//     institution: List<Institution>.from(json["institution"].map((x) => institutionValues.map[x])),
//     name: nameValues.map[json["name"]],
//     slug: slugValues.map[json["slug"]],
//     softDelete: json["soft_delete"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": idValues.reverse[id],
//     "createdAt": createdAt.toIso8601String(),
//     "institution": List<dynamic>.from(institution.map((x) => institutionValues.reverse[x])),
//     "name": nameValues.reverse[name],
//     "slug": slugValues.reverse[slug],
//     "soft_delete": softDelete,
//   };
// }
//
// enum Id { THE_5_FAE06_E6_D0_D4171_CFBA7_E70_C, THE_5_FB5_E1_C3855300533_D35_B21_F }
//
// final idValues = EnumValues({
//   "5fae06e6d0d4171cfba7e70c": Id.THE_5_FAE06_E6_D0_D4171_CFBA7_E70_C,
//   "5fb5e1c3855300533d35b21f": Id.THE_5_FB5_E1_C3855300533_D35_B21_F
// });
//
// enum Institution { SOFTWARICA }
//
// final institutionValues = EnumValues({
//   "softwarica": Institution.SOFTWARICA
// });
//
// enum Name { PROGRAMMING, DATA_ANALYSIS }
//
// final nameValues = EnumValues({
//   "Data Analysis": Name.DATA_ANALYSIS,
//   "Programming": Name.PROGRAMMING
// });
//
// enum Slug { PROGRAMMING_REV1, DATA_ANALYSIS_REV1 }
//
// final slugValues = EnumValues({
//   "data-analysis-rev1": Slug.DATA_ANALYSIS_REV1,
//   "programming-rev1": Slug.PROGRAMMING_REV1
// });
//
// class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }
