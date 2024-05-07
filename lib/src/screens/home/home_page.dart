import 'package:exium_mups_t20_world_cup/src/screens/home/controllers/user_info_controller.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/drawer/drawer.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedPageIndex = 0;
  final userInfoControllerGetx = Get.put(UserInfoControllerGetx());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const MyDrawer(),
      body: [
        Container(
          child: const Center(
            child: Text("Home"),
          ),
        ),
        Container(
          child: const Center(
            child: Text("Fixtures"),
          ),
        ),
        Container(
          child: const Center(
            child: Text("Standing"),
          ),
        ),
        Container(
          child: const Center(
            child: Text("Leader Board"),
          ),
        ),
      ][selectedPageIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade800.withOpacity(0.05),
          borderRadius: BorderRadius.circular(30),
        ),
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
