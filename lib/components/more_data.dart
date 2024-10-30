import 'package:flutter/material.dart';

class EmptyWidget {
  static Widget kEmpty = Image.asset('assets/images/no_content.PNG');
}

List<dynamic> menu_lecturer = [
  MenuLecturer(
      title: "Edit Profile",
      image: "assets/icons/profileicons/user.png",
      description: "Update details",
      tapValue: 0),
  MenuLecturer(
      title: "Overtime",
      image: "assets/icons/Lecturerprofileicons/overtime.png",
      tapValue: 1,
      description: "Request for overtime"),
  MenuLecturer(
      title: "Books",
      image: "assets/icons/profileicons/book.png",
      tapValue: 2,
      description: "Books you requested to borrow"),
  // MenuLecturer(
  //     title: "Requests",
  //     tapValue: 4,
  //     image: "assets/icons/profileicons/logout.png",
  //     description: "Add or view your logistics request"),
  MenuLecturer(
      title: "Settings",
      tapValue: 3,
      image: 'assets/icons/Lecturerprofileicons/settings.png',
      description: "Update Your Password"),
  MenuLecturer(
      title: "Logout",
      tapValue: 4,
      image: "assets/icons/profileicons/logout.png",
      description: "Logout your account from device"),
  // MenuLecturer(
  //     title: "Inventory",
  //     tapValue: 5,
  //     image: "assets/icons/inventory.png",
  //     description: "can't find item in inventory?. Order here"),
  // MenuLecturer(
  //     title: "Update Logistics/Inventory",
  //     image: "assets/icons/update.png",
  //     tapValue: 6,
  //     description: "Update request and give feedback"),
  // MenuLecturer(
  //     title: "Subject Attendance Report",
  //     tapValue: 7,
  //     image: "assets/images/report.png",
  //     description: "Subject wise attendance report"),
  // MenuLecturer(
  //     title: "Student Stats",
  //     tapValue: 8,
  //     image: "assets/icons/tickets.png",
  //     description: "Active student details"),
  // MenuLecturer(
  //     title: "Student Leave",
  //     tapValue: 9,
  //     image: "assets/icons/student_leave.png",
  //     description: "Student Leave details"),
  //
  // MenuLecturer(
  //     title: "Logout",
  //     tapValue: 10,
  //     image: "assets/images/logout_app.png",
  //     description: "Logout your account from device"),
];

class MenuLecturer {
  MenuLecturer({this.image, this.title, this.description, this.tapValue});

  String? title;
  String? description;
  String? image;
  int? tapValue;
}
