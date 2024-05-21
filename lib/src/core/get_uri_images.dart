import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<Uint8List?> getUriImage(String url) async {
  Directory cachedDir = await getApplicationCacheDirectory();
  final file = File(Uri.file(
          "${cachedDir.path}/${url.replaceAll("/", "").replaceAll(":", "")}")
      .path);
  if (await file.exists()) {
    Uint8List dataOfIamge = await file.readAsBytes();
    return dataOfIamge;
  } else {
    http.Response httpData = await http.get(Uri.parse(url));
    if (httpData.statusCode == 200) {
      Uint8List imageData = httpData.bodyBytes;
      final uri = Uri.file(
          "${cachedDir.path}/${url.replaceAll("/", "").replaceAll(":", "")}");
      await File(uri.path).writeAsBytes(imageData);
      return imageData;
    } else {
      return null;
    }
  }
}
