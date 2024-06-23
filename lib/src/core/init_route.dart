import 'package:exium_mups_t20_world_cup/src/core/in_app_update/cheak_for_update.dart';
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
    cheakUpdateAvailable(context);
    final box = Hive.box("info");
    if (box.get("userInfo", defaultValue: null) == null) {
      return const LoginPage();
    } else {
      if (box.get("team", defaultValue: null) == null) {
        return const EditTeam(
          updateCount: 0,
        );
      } else {
        final userInfoControllerGetx = Get.put(UserInfoControllerGetx());
        WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
          userInfoControllerGetx.userInfo.value =
              User.fromJson(box.get("userInfo"));
        });
        List<Map> teamPlayersList = List<Map>.from(box.get("team"));

        final playersController = Get.put(PlayersController());

        int max = 0;
        for (int i = 0; i < teamPlayersList.length; i++) {
          if (teamPlayersList[i].keys.contains("update_count") &&
              teamPlayersList[i]['update_count'].runtimeType != bool) {
            if (teamPlayersList[i]['update_count'] as int > max) {
              max = teamPlayersList[i]['update_count'];
            }
          }
        }

        List<PlayerInfoModel> listOfModelOfPlayers = [];
        for (int i = 0; i < teamPlayersList.length; i++) {
          if (PlayerInfoModel.fromMap(
                          Map<String, dynamic>.from(teamPlayersList[i]))
                      .teamName !=
                  null &&
              PlayerInfoModel.fromMap(
                      Map<String, dynamic>.from(teamPlayersList[i]))
                  .teamName!
                  .isNotEmpty) {
            listOfModelOfPlayers.add(PlayerInfoModel.fromMap(
                Map<String, dynamic>.from(teamPlayersList[i])));
          }
        }
        List<PlayerInfoModel> reseverd = [];
        for (int i = 0; i < teamPlayersList.length; i++) {
          if (PlayerInfoModel.fromMap(
                          Map<String, dynamic>.from(teamPlayersList[i]))
                      .teamName ==
                  null ||
              PlayerInfoModel.fromMap(
                      Map<String, dynamic>.from(teamPlayersList[i]))
                  .teamName!
                  .isEmpty) {
            reseverd.add(PlayerInfoModel.fromMap(
                Map<String, dynamic>.from(teamPlayersList[i])));
          }
        }

        WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
          playersController.players.value = listOfModelOfPlayers;
          playersController.reservedList.value = reseverd;
          playersController.countUpdate.value = max;
        });
        return const HomePage();
      }
    }
  }
}
