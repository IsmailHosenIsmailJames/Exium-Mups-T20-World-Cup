import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:exium_mups_t20_world_cup/src/core/init_route.dart';
import 'package:exium_mups_t20_world_cup/src/screens/auth/login/login.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../../models/success_login_responce.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passCodeController = TextEditingController();
  final key = GlobalKey<FormState>();
  Color errorIndecatpr = Colors.black;
  int accountTypeFlag = -1;

  void signUp() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    bool isNetworkActive =
        connectivityResult.contains(ConnectivityResult.mobile) ||
            connectivityResult.contains(ConnectivityResult.wifi) ||
            connectivityResult.contains(ConnectivityResult.ethernet);
    if (key.currentState!.validate() && accountTypeFlag != -1) {
      if (isNetworkActive) {
        final http.Response response = await http.post(
          Uri.parse("http://116.68.200.97:6048/api/v1/register"),
          headers: {HttpHeaders.contentTypeHeader: "application/json"},
          body: jsonEncode(
            {
              "full_name": nameController.text.trim(),
              "mobile_number": phoneController.text,
              "pin_number": passCodeController.text,
              "user_type": accountTypeFlag,
            },
          ),
        );
        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: jsonDecode(response.body)["message"]);
          final userModelData = User.fromMap(jsonDecode(response.body)['user']);
          final box = Hive.box("info");
          await box.put("userInfo", userModelData.toJson());
          Get.offAll(
            () => const InitRoutes(),
          );
        } else {
          Fluttertoast.showToast(msg: jsonDecode(response.body)["message"]);
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
                    signUp();
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
    } else {
      setState(() {
        errorIndecatpr = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
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
            height: 630,
            width: MediaQuery.of(context).size.width * 0.92,
            child: Form(
              key: key,
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  Center(
                    child: Text(
                      "Sign Up",
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
                    keyboardType: TextInputType.phone,
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
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: passCodeController,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length != 5) {
                        return "Please type your territory code here...";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    maxLength: 5,
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
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  height: 200,
                                  child: const Center(
                                    child: Text(
                                      "Territory Code will be provided\nby\nRadiant Colleague",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18),
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
                      labelText: "Territory Code",
                      hintText: "type the territory code here...",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Account type :",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: errorIndecatpr,
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            accountTypeFlag = 0;
                            errorIndecatpr = Colors.black;
                          });
                        },
                        child: Container(
                          height: 35,
                          width: MediaQuery.of(context).size.width * 0.30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: Row(
                            children: [
                              Checkbox.adaptive(
                                value: accountTypeFlag == 0,
                                onChanged: (value) {
                                  setState(() {
                                    accountTypeFlag = 0;
                                    errorIndecatpr = Colors.black;
                                  });
                                },
                              ),
                              const Text(
                                "Doctor",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            accountTypeFlag = 1;
                            errorIndecatpr = Colors.black;
                          });
                        },
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          height: 35,
                          width: MediaQuery.of(context).size.width * 0.30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: Row(
                            children: [
                              Checkbox.adaptive(
                                value: accountTypeFlag == 1,
                                onChanged: (value) {
                                  setState(() {
                                    accountTypeFlag = 1;
                                    errorIndecatpr = Colors.black;
                                  });
                                },
                              ),
                              const Text(
                                "CHQ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 40,
                    width: 540,
                    child: ElevatedButton(
                      onPressed: () {
                        signUp();
                      },
                      child: const Row(
                        children: [
                          Spacer(),
                          Text(
                            "Sign Up",
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
      ),
    );
  }
}
