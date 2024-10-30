import 'dart:convert';

Ratingresponse ratingresponseFromJson(String str) =>
    Ratingresponse.fromJson(json.decode(str));

String ratingresponseToJson(Ratingresponse data) => json.encode(data.toJson());

class Ratingresponse {
  Ratingresponse({
    this.success,
    this.averageRating,
  });

  bool? success;
  double? averageRating;

  factory Ratingresponse.fromJson(Map<String, dynamic> json) => Ratingresponse(
        success: json["success"],
        averageRating: json["averageRating"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "averageRating": averageRating,
      };
}
