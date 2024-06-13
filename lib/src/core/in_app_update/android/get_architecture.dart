import 'package:device_info_plus/device_info_plus.dart';

Future<String> getAndroidArchitecture() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String architecture;

  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  architecture =
      androidInfo.supportedAbis.first; // Gets the first supported ABI

  return architecture;
}
