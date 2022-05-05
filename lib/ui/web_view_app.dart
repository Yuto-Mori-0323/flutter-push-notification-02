import 'dart:io';
import 'package:flutter/material.dart';
import './web_view_footer.dart';
import './web_view_stack.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';


class WebViewApp extends StatefulWidget {
  const WebViewApp({Key? key}) : super(key: key);

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  final controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //     child: AppBar(
      //     ),
      //     preferredSize: Size.fromHeight(screenSize.height * 0.07))
      // ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: AppBar(
          backgroundColor: Colors.blue[800],
        ),
      ),
      body: WebViewStack(controller: controller),
      bottomNavigationBar: WebViewFooter(controller: controller),
    );
  }
}