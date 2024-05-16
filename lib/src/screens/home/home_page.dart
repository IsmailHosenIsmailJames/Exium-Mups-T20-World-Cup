import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:exium_mups_t20_world_cup/src/core/get_uri_images.dart';
import 'package:exium_mups_t20_world_cup/src/models/players_info_model.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/controllers/players_controller.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/controllers/user_info_controller.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/drawer/drawer.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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
        // backgroundColor: Colors.white.withOpacity(0.4),
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
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: Container(
                  color: Colors.white.withOpacity(0.35),
                  child: GetX<PlayersController>(builder: (controller) {
                    List<Widget> batsman = [];
                    List<Widget> allrounder = [];
                    List<Widget> wicketkeeper = [];
                    List<Widget> bowler = [];
                    for (PlayerInfoModel player in controller.players) {
                      if (player.role == "Batsman") {
                        batsman.add(buildCardOfPlayers(player));
                      } else if (player.role == "Bowler") {
                        bowler.add(buildCardOfPlayers(player));
                      } else if (player.role == "All-Rounder") {
                        allrounder.add(buildCardOfPlayers(player));
                      } else {
                        wicketkeeper.add(buildCardOfPlayers(player));
                      }
                    }
                    return ListView(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 100,
                        bottom: 70,
                      ),
                      children: [
                        const Gap(10),
                        const Center(
                          child: Text(
                            "Batsman",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: batsman,
                        ),
                        const Gap(10),
                        const Center(
                          child: Text(
                            "Batsman",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: allrounder,
                        ),
                        const Gap(10),
                        const Center(
                          child: Text(
                            "Wicket Keeper",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: wicketkeeper,
                        ),
                        const Gap(10),
                        const Center(
                          child: Text(
                            "Bowler",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: bowler,
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 95, bottom: 67),
          child: InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(
                "https://www.icc-cricket.com/fixtures-results",
              ),
            ),
            onLoadStop: (controller, url) {
              controller.injectJavascriptFileFromAsset(
                  assetFilePath: "assets/html/fixes.js");
            },
          ),
        ),
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
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: WebUri(
                        "https://www.google.com/search?q=t20+world+cup&oq=t20",
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
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
          color: Colors.white,
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

  Widget buildCardOfPlayers(PlayerInfoModel player) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 120,
            width: 120,
            child: FutureBuilder(
              future: getUriImage(
                  "http://116.68.200.97:6048/images/players/${player.playerImage}"),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Uint8List? response = snapshot.data;
                  if (response == null) {
                    return const Icon(
                      FluentIcons.person_32_regular,
                      size: 40,
                      color: Colors.black,
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.all(2),
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: MemoryImage(response),
                          fit: BoxFit.fitHeight,
                        ),
                        color: const Color.fromARGB(255, 41, 141, 255)
                            .withOpacity(0.2),
                      ),
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${player.totalPoint ?? 0}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 56, 141),
                          ),
                        ),
                      ),
                    );
                  }
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    padding: const EdgeInsets.all(2),
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 41, 141, 255)
                          .withOpacity(0.2),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${player.totalPoint ?? 0}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 56, 141),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          FluentIcons.person_32_regular,
                          size: 40,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  );
                }
                return const Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 2,
                ));
              },
            ),
          ),
          Center(
            child: Text(
              player.playerName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
