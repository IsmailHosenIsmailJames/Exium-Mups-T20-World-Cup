import 'package:exium_mups_t20_world_cup/src/models/success_login_responce.dart';
import 'package:exium_mups_t20_world_cup/src/screens/auth/login/login.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

class InitRoutes extends StatelessWidget {
  const InitRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box("info");
    return box.get("userInfo", defaultValue: null) == null
        ? const LoginPage()
        : HomePage(
            userInfo: User.fromJson(box.get("userInfo")),
          );
  }
}
