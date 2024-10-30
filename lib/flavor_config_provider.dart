import 'package:flutter/material.dart';

import 'config/flavor_config.dart';


class FlavorConfigProvider extends ChangeNotifier {
  FlavorConfig _config;

  FlavorConfigProvider(this._config);

  FlavorConfig get config => _config;

  set config(FlavorConfig newConfig) {
    _config = newConfig;
    notifyListeners();
  }
}
