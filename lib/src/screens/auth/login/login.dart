import 'dart:ui';

import 'package:exium_mups_t20_world_cup/src/screens/auth/signin/signin.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 40,
                      width: 540,
                      child: ElevatedButton(
                        onPressed: () {},
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
    );
  }
}
