import 'package:picacg/rust/api/types/image_entity.dart';

mixin HomeStore {
  String getImageUrl(ImageEntity image) {
    String baseUrl = image.fileServer;
    if (image.fileServer.endsWith('/')) {
      baseUrl = image.fileServer.substring(0, image.fileServer.length - 1);
    }

    return "$baseUrl/static/${image.path}";
  }

  String formatImageUrl(String url) {
    if (url.contains('//static/')) {
      return url.replaceAll('//static/', '/static/');
    }

    return url;
  }
}
