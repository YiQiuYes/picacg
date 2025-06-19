import 'package:picacg/provider/config_provider.dart';
import 'package:picacg/rust/api/types/image_entity.dart';

class ResUtil {
  static String getImageUrl(ImageEntity image) {
    String baseUrl = globalConfig.netData.imageServer;
    baseUrl = baseUrl.replaceAll(RegExp(r'/static.*'), '');

    String path = image.path;
    if (image.path.startsWith('/')) {
      return path = image.path.substring(1);
    }

    return "$baseUrl/static/$path";
  }
}
