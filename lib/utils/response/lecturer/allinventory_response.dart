import 'dart:convert';

AllInventorysresponse allInventorysresponseFromJson(String str) =>
    AllInventorysresponse.fromJson(json.decode(str));

String allInventorysresponseToJson(AllInventorysresponse data) =>
    json.encode(data.toJson());

class AllInventorysresponse {
  AllInventorysresponse({
    this.success,
    this.allInventory,
  });

  bool? success;
  List<dynamic>? allInventory;

  factory AllInventorysresponse.fromJson(Map<String, dynamic> json) =>
      AllInventorysresponse(
        success: json["success"],
        allInventory: List<dynamic>.from(json["allInventory"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "allInventory": List<dynamic>.from(allInventory!.map((x) => x)),
      };
}
