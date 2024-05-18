import 'dart:convert';

import 'package:exium_mups_t20_world_cup/src/screens/home/experiment/fixtures_excel.dart';
import 'package:exium_mups_t20_world_cup/src/screens/home/experiment/web_view_live_score.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

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
    getLiveURL();
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

  final controllerURL = WebViewController();
  String javascript = '''
var navElement = document.getElementById("nav");
navElement.style.display = "none";
var element = document.querySelector('.col-span-3');
if (element) {
    element.style.display = 'none';
}
var element = document.querySelector('.col-span-1');
if (element) {
    element.style.display = 'none';
}
var element = document.querySelector('.Footer_footer__cVJRj');
if (element) {
    element.style.display = 'none';
}

window.scrollBy(0, 48);

function preventDefault(e) {
    e.preventDefault();
}

function preventDefaultForScrollKeys(e) {
    if (keys[e.keyCode]) {
        preventDefault(e);
        return false;
    }
}

// modern Chrome requires { passive: false } when adding event
var supportsPassive = false;
try {
    window.addEventListener("test", null, Object.defineProperty({}, 'passive', {
        get: function () { supportsPassive = true; }
    }));
} catch (e) { }

var wheelOpt = supportsPassive ? { passive: false } : false;
var wheelEvent = 'onwheel' in document.createElement('div') ? 'wheel' : 'mousewheel';

window.addEventListener('DOMMouseScroll', preventDefault, false); // older FF
window.addEventListener(wheelEvent, preventDefault, wheelOpt); // modern desktop
window.addEventListener('touchmove', preventDefault, wheelOpt); // mobile
window.addEventListener('keydown', preventDefaultForScrollKeys, false);
''';
  bool isLoading = true;
  String urlOfLive = "";
  void getLiveURL() async {
    http.Response response = await http
        .get(Uri.parse("http://116.68.200.97:6048/api/v1/live_match"));
    if (response.statusCode == 200) {
      String url = jsonDecode(response.body)["url"];
      urlOfLive = url;
      controllerURL
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              controllerURL.runJavaScript(javascript);
              isLoading = false;
              setState(() {});
            },
            onWebResourceError: (WebResourceError error) {
              //Things to do when the page has error when loading
            },
          ),
        )
        ..loadRequest(Uri.parse(url));
    }
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
                  List<String> matchInfo = [];

                  List<Result> contryListResult = [];

                  for (int i = 0; i < countryList.length; i++) {
                    contryListResult.add(Result.fromMap(countryList[i]));
                  }

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

                    int epocOfMatchEnd = matchEndTime.millisecondsSinceEpoch;
                    int nowEpoc = DateTime.now().millisecondsSinceEpoch;
                    if (nowEpoc > epocOfMatchSart && nowEpoc < epocOfMatchEnd) {
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
                        countryName1.toLowerCase().trim()) {}
                    if (e.countryName.toLowerCase().trim() ==
                        countryName2.toLowerCase().trim()) {}
                  }

                  return Center(
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
                            margin: const EdgeInsets.all(5),
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
                        Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.only(bottom: 10),

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
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  if (urlOfLive.isNotEmpty) {
                                    Get.to(() => WebViewLiveScore(
                                          url: urlOfLive,
                                        ));
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Loading... Please wait.");
                                  }
                                },
                                child: const SizedBox(
                                  height: 50,
                                  child: Row(children: [
                                    Spacer(
                                      flex: 4,
                                    ),
                                    Text(
                                      "View details",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(255, 0, 50, 124),
                                      ),
                                    ),
                                    Spacer(
                                      flex: 3,
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                    Gap(10)
                                  ]),
                                ),
                              ),
                              SizedBox(
                                height: 289,
                                child: (isLoading)
                                    ? const Center(
                                        child: CupertinoActivityIndicator())
                                    : WebViewWidget(
                                        controller: controllerURL,
                                      ),
                              ),
                            ],
                          ),

                          // Column(
                          //   children: [
                          //     Container(
                          //       color: isLive
                          //           ? Colors.red
                          //           : Colors.white.withOpacity(0.5),
                          //       height: 25,
                          //       width: isLive ? 55 : 150,
                          //       alignment: Alignment.center,
                          //       child: Text(
                          //         isLive ? "LIVE" : "UPCOMMING",
                          //         style: TextStyle(
                          //           color: isLive
                          //               ? Colors.white
                          //               : Colors.blue.shade900,
                          //           fontSize: 18,
                          //         ),
                          //       ),
                          //     ),
                          //     const Gap(10),
                          //     Row(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceBetween,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: [
                          //         Column(
                          //           children: [
                          //             SizedBox(
                          //               height: 80,
                          //               width: 150,
                          //               child: team1 == null
                          //                   ? Image.asset(
                          //                       'assets/background/flag.png')
                          //                   : Image.network(
                          //                       "http://116.68.200.97:6048/images/flags/${team1.countryImage}",
                          //                       fit: BoxFit.fitHeight,
                          //                     ),
                          //             ),
                          //             const Gap(5),
                          //             Text(
                          //               matchInfo[4],
                          //               style: const TextStyle(
                          //                 fontSize: 18,
                          //                 fontWeight: FontWeight.w600,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //         Column(
                          //           children: [
                          //             Text(
                          //               "VS",
                          //               style: TextStyle(
                          //                 fontSize: 40,
                          //                 color: Colors.blue.shade900,
                          //                 fontWeight: FontWeight.w600,
                          //               ),
                          //             ),
                          //             if (!isLive)
                          //               StreamBuilder(
                          //                 stream:
                          //                     getMiliseconSinceEpochSteam(),
                          //                 builder: (context, snapshot) {
                          //                   Duration duration = startEpoch
                          //                       .difference(snapshot.data ??
                          //                           DateTime.now());
                          //                   return Text(
                          //                     "${duration.inDays} Days, \n${duration.inHours % 24} Hours,\n${duration.inMinutes % 60} Min, ${duration.inSeconds % 60} Sec",
                          //                     textAlign: TextAlign.center,
                          //                   );
                          //                 },
                          //               ),
                          //           ],
                          //         ),
                          //         Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.center,
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.center,
                          //           children: [
                          //             SizedBox(
                          //               height: 80,
                          //               width: 150,
                          //               child: team2 == null
                          //                   ? Image.asset(
                          //                       'assets/background/flag.png')
                          //                   : Image.network(
                          //                       "http://116.68.200.97:6048/images/flags/${team2.countryImage}",
                          //                       fit: BoxFit.fitHeight,
                          //                     ),
                          //             ),
                          //             const Gap(5),
                          //             Text(
                          //               matchInfo[5],
                          //               style: const TextStyle(
                          //                 fontSize: 18,
                          //                 fontWeight: FontWeight.w600,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ],
                          //     )
                          //   ],
                          // ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          height: 100,
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