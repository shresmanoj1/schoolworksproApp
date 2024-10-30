import 'package:hive/hive.dart';

class HiveUtils {
  static late final Box box;

  static Future<Box> init() async {
    box = await Hive.openBox("swp_box");
    return box;
  }
}
