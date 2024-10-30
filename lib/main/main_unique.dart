import 'package:flutter/material.dart';
import '../config/flavor_config.dart';
import 'main.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Unique Nepal Academy"
    ..institution = "una"
    ..androidID = "np.edu.schoolworkspro.uniques"
    ..iosID = "np.edu.schoolworkspro.uniques"
    ..apiEndpoint = {
      Endpoints.items: "https://api.schoolworkspro.com/",
      Endpoints.details: "https://api.schoolworkspro.com/"
    }
    ..imageLocation = "assets/partners/unique.png"
    ..theme = ThemeData.light().copyWith(
        primaryColor: const Color(0XFF123456),
        appBarTheme: ThemeData.light()
            .appBarTheme
            .copyWith(backgroundColor: const Color(0xFF654321))));
}
