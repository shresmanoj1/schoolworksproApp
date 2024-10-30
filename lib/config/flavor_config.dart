import 'package:flutter/material.dart';

enum Endpoints { items, details }

class FlavorConfig {
  String? appTitle;
  String? institution;
  Map<Endpoints, String>? apiEndpoint;
  String? imageLocation;
  String? androidID;
  String? iosID;
  ThemeData? theme;

  FlavorConfig(
      {this.theme,this.institution, this.imageLocation, this.appTitle, this.apiEndpoint,this.androidID,this.iosID});
}
