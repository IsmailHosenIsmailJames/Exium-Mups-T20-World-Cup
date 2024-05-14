import 'package:exium_mups_t20_world_cup/src/models/players_info_model.dart';
import 'package:exium_mups_t20_world_cup/src/models/success_login_responce.dart';
import 'package:exium_mups_t20_world_cup/src/screens/auth/login/login.dart';
import 'package:exium_mups_t20_world_cup/src/screens/edit_team/edit_team.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/controllers/players_controller.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

import '../screens/home/controllers/user_info_controller.dart';

class InitRoutes extends StatelessWidget {
  const InitRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    final box = Hive.box("info");
    if (box.get("userInfo", defaultValue: null) == null) {
      return const LoginPage();
    } else {
      if (box.get("team", defaultValue: null) == null) {
        return const EditTeam();
      } else {
        final userInfoControllerGetx = Get.put(UserInfoControllerGetx());
        WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
          userInfoControllerGetx.userInfo.value =
              User.fromJson(box.get("userInfo"));
        });
        List<Map> teamPlayersList = List<Map>.from(box.get("team"));
        final playersController = Get.put(PlayersController());
        List<PlayerInfoModel> listOfModelOfPlayers = [];
        for (int i = 0; i < teamPlayersList.length; i++) {
          listOfModelOfPlayers.add(PlayerInfoModel.fromMap(
              Map<String, dynamic>.from(teamPlayersList[i])));
        }
        WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
          playersController.players.value = listOfModelOfPlayers;
        });
        return const HomePage();
      }
    }
  }
}
