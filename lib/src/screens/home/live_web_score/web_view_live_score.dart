import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewLiveScore extends StatefulWidget {
  final String? appbar;
  final String url;
  const WebViewLiveScore({super.key, this.appbar, required this.url});

  @override
  State<WebViewLiveScore> createState() => _WebViewLiveScoreState();
}

class _WebViewLiveScoreState extends State<WebViewLiveScore> {
  final controller = WebViewController();
  bool isLoading = true;
  String javascript = '''
var navElement = document.getElementById("nav");
navElement.style.display = "none";
var element = document.querySelector('.si-card-wrap');
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
''';

  @override
  void initState() {
    super.initState();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {},
        onPageStarted: (String url) {
          controller.runJavaScript(javascript);
          isLoading = false;
          setState(() {});
        },
        onPageFinished: (String url) {
          controller.runJavaScript(javascript);
          isLoading = false;
          setState(() {});
        },
        onWebResourceError: (WebResourceError error) {
          //Things to do when the page has error when loading
        },
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: Scaffold(
        appBar: AppBar(
          // toolbarHeight: 40
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
        extendBodyBehindAppBar: true,
        body: (isLoading)
            ? const Center(child: CupertinoActivityIndicator())
            : WebViewWidget(
                controller: controller,
              ),
      ),
    );
  }
}
