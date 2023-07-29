import 'dart:async';
import 'dart:io';

import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/appbar_drawer.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/screen_argument.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebViewPage extends StatefulWidget {
  WebViewPage({Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;
  bool isLoading=true;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    final Completer<WebViewController> _controller =
    Completer<WebViewController>();
    const platform = MethodChannel('com.startActivity/external');
    return Scaffold(
      appBar: CustomAppBar(
        backUrl: RoutesName.home,
        title: "Paiement",
        showBack: true,
      ),
      body:
      WebView(
        initialUrl: args.id.toString(),
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        javascriptChannels: <JavascriptChannel>{
          _toasterJavascriptChannel(context),
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith(args.id.toString())) {
            print('blocking navigation to $request}');
            return NavigationDecision.prevent;
          }
          print('allowing navigation to $request');
          return NavigationDecision.navigate;
        },
        onWebResourceError: (WebResourceError webviewerrr) {
          print(
              "Handle your Error Page");
        },
        onPageStarted: (String url) {
          setState(() {
            isLoading = false;
          });
        },
        gestureNavigationEnabled: true,
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showBottomSheet((context) => Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text(message.message),
            ),
          ));
        });
  }
}