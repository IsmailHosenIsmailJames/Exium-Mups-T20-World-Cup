import 'dart:convert';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:exium_mups_t20_world_cup/src/core/get_uri_images.dart';
import 'package:exium_mups_t20_world_cup/src/models/country_list_model.dart';
import 'package:exium_mups_t20_world_cup/src/models/players_info_model.dart';
import 'package:exium_mups_t20_world_cup/src/screens/edit_team/controllers/edit_team_controller_getx.dart';
import 'package:exium_mups_t20_world_cup/src/screens/edit_team/players_list_of_country/players_list_of_country.dart';
import 'package:exium_mups_t20_world_cup/src/screens/edit_team/your_team/your_team.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;

import 'controllers/player_list_of_country_controller_getx.dart';

class EditTeam extends StatefulWidget {
  final List<PlayerInfoModel>? previousTeam;
  const EditTeam({super.key, this.previousTeam});

  @override
  State<EditTeam> createState() => _EditTeamState();
}

class _EditTeamState extends State<EditTeam> {
  final playerListControlller = Get.put(PlayerListOfACountryController());
  final editTeamController = Get.put(EditTeamController());

  @override
  void initState() {
    if (widget.previousTeam != null) {
      playerListControlller.selectedPlayer.value = widget.previousTeam!;
    }
    loadCountryList();
    super.initState();
  }

  void loadCountryList() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    bool isNetworkActive =
        connectivityResult.contains(ConnectivityResult.mobile) ||
            connectivityResult.contains(ConnectivityResult.wifi) ||
            connectivityResult.contains(ConnectivityResult.ethernet);
    if (isNetworkActive) {
      try {
        http.Response response = await http
            .get(Uri.parse("http://116.68.200.97:6048/api/v1/countries"));
        if (response.statusCode == 200) {
          await Hive.box("info").put("country", response.body);
          List countryList = List.from(jsonDecode(response.body)['results']);
          for (int i = 0; i < countryList.length; i++) {
            editTeamController.contryListResult
                .add(Result.fromMap(countryList[i]));
          }
          editTeamController.isLoading.value = false;
        } else {
          editTeamController.errorMessage.value =
              jsonDecode(response.body)['message'];
          editTeamController.isLoading.value = false;
        }
      } catch (e) {
        editTeamController.isLoading.value = false;
        editTeamController.errorMessage.value = e.toString();
      }
    } else {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("No internet connection!"),
            content: const Text(
              "This app can run when internet connection is active. Please cheak your internet connection and then try again",
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
                  loadCountryList();
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
                    borderRadius: BorderRadius.circular(10))),
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
                    willUpdate: widget.previousTeam != null,
                  ));
            },
            child: GetX<PlayerListOfACountryController>(
              builder: (controller) {
                return Text(
                  "Your Team : ${11 - controller.selectedPlayer.length} Players Left",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image:
                  AssetImage("assets/background/largest-cricket-stadium.jpg"),
              fit: BoxFit.cover,
              opacity: 0.6),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topCenter,
        child: Center(
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: GetX<EditTeamController>(
                builder: (controller) {
                  if (controller.contryListResult.isEmpty &&
                      controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controller.isLoading.value == false &&
                      controller.contryListResult.isEmpty) {
                    return Center(
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    );
                  } else if (controller.contryListResult.isNotEmpty) {
                    return SafeArea(
                      child: Column(
                        children: [
                          const Text(
                            "Select 11 Players",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                              itemCount: controller.contryListResult.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => PlayerList(
                                        countryId: controller
                                            .contryListResult[index].countryId,
                                        countryImageUrl:
                                            "http://116.68.200.97:6048/images/flags/${controller.contryListResult[index].countryImage}",
                                        countryName: controller
                                            .contryListResult[index]
                                            .countryName,
                                        willUpdate: widget.previousTeam != null,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 80,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black54,
                                                blurRadius: 7,
                                                offset: Offset(3, 2),
                                              ),
                                            ],
                                          ),
                                          child: FutureBuilder(
                                            future: getUriImage(
                                                "http://116.68.200.97:6048/images/flags/${controller.contryListResult[index].countryImage}"),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                Uint8List? data = snapshot.data;
                                                if (data == null) {
                                                  return const Icon(
                                                      Icons.error);
                                                } else {
                                                  return Image.memory(
                                                    data,
                                                    fit: BoxFit.fill,
                                                  );
                                                }
                                              }
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                          ),
                                        ),
                                        Text(
                                          controller.contryListResult[index]
                                              .countryName,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
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
                  }
                  return Container();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
