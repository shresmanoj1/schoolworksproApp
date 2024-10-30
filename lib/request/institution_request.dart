import 'dart:convert';

class Institutionrequest {
  Institutionrequest({
    this.institution,
  });

  String? institution;

  Map<String, dynamic> toJson() => {
        "institution": institution,
      };
}
