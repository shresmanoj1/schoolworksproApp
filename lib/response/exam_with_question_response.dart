class ExamWithQuestionResponse {
  bool? success;
  Exam? exam;

  ExamWithQuestionResponse({this.success, this.exam});

  ExamWithQuestionResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    exam = json['exam'] != null ? new Exam.fromJson(json['exam']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.exam != null) {
      data['exam'] = this.exam!.toJson();
    }
    return data;
  }
}

class Exam {
  String? status;
  num? fullMarks;
  num? passMarks;
  List<Questions>? questions;
  bool? examCodeEnabled;
  bool? singleSessionEnabled;
  String? sId;
  String? examTitle;
  String? startDate;
  String? endDate;
  String? remarks;
  String? duration;

  Exam(
      {this.status,
        this.fullMarks,
        this.passMarks,
        this.questions,
        this.examCodeEnabled,
        this.singleSessionEnabled,
        this.sId,
        this.examTitle,
        this.startDate,
        this.endDate,
        this.remarks,
        this.duration});

  Exam.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    fullMarks = json['fullMarks'];
    passMarks = json['passMarks'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
    examCodeEnabled = json['examCodeEnabled'];
    singleSessionEnabled = json['singleSessionEnabled'];
    sId = json['_id'];
    examTitle = json['examTitle'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    remarks = json['remarks'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['fullMarks'] = this.fullMarks;
    data['passMarks'] = this.passMarks;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    data['examCodeEnabled'] = this.examCodeEnabled;
    data['singleSessionEnabled'] = this.singleSessionEnabled;
    data['_id'] = this.sId;
    data['examTitle'] = this.examTitle;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['remarks'] = this.remarks;
    data['duration'] = this.duration;
    return data;
  }
}

class Questions {
  bool? hasCodeAnswer;
  List<dynamic>? codeOptions;
  String? sId;
  num? fullMarks;
  String? question;
  String? questionType;
  String? institution;
  List<String>? options;

  Questions(
      {this.hasCodeAnswer,
        this.codeOptions,
        this.sId,
        this.fullMarks,
        this.question,
        this.questionType,
        this.institution,
        this.options});

  Questions.fromJson(Map<String, dynamic> json) {
    hasCodeAnswer = json['hasCodeAnswer'];
    if (json['codeOptions'] != null) {
      codeOptions = <dynamic>[];
      json['codeOptions'].forEach((v) {
        codeOptions!.add(v);
      });
    }
    sId = json['_id'];
    fullMarks = json['fullMarks'];
    question = json['question'];
    questionType = json['questionType'];
    institution = json['institution'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hasCodeAnswer'] = this.hasCodeAnswer;
    if (this.codeOptions != null) {
      data['codeOptions'] = this.codeOptions!.map((v) => v?.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['fullMarks'] = this.fullMarks;
    data['question'] = this.question;
    data['questionType'] = this.questionType;
    data['institution'] = this.institution;
    data['options'] = this.options;
    return data;
  }
}
