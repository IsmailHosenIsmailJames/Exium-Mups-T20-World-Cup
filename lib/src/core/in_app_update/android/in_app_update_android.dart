// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../breakpoint.dart';
import '../../../../theme/show_toast_message.dart';

void showDialogForMobileUpdate(BuildContext context, String deviceV,
    String lastV, Map<String, dynamic> jsonData) async {
  String changes = jsonData['changes'];
  List files = jsonData['apkLinks'];
  String? apkURL;
  for (var e in files) {
    apkURL = e;
  }
  if (apkURL == null) {
    return;
  }

  String? apkFilePathOnDevice;

  final directory = await getExternalStorageDirectory();
  String p = "";
  if (directory == null) {
    return;
  } else {
    p = join(directory.path, lastV, apkURL.split("/").last);
  }

  bool isExitsErliter = await File(p).exists();

  if (!isExitsErliter) {
    await showDialog(
      context: context,
      builder: (context) {
        final processController = Get.put(ProcessInicator());
        return Dialog(
          insetPadding: MediaQuery.of(context).size.width > breakPointWidth
              ? null
              : const EdgeInsets.all(10),
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 300,
            width: MediaQuery.of(context).size.width > breakPointWidth
                ? 600
                : MediaQuery.of(context).size.width * 0.95,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(20),
                const Icon(
                  Icons.system_update_alt_rounded,
                  size: 60,
                ),
                const Gap(20),
                GetX<ProcessInicator>(
                  builder: (controller) => Text(
                    controller.percentage.value,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const Gap(10),
                const Text(
                  "Changes : ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(changes),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(10)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Not now",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                    const Gap(20),
                    ElevatedButton(
                      onPressed: () async {
                        final dio = Dio();

                        await dio.download(
                          apkURL!,
                          p,
                          onReceiveProgress: (received, total) {
                            if (total != -1) {
                              processController.percentage.value =
                                  "Downloading : ${(received / total * 100).toStringAsFixed(0)}%";
                            }
                          },
                        );

                        apkFilePathOnDevice = p;
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Download",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  } else {
    apkFilePathOnDevice = p;
  }

  if (apkFilePathOnDevice != null) {
    if (!await Permission.requestInstallPackages.isGranted) {
      await showDialog(
        context: context,
        builder: (context) => Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 300,
            width: MediaQuery.of(context).size.width > breakPointWidth
                ? 600
                : MediaQuery.of(context).size.width * 0.95,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(20),
                const Icon(
                  Icons.settings,
                  size: 60,
                ),
                const Gap(20),
                const Text(
                  "APK installation is restricted for this app.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const Text(
                  "You can enable this in system settings",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const Gap(15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(10)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Not now",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                    const Gap(20),
                    ElevatedButton(
                      onPressed: () async {
                        await Permission.requestInstallPackages.request();
                        if (await Permission.requestInstallPackages.isGranted) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "Settings",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
    if (!await Permission.requestInstallPackages.isGranted) {
      showToastedMessage("Something went worng");
      return;
    }
  }

  if (apkFilePathOnDevice != null &&
      await Permission.requestInstallPackages.isGranted) {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 300,
            width: MediaQuery.of(context).size.width > breakPointWidth
                ? 600
                : MediaQuery.of(context).size.width * 0.95,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(20),
                const Icon(
                  Icons.system_update_alt_rounded,
                  size: 60,
                ),
                const Gap(20),
                const Text(
                  "Ready for install the update!",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Gap(10),
                const Text(
                  "Changes : ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(changes),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(10)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Not now",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                    const Gap(10),
                    ElevatedButton(
                      onPressed: () async {
                        await OpenFilex.open(apkFilePathOnDevice);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Install",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProcessInicator extends GetxController {
  RxString percentage = "We have an Update available.".obs;
}
