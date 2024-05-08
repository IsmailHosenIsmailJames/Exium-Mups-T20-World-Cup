import 'package:exium_mups_t20_world_cup/src/screens/edit_team/controllers/player_list_of_country_controller_getx.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class YourTeam extends StatefulWidget {
  const YourTeam({super.key});

  @override
  State<YourTeam> createState() => _YourTeamState();
}

class _YourTeamState extends State<YourTeam> {
  final playerListControlller = Get.put(PlayerListOfACountryController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 35,
        title: Row(
          children: [
            const Spacer(),
            const Text(
              "Your Current Team",
              style: TextStyle(
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
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: playerListControlller.selectedPlayer.length,
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
                                  future: http.get(Uri.parse(
                                      "http://116.68.200.97:6048/images/players/$imageUrl")),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      http.Response response = snapshot.data!;
                                      if (response.statusCode == 200) {
                                        return Image.memory(response.bodyBytes);
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
