import 'dart:convert';

import 'package:exium_mups_t20_world_cup/src/core/get_uri_images.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/leaderboard/players_data.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

class LeaderboardTab extends StatefulWidget {
  const LeaderboardTab({super.key});

  @override
  State<LeaderboardTab> createState() => _LeaderboardTabState();
}

class _LeaderboardTabState extends State<LeaderboardTab> {
  List<PlayersDataForRanking> listOfRanking = [];
  @override
  void initState() {
    loadRankingData();
    super.initState();
  }

  void loadRankingData() async {
    http.Response response = await http
        .get(Uri.parse("http://116.68.200.97:6048/api/v1/leader_board"));
    if (response.statusCode == 200) {
      List<Map> listOfPlayersData =
          List<Map>.from(jsonDecode(response.body)['data']);
      for (int i = 0; i < listOfPlayersData.length; i++) {
        PlayersDataForRanking currentPlayerData = PlayersDataForRanking.fromMap(
            Map<String, dynamic>.from(listOfPlayersData[i]));
        listOfRanking.add(currentPlayerData);
      }
      setState(() {
        listOfRanking;
      });
    } else {
      Fluttertoast.showToast(
          msg: jsonDecode(response.body)["error"] ?? "Something went worng");
    }
  }

  @override
  Widget build(BuildContext context) {
    return listOfRanking.isEmpty
        ? const Center(child: CupertinoActivityIndicator())
        : Column(
            children: [
              const Row(
                children: [
                  Gap(10),
                  SizedBox(
                    width: 65,
                    child: Center(
                      child: Text(
                        "Rank",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Gap(10),
                  SizedBox(
                    width: 65,
                    child: Text(
                      "Image",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    "Name & Role",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Points",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Gap(15),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: listOfRanking.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 65,
                      // ignore: use_build_context_synchronously
                      width: MediaQuery.of(context).size.width * 0.95,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: index % 2 == 0
                            ? Colors.green.withOpacity(0.1)
                            : Colors.blue.shade900.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 65,
                            width: MediaQuery.of(context).size.width * 0.15,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Center(
                                child: Text(
                                  (index + 1).toString(),
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: 65,
                            child: FutureBuilder(
                              future: getUriImage(
                                  "http://116.68.200.97:6048/images/players/${listOfRanking[index].playerImage}"),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  Uint8List? data = snapshot.data;
                                  if (data != null) {
                                    return Container(
                                      width: 65,
                                      height: 65,
                                      margin: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(
                                          image: MemoryImage(data),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    );
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
                                  ),
                                );
                              },
                            ),
                          ),
                          const Gap(10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.40,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    listOfRanking[index].playerName,
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                listOfRanking[index].role,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            height: 65,
                            width: MediaQuery.of(context).size.width * 0.25,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(50),
                                bottomLeft: Radius.circular(50),
                                bottomRight: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  (listOfRanking[index].point).toString(),
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}
