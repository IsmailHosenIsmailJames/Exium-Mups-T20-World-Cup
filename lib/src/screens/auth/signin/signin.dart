import 'dart:ui';

import 'package:exium_mups_t20_world_cup/src/screens/auth/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isCheaked = false;
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
                height: 600,
                width: MediaQuery.of(context).size.width * 0.92,
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
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
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
                              },
                            ),
                            const Text(
                              "I agree to get SMS every day for this contest purpose.",
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
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
    );
  }
}
