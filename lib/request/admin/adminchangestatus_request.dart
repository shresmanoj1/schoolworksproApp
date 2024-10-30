

class AdminChangeTicketStatusRequest {
  AdminChangeTicketStatusRequest({
    this.status,
  });

  String ? status;

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
