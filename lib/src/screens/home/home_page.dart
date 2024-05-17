import 'dart:convert';
import 'dart:ui';

import 'package:exium_mups_t20_world_cup/src/screens/home/controllers/user_info_controller.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/drawer/drawer.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/fixtures.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/home_tab.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/standings.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedPageIndex = 0;
  final userInfoControllerGetx = Get.put(UserInfoControllerGetx());

  int sec = DateTime.now().millisecondsSinceEpoch;

  Future<void> loadPlayersData() async {
    try {
      http.Response response2 = await http.get(
        Uri.parse(
          "http://116.68.200.97:6048/api/v1/selected_player_list?user_id=${userInfoControllerGetx.userInfo.value.id}",
        ),
      );

      if (response2.statusCode == 200) {
        final decodeData = jsonDecode(response2.body);
        List<Map> listOfPalyers = List<Map>.from(decodeData["data"]);
        if (listOfPalyers.length == 11) {
          await Hive.box("info").put("team", listOfPalyers);
          await Hive.box("info").put(
            "teamName",
            listOfPalyers[0]['team_name'],
          );
        }
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  void initState() {
    loadPlayersData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(Hive.box("info").get("teamName")),
            const Spacer(),
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blue.shade900.withOpacity(0.3),
              backgroundImage: const NetworkImage(
                "https://upload.wikimedia.org/wikipedia/commons/9/92/Cricket-hit-wall-sticker1.png",
              ),
            ),
            const Gap(10),
            IconButton(
              onPressed: () async {
                if (DateTime.now().millisecondsSinceEpoch - sec > 10000) {
                  loadPlayersData();
                  sec = DateTime.now().millisecondsSinceEpoch;
                }
              },
              icon: const Icon(
                Icons.replay_outlined,
              ),
            ),
          ],
        ),
        // toolbarHeight: 120,
        backgroundColor: Colors.white.withOpacity(0.4),
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      drawer: const MyDrawer(),
      body: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/background/home.jpg",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                color: Colors.white.withOpacity(0.35),
                child: const HomeTab(),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 33),
          child: const Fixtures(),
        ),
        const Standings(),
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/background/home.jpg",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: Container(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ),
        ),
      ][selectedPageIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(30),
        ),
        margin: const EdgeInsets.all(3),
        child: SalomonBottomBar(
          currentIndex: selectedPageIndex,
          onTap: (i) => setState(() => selectedPageIndex = i),
          items: [
            SalomonBottomBarItem(
              icon: const Icon(FluentIcons.home_12_regular),
              title: const Text("Home"),
              selectedColor: Colors.purple,
            ),
            SalomonBottomBarItem(
              icon: const Icon(FluentIcons.calendar_32_regular),
              title: const Text("Fixtures"),
              selectedColor: Colors.pink,
            ),
            SalomonBottomBarItem(
              icon: const Icon(
                CupertinoIcons.group,
                size: 28,
              ),
              title: const Text("Standing"),
              selectedColor: Colors.orange.shade800,
            ),
            SalomonBottomBarItem(
              icon: const Icon(FluentIcons.chart_multiple_20_regular),
              title: const Text("LeaderBoard"),
              selectedColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}
