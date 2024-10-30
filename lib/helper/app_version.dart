import 'dart:io';

import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';

import '../flavor_config_provider.dart';

class VersionChecker {

  static void checkVersion(BuildContext context) async {
    final flavorConfigProvider = Provider.of<FlavorConfigProvider>(context);
    final config = flavorConfigProvider.config;
    final newVersion = NewVersion(
      androidId: config.androidID,
      iOSId: config.iosID,
    );

    try {
      final status = await newVersion.getVersionStatus();
      if (status != null) {
        if (Platform.isAndroid) {
          if (status.localVersion != status.storeVersion && context.mounted) {
            newVersion.showUpdateDialog(
              dialogText: "You need to update this application",
              context: context,
              versionStatus: status,
            );
          }
        } else if (Platform.isIOS) {
          if (status.canUpdate && context.mounted) {
            newVersion.showUpdateDialog(
              dialogText: "You need to update this application",
              context: context,
              versionStatus: status,
            );
          }
        }
      }
    } catch (e) {
      print("Error checking version: $e");
    }
  }
}
