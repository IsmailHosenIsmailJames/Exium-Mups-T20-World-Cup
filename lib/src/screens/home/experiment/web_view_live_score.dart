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

  String javascript = '''
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
var element = document.querySelector('.FSIemd');
if (element) {
    element.style.display = 'none';
}
var element = document.querySelector('.gDIH3');
if (element) {
    element.style.display = 'none';
}
var element = document.querySelector('.Wrsj9b');
if (element) {
    element.style.display = 'none';
}
var element = document.querySelector('.tb_sh');
if (element) {
    element.style.display = 'none';
}
var element = document.querySelector('.imso-ft');
if (element) {
    element.style.display = 'none';
}

document.addEventListener("click", handler, true);
    
function handler(e) {
  e.stopPropagation();
  e.preventDefault();
}

var keys = { 37: 1, 38: 1, 39: 1, 40: 1 };

function preventDefault(e) {
    e.preventDefault();
}

function preventDefaultForScrollKeys(e) {
    if (keys[e.keyCode]) {
        preventDefault(e);
        return false;
    }
}

// modern Chrome requires { passive: false } when adding event
var supportsPassive = false;
try {
    window.addEventListener("test", null, Object.defineProperty({}, 'passive', {
        get: function () { supportsPassive = true; }
    }));
} catch (e) { }

var wheelOpt = supportsPassive ? { passive: false } : false;
var wheelEvent = 'onwheel' in document.createElement('div') ? 'wheel' : 'mousewheel';

window.addEventListener('DOMMouseScroll', preventDefault, false); // older FF
window.addEventListener(wheelEvent, preventDefault, wheelOpt); // modern desktop
window.addEventListener('touchmove', preventDefault, wheelOpt); // mobile
window.addEventListener('keydown', preventDefaultForScrollKeys, false);
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
      ..loadRequest(Uri.parse("https://www.google.com/search?q=ipl&oq=ipl"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: Text(
          widget.appbar ?? "Live Score",
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0.5),
      ),
      body: (isLoading)
          ? const Center(child: CupertinoActivityIndicator())
          : GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: WebViewWidget(
                controller: controller,
                gestureRecognizers:
                    <Factory<OneSequenceGestureRecognizer>>{}.toSet(),
              ),
            ),
    );
  }
}
