import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:exium_mups_t20_world_cup/src/models/players_info_model.dart';
import 'package:exium_mups_t20_world_cup/src/screens/edit_team/controllers/player_list_of_country_controller_getx.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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
      appBar: AppBar(
        leadingWidth: 35,
        title: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              height: 40,
              child: CachedNetworkImage(
                imageUrl: widget.countryImageUrl,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            const Spacer(),
            Text(
              widget.countryName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Current Team"),
            ),
            const SizedBox(
              width: 10,
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
                      padding: const EdgeInsets.all(10),
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
                                    future: http.get(Uri.parse(
                                        "http://116.68.200.97:6048/images/players/$imageUrl")),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        http.Response response = snapshot.data!;
                                        if (response.statusCode == 200) {
                                          return Image.memory(
                                              response.bodyBytes);
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
                                                playerListControlller
                                                    .selectedPlayer
                                                    .add(playerListControlller
                                                        .listOfPlayers[index]);
                                              }
                                            });
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
