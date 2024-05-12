import 'dart:convert';
import 'dart:typed_data';

import 'package:exium_mups_t20_world_cup/src/core/get_uri_images.dart';
import 'package:exium_mups_t20_world_cup/src/models/players_info_model.dart';
import 'package:exium_mups_t20_world_cup/src/screens/edit_team/controllers/player_list_of_country_controller_getx.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../your_team/your_team.dart';

class PlayerList extends StatefulWidget {
  final int countryId;
  final String countryName;
  final String countryImageUrl;
  const PlayerList(
      {super.key,
      required this.countryId,
      required this.countryName,
      required this.countryImageUrl});

  @override
  State<PlayerList> createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  final playerListControlller = Get.put(PlayerListOfACountryController());
  @override
  void initState() {
    getPlayerList();
    super.initState();
  }

  void getPlayerList() async {
    playerListControlller.listOfPlayers.value = [];
    try {
      http.Response response = await http.get(Uri.parse(
          "http://116.68.200.97:6048/api/v1/players/${widget.countryId}"));
      if (response.statusCode == 200) {
        List countryList = List.from(jsonDecode(response.body)['results']);
        for (int i = 0; i < countryList.length; i++) {
          playerListControlller.listOfPlayers
              .add(PlayerInfoModel.fromMap(countryList[i]));
        }
        playerListControlller.isLoading.value = false;
      } else {
        playerListControlller.errorMessage.value =
            jsonDecode(response.body)['message'];
        playerListControlller.isLoading.value = false;
      }
    } catch (e) {
      playerListControlller.isLoading.value = false;
      playerListControlller.errorMessage.value = e.toString();
    }
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
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Get.to(() => const YourTeam());
            },
            child: GetX<PlayerListOfACountryController>(
              builder: (controller) {
                return Text(
                  "Your Courrent Team : ${11 - controller.selectedPlayer.length} Players Left",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                );
              },
            ),
          ),
        ),
      ),
      appBar: AppBar(
        leadingWidth: 35,
        title: Row(
          children: [
            Text(
              widget.countryName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.all(5),
              height: 40,
              child: FutureBuilder(
                future: getUriImage(widget.countryImageUrl),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Uint8List? data = snapshot.data;
                    if (data == null) {
                      return const Icon(Icons.error);
                    } else {
                      return Image.memory(data);
                    }
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    return const Icon(Icons.error);
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
      body: Obx(
        () {
          if (playerListControlller.listOfPlayers.isEmpty &&
              playerListControlller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (playerListControlller.isLoading.value == false &&
              playerListControlller.listOfPlayers.isEmpty) {
            return Center(
              child: Text(
                playerListControlller.errorMessage.value,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          } else if (playerListControlller.listOfPlayers.isNotEmpty) {
            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      cacheExtent: 100,
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 100),
                      itemCount: playerListControlller.listOfPlayers.length,
                      itemBuilder: (context, index) {
                        String imageUrl = playerListControlller
                            .listOfPlayers[index].playerImage;
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
                                        Uint8List? response = snapshot.data;
                                        if (response == null) {
                                          return const Icon(
                                            FluentIcons.person_32_regular,
                                            size: 40,
                                            color: Colors.grey,
                                          );
                                        } else {
                                          return Image.memory(response);
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    playerListControlller
                                        .listOfPlayers[index].playerName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    playerListControlller
                                        .listOfPlayers[index].role,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Obx(
                                () {
                                  bool isSelected = false;
                                  int indexOfSelectedPlayer = -1;
                                  for (int i = 0;
                                      i <
                                          playerListControlller
                                              .selectedPlayer.length;
                                      i++) {
                                    if (playerListControlller
                                            .selectedPlayer[i].playerCode ==
                                        playerListControlller
                                            .listOfPlayers[index].playerCode) {
                                      isSelected = true;
                                      indexOfSelectedPlayer = i;
                                      break;
                                    }
                                  }
                                  return Checkbox.adaptive(
                                    value: isSelected,
                                    onChanged: playerListControlller
                                                    .selectedPlayer.length >=
                                                11 &&
                                            isSelected == false
                                        ? null
                                        : (value) {
                                            if (isSelected) {
                                              playerListControlller
                                                  .selectedPlayer
                                                  .removeAt(
                                                      indexOfSelectedPlayer);
                                            } else {
                                              String role =
                                                  playerListControlller
                                                      .listOfPlayers[index]
                                                      .role;
                                              int alreadySelectedSameRole = 0;
                                              for (int i = 0;
                                                  i <
                                                      playerListControlller
                                                          .selectedPlayer
                                                          .length;
                                                  i++) {
                                                if (role ==
                                                    playerListControlller
                                                        .selectedPlayer[i]
                                                        .role) {
                                                  alreadySelectedSameRole++;
                                                }
                                              }
                                              if (PlayesrMaxMinRoules
                                                      .max[role]! >
                                                  alreadySelectedSameRole) {
                                                playerListControlller
                                                    .selectedPlayer
                                                    .add(playerListControlller
                                                        .listOfPlayers[index]);
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: Text(
                                                        "Maximum ${PlayesrMaxMinRoules.max[role]} $role is allowed"),
                                                    content: const Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Here are the roules :",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Divider(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          "1. Batsman Minimum 2 & Maximum 4\n2. Bowler Minimum 2 & Maximum 4\n3. All-Rounder Minimum 2 & Maximum 4\n4. Wicket Keeper Minimum 1 & Maximum 3",
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          "Got it",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                  );
                                },
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
          }
          return Container();
        },
      ),
    );
  }
}

class PlayesrMaxMinRoules {
  static Map<String, int> max = {
    "Batsman": 4,
    "Bowler": 4,
    "All-Rounder": 4,
    "Wicket Keeper": 3,
  };
  static Map<String, int> min = {
    "Batsman": 2,
    "Bowler": 2,
    "All-Rounder": 2,
    "Wicket Keeper": 1,
  };
}
