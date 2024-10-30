import 'dart:convert';

checkquizquestionrequest checkquizquestionRequestFromJson(String str) => checkquizquestionrequest.fromJson(json.decode(str));

String checkquizquestionRequestToJson(checkquizquestionrequest data) => json.encode(data.toJson());

class checkquizquestionrequest {
  checkquizquestionrequest({

    this.success,
    this.hasCodeAnswer,
  });


  bool? success;
  bool ?hasCodeAnswer;

  factory checkquizquestionrequest.fromJson(Map<String, dynamic> json) => checkquizquestionrequest(

    success: json["discount"],
    hasCodeAnswer: json["hasCodeAnswer"],
  );

  Map<String, dynamic> toJson() => {

    "discount": success,
    "hasCodeAnswer": hasCodeAnswer,
  };
}




