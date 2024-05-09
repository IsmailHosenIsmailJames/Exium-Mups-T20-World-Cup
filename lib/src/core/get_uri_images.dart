import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

Future<Uint8List?> getUriImage(String url) async {
  Directory cachedDir = await getApplicationCacheDirectory();
  final box = await Hive.openBox(url.replaceAll("/", "").replaceAll(":", ""),
      path: cachedDir.path);
  final data = box.get("image", defaultValue: null);
  if (data == null) {
    http.Response httpData = await http.get(Uri.parse(url));
    if (httpData.statusCode == 200) {
      Uint8List imageData = httpData.bodyBytes;
      await box.put("image", imageData);
      await box.close();
      return imageData;
    } else {
      await box.close();
      return null;
    }
  } else {
    await box.close();
    return Uint8List.fromList(List<int>.from(data));
  }
}
