import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewLiveScore extends StatefulWidget {
  final String? appbar;
  const WebViewLiveScore({super.key, this.appbar});

  @override
  State<WebViewLiveScore> createState() => _WebViewLiveScoreState();
}

class _WebViewLiveScoreState extends State<WebViewLiveScore> {
  final controller = WebViewController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {
          controller.runJavaScript('''
var element = document.querySelector('.Fh5muf');
if (element) {
    element.style.display = 'none';
}
var element = document.querySelector('.s2gQvd');
if (element) {
    element.style.display = 'none';
}
var listElement = document.querySelectorAll('.MjjYud');
for (let i = 1; i < listElement.length; i++) {
    listElement[i].style.display = 'none';
}



    ''');
          isLoading = false;
          setState(() {});
        },
        onWebResourceError: (WebResourceError error) {
          //Things to do when the page has error when loading
        },
      ))
      ..loadRequest(Uri.parse("https://www.google.com/search?q=ipl&oq=ipl"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appbar ?? "Live Score",
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: (isLoading)
          ? const Center(child: CupertinoActivityIndicator())
          : Padding(
              padding: const EdgeInsets.only(top: 50),
              child: WebViewWidget(
                controller: controller,
                gestureRecognizers:
                    <Factory<OneSequenceGestureRecognizer>>{}.toSet(),
              ),
            ),
    );
  }
}
