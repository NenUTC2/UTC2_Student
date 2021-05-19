import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebUTC2 extends StatelessWidget {
  final String link;

  const WebUTC2({this.link});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: link,
      ),
    );
  }
}
