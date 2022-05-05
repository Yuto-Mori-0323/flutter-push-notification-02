import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import '../repository/device_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import '../setting.dart';


class WebViewStack extends StatefulWidget {
  const WebViewStack({required this.controller, Key? key}) : super(key: key);
  final Completer<WebViewController> controller;

  @override
  State<WebViewStack> createState() => _WebViewStackState(controller);
}

class _WebViewStackState extends State<WebViewStack> {
  _WebViewStackState(this.controller);
  final Completer<WebViewController> controller;

  final CookieManager cookieManager = CookieManager();

  var userAgent = '';

  var loadingPercentage = 0;
  String initialUrl = Setting().domain;

  initState() {
    super.initState();
  }

  get_webview_cookies() async {
    final cookieManager = WebviewCookieManager();
    final gotCookies = await cookieManager.getCookies(initialUrl);
    var cookieString = '';

    for (var item in gotCookies) {
      if (item.name == '_ga' || item.name == 'user.id' || item.name == 'remember_user_token' || item.name == '_session_id') {
        print(item.name);
        print(item.value);
        cookieString = cookieString + item.name + '=' + item.value + ';';
      }
    }

    return cookieString;
  }

  notificationAlert() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    final messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //トークンの取得
      final token = await messaging.getToken();
      print('🐯 FCM TOKEN: $token');

      //トークンの保存
      final cookies = await get_webview_cookies();
      var deviceRepository = DeviceRepository();
      await deviceRepository.postDeviceToken(token, cookies);
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }



  }

  @override
  Widget build(BuildContext context) {
    print("実行された！１！！１！！！！！！");
    return FutureBuilder<WebViewController>(
        future: controller.future,
        builder: (context, snapshot)
    {



      return Stack(
        children: [
          WebView(
              initialUrl: initialUrl,
              onWebViewCreated: (webViewController) async {
                widget.controller.complete(webViewController);
                final WebViewController? controller = webViewController;
                final ua = await controller?.runJavascriptReturningResult("navigator.userAgent;");

                print("クリエイト１！！！");
                print(ua);
                setState(() {
                  userAgent = ua! + " anamne-app";
                });
                print(userAgent);
                // final WebViewController? controller = webViewController;
                // controller = webViewController;
              },
              onPageStarted: (url) {
                setState(() {
                  loadingPercentage = 0;
                });
              },
              onProgress: (progress) {
                setState(() {
                  loadingPercentage = progress;
                });
              },
              onPageFinished: (url) async {
                // var javascript = '''
                // window.alert = function (e){
                //   Alert.postMessage(e);
                // }
                // ''';
                // await controller.runJavascriptReturningResult('JS code');
                setState(() {
                  loadingPercentage = 100;
                });
                if (url == initialUrl) {
                  notificationAlert();
                }
                print(url);
              },
              javascriptChannels: Set.from(
                [
                  JavascriptChannel(
                    name: 'defaultAlert',
                    onMessageReceived: (JavascriptMessage message) async {
                      // alert message = Test alert Message
                      print(message.message);
                      // await controller?.evaluateJavascript("this.changeColor();");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(message.message),
                      ));
                      // TODO popup
                    },
                  )
                ],
              ),
              navigationDelegate: (navigation) {
                return NavigationDecision.navigate;
              },
              javascriptMode: JavascriptMode.unrestricted,
              userAgent: userAgent
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
        ],
      );
    });
  }
}