import 'package:exium_mups_t20_world_cup/src/screens/home/controllers/web_state_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Standings extends StatefulWidget {
  final WebViewController controller;
  const Standings({super.key, required this.controller});

  @override
  State<Standings> createState() => _StandingsState();
}

class _StandingsState extends State<Standings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<WebStateController>(
        builder: (controller) {
          return (controller.standingLoading.value)
              ? const Center(child: CupertinoActivityIndicator())
              : WebViewWidget(
                  controller: widget.controller,
                );
        },
      ),
    );
  }
}
