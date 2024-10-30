class ExamScoreResponse {
  bool? success;
  List<Answers>? answers;
  ExamScore? examScore;

  ExamScoreResponse({this.success, this.answers, this.examScore});

  ExamScoreResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(new Answers.fromJson(v));
      });
    }
    examScore = json['examScore'] != null
        ? new ExamScore.fromJson(json['examScore'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.answers != null) {
      data['answers'] = this.answers!.map((v) => v.toJson()).toList();
    }
    if (this.examScore != null) {
      data['examScore'] = this.examScore!.toJson();
    }
    return data;
  }
}

class Answers {
  List<String>? incorrectAnswers;
  bool? hasCodeAnswer;
  dynamic? codeOptions;
  List<String>? correctAnswers;
  dynamic fullMarks;
  String? question;
  String? questionType;
  String? questionId;
  String? answerType;
  List<String>? objectiveAnswers;
  bool? isSubjective;
  String? sId;
  String? username;
  String? answer;
  String? codeAnswer;
  dynamic marks;
  List<String>? options;

  Answers(
      {this.incorrectAnswers,
      this.hasCodeAnswer,
      this.codeOptions,
      this.correctAnswers,
      this.fullMarks,
      this.question,
      this.questionType,
      this.questionId,
      this.answerType,
      this.objectiveAnswers,
      this.isSubjective,
      this.sId,
      this.username,
      this.answer,
      this.codeAnswer,
      this.marks,
      this.options});

  Answers.fromJson(Map<String, dynamic> json) {
    incorrectAnswers = json['incorrectAnswers'].cast<String>();
    hasCodeAnswer = json['hasCodeAnswer'];
    correctAnswers = json['correctAnswers'].cast<String>();
    fullMarks = json['fullMarks'];
    question = json['question'];
    questionType = json['questionType'];
    questionId = json['questionId'];
    answerType = json['answerType'];
    objectiveAnswers = json['objectiveAnswers'] == null
        ? null
        : json['objectiveAnswers'].cast<String>();
    isSubjective = json['isSubjective'];
    sId = json['_id'];
    username = json['username'];
    answer = json['answer'];
    codeAnswer = json['codeAnswer'];
    marks = json['marks'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['incorrectAnswers'] = this.incorrectAnswers;
    data['hasCodeAnswer'] = data['codeOptions'];
    data['correctAnswers'] = this.correctAnswers;
    data['fullMarks'] = this.fullMarks;
    data['question'] = this.question;
    data['questionType'] = this.questionType;
    data['questionId'] = this.questionId;
    data['answerType'] = this.answerType;
    data['objectiveAnswers'] = this.objectiveAnswers;
    data['isSubjective'] = this.isSubjective;
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['answer'] = this.answer;
    data['codeAnswer'] = this.codeAnswer;
    data['marks'] = this.marks;
    data['options'] = this.options;
    return data;
  }
}

class ExamScore {
  String? sId;
  String? examId;
  String? username;
  dynamic iV;
  String? createdAt;
  String? institution;
  dynamic score;
  String? updatedAt;

  ExamScore(
      {this.sId,
      this.examId,
      this.username,
      this.iV,
      this.createdAt,
      this.institution,
      this.score,
      this.updatedAt});

  ExamScore.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    examId = json['examId'];
    username = json['username'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    institution = json['institution'];
    score = json['score'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['examId'] = this.examId;
    data['username'] = this.username;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['institution'] = this.institution;
    data['score'] = this.score;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
