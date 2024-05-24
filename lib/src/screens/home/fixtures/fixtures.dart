import 'package:exium_mups_t20_world_cup/src/screens/home/controllers/web_state_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Fixtures extends StatefulWidget {
  final WebViewController controller;
  const Fixtures({super.key, required this.controller});

  @override
  State<Fixtures> createState() => _FixturesState();
}

class _FixturesState extends State<Fixtures> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetX<WebStateController>(
      builder: (controller) => (controller.fixturesLoading.value)
          ? const Center(child: CupertinoActivityIndicator())
          : WebViewWidget(
              controller: widget.controller,
            ),
    ));
  }
}
