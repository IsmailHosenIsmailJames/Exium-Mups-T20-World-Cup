import 'dart:convert';

import 'package:exium_mups_t20_world_cup/src/core/init_route.dart';
import 'package:exium_mups_t20_world_cup/src/screens/edit_team/edit_team.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/controllers/players_controller.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/controllers/user_info_controller.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/experiment/web_view_live_score.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final userInformationController = Get.put(UserInfoControllerGetx());
  final playersListController = Get.put(PlayersController());
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(100),
                  bottomLeft: Radius.circular(100),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.blue.shade200),
                    child: Center(
                      child: Text(
                        userInformationController.userInfo.value.fullName
                            .substring(0, 2)
                            .toUpperCase(),
                        style: TextStyle(
                            fontSize: 46, color: Colors.blue.shade900),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userInformationController
                                    .userInfo.value.fullName.length <
                                23
                            ? userInformationController.userInfo.value.fullName
                            : "${userInformationController.userInfo.value.fullName.substring(0, 22)}...",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userInformationController.userInfo.value.mobileNumber,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "ID: ${userInformationController.userInfo.value.id}",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(10),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => EditTeam(
                        previousTeam: playersListController.players,
                      ));
                },
                child: const Row(
                  children: [
                    Icon(
                      FluentIcons.edit_24_regular,
                    ),
                    Gap(20),
                    Text(
                      "Edit your team",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(10),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: ElevatedButton(
                onPressed: () async {
                  http.Response response = await http.get(
                      Uri.parse("http://116.68.200.97:6048/api/v1/live_match"));
                  if (response.statusCode == 200) {
                    String url = jsonDecode(response.body)['url'];
                    Get.to(() => WebViewLiveScore(url: url));
                  }
                },
                child: const Row(
                  children: [
                    Icon(
                      FluentIcons.live_24_regular,
                    ),
                    Gap(20),
                    Text(
                      "Live Score",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: ElevatedButton(
                onPressed: () async {
                  final box = Hive.box("info");
                  await box.deleteFromDisk();
                  await Hive.openBox("info");
                  await Future.delayed(const Duration(milliseconds: 500));
                  Get.offAll(() => const InitRoutes());
                  Fluttertoast.showToast(msg: "LogOut successfull");
                },
                child: const Row(
                  children: [
                    Spacer(),
                    Text("Log Out"),
                    SizedBox(
                      width: 15,
                    ),
                    Spacer(),
                    Icon(
                      Icons.logout_rounded,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ),
            const Gap(10),
          ],
        ),
      ),
    );
  }
}
