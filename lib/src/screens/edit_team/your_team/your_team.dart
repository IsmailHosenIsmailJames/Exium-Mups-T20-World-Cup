import 'dart:typed_data';

import 'package:exium_mups_t20_world_cup/src/core/get_uri_images.dart';
import 'package:exium_mups_t20_world_cup/src/screens/edit_team/controllers/player_list_of_country_controller_getx.dart';
import 'package:exium_mups_t20_world_cup/src/screens/edit_team/players_list_of_country/players_list_of_country.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class YourTeam extends StatefulWidget {
  const YourTeam({super.key});

  @override
  State<YourTeam> createState() => _YourTeamState();
}

class _YourTeamState extends State<YourTeam> {
  final playerListControlller = Get.put(PlayerListOfACountryController());
  String? isTeamReady() {
    List<String> roleList = [
      "Batsman",
      "Bowler",
      "All-Rounder",
      "Wicket Keeper"
    ];
    List<String> rulesOfSelectingPlayes = [
      "Batsman Minimum 2 & Maximum 4",
      "Bowler Minimum 2 & Maximum 4",
      "All-Rounder Minimum 2 & Maximum 4",
      "Wicket Keeper Minimum 1 & Maximum 3",
    ];
    for (int i = 0; i < roleList.length; i++) {
      int count = 0;
      for (int j = 0; j < playerListControlller.selectedPlayer.length; j++) {
        if (playerListControlller.selectedPlayer[j].role == roleList[i]) {
          count++;
        }
      }
      if (count >= PlayesrMaxMinRoules.min[roleList[i]]! &&
          count <= PlayesrMaxMinRoules.max[roleList[i]]!) {
        continue;
      } else {
        return rulesOfSelectingPlayes[i];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        extendedPadding: EdgeInsets.zero,
        onPressed: null,
        label: SizedBox(
          height: 56,
          width: 300,
          child: GetX<PlayerListOfACountryController>(
            builder: (controller) {
              String? isReady = isTeamReady();
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: isReady != null ||
                        playerListControlller.selectedPlayer.length < 11
                    ? null
                    : () {},
                child: isReady != null &&
                        playerListControlller.selectedPlayer.length == 11
                    ? Text(
                        isReady,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      )
                    : const Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
              );
            },
          ),
        ),
      ),
      appBar: AppBar(
        leadingWidth: 35,
        title: GetX<PlayerListOfACountryController>(
          builder: (controller) => Text(
            "You Team : ${11 - controller.selectedPlayer.length} Players left",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Obx(
        () {
          return playerListControlller.selectedPlayer.isEmpty
              ? const Center(
                  child: Text(
                    "All players of your team will show here.\nCurrently you have 0 players selected",
                    textAlign: TextAlign.center,
                  ),
                )
              : SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 100),
                          itemCount:
                              playerListControlller.selectedPlayer.length,
                          itemBuilder: (context, index) {
                            String imageUrl = playerListControlller
                                .selectedPlayer[index].playerImage;

                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade200,
                              ),
                              height: 60,
                              margin: const EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: FutureBuilder(
                                        future: getUriImage(
                                            "http://116.68.200.97:6048/images/players/$imageUrl"),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            Uint8List? data = snapshot.data;
                                            if (data != null) {
                                              return Image.memory(data);
                                            } else {
                                              return const Icon(
                                                FluentIcons.person_32_regular,
                                                size: 40,
                                                color: Colors.grey,
                                              );
                                            }
                                          }
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return const Icon(
                                              FluentIcons.person_32_regular,
                                              size: 40,
                                              color: Colors.grey,
                                            );
                                          }
                                          return const Center(
                                              child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ));
                                        },
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        playerListControlller
                                            .selectedPlayer[index].playerName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        playerListControlller
                                            .selectedPlayer[index].role,
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      playerListControlller.selectedPlayer
                                          .removeAt(index);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const Gap(10),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
