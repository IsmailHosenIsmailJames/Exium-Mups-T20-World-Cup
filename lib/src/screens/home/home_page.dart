import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/controllers/user_info_controller.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/controllers/web_state_controller.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/drawer/drawer.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/fixtures/fixtures.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/home_tab/home_tab.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/leaderboard/leaderboard_tab.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/standings/standings.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

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
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
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
      } catch (e) {
        Fluttertoast.showToast(msg: "Something went worng");
      }
    } else {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Need internet connection"),
            content: const Text(
              "This app must need internet connection. Please cheak your internet connection and then try again",
            ),
            actions: [
              OutlinedButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text(
                  "Quit",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  loadPlayersData();
                },
                child: const Text(
                  "Try again",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  WebViewController standingWebView = WebViewController();
  final webStateController = Get.put(WebStateController());
  WebViewController fixturesWebView = WebViewController();

  @override
  void initState() {
    standingWebView
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {
          standingWebView.runJavaScript('''
        var element = document.querySelector('.Header_header__Mklic');
      if (element) {
        element.style.display = 'none';
      }
      var element = document.querySelector('.MustHead_must-head__6uGMB');
      if (element) {
        element.style.display = 'none';
      }
         var element = document.querySelector('.Footer_footer__cVJRj');
      if (element) {
        element.style.display = 'none';
      }
    ''');
          webStateController.standingLoading.value = false;
          setState(() {});
        },
        onWebResourceError: (WebResourceError error) {
          //Things to do when the page has error when loading
        },
      ))
      ..loadRequest(Uri.parse(
          "https://www.icc-cricket.com/tournaments/t20cricketworldcup/standings"));

    fixturesWebView
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {
          fixturesWebView.runJavaScript('''
      var element = document.querySelector('.Header_header__Mklic');
      if (element) {
        element.style.display = 'none';
      }
      var element = document.querySelector('.MustHead_must-head__6uGMB');
      if (element) {
        element.style.display = 'none';
      }
         var element = document.querySelector('.Footer_footer__cVJRj');
      if (element) {
        element.style.display = 'none';
      }
    ''');
          webStateController.fixturesLoading.value = false;
          setState(() {});
        },
        onWebResourceError: (WebResourceError error) {
          //Things to do when the page has error when loading
        },
      ))
      ..loadRequest(Uri.parse("https://www.icc-cricket.com/fixtures-results"));

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
              radius: 23,
              backgroundColor: Colors.blue.shade900.withOpacity(0.3),
              backgroundImage: const NetworkImage(
                "https://upload.wikimedia.org/wikipedia/commons/9/92/Cricket-hit-wall-sticker1.png",
              ),
            ),
            const Gap(10),
          ],
        ),
        // toolbarHeight: 120,
        backgroundColor: Colors.white.withOpacity(0.4),
      ),
      drawer: const MyDrawer(),
      body: [
        Container(
          color: Colors.white.withOpacity(0.35),
          child: const HomeTab(),
        ),
        Fixtures(controller: fixturesWebView),
        Standings(
          controller: standingWebView,
        ),
        const LeaderboardTab(),
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
