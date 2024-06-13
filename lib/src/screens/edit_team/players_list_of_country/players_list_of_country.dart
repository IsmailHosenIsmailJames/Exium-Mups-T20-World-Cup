import 'dart:convert';

import 'package:exium_mups_t20_world_cup/src/core/get_uri_images.dart';
import 'package:exium_mups_t20_world_cup/src/models/players_info_model.dart';
import 'package:exium_mups_t20_world_cup/src/screens/edit_team/controllers/player_list_of_country_controller_getx.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../your_team/your_team.dart';

class PlayerList extends StatefulWidget {
  final int countryId;
  final int updateCount;
  final String countryName;
  final String countryImageUrl;
  final bool willUpdate;
  final List<PlayerInfoModel>? previousTeam;
  final List<int>? playersCode;

  const PlayerList(
      {super.key,
      required this.countryId,
      required this.countryName,
      required this.countryImageUrl,
      required this.willUpdate,
      required this.updateCount,
      this.previousTeam,
      this.playersCode});

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
        List playersList = List.from(jsonDecode(response.body)['results']);
        for (int i = 0; i < playersList.length; i++) {
          playerListControlller.listOfPlayers.add(PlayerInfoModel(
            playerCode: playersList[i]['player_code'],
            playerName: playersList[i]['player_name'],
            role: playersList[i]['role'],
            playerImage: playersList[i]['player_image'],
            countryName: widget.countryImageUrl,
            countryImage: widget.countryName,
          ));
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

  int getPlayerChangeCount(List<PlayerInfoModel> playersList) {
    if (widget.willUpdate) {
      List<int> previousTeam = widget.playersCode!;
      int count = 0;
      for (int i = 0; i < previousTeam.length; i++) {
        int select = previousTeam[i];
        bool matched = false;
        for (int j = 0; j < 11; j++) {
          int compare = -1;
          if (playersList.length > j) {
            compare = playersList[j].playerCode;
          }
          if (select == compare) {
            matched = true;
            break;
          }
        }
        if (matched == false) {
          count++;
        }
      }
      count += widget.updateCount;
      return count;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: Scaffold(
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
                List<PlayerInfoModel> batsman = [];
                List<PlayerInfoModel> allrounder = [];
                List<PlayerInfoModel> wicketkeeper = [];
                List<PlayerInfoModel> bowler = [];
                for (PlayerInfoModel player
                    in playerListControlller.selectedPlayer) {
                  if (player.role == "Batsman") {
                    batsman.add(player);
                  } else if (player.role == "Bowler") {
                    bowler.add(player);
                  } else if (player.role == "All-Rounder") {
                    allrounder.add(player);
                  } else {
                    wicketkeeper.add(player);
                  }
                }
                playerListControlller.selectedPlayer.value =
                    batsman + allrounder + wicketkeeper + bowler;
                Get.to(() => YourTeam(
                      updateCount: widget.updateCount,
                      willUpdate: widget.willUpdate,
                      previousTeam: widget.previousTeam,
                      playersCode: widget.playersCode,
                    ));
              },
              child: GetX<PlayerListOfACountryController>(
                builder: (controller) {
                  return Text(
                    "Your Courrent Team : ${11 - controller.selectedPlayer.length} Players Left",
                    textAlign: TextAlign.center,
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
                widget.countryName.replaceAll("_", " "),
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
              List<Widget> batsmanWidgets = [];
              List<Widget> allrounderWidgets = [];
              List<Widget> wicketkeeperWidgets = [];
              List<Widget> bowlerWidgets = [];

              for (PlayerInfoModel player
                  in playerListControlller.listOfPlayers) {
                if (player.role == "Batsman") {
                  batsmanWidgets.add(buildWidgetForPlayers(player));
                } else if (player.role == "Bowler") {
                  bowlerWidgets.add(buildWidgetForPlayers(player));
                } else if (player.role == "All-Rounder") {
                  allrounderWidgets.add(buildWidgetForPlayers(player));
                } else {
                  wicketkeeperWidgets.add(buildWidgetForPlayers(player));
                }
              }
              List<Widget> listOfAlPlayersWidget = <Widget>[
                    const Gap(10),
                    const Text(
                      "Batsmen",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    if (batsmanWidgets.isEmpty)
                      const Center(
                        child: Text("Empty"),
                      ),
                  ] +
                  batsmanWidgets +
                  [
                    const Gap(10),
                    const Text(
                      "Wicket Keepers",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    if (wicketkeeperWidgets.isEmpty)
                      const Center(
                        child: Text("Empty"),
                      ),
                  ] +
                  wicketkeeperWidgets +
                  [
                    const Gap(10),
                    const Text(
                      "All-Rounders",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    if (allrounderWidgets.isEmpty)
                      const Center(
                        child: Text("Empty"),
                      ),
                  ] +
                  allrounderWidgets +
                  [
                    const Gap(10),
                    const Text(
                      "Bowlers",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    if (bowlerWidgets.isEmpty)
                      const Center(
                        child: Text("Empty"),
                      ),
                  ] +
                  bowlerWidgets;

              return SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        cacheExtent: 100,
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 100),
                        children: listOfAlPlayersWidget,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget buildWidgetForPlayers(PlayerInfoModel player) {
    String imageUrl = player.playerImage;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
      ),
      height: 60,
      margin: const EdgeInsets.all(5),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 300,
                    width: 300,
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
                        if (snapshot.connectionState == ConnectionState.done) {
                          return const Icon(
                            FluentIcons.person_32_regular,
                            size: 40,
                            color: Colors.grey,
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        );
                      },
                    ),
                  ),
                  const Gap(15),
                  Text(
                    player.playerName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    player.role,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(15),
                ],
              ),
            ),
          );
        },
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
                    if (snapshot.connectionState == ConnectionState.done) {
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
            FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.playerName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    player.role,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Obx(
              () {
                bool isSelected = false;
                int indexOfSelectedPlayer = -1;
                for (int i = 0;
                    i < playerListControlller.selectedPlayer.length;
                    i++) {
                  if (playerListControlller.selectedPlayer[i].playerCode ==
                      player.playerCode) {
                    isSelected = true;
                    indexOfSelectedPlayer = i;
                    break;
                  }
                }
                return playerListControlller.selectedPlayer.length >= 11 &&
                        isSelected == false
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.90,
                                padding: const EdgeInsets.only(
                                    left: 20, bottom: 20, right: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(Icons.close),
                                        ),
                                      ],
                                    ),
                                    const Gap(30),
                                    const Center(
                                      child: Text(
                                        "Your team member is full with 11 players. Please remove anyone from your team list then try again",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    const Gap(30),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.check_box_outline_blank,
                          color: Colors.grey,
                        ),
                      )
                    : Checkbox.adaptive(
                        splashRadius: 40,
                        value: isSelected,
                        onChanged: (value) {
                          if (isSelected) {
                            int x = getPlayerChangeCount(
                                playerListControlller.selectedPlayer);
                            if (4 - x > 0) {
                              playerListControlller.selectedPlayer
                                  .removeAt(indexOfSelectedPlayer);
                            } else {
                              bool isExits = false;
                              for (int code in widget.playersCode!) {
                                if (playerListControlller
                                        .selectedPlayer[indexOfSelectedPlayer]
                                        .playerCode ==
                                    code) {
                                  isExits = true;
                                  break;
                                }
                              }
                              if (isExits == false) {
                                playerListControlller.selectedPlayer
                                    .removeAt(indexOfSelectedPlayer);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text(
                                        "Changing players limit is over."),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Got it",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                          } else {
                            String role = player.role;
                            int alreadySelectedSameRole = 0;
                            for (int i = 0;
                                i < playerListControlller.selectedPlayer.length;
                                i++) {
                              if (role ==
                                  playerListControlller
                                      .selectedPlayer[i].role) {
                                alreadySelectedSameRole++;
                              }
                            }

                            if ((PlayesrMaxMinRoules.max[role] ?? 3) >
                                alreadySelectedSameRole) {
                              if (widget.willUpdate) {
                                print("object");
                                int c = getPlayerChangeCount(
                                    playerListControlller.selectedPlayer);
                                print("object");

                                if (!(4 - c >= 0)) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "Got it",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return;
                                }
                              }

                              playerListControlller.selectedPlayer.add(player);
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Maximum ${PlayesrMaxMinRoules.max[role] ?? 3} $role is allowed",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Here are the rules :",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Divider(
                                              height: 2,
                                            ),
                                            Text(
                                              "1. Batsman Minimum 2 & Maximum 4\n2. Bowler Minimum 2 & Maximum 4\n3. All-Rounder Minimum 2 & Maximum 4\n4. Wicket Keeper Minimum 1 & Maximum 3",
                                              style: TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Gap(10),
                                        Row(
                                          children: [
                                            const Spacer(),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                "Got it",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
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
    "Batsman ( wk )": 3,
  };
  static Map<String, int> min = {
    "Batsman": 2,
    "Bowler": 2,
    "All-Rounder": 2,
    "Wicket Keeper": 1,
    "Batsman ( wk )": 1,
  };
}
