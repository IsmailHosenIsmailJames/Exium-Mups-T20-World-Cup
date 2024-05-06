import 'dart:convert';
import 'dart:ui';

import 'package:exium_mups_t20_world_cup/src/screens/auth/login/login.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../../models/success_login_responce.dart';
import '../../home/home_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isCheaked = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passCodeController = TextEditingController();
  final key = GlobalKey<FormState>();
  Color cheakOkColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/t20/t20-logo.png"),
            fit: BoxFit.contain,
            alignment: Alignment.bottomCenter,
          ),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topCenter,
        child: Center(
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                decoration: BoxDecoration(
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
                height: 600,
                width: MediaQuery.of(context).size.width * 0.92,
                child: Form(
                  key: key,
                  child: ListView(
                    padding: const EdgeInsets.all(10),
                    children: [
                      Center(
                        child: Text(
                          "Regester",
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please type your name here...";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.blue.shade900,
                          ),
                          labelText: "Your Name",
                          hintText: "type your name here...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            borderSide: const BorderSide(width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: phoneController,
                        validator: (value) {
                          if (value == null || value.length != 11) {
                            return "Please type your phone number properly...";
                          } else {
                            return null;
                          }
                        },
                        maxLength: 11,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: Colors.blue.shade900,
                          ),
                          labelText: "Phone Number",
                          hintText: "type your phone number here...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            borderSide: const BorderSide(width: 2),
                          ),
                        ),
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: passCodeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please type your name here...";
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          suffix: SizedBox(
                            height: 20,
                            width: 20,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 15,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    child: Container(
                                      margin: const EdgeInsets.all(20),
                                      width: MediaQuery.of(context).size.width -
                                          150,
                                      height: 200,
                                      child: const Center(
                                        child: Text(
                                          "This passcode will provided by\nrespective personof Radiant.",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(FluentIcons.info_12_filled),
                            ),
                          ),
                          prefixIcon: Icon(
                            CupertinoIcons.lock,
                            color: Colors.blue.shade900,
                          ),
                          labelText: "Pass Code",
                          hintText: "type the pass code here...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            borderSide: const BorderSide(width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isCheaked = !isCheaked;
                          });
                        },
                        child: SizedBox(
                          height: 25,
                          child: Row(
                            children: [
                              Checkbox.adaptive(
                                value: isCheaked,
                                onChanged: (value) {
                                  setState(() {
                                    isCheaked = !isCheaked;
                                  });
                                  if (isCheaked) {
                                    cheakOkColor = Colors.black;
                                  } else {
                                    cheakOkColor = Colors.red;
                                  }
                                },
                              ),
                              Text(
                                "I agree to get SMS every day for this contest purpose.",
                                style: TextStyle(
                                  color: cheakOkColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 40,
                        width: 540,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (key.currentState!.validate() && isCheaked) {
                              final http.Response response = await http.post(
                                Uri.parse(
                                    "http://116.68.200.97:6048/api/v1/register"),
                                body: {
                                  "full_name": nameController.text,
                                  "mobile_number": phoneController.text,
                                  "pin_number": passCodeController.text,
                                },
                              );
                              print(response.body);
                              if (response.statusCode == 200) {
                                Fluttertoast.showToast(
                                    msg: jsonDecode(response.body)["message"]);
                                final userModelData = User.fromMap(
                                    jsonDecode(response.body)['user']);
                                final box = Hive.box("info");
                                print(userModelData.createdAt);
                                await box.put(
                                    "userInfo", userModelData.toJson());
                                Get.offAll(
                                  () => HomePage(
                                    userInfo: userModelData,
                                  ),
                                );
                              } else {
                                Fluttertoast.showToast(
                                    msg: jsonDecode(response.body)["message"]);
                              }
                            } else {
                              if (isCheaked == false) {
                                setState(() {
                                  cheakOkColor = Colors.red;
                                });
                              }
                            }
                          },
                          child: const Row(
                            children: [
                              Spacer(),
                              Text(
                                "Register",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w600),
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
                            width: 60,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "or Already have account?",
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
                            width: 60,
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
                            Get.off(() => const LoginPage());
                          },
                          child: const Row(
                            children: [
                              Spacer(),
                              Text(
                                "Login",
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
                        height: 15,
                      ),
                      const Center(
                        child: Text(
                          "Sponsored by",
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
          ),
        ),
      ),
    );
  }
}
