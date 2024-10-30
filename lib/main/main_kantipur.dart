import 'package:flutter/material.dart';
import '../config/flavor_config.dart';
import 'main.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Kantipur English High School"
    ..androidID = "np.edu.schoolworkspro.kantipur"
    ..iosID = "np.edu.schoolworkspro.kantipur"
    ..apiEndpoint = {
      Endpoints.items: "https://api.schoolworkspro.com/",
      Endpoints.details: "https://api.schoolworkspro.com/"
    }
    ..imageLocation = "assets/partners/kantipur.png"
    ..theme = ThemeData.light().copyWith(
        primaryColor: const Color(0XFF123456),
        appBarTheme: ThemeData.light()
            .appBarTheme
            .copyWith(backgroundColor: const Color(0xFF654321))));
}
