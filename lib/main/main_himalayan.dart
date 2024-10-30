import 'package:flutter/material.dart';
import '../config/flavor_config.dart';
import 'main.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Himalayan Public School"
    ..androidID = "np.edu.schoolworkspro.himalayan"
    ..iosID = "np.edu.schoolworkspro.himalayan"
    ..apiEndpoint = {
      Endpoints.items: "https://api.schoolworkspro.com/",
      Endpoints.details: "https://api.schoolworkspro.com/"
    }
    ..imageLocation = "assets/partners/himalayan.jpg"
    ..theme = ThemeData.light().copyWith(
        primaryColor: const Color(0XFF123456),
        appBarTheme: ThemeData.light()
            .appBarTheme
            .copyWith(backgroundColor: const Color(0xFF654321))));
}
