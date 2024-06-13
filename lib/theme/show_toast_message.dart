import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

void showToastedMessage(String msg) {
  bool possibleToShowTwoatsedMessage =
      Platform.isIOS || Platform.isAndroid || kIsWeb;
  if (possibleToShowTwoatsedMessage) {
    Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_LONG);
  } else {
    Get.showSnackbar(GetSnackBar(
      message: msg,
      duration: const Duration(seconds: 2),
    ));
  }
}
