import 'dart:convert';

import 'package:exium_mups_t20_world_cup/src/core/init_route.dart';
import 'package:exium_mups_t20_world_cup/src/models/success_login_responce.dart';
import 'package:exium_mups_t20_world_cup/src/screens/auth/signin/signin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController numberController = TextEditingController();
  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color.fromARGB(255, 151, 255, 203).withOpacity(0.5),
                const Color.fromARGB(255, 136, 103, 255).withOpacity(0.5)
              ],
            ),
          ),
          height: 450,
          width: MediaQuery.of(context).size.width * 0.92,
          child: Form(
            key: key,
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontSize: 70,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: numberController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.length != 11) {
                      return " Please fill number properly";
                    } else {
                      try {
                        int.parse(value);
                        return null;
                      } catch (e) {
                        return " Please fill number properly";
                      }
                    }
                  },
                  maxLength: 11,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.phone_android,
                      color: Colors.blue.shade900,
                    ),
                    hintText: "type your phone number here...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      borderSide: const BorderSide(width: 2),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: 540,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (key.currentState!.validate()) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue.shade800,
                            ),
                          ),
                        );
                        http.Response response = await http.post(
                          Uri.parse(
                            "http://116.68.200.97:6048/api/v1/login",
                          ),
                          body: {"mobile_number": numberController.text},
                        );
                        if (response.statusCode == 200) {
                          Fluttertoast.showToast(
                              msg: jsonDecode(response.body)["message"]);
                          final userModelData =
                              User.fromMap(jsonDecode(response.body)['user']);
                          final box = Hive.box("info");
                          await box.put("userInfo", userModelData.toJson());

                          http.Response response2 = await http.get(
                            Uri.parse(
                              "http://116.68.200.97:6048/api/v1/selected_player_list?user_id=${userModelData.id}",
                            ),
                          );

                          if (response2.statusCode == 200) {
                            final decodeData = jsonDecode(response2.body);
                            List<Map> listOfPalyers =
                                List<Map>.from(decodeData["data"]);
                            if (listOfPalyers.length == 11) {
                              await box.put("team", listOfPalyers);
                              await box.put(
                                "teamName",
                                listOfPalyers[0]['team_name'],
                              );
                            }
                          }

                          await Get.offAll(() => const InitRoutes());
                        } else {
                          Fluttertoast.showToast(
                              msg: jsonDecode(response.body)["message"]);
                        }
                      }
                    },
                    child: const Row(
                      children: [
                        Spacer(),
                        Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 1,
                      width: 50,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "or don't have account?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 1,
                      width: 50,
                      color: Colors.black,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 40,
                  width: 540,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.off(() => const SignUp());
                    },
                    child: const Row(
                      children: [
                        Spacer(),
                        Text(
                          "Register using Mobile Number",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward)
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                    "Powered By",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: Image.asset(
                    "assets/exium/Exium-MUPS_Exium_MUPS.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
