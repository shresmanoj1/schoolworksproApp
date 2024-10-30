class Journalrequest {
  Journalrequest({
    this.title,
    this.intro,
    this.content,
  });

  String ? title;
  String ? intro;
  String ? content;

  Map<String, dynamic> toJson() => {
    "title": title,
    "intro": intro,
    "content": content,
  };
}
