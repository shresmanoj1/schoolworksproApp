import '../config/environment.config.dart';

class ImageFromNetwork {

  static String fullImageUrl(
    String url,){
    return "${EnvironmentConfig.url}/$url";
  }
}
