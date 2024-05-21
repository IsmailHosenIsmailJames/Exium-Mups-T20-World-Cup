import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:exium_mups_t20_world_cup/src/core/get_uri_images.dart';
import 'package:exium_mups_t20_world_cup/src/models/success_login_responce.dart';
import 'package:exium_mups_t20_world_cup/src/screens/edit_team/controllers/player_list_of_country_controller_getx.dart';
import 'package:exium_mups_t20_world_cup/src/screens/edit_team/players_list_of_country/players_list_of_country.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/controllers/players_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;

import '../../../core/init_route.dart';

class YourTeam extends StatefulWidget {
  final bool willUpdate;
  const YourTeam({super.key, required this.willUpdate});

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
                    : () {
                        TextEditingController teamName = TextEditingController(
                            text: Hive.box("info")
                                    .get("teamName", defaultValue: null) ??
                                "");

                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Your Team Name",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Gap(10),
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.trim().isEmpty) {
                                          return "Plaese type your team name here";
                                        }
                                        return null;
                                      },
                                      autovalidateMode: AutovalidateMode.always,
                                      controller: teamName,
                                      decoration: InputDecoration(
                                        hintText:
                                            "Plaese type your team name here",
                                        labelText: "Team Name",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                    const Gap(10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 130,
                                          child: OutlinedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("cancel"),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 130,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              if (teamName.text
                                                  .trim()
                                                  .isNotEmpty) {
                                                if (widget.willUpdate) {
                                                  final previousTeam = Get.put(
                                                      PlayersController());
                                                  List<bool> isNoChange = [];
                                                  for (int i = 0;
                                                      i <
                                                          previousTeam
                                                              .players.length;
                                                      i++) {
                                                    isNoChange.add(
                                                        playerListControlller
                                                                .selectedPlayer[
                                                                    i]
                                                                .playerCode ==
                                                            previousTeam
                                                                .players[i]
                                                                .playerCode);
                                                  }
                                                  if (isNoChange
                                                      .contains(false)) {
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "Can't save. No Change compared with previous",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                    );
                                                    return;
                                                  }
                                                }
                                                final box = Hive.box("info");
                                                final userInfo = box.get(
                                                    "userInfo",
                                                    defaultValue: null);
                                                User user =
                                                    User.fromJson(userInfo);
                                                List<Map> playersList = [];
                                                List<Map> playersListToSendAPI =
                                                    [];

                                                for (int i = 0;
                                                    i <
                                                        playerListControlller
                                                            .selectedPlayer
                                                            .length;
                                                    i++) {
                                                  playersList.add(
                                                      playerListControlller
                                                          .selectedPlayer[i]
                                                          .toMap());

                                                  playersListToSendAPI.add({
                                                    "player_code":
                                                        playerListControlller
                                                            .selectedPlayer[i]
                                                            .playerCode
                                                  });
                                                }

                                                http.Response response =
                                                    await http.post(
                                                  Uri.parse(
                                                    widget.willUpdate
                                                        ? "http://116.68.200.97:6048/api/v1/update_player_select"
                                                        : "http://116.68.200.97:6048/api/v1/save_player_select",
                                                  ),
                                                  headers: {
                                                    HttpHeaders
                                                            .contentTypeHeader:
                                                        "application/json"
                                                  },
                                                  body: jsonEncode(
                                                    <String, dynamic>{
                                                      "userInfo": {
                                                        "id": user.id,
                                                      },
                                                      "teamName":
                                                          teamName.text.trim(),
                                                      "playersOfTeam":
                                                          playersListToSendAPI,
                                                    },
                                                  ),
                                                );

                                                if (response.statusCode ==
                                                    200) {
                                                  //save data to local
                                                  await box.put(
                                                      "team", playersList);
                                                  await box.put("teamName",
                                                      teamName.text);
                                                  Get.offAll(
                                                    () => const InitRoutes(),
                                                  );
                                                  Fluttertoast.showToast(
                                                      msg: jsonDecode(response
                                                          .body)['message']);
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: jsonDecode(response
                                                          .body)['error']);
                                                }
                                              }
                                            },
                                            child: const Text("Save"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                child: isReady != null &&
                        playerListControlller.selectedPlayer.length == 11
                    ? Text(
                        isReady,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      )
                    : const Text(
                        "NEXT",
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
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
                                                  Uint8List? data =
                                                      snapshot.data;
                                                  if (data != null) {
                                                    return Image.memory(data);
                                                  } else {
                                                    return const Icon(
                                                      FluentIcons
                                                          .person_32_regular,
                                                      size: 40,
                                                      color: Colors.grey,
                                                    );
                                                  }
                                                }
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  return const Icon(
                                                    FluentIcons
                                                        .person_32_regular,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  );
                                                }
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          const Gap(15),
                                          Text(
                                            playerListControlller
                                                .selectedPlayer[index]
                                                .playerName,
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
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                                                child:
                                                    CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ));
                                          },
                                        ),
                                      ),
                                    ),
                                    const Gap(10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      padding: const EdgeInsets.all(16),
                                      style: IconButton.styleFrom(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.zero)),
                                      onPressed: () {
                                        playerListControlller.selectedPlayer
                                            .removeAt(index);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
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
