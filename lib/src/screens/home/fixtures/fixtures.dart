import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Fixtures extends StatefulWidget {
  const Fixtures({super.key});

  @override
  State<Fixtures> createState() => _FixturesState();
}

class _FixturesState extends State<Fixtures> {
  final controller = WebViewController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {
          controller.runJavaScript('''
      var element = document.querySelector('.Header_header__Mklic');
      if (element) {
        element.style.display = 'none';
      }
      var element = document.querySelector('.MustHead_must-head__6uGMB');
      if (element) {
        element.style.display = 'none';
      }
         var element = document.querySelector('.Footer_footer__cVJRj');
      if (element) {
        element.style.display = 'none';
      }
    ''');
          isLoading = false;
          setState(() {});
        },
        onWebResourceError: (WebResourceError error) {
          //Things to do when the page has error when loading
        },
      ))
      ..loadRequest(Uri.parse("https://www.icc-cricket.com/fixtures-results"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (isLoading)
          ? const Center(child: CupertinoActivityIndicator())
          : WebViewWidget(
              controller: controller,
            ),
    );
  }
}
