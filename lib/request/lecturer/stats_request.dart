class StudentStatsRequest {
  StudentStatsRequest({
    this.username,

  });

  String? username;


  Map<String, dynamic> toJson() => {
    "username": username,

  };
}
