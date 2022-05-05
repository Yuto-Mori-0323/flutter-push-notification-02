import 'package:flutter/material.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewFooter extends StatefulWidget {
  const WebViewFooter({required this.controller, Key? key}) : super(key: key);

  final Completer<WebViewController> controller;

  @override
  State<WebViewFooter> createState() => _WebViewFooterState(controller);
}

class _WebViewFooterState extends State<WebViewFooter> {
  _WebViewFooterState(this.controller);
  final Completer<WebViewController> controller;
  var arrow_back_color = Colors.grey[600];
  var arrow_forward_color = Colors.grey[600];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller.future,
      builder: (context, snapshot) {
        final WebViewController? controller = snapshot.data;
        if (snapshot.connectionState != ConnectionState.done ||
            controller == null) {
          return Row(
            children: const <Widget>[
              Icon(Icons.arrow_back_ios),
              Icon(Icons.arrow_forward_ios),
              Icon(Icons.replay),
            ],
          );
        }



        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color:  arrow_back_color,
                  onPressed: () async {
                    if (await controller.canGoBack()) {
                    await controller.goBack();
                    // await controller.evaluateJavascript("changeColor();");
                  } else {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text('No back history item')),
                  // );
                  // return;
                  }
                },
              ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  color:arrow_forward_color,
                  onPressed: () async {
                    if (await controller.canGoForward()) {
                      await controller.goForward();
                    } else {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('No forward history item')),
                      // );
                      // return;
                    }
                  },
                )
              ]
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: () {
                controller.reload();
              },
            ),
          ],
        );
      },
    );

  }
}