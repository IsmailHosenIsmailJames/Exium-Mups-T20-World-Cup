import 'dart:convert';

import 'package:exium_mups_t20_world_cup/src/screens/home/experiment/fixtures_excel.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/experiment/web_view_live_score.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;

import '../../core/get_uri_images.dart';
import '../../models/country_list_model.dart';
import '../../models/players_info_model.dart';
import 'controllers/players_controller.dart';
import 'controllers/user_info_controller.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool isPlayerList = false;
  List<String> listOfRows = csv.split("\n");
  final userInformationController = Get.put(UserInfoControllerGetx());
  List countryList = [];

  @override
  void initState() {
    if (Hive.box("info").get("country", defaultValue: null) == null) {
      getCountryList();
    } else {
      countryList =
          List.from(jsonDecode(Hive.box("info").get("country"))['results']);
    }
    super.initState();
  }

  void getCountryList() async {
    try {
      http.Response response = await http
          .get(Uri.parse("http://116.68.200.97:6048/api/v1/countries"));
      if (response.statusCode == 200) {
        await Hive.box("info").put("country", response.body);
        setState(() {
          countryList = List.from(jsonDecode(response.body)['results']);
        });
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return isPlayerList
        ? GetX<PlayersController>(
            builder: (controller) {
              List<Widget> batsman = [];
              List<Widget> allrounder = [];
              List<Widget> wicketkeeper = [];
              List<Widget> bowler = [];
              for (PlayerInfoModel player in controller.players) {
                if (player.role == "Batsman") {
                  batsman.add(buildCardOfPlayers(player));
                } else if (player.role == "Bowler") {
                  bowler.add(buildCardOfPlayers(player));
                } else if (player.role == "All-Rounder") {
                  allrounder.add(buildCardOfPlayers(player));
                } else {
                  wicketkeeper.add(buildCardOfPlayers(player));
                }
              }
              return ListView(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 100,
                  bottom: 70,
                ),
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() {
                              isPlayerList = false;
                            });
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                          ),
                        ),
                      ),
                      const Spacer()
                    ],
                  ),
                  const Gap(10),
                  const Center(
                    child: Text(
                      "Batsman",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: batsman,
                  ),
                  const Gap(10),
                  const Center(
                    child: Text(
                      "Batsman",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: allrounder,
                  ),
                  const Gap(10),
                  const Center(
                    child: Text(
                      "Wicket Keeper",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: wicketkeeper,
                  ),
                  const Gap(10),
                  const Center(
                    child: Text(
                      "Bowler",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: bowler,
                  ),
                ],
              );
            },
          )
        : GetX<PlayersController>(
            builder: (controller) {
              int totalPoint = 0;
              for (var e in controller.players) {
                totalPoint += e.totalPoint ?? 0;
              }
              return StreamBuilder(
                stream: getTimeStream(),
                builder: (context, snapshot) {
                  bool isLive = false;
                  List<String> matchInfo = [];
                  Result? team1;
                  Result? team2;
                  List<Result> contryListResult = [];

                  for (int i = 0; i < countryList.length; i++) {
                    contryListResult.add(Result.fromMap(countryList[i]));
                  }
                  DateTime startEpoch = DateTime.now();
                  for (int index = 0; index < listOfRows.length; index++) {
                    List<String> listOfCellInRow = listOfRows[index].split(",");
                    int day = int.parse(listOfCellInRow[1]);
                    int month = int.parse(listOfCellInRow[2]);
                    int year = int.parse(listOfCellInRow[3]);
                    int hour =
                        int.parse(listOfCellInRow[listOfCellInRow.length - 3]);
                    int min =
                        int.parse(listOfCellInRow[listOfCellInRow.length - 2]);
                    if (listOfCellInRow[listOfCellInRow.length - 1] == 'PM') {
                      hour += 12;
                    }
                    DateTime matchStartTime =
                        DateTime(year, month, day, hour, min);
                    DateTime matchEndTime =
                        DateTime(year, month, day, hour + 4, min);
                    int epocOfMatchSart = matchStartTime.millisecondsSinceEpoch;
                    startEpoch = matchStartTime;
                    int epocOfMatchEnd = matchEndTime.millisecondsSinceEpoch;
                    int nowEpoc = DateTime.now().millisecondsSinceEpoch;
                    if (nowEpoc > epocOfMatchSart && nowEpoc < epocOfMatchEnd) {
                      isLive = true;
                      matchInfo = listOfCellInRow;

                      break;
                    } else if (nowEpoc < epocOfMatchSart) {
                      matchInfo = listOfCellInRow;
                      break;
                    }
                  }

                  String countryName1 = matchInfo[4];
                  String countryName2 = matchInfo[5];
                  for (var x in countryList) {
                    Result e = Result.fromMap(x);
                    if (e.countryName.toLowerCase().trim() ==
                        countryName1.toLowerCase().trim()) {
                      team1 = e;
                    }
                    if (e.countryName.toLowerCase().trim() ==
                        countryName2.toLowerCase().trim()) {
                      team2 = e;
                    }
                  }

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 90, bottom: 90),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isPlayerList = true;
                              });
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                              height: 220,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color.fromARGB(255, 79, 223, 255)
                                        .withOpacity(0.5),
                                    const Color.fromARGB(255, 136, 103, 255)
                                        .withOpacity(0.5)
                                  ],
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    userInformationController
                                        .userInfo.value.fullName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    Hive.box("info").get("teamName"),
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    totalPoint.toString(),
                                    style: const TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    "Team Points",
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                  const Gap(10),
                                  Text(
                                    "View details",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Gap(10),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Get.to(() => const WebViewLiveScore());
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              height: 170,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color.fromARGB(255, 79, 223, 255)
                                        .withOpacity(0.5),
                                    const Color.fromARGB(255, 136, 103, 255)
                                        .withOpacity(0.5)
                                  ],
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    color: isLive
                                        ? Colors.red
                                        : Colors.white.withOpacity(0.5),
                                    height: 25,
                                    width: isLive ? 55 : 150,
                                    alignment: Alignment.center,
                                    child: Text(
                                      isLive ? "LIVE" : "UPCOMMING",
                                      style: TextStyle(
                                        color: isLive
                                            ? Colors.white
                                            : Colors.blue.shade900,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 80,
                                            child: team1 == null
                                                ? Image.asset(
                                                    'assets/background/flag.png')
                                                : Image.network(
                                                    "http://116.68.200.97:6048/images/flags/${team1.countryImage}",
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                          ),
                                          const Gap(5),
                                          Text(
                                            matchInfo[4],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "VS",
                                            style: TextStyle(
                                              fontSize: 40,
                                              color: Colors.blue.shade900,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          if (!isLive)
                                            StreamBuilder(
                                              stream:
                                                  getMiliseconSinceEpochSteam(),
                                              builder: (context, snapshot) {
                                                Duration duration = startEpoch
                                                    .difference(snapshot.data ??
                                                        DateTime.now());
                                                return Text(
                                                  "${duration.inDays} Days, ${duration.inHours % 24} Hours,\n${duration.inMinutes % 60} Minutes, ${duration.inSeconds % 60} Sec",
                                                  textAlign: TextAlign.center,
                                                );
                                              },
                                            ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 80,
                                            child: team2 == null
                                                ? Image.asset(
                                                    'assets/background/flag.png')
                                                : Image.network(
                                                    "http://116.68.200.97:6048/images/flags/${team2.countryImage}",
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                          ),
                                          const Gap(5),
                                          Text(
                                            matchInfo[5],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Gap(10),
                          Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color.fromARGB(255, 79, 223, 255)
                                      .withOpacity(0.5),
                                  const Color.fromARGB(255, 136, 103, 255)
                                      .withOpacity(0.5)
                                ],
                              ),
                              image: const DecorationImage(
                                image: AssetImage(
                                  "assets/exium/Exium-MUPS_Exium_MUPS.png",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
  }

  Widget buildCardOfPlayers(PlayerInfoModel player) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 120,
            width: 120,
            child: FutureBuilder(
              future: getUriImage(
                  "http://116.68.200.97:6048/images/players/${player.playerImage}"),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Uint8List? response = snapshot.data;
                  if (response == null) {
                    return const Icon(
                      FluentIcons.person_32_regular,
                      size: 40,
                      color: Colors.black,
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.all(2),
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: MemoryImage(response),
                          fit: BoxFit.fitHeight,
                        ),
                        color: const Color.fromARGB(255, 41, 141, 255)
                            .withOpacity(0.2),
                      ),
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white.withOpacity(0.7)),
                        child: Text(
                          "${player.totalPoint ?? 0}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 56, 141),
                          ),
                        ),
                      ),
                    );
                  }
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    padding: const EdgeInsets.all(2),
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 41, 141, 255)
                          .withOpacity(0.2),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          FluentIcons.person_32_regular,
                          size: 40,
                          color: Colors.black,
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white.withOpacity(0.7)),
                              child: Text(
                                "${player.totalPoint ?? 0}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 56, 141),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return const Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 2,
                ));
              },
            ),
          ),
          Center(
            child: Text(
              player.playerName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Stream<DateTime> getTimeStream() async* {
  DateTime currentTime = DateTime.now();
  while (true) {
    await Future.delayed(const Duration(minutes: 1));
    yield currentTime;
  }
}

Stream<DateTime> getMiliseconSinceEpochSteam() async* {
  while (true) {
    DateTime currentTime = DateTime.now();
    await Future.delayed(const Duration(seconds: 1));
    yield currentTime;
  }
}
